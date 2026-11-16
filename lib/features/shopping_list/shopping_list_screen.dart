import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/format_utils.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_skeleton.dart';
import '../../data/local/enums.dart';
import '../../data/models/shopping_list_entry.dart';
import '../../data/repositories/repository_providers.dart';
import '../../l10n/app_labels.dart';
import '../../l10n/app_localizations.dart';
import 'shopping_list_providers.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  Future<void> _addItem() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final draft = await showModalBottomSheet<_ShoppingDraft>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _ShoppingItemSheet(
        title: l10n.shoppingListAddTitle,
        saveLabel: l10n.shoppingListAddAction,
      ),
    );
    if (draft == null) return;

    await ref
        .read(shoppingListRepositoryProvider)
        .addItem(name: draft.name, quantity: draft.quantity, unit: draft.unit);
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.shoppingListAddSuccess)),
    );
  }

  Future<void> _editItem(ShoppingListEntry entry) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final draft = await showModalBottomSheet<_ShoppingDraft>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _ShoppingItemSheet(
        title: l10n.shoppingListEditTitle,
        saveLabel: l10n.genericSave,
        initial: entry,
      ),
    );
    if (draft == null) return;

    await ref
        .read(shoppingListRepositoryProvider)
        .updateItem(
          entry.id,
          name: draft.name,
          quantity: draft.quantity,
          unit: draft.unit,
        );
    messenger.showSnackBar(SnackBar(content: Text(l10n.formUpdated)));
  }

  Future<void> _deleteItem(ShoppingListEntry entry) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await ref.read(shoppingListRepositoryProvider).deleteItem(entry.id);
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.shoppingListDeleteSuccess)),
    );
  }

  Future<void> _clearChecked() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await ref.read(shoppingListRepositoryProvider).clearChecked();
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.shoppingListClearCheckedSuccess)),
    );
  }

  Future<void> _clearAll() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.shoppingListClearAllConfirmTitle,
      message: l10n.shoppingListClearAllConfirmBody,
      confirmLabel: l10n.shoppingListClearAll,
      destructive: true,
    );
    if (!confirmed) return;

    await ref.read(shoppingListRepositoryProvider).clearAll();
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.shoppingListClearCheckedSuccess)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final asyncItems = ref.watch(shoppingListProvider);
    final items = asyncItems.value ?? const <ShoppingListEntry>[];
    final checked = items.where((item) => item.isChecked).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.shoppingListTitle),
        actions: <Widget>[
          if (checked > 0)
            IconButton(
              tooltip: l10n.shoppingListClearChecked,
              onPressed: _clearChecked,
              icon: const Icon(Icons.done_all_rounded),
            ),
          if (items.isNotEmpty)
            PopupMenuButton<String>(
              tooltip: l10n.shoppingListTitle,
              onSelected: (value) {
                if (value == 'clear') _clearAll();
              },
              itemBuilder: (context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'clear',
                  child: Text(l10n.shoppingListClearAll),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addItem,
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.shoppingListAddAction),
      ),
      body: SafeArea(
        child: asyncItems.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: LoadingSkeleton(items: 4),
          ),
          error: (error, stackTrace) => EmptyState(
            icon: Icons.error_outline_rounded,
            title: l10n.genericRetry,
            message: l10n.homeLoadError,
            action: AppButton(
              label: l10n.genericRetry,
              onPressed: () => ref.invalidate(shoppingListProvider),
            ),
          ),
          data: (entries) {
            if (entries.isEmpty) {
              return EmptyState(
                icon: Icons.shopping_basket_outlined,
                title: l10n.shoppingListEmptyTitle,
                message: l10n.shoppingListEmptyBody,
                action: AppButton(
                  label: l10n.shoppingListAddAction,
                  icon: Icons.add_rounded,
                  onPressed: _addItem,
                ),
              );
            }
            return _ShoppingListBody(
              entries: entries,
              onToggle: (entry, checked) => ref
                  .read(shoppingListRepositoryProvider)
                  .setChecked(entry.id, checked),
              onEdit: _editItem,
              onDelete: _deleteItem,
            );
          },
        ),
      ),
    );
  }
}

