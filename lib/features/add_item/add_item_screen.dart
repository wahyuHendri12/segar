import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/catalog_filter.dart';
import '../../core/utils/expiry_utils.dart';
import '../../core/utils/format_utils.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_skeleton.dart';
import '../../core/widgets/section_header.dart';
import '../../data/local/enums.dart';
import '../../data/models/barcode_lookup.dart';
import '../../data/models/ingredient_catalog_view.dart';
import '../../data/models/pantry_item_view.dart';
import '../../data/repositories/repository_providers.dart';
import '../../l10n/app_labels.dart';
import '../../l10n/app_localizations.dart';
import '../barcode/barcode_lookup_sheet.dart';
import '../item_detail/item_detail_providers.dart';
import 'add_item_providers.dart';

class AddItemScreen extends ConsumerWidget {
  const AddItemScreen({super.key, this.itemId});

  /// Null means "add new". A value means "edit this item".
  final String? itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = itemId;
    if (id == null) return const _AddItemForm(initialItem: null);

    final asyncItem = ref.watch(itemDetailProvider(id));
    return asyncItem.when(
      loading: () => const _FormLoading(),
      error: (error, stackTrace) =>
          const _FormMessage(icon: Icons.error_outline_rounded, isError: true),
      data: (item) => item == null
          ? const _FormMessage(icon: Icons.search_off_rounded)
          : _AddItemForm(initialItem: item),
    );
  }
}

class _FormLoading extends StatelessWidget {
  const _FormLoading();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.formEditTitle)),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: LoadingSkeleton(items: 5),
        ),
      ),
    );
  }
}

class _FormMessage extends StatelessWidget {
  const _FormMessage({required this.icon, this.isError = false});

  final IconData icon;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.formEditTitle)),
      body: SafeArea(
        child: EmptyState(
          icon: icon,
          title: isError ? l10n.homeLoadError : l10n.detailNotFoundTitle,
          message: isError ? l10n.actionFailed : l10n.detailNotFoundBody,
        ),
      ),
    );
  }
}

class _AddItemForm extends ConsumerStatefulWidget {
  const _AddItemForm({required this.initialItem});

  final PantryItemView? initialItem;

  @override
  ConsumerState<_AddItemForm> createState() => _AddItemFormState();
}

class _AddItemFormState extends ConsumerState<_AddItemForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _priceController;
  late final TextEditingController _noteController;

  IngredientCatalogView? _catalog;
  late IngredientCategory _category;
  late Unit _unit;
  late StorageLocation _location;
  late DateTime _purchaseDate;
  late DateTime _expiryDate;
  late ExpirySource _expirySource;
  late bool _notifyEnabled;
  late bool _expiryManuallyEdited;
  String? _barcode;
  BarcodeLookup? _appliedBarcode;

  bool _isSaving = false;
  bool _applyingCatalog = false;

  bool get _isEditing => widget.initialItem != null;

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    final now = dateOnly(DateTime.now());

    if (item == null) {
      _nameController = TextEditingController();
      _quantityController = TextEditingController(text: '1');
      _priceController = TextEditingController();
      _noteController = TextEditingController();
      _catalog = null;
      _category = IngredientCategory.lainnya;
      _unit = Unit.pcs;
      _location = StorageLocation.kulkas;
      _purchaseDate = now;
      _expiryDate = estimateExpiryDate(purchaseDate: now, shelfLifeDays: null);
      _expirySource = ExpirySource.estimasi;
      _notifyEnabled = true;
      _expiryManuallyEdited = false;
      _barcode = null;
      _appliedBarcode = null;
    } else {
      _nameController = TextEditingController(text: item.name);
      _quantityController = TextEditingController(
        text: formatQuantity(item.quantity),
      );
      _priceController = TextEditingController(
        text: item.priceIdr?.toString() ?? '',
      );
      _noteController = TextEditingController(text: item.note ?? '');
      _catalog = item.catalog;
      _category = item.category;
      _unit = item.unit;
      _location = item.storageLocation;
      _purchaseDate = dateOnly(item.purchaseDate);
      _expiryDate = dateOnly(item.expiryDate);
      _expirySource = item.expirySource;
      _notifyEnabled = item.notifyEnabled;
      _expiryManuallyEdited = item.expirySource != ExpirySource.estimasi;
      _barcode = item.barcode;
      _appliedBarcode = null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _applyEstimatedExpiry() {
    final days = _catalog?.shelfLifeFor(_location);
    _expiryDate = estimateExpiryDate(
      purchaseDate: _purchaseDate,
      shelfLifeDays: days,
    );
    _expirySource = ExpirySource.estimasi;
    _expiryManuallyEdited = false;
  }

  void _applyCatalog(IngredientCatalogView catalog) {
    setState(() {
      _applyingCatalog = true;
      _catalog = catalog;
      _nameController.text = catalog.nameId;
      _category = catalog.category;
      _unit = catalog.defaultUnit;
      _applyEstimatedExpiry();
      _applyingCatalog = false;
    });
  }

  void _onNameChanged(String value) {
    if (_applyingCatalog) return;
    final catalog = _catalog;
    if (catalog != null && value.trim() != catalog.nameId) {
      setState(() => _catalog = null);
    }
  }

  Future<void> _pickPurchaseDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _purchaseDate = dateOnly(picked);
      if (!_expiryManuallyEdited) _applyEstimatedExpiry();
    });
  }

  Future<void> _pickExpiryDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 3),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _expiryDate = dateOnly(picked);
      _expirySource = ExpirySource.manual;
      _expiryManuallyEdited = true;
    });
  }

  void _onLocationChanged(StorageLocation location) {
    setState(() {
      _location = location;
      if (!_expiryManuallyEdited) _applyEstimatedExpiry();
    });
  }

  double? _parsedQuantity() {
    final raw = _quantityController.text.trim().replaceAll(',', '.');
    return double.tryParse(raw);
  }

  int? _parsedPrice() {
    final raw = _priceController.text.trim();
    if (raw.isEmpty) return null;
    return int.tryParse(raw);
  }

  Future<void> _openCatalogPicker() async {
    final selected = await showModalBottomSheet<IngredientCatalogView>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _CatalogPickerSheet(selectedId: _catalog?.id),
    );
    if (selected != null && mounted) _applyCatalog(selected);
  }

  Future<void> _openBarcodeLookup() async {
    final lookup = await showBarcodeLookupSheet(context);
    if (lookup == null || !mounted) return;
    _applyBarcode(lookup);
  }

  void _applyBarcode(BarcodeLookup lookup) {
    setState(() {
      _applyingCatalog = true;
      _barcode = lookup.barcode;
      _appliedBarcode = lookup;
      _catalog = null;
      _nameController.text = lookup.name;
      _category = lookup.category;
      if (lookup.quantity != null && lookup.unit != null) {
        _quantityController.text = formatQuantity(lookup.quantity!);
        _unit = lookup.unit!;
      }
      _applyEstimatedExpiry();
      _applyingCatalog = false;
    });
  }

  void _clearBarcode() {
    setState(() {
      _barcode = null;
      _appliedBarcode = null;
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final quantity = _parsedQuantity();
    if (quantity == null || quantity <= 0) {
      _showMessage(l10n.formQuantityInvalid);
      return;
    }
    if (dateOnly(_expiryDate).isBefore(dateOnly(_purchaseDate))) {
      _showMessage(l10n.formExpiryBeforePurchase);
      return;
    }

    final price = _parsedPrice();
    final catalog = _catalog;
    final barcode = _barcode;
    final input = NewPantryItemInput(
      catalogId: catalog?.id,
      name: _nameController.text.trim(),
      emoji: catalog?.emoji,
      category: _category,
      quantity: quantity,
      unit: _unit,
      storageLocation: _location,
      purchaseDate: _purchaseDate,
      expiryDate: _expiryDate,
      expirySource: _expirySource,
      priceIdr: price,
      note: _noteController.text,
      barcode: barcode,
      notifyEnabled: _notifyEnabled,
    );

    setState(() => _isSaving = true);
    final messenger = ScaffoldMessenger.of(context);
    final repository = ref.read(pantryRepositoryProvider);
    final barcodeRepository = ref.read(barcodeRepositoryProvider);

    try {
      if (_isEditing) {
        await repository.updateItem(widget.initialItem!.id, input);
      } else {
        await repository.addItem(input);
      }
      if (barcode != null) {
        final applied = _appliedBarcode;
        final lookup = applied != null && applied.barcode == barcode
            ? applied
            : BarcodeLookup(
                barcode: barcode,
                name: input.name,
                category: input.category,
              );
        try {
          await barcodeRepository.rememberLocal(lookup);
        } on Object {
          // Remembering the barcode is best effort; the item is already saved.
        }
      }
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(_isEditing ? l10n.formUpdated : l10n.formSaved)),
      );
      Navigator.of(context).pop(true);
    } on Object {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _showMessage(l10n.formSaveError);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.formEditTitle : l10n.addItemTitle),
      ),
      body: SafeArea(
        bottom: false,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            children: <Widget>[
              Text(
                l10n.formSubtitle,
                style: context.texts.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildBarcodeSection(context, l10n),
              const SizedBox(height: AppSpacing.lg),
              _buildCatalogSection(context, l10n),
              const SizedBox(height: AppSpacing.lg),
              _buildDetailsSection(context, l10n),
              const SizedBox(height: AppSpacing.lg),
              SectionHeader(title: l10n.formSectionStorage),
              const SizedBox(height: AppSpacing.sm),
              _buildLocationChips(l10n),
              const SizedBox(height: AppSpacing.sm),
              _buildDateFields(context, l10n),
              const SizedBox(height: AppSpacing.lg),
              SectionHeader(title: l10n.formSectionOptional),
              const SizedBox(height: AppSpacing.sm),
              _buildOptionalFields(context, l10n),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: _isEditing ? l10n.formUpdate : l10n.formSave,
                icon: Icons.check_rounded,
                isLoading: _isSaving,
                expand: true,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarcodeSection(BuildContext context, AppLocalizations l10n) {
    final colors = context.colors;
    final barcode = _barcode;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.qr_code_scanner_rounded, color: colors.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      l10n.barcodeSectionTitle,
                      style: context.texts.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.barcodeSectionBody,
                      style: context.texts.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (barcode != null) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.qr_code_2_rounded,
                    size: 18,
                    color: colors.onPrimaryContainer,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Expanded(
                    child: Text(
                      l10n.barcodeAttached(barcode),
                      style: context.texts.labelMedium?.copyWith(
                        color: colors.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.barcodeClearAction,
                    visualDensity: VisualDensity.compact,
                    onPressed: _clearBarcode,
                    icon: const Icon(Icons.close_rounded, size: 18),
                    color: colors.onPrimaryContainer,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: l10n.barcodeSectionAction,
            icon: Icons.qr_code_scanner_rounded,
            variant: AppButtonVariant.outline,
            expand: true,
            onPressed: _openBarcodeLookup,
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogSection(BuildContext context, AppLocalizations l10n) {
    final popularAsync = ref.watch(popularCatalogProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SectionHeader(title: l10n.formPopularTitle),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton.icon(
            onPressed: _openCatalogPicker,
            icon: const Icon(Icons.search_rounded, size: 18),
            label: Text(l10n.formSearchCatalog),
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        popularAsync.when(
          loading: () => const LinearProgressIndicator(minHeight: 3),
          error: (error, stackTrace) => Text(
            l10n.homeLoadError,
            style: context.texts.bodySmall?.copyWith(
              color: context.colors.error,
            ),
          ),
          data: (items) {
            if (items.isEmpty) {
              return Text(
                l10n.formCustomIngredient,
                style: context.texts.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              );
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  for (
                    var index = 0;
                    index < items.length;
                    index++
                  ) ...<Widget>[
                    FilterChip(
                      selected: _catalog?.id == items[index].id,
                      onSelected: (_) => _applyCatalog(items[index]),
                      label: Text(
                        '${items[index].emoji} ${items[index].nameId}',
                      ),
                    ),
                    if (index != items.length - 1)
                      const SizedBox(width: AppSpacing.xxs),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDetailsSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SectionHeader(title: l10n.formSectionDetails),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _nameController,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.sentences,
          onChanged: _onNameChanged,
          decoration: InputDecoration(
            labelText: l10n.formNameLabel,
            hintText: l10n.formNameHint,
            prefixIcon: const Icon(Icons.eco_outlined),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.formNameRequired;
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _quantityController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                decoration: InputDecoration(labelText: l10n.formQuantityLabel),
                validator: (value) {
                  final parsed = double.tryParse(
                    (value ?? '').trim().replaceAll(',', '.'),
                  );
                  if (parsed == null || parsed <= 0) {
                    return l10n.formQuantityInvalid;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<Unit>(
                key: ValueKey<Unit>(_unit),
                initialValue: _unit,
                isExpanded: true,
                decoration: InputDecoration(labelText: l10n.formUnitLabel),
                items: <DropdownMenuItem<Unit>>[
                  for (final unit in Unit.values)
                    DropdownMenuItem<Unit>(
                      value: unit,
                      child: Text(
                        l10n.unitLabel(unit),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _unit = value);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<IngredientCategory>(
          key: ValueKey<IngredientCategory>(_category),
          initialValue: _category,
          isExpanded: true,
          decoration: InputDecoration(labelText: l10n.formCategoryLabel),
          items: <DropdownMenuItem<IngredientCategory>>[
            for (final category in IngredientCategory.values)
              DropdownMenuItem<IngredientCategory>(
                value: category,
                child: Text(
                  l10n.categoryLabel(category),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: (value) {
            if (value != null) setState(() => _category = value);
          },
        ),
      ],
    );
  }

  Widget _buildLocationChips(AppLocalizations l10n) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xxs,
      children: <Widget>[
        for (final location in StorageLocation.values)
          ChoiceChip(
            label: Text(l10n.storageLabel(location)),
            selected: _location == location,
            onSelected: (_) => _onLocationChanged(location),
          ),
      ],
    );
  }

  Widget _buildDateFields(BuildContext context, AppLocalizations l10n) {
    final catalog = _catalog;
    final shelfLifeDays = catalog?.shelfLifeFor(_location);
    final sourceLabel = _expirySource == ExpirySource.estimasi
        ? l10n.formExpiryEstimate
        : _expirySource == ExpirySource.kemasan
        ? l10n.expirySourceKemasan
        : l10n.formExpiryManual;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _DateField(
          label: l10n.formPurchaseDateLabel,
          value: formatDateId(_purchaseDate),
          onTap: _pickPurchaseDate,
        ),
        const SizedBox(height: AppSpacing.sm),
        _DateField(
          label: l10n.formExpiryDateLabel,
          value: formatDateId(_expiryDate),
          onTap: _pickExpiryDate,
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              _expirySource == ExpirySource.estimasi
                  ? Icons.auto_awesome_rounded
                  : Icons.edit_calendar_rounded,
              size: 16,
              color: context.colors.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.xxs),
            Expanded(
              child: Text(
                sourceLabel,
                style: context.texts.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        if (catalog != null) ...<Widget>[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            shelfLifeDays == null
                ? l10n.formShelfLifeUnknown
                : l10n.formShelfLifeInfo(
                    l10n.storageLabel(_location),
                    shelfLifeDays,
                  ),
            style: context.texts.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          if (catalog.shelfLifeNote.trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: 2),
            Text(
              catalog.shelfLifeNote,
              style: context.texts.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildOptionalFields(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextFormField(
          controller: _priceController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            labelText: l10n.formPriceLabel,
            hintText: l10n.formPriceHint,
            prefixText: 'Rp ',
          ),
          validator: (value) {
            final raw = (value ?? '').trim();
            if (raw.isEmpty) return null;
            if (int.tryParse(raw) == null) return l10n.formPriceInvalid;
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _noteController,
          minLines: 2,
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: l10n.formNoteLabel,
            hintText: l10n.formNoteHint,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          padding: EdgeInsets.zero,
          child: SwitchListTile.adaptive(
            value: _notifyEnabled,
            onChanged: (value) => setState(() => _notifyEnabled = value),
            title: Text(l10n.formNotifyLabel),
            subtitle: Text(l10n.formNotifyBody),
            secondary: const Icon(Icons.notifications_active_outlined),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xxs,
            ),
          ),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.button),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_month_rounded),
        ),
        child: Text(value),
      ),
    );
  }
}

class _CatalogPickerSheet extends ConsumerStatefulWidget {
  const _CatalogPickerSheet({this.selectedId});

  final String? selectedId;

  @override
  ConsumerState<_CatalogPickerSheet> createState() =>
      _CatalogPickerSheetState();
}

class _CatalogPickerSheetState extends ConsumerState<_CatalogPickerSheet> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final catalogAsync = ref.watch(catalogListProvider);
    final viewInsets = MediaQuery.viewInsetsOf(context);

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.72,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Text(
                l10n.formSearchCatalog,
                style: context.texts.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: TextField(
                controller: _controller,
                autofocus: true,
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  hintText: l10n.formCatalogSearchHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                  isDense: true,
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _controller.clear();
                            setState(() => _query = '');
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: catalogAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: LoadingSkeleton(items: 4),
                ),
                error: (error, stackTrace) => Center(
                  child: Text(
                    l10n.homeLoadError,
                    style: TextStyle(color: colors.error),
                  ),
                ),
                data: (items) {
                  final filtered = filterCatalogItems(items, _query);
                  if (filtered.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Text(
                          l10n.formCatalogEmpty,
                          textAlign: TextAlign.center,
                          style: context.texts.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.sm,
                      AppSpacing.xxs,
                      AppSpacing.sm,
                      AppSpacing.lg,
                    ),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return ListTile(
                        leading: Text(
                          item.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                        title: Text(item.nameId),
                        subtitle: Text(l10n.categoryLabel(item.category)),
                        trailing: widget.selectedId == item.id
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: colors.primary,
                              )
                            : null,
                        onTap: () => Navigator.of(context).pop(item),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