class _ShoppingListBody extends StatelessWidget {
  const _ShoppingListBody({
    required this.entries,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final List<ShoppingListEntry> entries;
  final void Function(ShoppingListEntry entry, bool checked) onToggle;
  final ValueChanged<ShoppingListEntry> onEdit;
  final ValueChanged<ShoppingListEntry> onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final checked = entries.where((item) => item.isChecked).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        100,
      ),
      children: <Widget>[
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                l10n.shoppingListCheckedCount(checked, entries.length),
                style: context.texts.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: LinearProgressIndicator(
                  value: entries.isEmpty ? 0 : checked / entries.length,
                  minHeight: 8,
                  backgroundColor: colors.surfaceContainerHighest,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SlidableAutoCloseBehavior(
          child: Column(
            children: <Widget>[
              for (final entry in entries) ...<Widget>[
                Slidable(
                  key: ValueKey<String>(entry.id),
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    extentRatio: 0.28,
                    children: <Widget>[
                      SlidableAction(
                        onPressed: (_) => onDelete(entry),
                        backgroundColor: colors.error,
                        foregroundColor: colors.onError,
                        icon: Icons.delete_outline_rounded,
                        label: l10n.genericDelete,
                      ),
                    ],
                  ),
                  child: AppCard(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: Checkbox(
                        value: entry.isChecked,
                        onChanged: (value) => onToggle(entry, value ?? false),
                      ),
                      onLongPress: () => onEdit(entry),
                      trailing: IconButton(
                        tooltip: l10n.genericEdit,
                        onPressed: () => onEdit(entry),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      title: Text(
                        entry.name,
                        style: context.texts.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          decoration: entry.isChecked
                              ? TextDecoration.lineThrough
                              : null,
                          color: entry.isChecked
                              ? colors.onSurfaceVariant
                              : null,
                        ),
                      ),
                      subtitle: Text(
                        '${formatQuantity(entry.quantity)} '
                        '${l10n.unitLabel(entry.unit)} • '
                        '${l10n.shoppingSourceLabel(entry.source)}',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ShoppingDraft {
  const _ShoppingDraft({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  final String name;
  final double quantity;
  final Unit unit;
}

class _ShoppingItemSheet extends StatefulWidget {
  const _ShoppingItemSheet({
    required this.title,
    required this.saveLabel,
    this.initial,
  });

  final String title;
  final String saveLabel;
  final ShoppingListEntry? initial;

  @override
  State<_ShoppingItemSheet> createState() => _ShoppingItemSheetState();
}

class _ShoppingItemSheetState extends State<_ShoppingItemSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late Unit _unit;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _nameController = TextEditingController(text: initial?.name ?? '');
    _quantityController = TextEditingController(
      text: initial == null ? '1' : formatQuantity(initial.quantity),
    );
    _unit = initial?.unit ?? Unit.pcs;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final quantity = double.parse(
      _quantityController.text.trim().replaceAll(',', '.'),
    );
    Navigator.of(context).pop(
      _ShoppingDraft(
        name: _nameController.text.trim(),
        quantity: quantity,
        unit: _unit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.title,
                style: context.texts.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.shoppingListNameLabel,
                  hintText: l10n.shoppingListNameHint,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.shoppingListNameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: l10n.shoppingListQuantityLabel,
                      ),
                      validator: (value) {
                        final parsed = double.tryParse(
                          (value ?? '').trim().replaceAll(',', '.'),
                        );
                        if (parsed == null || parsed <= 0) {
                          return l10n.shoppingListQuantityInvalid;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: DropdownButtonFormField<Unit>(
                      initialValue: _unit,
                      decoration: InputDecoration(
                        labelText: l10n.shoppingListUnitLabel,
                      ),
                      items: Unit.values
                          .map(
                            (unit) => DropdownMenuItem<Unit>(
                              value: unit,
                              child: Text(l10n.unitLabel(unit)),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (unit) {
                        if (unit != null) setState(() => _unit = unit);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: widget.saveLabel,
                expand: true,
                onPressed: _submit,
              ),
              const SizedBox(height: AppSpacing.xs),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    l10n.genericCancel,
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
