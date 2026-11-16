// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PantryItemsTable extends PantryItems
    with TableInfo<$PantryItemsTable, PantryItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PantryItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catalogIdMeta = const VerificationMeta(
    'catalogId',
  );
  @override
  late final GeneratedColumn<String> catalogId = GeneratedColumn<String>(
    'catalog_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _photoAssetMeta = const VerificationMeta(
    'photoAsset',
  );
  @override
  late final GeneratedColumn<String> photoAsset = GeneratedColumn<String>(
    'photo_asset',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<IngredientCategory, String>
  category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<IngredientCategory>($PantryItemsTable.$convertercategory);
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Unit, String> unit =
      GeneratedColumn<String>(
        'unit',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Unit>($PantryItemsTable.$converterunit);
  static const VerificationMeta _weightGramsMeta = const VerificationMeta(
    'weightGrams',
  );
  @override
  late final GeneratedColumn<int> weightGrams = GeneratedColumn<int>(
    'weight_grams',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<StorageLocation, String>
  storageLocation = GeneratedColumn<String>(
    'storage_location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<StorageLocation>($PantryItemsTable.$converterstorageLocation);
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
    'purchase_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiryDateMeta = const VerificationMeta(
    'expiryDate',
  );
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
    'expiry_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ExpirySource, String>
  expirySource = GeneratedColumn<String>(
    'expiry_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<ExpirySource>($PantryItemsTable.$converterexpirySource);
  static const VerificationMeta _priceIdrMeta = const VerificationMeta(
    'priceIdr',
  );
  @override
  late final GeneratedColumn<int> priceIdr = GeneratedColumn<int>(
    'price_idr',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notifyEnabledMeta = const VerificationMeta(
    'notifyEnabled',
  );
  @override
  late final GeneratedColumn<bool> notifyEnabled = GeneratedColumn<bool>(
    'notify_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PantryStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('aktif'),
      ).withConverter<PantryStatus>($PantryItemsTable.$converterstatus);
  static const VerificationMeta _statusChangedAtMeta = const VerificationMeta(
    'statusChangedAt',
  );
  @override
  late final GeneratedColumn<DateTime> statusChangedAt =
      GeneratedColumn<DateTime>(
        'status_changed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    catalogId,
    name,
    emoji,
    photoAsset,
    category,
    quantity,
    unit,
    weightGrams,
    storageLocation,
    purchaseDate,
    expiryDate,
    expirySource,
    priceIdr,
    barcode,
    note,
    notifyEnabled,
    status,
    statusChangedAt,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pantry_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PantryItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('catalog_id')) {
      context.handle(
        _catalogIdMeta,
        catalogId.isAcceptableOrUnknown(data['catalog_id']!, _catalogIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    }
    if (data.containsKey('photo_asset')) {
      context.handle(
        _photoAssetMeta,
        photoAsset.isAcceptableOrUnknown(data['photo_asset']!, _photoAssetMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('weight_grams')) {
      context.handle(
        _weightGramsMeta,
        weightGrams.isAcceptableOrUnknown(
          data['weight_grams']!,
          _weightGramsMeta,
        ),
      );
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchaseDateMeta);
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
        _expiryDateMeta,
        expiryDate.isAcceptableOrUnknown(data['expiry_date']!, _expiryDateMeta),
      );
    } else if (isInserting) {
      context.missing(_expiryDateMeta);
    }
    if (data.containsKey('price_idr')) {
      context.handle(
        _priceIdrMeta,
        priceIdr.isAcceptableOrUnknown(data['price_idr']!, _priceIdrMeta),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('notify_enabled')) {
      context.handle(
        _notifyEnabledMeta,
        notifyEnabled.isAcceptableOrUnknown(
          data['notify_enabled']!,
          _notifyEnabledMeta,
        ),
      );
    }
    if (data.containsKey('status_changed_at')) {
      context.handle(
        _statusChangedAtMeta,
        statusChangedAt.isAcceptableOrUnknown(
          data['status_changed_at']!,
          _statusChangedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PantryItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PantryItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      catalogId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      photoAsset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_asset'],
      ),
      category: $PantryItemsTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unit: $PantryItemsTable.$converterunit.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unit'],
        )!,
      ),
      weightGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight_grams'],
      ),
      storageLocation: $PantryItemsTable.$converterstorageLocation.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}storage_location'],
        )!,
      ),
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchase_date'],
      )!,
      expiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expiry_date'],
      )!,
      expirySource: $PantryItemsTable.$converterexpirySource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}expiry_source'],
        )!,
      ),
      priceIdr: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_idr'],
      ),
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      notifyEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_enabled'],
      )!,
      status: $PantryItemsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      statusChangedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}status_changed_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $PantryItemsTable createAlias(String alias) {
    return $PantryItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<IngredientCategory, String, String>
  $convertercategory = const EnumNameConverter<IngredientCategory>(
    IngredientCategory.values,
  );
  static JsonTypeConverter2<Unit, String, String> $converterunit =
      const EnumNameConverter<Unit>(Unit.values);
  static JsonTypeConverter2<StorageLocation, String, String>
  $converterstorageLocation = const EnumNameConverter<StorageLocation>(
    StorageLocation.values,
  );
  static JsonTypeConverter2<ExpirySource, String, String>
  $converterexpirySource = const EnumNameConverter<ExpirySource>(
    ExpirySource.values,
  );
  static JsonTypeConverter2<PantryStatus, String, String> $converterstatus =
      const EnumNameConverter<PantryStatus>(PantryStatus.values);
}

class PantryItem extends DataClass implements Insertable<PantryItem> {
  final String id;

  /// Null for custom ingredients that are not in the catalog.
  final String? catalogId;
  final String name;
  final String emoji;
  final String? photoAsset;
  final IngredientCategory category;
  final double quantity;
  final Unit unit;

  /// Total weight in grams. Derived from catalog weight per unit when null.
  final int? weightGrams;
  final StorageLocation storageLocation;
  final DateTime purchaseDate;
  final DateTime expiryDate;
  final ExpirySource expirySource;
  final int? priceIdr;
  final String? barcode;
  final String? note;
  final bool notifyEnabled;
  final PantryStatus status;
  final DateTime? statusChangedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Soft delete. Rows with a value here are excluded from lists and stats.
  final DateTime? deletedAt;
  const PantryItem({
    required this.id,
    this.catalogId,
    required this.name,
    required this.emoji,
    this.photoAsset,
    required this.category,
    required this.quantity,
    required this.unit,
    this.weightGrams,
    required this.storageLocation,
    required this.purchaseDate,
    required this.expiryDate,
    required this.expirySource,
    this.priceIdr,
    this.barcode,
    this.note,
    required this.notifyEnabled,
    required this.status,
    this.statusChangedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || catalogId != null) {
      map['catalog_id'] = Variable<String>(catalogId);
    }
    map['name'] = Variable<String>(name);
    map['emoji'] = Variable<String>(emoji);
    if (!nullToAbsent || photoAsset != null) {
      map['photo_asset'] = Variable<String>(photoAsset);
    }
    {
      map['category'] = Variable<String>(
        $PantryItemsTable.$convertercategory.toSql(category),
      );
    }
    map['quantity'] = Variable<double>(quantity);
    {
      map['unit'] = Variable<String>(
        $PantryItemsTable.$converterunit.toSql(unit),
      );
    }
    if (!nullToAbsent || weightGrams != null) {
      map['weight_grams'] = Variable<int>(weightGrams);
    }
    {
      map['storage_location'] = Variable<String>(
        $PantryItemsTable.$converterstorageLocation.toSql(storageLocation),
      );
    }
    map['purchase_date'] = Variable<DateTime>(purchaseDate);
    map['expiry_date'] = Variable<DateTime>(expiryDate);
    {
      map['expiry_source'] = Variable<String>(
        $PantryItemsTable.$converterexpirySource.toSql(expirySource),
      );
    }
    if (!nullToAbsent || priceIdr != null) {
      map['price_idr'] = Variable<int>(priceIdr);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['notify_enabled'] = Variable<bool>(notifyEnabled);
    {
      map['status'] = Variable<String>(
        $PantryItemsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || statusChangedAt != null) {
      map['status_changed_at'] = Variable<DateTime>(statusChangedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  PantryItemsCompanion toCompanion(bool nullToAbsent) {
    return PantryItemsCompanion(
      id: Value(id),
      catalogId: catalogId == null && nullToAbsent
          ? const Value.absent()
          : Value(catalogId),
      name: Value(name),
      emoji: Value(emoji),
      photoAsset: photoAsset == null && nullToAbsent
          ? const Value.absent()
          : Value(photoAsset),
      category: Value(category),
      quantity: Value(quantity),
      unit: Value(unit),
      weightGrams: weightGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(weightGrams),
      storageLocation: Value(storageLocation),
      purchaseDate: Value(purchaseDate),
      expiryDate: Value(expiryDate),
      expirySource: Value(expirySource),
      priceIdr: priceIdr == null && nullToAbsent
          ? const Value.absent()
          : Value(priceIdr),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      notifyEnabled: Value(notifyEnabled),
      status: Value(status),
      statusChangedAt: statusChangedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(statusChangedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory PantryItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PantryItem(
      id: serializer.fromJson<String>(json['id']),
      catalogId: serializer.fromJson<String?>(json['catalogId']),
      name: serializer.fromJson<String>(json['name']),
      emoji: serializer.fromJson<String>(json['emoji']),
      photoAsset: serializer.fromJson<String?>(json['photoAsset']),
      category: $PantryItemsTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: $PantryItemsTable.$converterunit.fromJson(
        serializer.fromJson<String>(json['unit']),
      ),
      weightGrams: serializer.fromJson<int?>(json['weightGrams']),
      storageLocation: $PantryItemsTable.$converterstorageLocation.fromJson(
        serializer.fromJson<String>(json['storageLocation']),
      ),
      purchaseDate: serializer.fromJson<DateTime>(json['purchaseDate']),
      expiryDate: serializer.fromJson<DateTime>(json['expiryDate']),
      expirySource: $PantryItemsTable.$converterexpirySource.fromJson(
        serializer.fromJson<String>(json['expirySource']),
      ),
      priceIdr: serializer.fromJson<int?>(json['priceIdr']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      note: serializer.fromJson<String?>(json['note']),
      notifyEnabled: serializer.fromJson<bool>(json['notifyEnabled']),
      status: $PantryItemsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      statusChangedAt: serializer.fromJson<DateTime?>(json['statusChangedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'catalogId': serializer.toJson<String?>(catalogId),
      'name': serializer.toJson<String>(name),
      'emoji': serializer.toJson<String>(emoji),
      'photoAsset': serializer.toJson<String?>(photoAsset),
      'category': serializer.toJson<String>(
        $PantryItemsTable.$convertercategory.toJson(category),
      ),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(
        $PantryItemsTable.$converterunit.toJson(unit),
      ),
      'weightGrams': serializer.toJson<int?>(weightGrams),
      'storageLocation': serializer.toJson<String>(
        $PantryItemsTable.$converterstorageLocation.toJson(storageLocation),
      ),
      'purchaseDate': serializer.toJson<DateTime>(purchaseDate),
      'expiryDate': serializer.toJson<DateTime>(expiryDate),
      'expirySource': serializer.toJson<String>(
        $PantryItemsTable.$converterexpirySource.toJson(expirySource),
      ),
      'priceIdr': serializer.toJson<int?>(priceIdr),
      'barcode': serializer.toJson<String?>(barcode),
      'note': serializer.toJson<String?>(note),
      'notifyEnabled': serializer.toJson<bool>(notifyEnabled),
      'status': serializer.toJson<String>(
        $PantryItemsTable.$converterstatus.toJson(status),
      ),
      'statusChangedAt': serializer.toJson<DateTime?>(statusChangedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  PantryItem copyWith({
    String? id,
    Value<String?> catalogId = const Value.absent(),
    String? name,
    String? emoji,
    Value<String?> photoAsset = const Value.absent(),
    IngredientCategory? category,
    double? quantity,
    Unit? unit,
    Value<int?> weightGrams = const Value.absent(),
    StorageLocation? storageLocation,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    ExpirySource? expirySource,
    Value<int?> priceIdr = const Value.absent(),
    Value<String?> barcode = const Value.absent(),
    Value<String?> note = const Value.absent(),
    bool? notifyEnabled,
    PantryStatus? status,
    Value<DateTime?> statusChangedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => PantryItem(
    id: id ?? this.id,
    catalogId: catalogId.present ? catalogId.value : this.catalogId,
    name: name ?? this.name,
    emoji: emoji ?? this.emoji,
    photoAsset: photoAsset.present ? photoAsset.value : this.photoAsset,
    category: category ?? this.category,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    weightGrams: weightGrams.present ? weightGrams.value : this.weightGrams,
    storageLocation: storageLocation ?? this.storageLocation,
    purchaseDate: purchaseDate ?? this.purchaseDate,
    expiryDate: expiryDate ?? this.expiryDate,
    expirySource: expirySource ?? this.expirySource,
    priceIdr: priceIdr.present ? priceIdr.value : this.priceIdr,
    barcode: barcode.present ? barcode.value : this.barcode,
    note: note.present ? note.value : this.note,
    notifyEnabled: notifyEnabled ?? this.notifyEnabled,
    status: status ?? this.status,
    statusChangedAt: statusChangedAt.present
        ? statusChangedAt.value
        : this.statusChangedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  PantryItem copyWithCompanion(PantryItemsCompanion data) {
    return PantryItem(
      id: data.id.present ? data.id.value : this.id,
      catalogId: data.catalogId.present ? data.catalogId.value : this.catalogId,
      name: data.name.present ? data.name.value : this.name,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      photoAsset: data.photoAsset.present
          ? data.photoAsset.value
          : this.photoAsset,
      category: data.category.present ? data.category.value : this.category,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      weightGrams: data.weightGrams.present
          ? data.weightGrams.value
          : this.weightGrams,
      storageLocation: data.storageLocation.present
          ? data.storageLocation.value
          : this.storageLocation,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      expiryDate: data.expiryDate.present
          ? data.expiryDate.value
          : this.expiryDate,
      expirySource: data.expirySource.present
          ? data.expirySource.value
          : this.expirySource,
      priceIdr: data.priceIdr.present ? data.priceIdr.value : this.priceIdr,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      note: data.note.present ? data.note.value : this.note,
      notifyEnabled: data.notifyEnabled.present
          ? data.notifyEnabled.value
          : this.notifyEnabled,
      status: data.status.present ? data.status.value : this.status,
      statusChangedAt: data.statusChangedAt.present
          ? data.statusChangedAt.value
          : this.statusChangedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PantryItem(')
          ..write('id: $id, ')
          ..write('catalogId: $catalogId, ')
          ..write('name: $name, ')
          ..write('emoji: $emoji, ')
          ..write('photoAsset: $photoAsset, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('storageLocation: $storageLocation, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('expirySource: $expirySource, ')
          ..write('priceIdr: $priceIdr, ')
          ..write('barcode: $barcode, ')
          ..write('note: $note, ')
          ..write('notifyEnabled: $notifyEnabled, ')
          ..write('status: $status, ')
          ..write('statusChangedAt: $statusChangedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    catalogId,
    name,
    emoji,
    photoAsset,
    category,
    quantity,
    unit,
    weightGrams,
    storageLocation,
    purchaseDate,
    expiryDate,
    expirySource,
    priceIdr,
    barcode,
    note,
    notifyEnabled,
    status,
    statusChangedAt,
    createdAt,
    updatedAt,
    deletedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PantryItem &&
          other.id == this.id &&
          other.catalogId == this.catalogId &&
          other.name == this.name &&
          other.emoji == this.emoji &&
          other.photoAsset == this.photoAsset &&
          other.category == this.category &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.weightGrams == this.weightGrams &&
          other.storageLocation == this.storageLocation &&
          other.purchaseDate == this.purchaseDate &&
          other.expiryDate == this.expiryDate &&
          other.expirySource == this.expirySource &&
          other.priceIdr == this.priceIdr &&
          other.barcode == this.barcode &&
          other.note == this.note &&
          other.notifyEnabled == this.notifyEnabled &&
          other.status == this.status &&
          other.statusChangedAt == this.statusChangedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class PantryItemsCompanion extends UpdateCompanion<PantryItem> {
  final Value<String> id;
  final Value<String?> catalogId;
  final Value<String> name;
  final Value<String> emoji;
  final Value<String?> photoAsset;
  final Value<IngredientCategory> category;
  final Value<double> quantity;
  final Value<Unit> unit;
  final Value<int?> weightGrams;
  final Value<StorageLocation> storageLocation;
  final Value<DateTime> purchaseDate;
  final Value<DateTime> expiryDate;
  final Value<ExpirySource> expirySource;
  final Value<int?> priceIdr;
  final Value<String?> barcode;
  final Value<String?> note;
  final Value<bool> notifyEnabled;
  final Value<PantryStatus> status;
  final Value<DateTime?> statusChangedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const PantryItemsCompanion({
    this.id = const Value.absent(),
    this.catalogId = const Value.absent(),
    this.name = const Value.absent(),
    this.emoji = const Value.absent(),
    this.photoAsset = const Value.absent(),
    this.category = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.weightGrams = const Value.absent(),
    this.storageLocation = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.expirySource = const Value.absent(),
    this.priceIdr = const Value.absent(),
    this.barcode = const Value.absent(),
    this.note = const Value.absent(),
    this.notifyEnabled = const Value.absent(),
    this.status = const Value.absent(),
    this.statusChangedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PantryItemsCompanion.insert({
    required String id,
    this.catalogId = const Value.absent(),
    required String name,
    this.emoji = const Value.absent(),
    this.photoAsset = const Value.absent(),
    required IngredientCategory category,
    required double quantity,
    required Unit unit,
    this.weightGrams = const Value.absent(),
    required StorageLocation storageLocation,
    required DateTime purchaseDate,
    required DateTime expiryDate,
    required ExpirySource expirySource,
    this.priceIdr = const Value.absent(),
    this.barcode = const Value.absent(),
    this.note = const Value.absent(),
    this.notifyEnabled = const Value.absent(),
    this.status = const Value.absent(),
    this.statusChangedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       category = Value(category),
       quantity = Value(quantity),
       unit = Value(unit),
       storageLocation = Value(storageLocation),
       purchaseDate = Value(purchaseDate),
       expiryDate = Value(expiryDate),
       expirySource = Value(expirySource),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PantryItem> custom({
    Expression<String>? id,
    Expression<String>? catalogId,
    Expression<String>? name,
    Expression<String>? emoji,
    Expression<String>? photoAsset,
    Expression<String>? category,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<int>? weightGrams,
    Expression<String>? storageLocation,
    Expression<DateTime>? purchaseDate,
    Expression<DateTime>? expiryDate,
    Expression<String>? expirySource,
    Expression<int>? priceIdr,
    Expression<String>? barcode,
    Expression<String>? note,
    Expression<bool>? notifyEnabled,
    Expression<String>? status,
    Expression<DateTime>? statusChangedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (catalogId != null) 'catalog_id': catalogId,
      if (name != null) 'name': name,
      if (emoji != null) 'emoji': emoji,
      if (photoAsset != null) 'photo_asset': photoAsset,
      if (category != null) 'category': category,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (weightGrams != null) 'weight_grams': weightGrams,
      if (storageLocation != null) 'storage_location': storageLocation,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (expirySource != null) 'expiry_source': expirySource,
      if (priceIdr != null) 'price_idr': priceIdr,
      if (barcode != null) 'barcode': barcode,
      if (note != null) 'note': note,
      if (notifyEnabled != null) 'notify_enabled': notifyEnabled,
      if (status != null) 'status': status,
      if (statusChangedAt != null) 'status_changed_at': statusChangedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PantryItemsCompanion copyWith({
    Value<String>? id,
    Value<String?>? catalogId,
    Value<String>? name,
    Value<String>? emoji,
    Value<String?>? photoAsset,
    Value<IngredientCategory>? category,
    Value<double>? quantity,
    Value<Unit>? unit,
    Value<int?>? weightGrams,
    Value<StorageLocation>? storageLocation,
    Value<DateTime>? purchaseDate,
    Value<DateTime>? expiryDate,
    Value<ExpirySource>? expirySource,
    Value<int?>? priceIdr,
    Value<String?>? barcode,
    Value<String?>? note,
    Value<bool>? notifyEnabled,
    Value<PantryStatus>? status,
    Value<DateTime?>? statusChangedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return PantryItemsCompanion(
      id: id ?? this.id,
      catalogId: catalogId ?? this.catalogId,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      photoAsset: photoAsset ?? this.photoAsset,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      weightGrams: weightGrams ?? this.weightGrams,
      storageLocation: storageLocation ?? this.storageLocation,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      expirySource: expirySource ?? this.expirySource,
      priceIdr: priceIdr ?? this.priceIdr,
      barcode: barcode ?? this.barcode,
      note: note ?? this.note,
      notifyEnabled: notifyEnabled ?? this.notifyEnabled,
      status: status ?? this.status,
      statusChangedAt: statusChangedAt ?? this.statusChangedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (catalogId.present) {
      map['catalog_id'] = Variable<String>(catalogId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (photoAsset.present) {
      map['photo_asset'] = Variable<String>(photoAsset.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $PantryItemsTable.$convertercategory.toSql(category.value),
      );
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(
        $PantryItemsTable.$converterunit.toSql(unit.value),
      );
    }
    if (weightGrams.present) {
      map['weight_grams'] = Variable<int>(weightGrams.value);
    }
    if (storageLocation.present) {
      map['storage_location'] = Variable<String>(
        $PantryItemsTable.$converterstorageLocation.toSql(
          storageLocation.value,
        ),
      );
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (expirySource.present) {
      map['expiry_source'] = Variable<String>(
        $PantryItemsTable.$converterexpirySource.toSql(expirySource.value),
      );
    }
    if (priceIdr.present) {
      map['price_idr'] = Variable<int>(priceIdr.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (notifyEnabled.present) {
      map['notify_enabled'] = Variable<bool>(notifyEnabled.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $PantryItemsTable.$converterstatus.toSql(status.value),
      );
    }
    if (statusChangedAt.present) {
      map['status_changed_at'] = Variable<DateTime>(statusChangedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PantryItemsCompanion(')
          ..write('id: $id, ')
          ..write('catalogId: $catalogId, ')
          ..write('name: $name, ')
          ..write('emoji: $emoji, ')
          ..write('photoAsset: $photoAsset, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('storageLocation: $storageLocation, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('expirySource: $expirySource, ')
          ..write('priceIdr: $priceIdr, ')
          ..write('barcode: $barcode, ')
          ..write('note: $note, ')
          ..write('notifyEnabled: $notifyEnabled, ')
          ..write('status: $status, ')
          ..write('statusChangedAt: $statusChangedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsageLogsTable extends UsageLogs
    with TableInfo<$UsageLogsTable, UsageLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsageLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pantryItemIdMeta = const VerificationMeta(
    'pantryItemId',
  );
  @override
  late final GeneratedColumn<String> pantryItemId = GeneratedColumn<String>(
    'pantry_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<UsageAction, String> action =
      GeneratedColumn<String>(
        'action',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<UsageAction>($UsageLogsTable.$converteraction);
  static const VerificationMeta _quantityChangedMeta = const VerificationMeta(
    'quantityChanged',
  );
  @override
  late final GeneratedColumn<double> quantityChanged = GeneratedColumn<double>(
    'quantity_changed',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueIdrMeta = const VerificationMeta(
    'valueIdr',
  );
  @override
  late final GeneratedColumn<int> valueIdr = GeneratedColumn<int>(
    'value_idr',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isEstimateMeta = const VerificationMeta(
    'isEstimate',
  );
  @override
  late final GeneratedColumn<bool> isEstimate = GeneratedColumn<bool>(
    'is_estimate',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_estimate" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _weightGramsMeta = const VerificationMeta(
    'weightGrams',
  );
  @override
  late final GeneratedColumn<int> weightGrams = GeneratedColumn<int>(
    'weight_grams',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<IngredientCategory, String>
  category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<IngredientCategory>($UsageLogsTable.$convertercategory);
  @override
  late final GeneratedColumnWithTypeConverter<WasteReason?, String>
  reasonWasted = GeneratedColumn<String>(
    'reason_wasted',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<WasteReason?>($UsageLogsTable.$converterreasonWastedn);
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pantryItemId,
    action,
    quantityChanged,
    valueIdr,
    isEstimate,
    weightGrams,
    category,
    reasonWasted,
    loggedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usage_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsageLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('pantry_item_id')) {
      context.handle(
        _pantryItemIdMeta,
        pantryItemId.isAcceptableOrUnknown(
          data['pantry_item_id']!,
          _pantryItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pantryItemIdMeta);
    }
    if (data.containsKey('quantity_changed')) {
      context.handle(
        _quantityChangedMeta,
        quantityChanged.isAcceptableOrUnknown(
          data['quantity_changed']!,
          _quantityChangedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityChangedMeta);
    }
    if (data.containsKey('value_idr')) {
      context.handle(
        _valueIdrMeta,
        valueIdr.isAcceptableOrUnknown(data['value_idr']!, _valueIdrMeta),
      );
    }
    if (data.containsKey('is_estimate')) {
      context.handle(
        _isEstimateMeta,
        isEstimate.isAcceptableOrUnknown(data['is_estimate']!, _isEstimateMeta),
      );
    }
    if (data.containsKey('weight_grams')) {
      context.handle(
        _weightGramsMeta,
        weightGrams.isAcceptableOrUnknown(
          data['weight_grams']!,
          _weightGramsMeta,
        ),
      );
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsageLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsageLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      pantryItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pantry_item_id'],
      )!,
      action: $UsageLogsTable.$converteraction.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}action'],
        )!,
      ),
      quantityChanged: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity_changed'],
      )!,
      valueIdr: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value_idr'],
      )!,
      isEstimate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_estimate'],
      )!,
      weightGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight_grams'],
      )!,
      category: $UsageLogsTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      reasonWasted: $UsageLogsTable.$converterreasonWastedn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reason_wasted'],
        ),
      ),
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_at'],
      )!,
    );
  }

  @override
  $UsageLogsTable createAlias(String alias) {
    return $UsageLogsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<UsageAction, String, String> $converteraction =
      const EnumNameConverter<UsageAction>(UsageAction.values);
  static JsonTypeConverter2<IngredientCategory, String, String>
  $convertercategory = const EnumNameConverter<IngredientCategory>(
    IngredientCategory.values,
  );
  static JsonTypeConverter2<WasteReason, String, String>
  $converterreasonWasted = const EnumNameConverter<WasteReason>(
    WasteReason.values,
  );
  static JsonTypeConverter2<WasteReason?, String?, String?>
  $converterreasonWastedn = JsonTypeConverter2.asNullable(
    $converterreasonWasted,
  );
}

class UsageLog extends DataClass implements Insertable<UsageLog> {
  final String id;
  final String pantryItemId;
  final UsageAction action;
  final double quantityChanged;
  final int valueIdr;
  final bool isEstimate;
  final int weightGrams;
  final IngredientCategory category;
  final WasteReason? reasonWasted;
  final DateTime loggedAt;
  const UsageLog({
    required this.id,
    required this.pantryItemId,
    required this.action,
    required this.quantityChanged,
    required this.valueIdr,
    required this.isEstimate,
    required this.weightGrams,
    required this.category,
    this.reasonWasted,
    required this.loggedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['pantry_item_id'] = Variable<String>(pantryItemId);
    {
      map['action'] = Variable<String>(
        $UsageLogsTable.$converteraction.toSql(action),
      );
    }
    map['quantity_changed'] = Variable<double>(quantityChanged);
    map['value_idr'] = Variable<int>(valueIdr);
    map['is_estimate'] = Variable<bool>(isEstimate);
    map['weight_grams'] = Variable<int>(weightGrams);
    {
      map['category'] = Variable<String>(
        $UsageLogsTable.$convertercategory.toSql(category),
      );
    }
    if (!nullToAbsent || reasonWasted != null) {
      map['reason_wasted'] = Variable<String>(
        $UsageLogsTable.$converterreasonWastedn.toSql(reasonWasted),
      );
    }
    map['logged_at'] = Variable<DateTime>(loggedAt);
    return map;
  }

  UsageLogsCompanion toCompanion(bool nullToAbsent) {
    return UsageLogsCompanion(
      id: Value(id),
      pantryItemId: Value(pantryItemId),
      action: Value(action),
      quantityChanged: Value(quantityChanged),
      valueIdr: Value(valueIdr),
      isEstimate: Value(isEstimate),
      weightGrams: Value(weightGrams),
      category: Value(category),
      reasonWasted: reasonWasted == null && nullToAbsent
          ? const Value.absent()
          : Value(reasonWasted),
      loggedAt: Value(loggedAt),
    );
  }

  factory UsageLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsageLog(
      id: serializer.fromJson<String>(json['id']),
      pantryItemId: serializer.fromJson<String>(json['pantryItemId']),
      action: $UsageLogsTable.$converteraction.fromJson(
        serializer.fromJson<String>(json['action']),
      ),
      quantityChanged: serializer.fromJson<double>(json['quantityChanged']),
      valueIdr: serializer.fromJson<int>(json['valueIdr']),
      isEstimate: serializer.fromJson<bool>(json['isEstimate']),
      weightGrams: serializer.fromJson<int>(json['weightGrams']),
      category: $UsageLogsTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      reasonWasted: $UsageLogsTable.$converterreasonWastedn.fromJson(
        serializer.fromJson<String?>(json['reasonWasted']),
      ),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'pantryItemId': serializer.toJson<String>(pantryItemId),
      'action': serializer.toJson<String>(
        $UsageLogsTable.$converteraction.toJson(action),
      ),
      'quantityChanged': serializer.toJson<double>(quantityChanged),
      'valueIdr': serializer.toJson<int>(valueIdr),
      'isEstimate': serializer.toJson<bool>(isEstimate),
      'weightGrams': serializer.toJson<int>(weightGrams),
      'category': serializer.toJson<String>(
        $UsageLogsTable.$convertercategory.toJson(category),
      ),
      'reasonWasted': serializer.toJson<String?>(
        $UsageLogsTable.$converterreasonWastedn.toJson(reasonWasted),
      ),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
    };
  }

  UsageLog copyWith({
    String? id,
    String? pantryItemId,
    UsageAction? action,
    double? quantityChanged,
    int? valueIdr,
    bool? isEstimate,
    int? weightGrams,
    IngredientCategory? category,
    Value<WasteReason?> reasonWasted = const Value.absent(),
    DateTime? loggedAt,
  }) => UsageLog(
    id: id ?? this.id,
    pantryItemId: pantryItemId ?? this.pantryItemId,
    action: action ?? this.action,
    quantityChanged: quantityChanged ?? this.quantityChanged,
    valueIdr: valueIdr ?? this.valueIdr,
    isEstimate: isEstimate ?? this.isEstimate,
    weightGrams: weightGrams ?? this.weightGrams,
    category: category ?? this.category,
    reasonWasted: reasonWasted.present ? reasonWasted.value : this.reasonWasted,
    loggedAt: loggedAt ?? this.loggedAt,
  );
  UsageLog copyWithCompanion(UsageLogsCompanion data) {
    return UsageLog(
      id: data.id.present ? data.id.value : this.id,
      pantryItemId: data.pantryItemId.present
          ? data.pantryItemId.value
          : this.pantryItemId,
      action: data.action.present ? data.action.value : this.action,
      quantityChanged: data.quantityChanged.present
          ? data.quantityChanged.value
          : this.quantityChanged,
      valueIdr: data.valueIdr.present ? data.valueIdr.value : this.valueIdr,
      isEstimate: data.isEstimate.present
          ? data.isEstimate.value
          : this.isEstimate,
      weightGrams: data.weightGrams.present
          ? data.weightGrams.value
          : this.weightGrams,
      category: data.category.present ? data.category.value : this.category,
      reasonWasted: data.reasonWasted.present
          ? data.reasonWasted.value
          : this.reasonWasted,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsageLog(')
          ..write('id: $id, ')
          ..write('pantryItemId: $pantryItemId, ')
          ..write('action: $action, ')
          ..write('quantityChanged: $quantityChanged, ')
          ..write('valueIdr: $valueIdr, ')
          ..write('isEstimate: $isEstimate, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('category: $category, ')
          ..write('reasonWasted: $reasonWasted, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pantryItemId,
    action,
    quantityChanged,
    valueIdr,
    isEstimate,
    weightGrams,
    category,
    reasonWasted,
    loggedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsageLog &&
          other.id == this.id &&
          other.pantryItemId == this.pantryItemId &&
          other.action == this.action &&
          other.quantityChanged == this.quantityChanged &&
          other.valueIdr == this.valueIdr &&
          other.isEstimate == this.isEstimate &&
          other.weightGrams == this.weightGrams &&
          other.category == this.category &&
          other.reasonWasted == this.reasonWasted &&
          other.loggedAt == this.loggedAt);
}

class UsageLogsCompanion extends UpdateCompanion<UsageLog> {
  final Value<String> id;
  final Value<String> pantryItemId;
  final Value<UsageAction> action;
  final Value<double> quantityChanged;
  final Value<int> valueIdr;
  final Value<bool> isEstimate;
  final Value<int> weightGrams;
  final Value<IngredientCategory> category;
  final Value<WasteReason?> reasonWasted;
  final Value<DateTime> loggedAt;
  final Value<int> rowid;
  const UsageLogsCompanion({
    this.id = const Value.absent(),
    this.pantryItemId = const Value.absent(),
    this.action = const Value.absent(),
    this.quantityChanged = const Value.absent(),
    this.valueIdr = const Value.absent(),
    this.isEstimate = const Value.absent(),
    this.weightGrams = const Value.absent(),
    this.category = const Value.absent(),
    this.reasonWasted = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsageLogsCompanion.insert({
    required String id,
    required String pantryItemId,
    required UsageAction action,
    required double quantityChanged,
    this.valueIdr = const Value.absent(),
    this.isEstimate = const Value.absent(),
    this.weightGrams = const Value.absent(),
    required IngredientCategory category,
    this.reasonWasted = const Value.absent(),
    required DateTime loggedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       pantryItemId = Value(pantryItemId),
       action = Value(action),
       quantityChanged = Value(quantityChanged),
       category = Value(category),
       loggedAt = Value(loggedAt);
  static Insertable<UsageLog> custom({
    Expression<String>? id,
    Expression<String>? pantryItemId,
    Expression<String>? action,
    Expression<double>? quantityChanged,
    Expression<int>? valueIdr,
    Expression<bool>? isEstimate,
    Expression<int>? weightGrams,
    Expression<String>? category,
    Expression<String>? reasonWasted,
    Expression<DateTime>? loggedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pantryItemId != null) 'pantry_item_id': pantryItemId,
      if (action != null) 'action': action,
      if (quantityChanged != null) 'quantity_changed': quantityChanged,
      if (valueIdr != null) 'value_idr': valueIdr,
      if (isEstimate != null) 'is_estimate': isEstimate,
      if (weightGrams != null) 'weight_grams': weightGrams,
      if (category != null) 'category': category,
      if (reasonWasted != null) 'reason_wasted': reasonWasted,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsageLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? pantryItemId,
    Value<UsageAction>? action,
    Value<double>? quantityChanged,
    Value<int>? valueIdr,
    Value<bool>? isEstimate,
    Value<int>? weightGrams,
    Value<IngredientCategory>? category,
    Value<WasteReason?>? reasonWasted,
    Value<DateTime>? loggedAt,
    Value<int>? rowid,
  }) {
    return UsageLogsCompanion(
      id: id ?? this.id,
      pantryItemId: pantryItemId ?? this.pantryItemId,
      action: action ?? this.action,
      quantityChanged: quantityChanged ?? this.quantityChanged,
      valueIdr: valueIdr ?? this.valueIdr,
      isEstimate: isEstimate ?? this.isEstimate,
      weightGrams: weightGrams ?? this.weightGrams,
      category: category ?? this.category,
      reasonWasted: reasonWasted ?? this.reasonWasted,
      loggedAt: loggedAt ?? this.loggedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (pantryItemId.present) {
      map['pantry_item_id'] = Variable<String>(pantryItemId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(
        $UsageLogsTable.$converteraction.toSql(action.value),
      );
    }
    if (quantityChanged.present) {
      map['quantity_changed'] = Variable<double>(quantityChanged.value);
    }
    if (valueIdr.present) {
      map['value_idr'] = Variable<int>(valueIdr.value);
    }
    if (isEstimate.present) {
      map['is_estimate'] = Variable<bool>(isEstimate.value);
    }
    if (weightGrams.present) {
      map['weight_grams'] = Variable<int>(weightGrams.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $UsageLogsTable.$convertercategory.toSql(category.value),
      );
    }
    if (reasonWasted.present) {
      map['reason_wasted'] = Variable<String>(
        $UsageLogsTable.$converterreasonWastedn.toSql(reasonWasted.value),
      );
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsageLogsCompanion(')
          ..write('id: $id, ')
          ..write('pantryItemId: $pantryItemId, ')
          ..write('action: $action, ')
          ..write('quantityChanged: $quantityChanged, ')
          ..write('valueIdr: $valueIdr, ')
          ..write('isEstimate: $isEstimate, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('category: $category, ')
          ..write('reasonWasted: $reasonWasted, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IngredientCatalogsTable extends IngredientCatalogs
    with TableInfo<$IngredientCatalogsTable, IngredientCatalog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientCatalogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameIdMeta = const VerificationMeta('nameId');
  @override
  late final GeneratedColumn<String> nameId = GeneratedColumn<String>(
    'name_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> aliases =
      GeneratedColumn<String>(
        'aliases',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($IngredientCatalogsTable.$converteraliases);
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<IngredientCategory, String>
  category =
      GeneratedColumn<String>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<IngredientCategory>(
        $IngredientCatalogsTable.$convertercategory,
      );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoAssetMeta = const VerificationMeta(
    'photoAsset',
  );
  @override
  late final GeneratedColumn<String> photoAsset = GeneratedColumn<String>(
    'photo_asset',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Unit, String> defaultUnit =
      GeneratedColumn<String>(
        'default_unit',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Unit>($IngredientCatalogsTable.$converterdefaultUnit);
  static const VerificationMeta _shelfLifeKulkasMeta = const VerificationMeta(
    'shelfLifeKulkas',
  );
  @override
  late final GeneratedColumn<int> shelfLifeKulkas = GeneratedColumn<int>(
    'shelf_life_kulkas',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shelfLifeFreezerMeta = const VerificationMeta(
    'shelfLifeFreezer',
  );
  @override
  late final GeneratedColumn<int> shelfLifeFreezer = GeneratedColumn<int>(
    'shelf_life_freezer',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shelfLifeLemariMeta = const VerificationMeta(
    'shelfLifeLemari',
  );
  @override
  late final GeneratedColumn<int> shelfLifeLemari = GeneratedColumn<int>(
    'shelf_life_lemari',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shelfLifeSuhuRuangMeta =
      const VerificationMeta('shelfLifeSuhuRuang');
  @override
  late final GeneratedColumn<int> shelfLifeSuhuRuang = GeneratedColumn<int>(
    'shelf_life_suhu_ruang',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shelfLifeNoteMeta = const VerificationMeta(
    'shelfLifeNote',
  );
  @override
  late final GeneratedColumn<String> shelfLifeNote = GeneratedColumn<String>(
    'shelf_life_note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tips =
      GeneratedColumn<String>(
        'tips',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($IngredientCatalogsTable.$convertertips);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> quickTags =
      GeneratedColumn<String>(
        'quick_tags',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>(
        $IngredientCatalogsTable.$converterquickTags,
      );
  static const VerificationMeta _avgWeightPerUnitGramsMeta =
      const VerificationMeta('avgWeightPerUnitGrams');
  @override
  late final GeneratedColumn<double> avgWeightPerUnitGrams =
      GeneratedColumn<double>(
        'avg_weight_per_unit_grams',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _typicalPriceIdrMeta = const VerificationMeta(
    'typicalPriceIdr',
  );
  @override
  late final GeneratedColumn<int> typicalPriceIdr = GeneratedColumn<int>(
    'typical_price_idr',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  quickIdeaRecipeIds =
      GeneratedColumn<String>(
        'quick_idea_recipe_ids',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>(
        $IngredientCatalogsTable.$converterquickIdeaRecipeIds,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameId,
    aliases,
    nameEn,
    category,
    emoji,
    photoAsset,
    defaultUnit,
    shelfLifeKulkas,
    shelfLifeFreezer,
    shelfLifeLemari,
    shelfLifeSuhuRuang,
    shelfLifeNote,
    tips,
    quickTags,
    avgWeightPerUnitGrams,
    typicalPriceIdr,
    quickIdeaRecipeIds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredient_catalogs';
  @override
  VerificationContext validateIntegrity(
    Insertable<IngredientCatalog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name_id')) {
      context.handle(
        _nameIdMeta,
        nameId.isAcceptableOrUnknown(data['name_id']!, _nameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nameIdMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('photo_asset')) {
      context.handle(
        _photoAssetMeta,
        photoAsset.isAcceptableOrUnknown(data['photo_asset']!, _photoAssetMeta),
      );
    }
    if (data.containsKey('shelf_life_kulkas')) {
      context.handle(
        _shelfLifeKulkasMeta,
        shelfLifeKulkas.isAcceptableOrUnknown(
          data['shelf_life_kulkas']!,
          _shelfLifeKulkasMeta,
        ),
      );
    }
    if (data.containsKey('shelf_life_freezer')) {
      context.handle(
        _shelfLifeFreezerMeta,
        shelfLifeFreezer.isAcceptableOrUnknown(
          data['shelf_life_freezer']!,
          _shelfLifeFreezerMeta,
        ),
      );
    }
    if (data.containsKey('shelf_life_lemari')) {
      context.handle(
        _shelfLifeLemariMeta,
        shelfLifeLemari.isAcceptableOrUnknown(
          data['shelf_life_lemari']!,
          _shelfLifeLemariMeta,
        ),
      );
    }
    if (data.containsKey('shelf_life_suhu_ruang')) {
      context.handle(
        _shelfLifeSuhuRuangMeta,
        shelfLifeSuhuRuang.isAcceptableOrUnknown(
          data['shelf_life_suhu_ruang']!,
          _shelfLifeSuhuRuangMeta,
        ),
      );
    }
    if (data.containsKey('shelf_life_note')) {
      context.handle(
        _shelfLifeNoteMeta,
        shelfLifeNote.isAcceptableOrUnknown(
          data['shelf_life_note']!,
          _shelfLifeNoteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shelfLifeNoteMeta);
    }
    if (data.containsKey('avg_weight_per_unit_grams')) {
      context.handle(
        _avgWeightPerUnitGramsMeta,
        avgWeightPerUnitGrams.isAcceptableOrUnknown(
          data['avg_weight_per_unit_grams']!,
          _avgWeightPerUnitGramsMeta,
        ),
      );
    }
    if (data.containsKey('typical_price_idr')) {
      context.handle(
        _typicalPriceIdrMeta,
        typicalPriceIdr.isAcceptableOrUnknown(
          data['typical_price_idr']!,
          _typicalPriceIdrMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IngredientCatalog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngredientCatalog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_id'],
      )!,
      aliases: $IngredientCatalogsTable.$converteraliases.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}aliases'],
        )!,
      ),
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      category: $IngredientCatalogsTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      photoAsset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_asset'],
      ),
      defaultUnit: $IngredientCatalogsTable.$converterdefaultUnit.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}default_unit'],
        )!,
      ),
      shelfLifeKulkas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shelf_life_kulkas'],
      ),
      shelfLifeFreezer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shelf_life_freezer'],
      ),
      shelfLifeLemari: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shelf_life_lemari'],
      ),
      shelfLifeSuhuRuang: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shelf_life_suhu_ruang'],
      ),
      shelfLifeNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shelf_life_note'],
      )!,
      tips: $IngredientCatalogsTable.$convertertips.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tips'],
        )!,
      ),
      quickTags: $IngredientCatalogsTable.$converterquickTags.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}quick_tags'],
        )!,
      ),
      avgWeightPerUnitGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_weight_per_unit_grams'],
      ),
      typicalPriceIdr: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}typical_price_idr'],
      ),
      quickIdeaRecipeIds: $IngredientCatalogsTable.$converterquickIdeaRecipeIds
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}quick_idea_recipe_ids'],
            )!,
          ),
    );
  }

  @override
  $IngredientCatalogsTable createAlias(String alias) {
    return $IngredientCatalogsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converteraliases =
      const StringListConverter();
  static JsonTypeConverter2<IngredientCategory, String, String>
  $convertercategory = const EnumNameConverter<IngredientCategory>(
    IngredientCategory.values,
  );
  static JsonTypeConverter2<Unit, String, String> $converterdefaultUnit =
      const EnumNameConverter<Unit>(Unit.values);
  static TypeConverter<List<String>, String> $convertertips =
      const StringListConverter();
  static TypeConverter<List<String>, String> $converterquickTags =
      const StringListConverter();
  static TypeConverter<List<String>, String> $converterquickIdeaRecipeIds =
      const StringListConverter();
}

class IngredientCatalog extends DataClass
    implements Insertable<IngredientCatalog> {
  final String id;
  final String nameId;

  /// Alternate Indonesian names, e.g. "bayam hijau".
  final List<String> aliases;

  /// English name used for TheMealDB lookups.
  final String nameEn;
  final IngredientCategory category;
  final String emoji;
  final String? photoAsset;
  final Unit defaultUnit;

  /// Shelf life in days. Null means "not recommended for this location".
  final int? shelfLifeKulkas;
  final int? shelfLifeFreezer;
  final int? shelfLifeLemari;
  final int? shelfLifeSuhuRuang;
  final String shelfLifeNote;
  final List<String> tips;
  final List<String> quickTags;

  /// Average weight of one [defaultUnit] in grams.
  final double? avgWeightPerUnitGrams;
  final int? typicalPriceIdr;
  final List<String> quickIdeaRecipeIds;
  const IngredientCatalog({
    required this.id,
    required this.nameId,
    required this.aliases,
    required this.nameEn,
    required this.category,
    required this.emoji,
    this.photoAsset,
    required this.defaultUnit,
    this.shelfLifeKulkas,
    this.shelfLifeFreezer,
    this.shelfLifeLemari,
    this.shelfLifeSuhuRuang,
    required this.shelfLifeNote,
    required this.tips,
    required this.quickTags,
    this.avgWeightPerUnitGrams,
    this.typicalPriceIdr,
    required this.quickIdeaRecipeIds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name_id'] = Variable<String>(nameId);
    {
      map['aliases'] = Variable<String>(
        $IngredientCatalogsTable.$converteraliases.toSql(aliases),
      );
    }
    map['name_en'] = Variable<String>(nameEn);
    {
      map['category'] = Variable<String>(
        $IngredientCatalogsTable.$convertercategory.toSql(category),
      );
    }
    map['emoji'] = Variable<String>(emoji);
    if (!nullToAbsent || photoAsset != null) {
      map['photo_asset'] = Variable<String>(photoAsset);
    }
    {
      map['default_unit'] = Variable<String>(
        $IngredientCatalogsTable.$converterdefaultUnit.toSql(defaultUnit),
      );
    }
    if (!nullToAbsent || shelfLifeKulkas != null) {
      map['shelf_life_kulkas'] = Variable<int>(shelfLifeKulkas);
    }
    if (!nullToAbsent || shelfLifeFreezer != null) {
      map['shelf_life_freezer'] = Variable<int>(shelfLifeFreezer);
    }
    if (!nullToAbsent || shelfLifeLemari != null) {
      map['shelf_life_lemari'] = Variable<int>(shelfLifeLemari);
    }
    if (!nullToAbsent || shelfLifeSuhuRuang != null) {
      map['shelf_life_suhu_ruang'] = Variable<int>(shelfLifeSuhuRuang);
    }
    map['shelf_life_note'] = Variable<String>(shelfLifeNote);
    {
      map['tips'] = Variable<String>(
        $IngredientCatalogsTable.$convertertips.toSql(tips),
      );
    }
    {
      map['quick_tags'] = Variable<String>(
        $IngredientCatalogsTable.$converterquickTags.toSql(quickTags),
      );
    }
    if (!nullToAbsent || avgWeightPerUnitGrams != null) {
      map['avg_weight_per_unit_grams'] = Variable<double>(
        avgWeightPerUnitGrams,
      );
    }
    if (!nullToAbsent || typicalPriceIdr != null) {
      map['typical_price_idr'] = Variable<int>(typicalPriceIdr);
    }
    {
      map['quick_idea_recipe_ids'] = Variable<String>(
        $IngredientCatalogsTable.$converterquickIdeaRecipeIds.toSql(
          quickIdeaRecipeIds,
        ),
      );
    }
    return map;
  }

  IngredientCatalogsCompanion toCompanion(bool nullToAbsent) {
    return IngredientCatalogsCompanion(
      id: Value(id),
      nameId: Value(nameId),
      aliases: Value(aliases),
      nameEn: Value(nameEn),
      category: Value(category),
      emoji: Value(emoji),
      photoAsset: photoAsset == null && nullToAbsent
          ? const Value.absent()
          : Value(photoAsset),
      defaultUnit: Value(defaultUnit),
      shelfLifeKulkas: shelfLifeKulkas == null && nullToAbsent
          ? const Value.absent()
          : Value(shelfLifeKulkas),
      shelfLifeFreezer: shelfLifeFreezer == null && nullToAbsent
          ? const Value.absent()
          : Value(shelfLifeFreezer),
      shelfLifeLemari: shelfLifeLemari == null && nullToAbsent
          ? const Value.absent()
          : Value(shelfLifeLemari),
      shelfLifeSuhuRuang: shelfLifeSuhuRuang == null && nullToAbsent
          ? const Value.absent()
          : Value(shelfLifeSuhuRuang),
      shelfLifeNote: Value(shelfLifeNote),
      tips: Value(tips),
      quickTags: Value(quickTags),
      avgWeightPerUnitGrams: avgWeightPerUnitGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(avgWeightPerUnitGrams),
      typicalPriceIdr: typicalPriceIdr == null && nullToAbsent
          ? const Value.absent()
          : Value(typicalPriceIdr),
      quickIdeaRecipeIds: Value(quickIdeaRecipeIds),
    );
  }

  factory IngredientCatalog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngredientCatalog(
      id: serializer.fromJson<String>(json['id']),
      nameId: serializer.fromJson<String>(json['nameId']),
      aliases: serializer.fromJson<List<String>>(json['aliases']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      category: $IngredientCatalogsTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      emoji: serializer.fromJson<String>(json['emoji']),
      photoAsset: serializer.fromJson<String?>(json['photoAsset']),
      defaultUnit: $IngredientCatalogsTable.$converterdefaultUnit.fromJson(
        serializer.fromJson<String>(json['defaultUnit']),
      ),
      shelfLifeKulkas: serializer.fromJson<int?>(json['shelfLifeKulkas']),
      shelfLifeFreezer: serializer.fromJson<int?>(json['shelfLifeFreezer']),
      shelfLifeLemari: serializer.fromJson<int?>(json['shelfLifeLemari']),
      shelfLifeSuhuRuang: serializer.fromJson<int?>(json['shelfLifeSuhuRuang']),
      shelfLifeNote: serializer.fromJson<String>(json['shelfLifeNote']),
      tips: serializer.fromJson<List<String>>(json['tips']),
      quickTags: serializer.fromJson<List<String>>(json['quickTags']),
      avgWeightPerUnitGrams: serializer.fromJson<double?>(
        json['avgWeightPerUnitGrams'],
      ),
      typicalPriceIdr: serializer.fromJson<int?>(json['typicalPriceIdr']),
      quickIdeaRecipeIds: serializer.fromJson<List<String>>(
        json['quickIdeaRecipeIds'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nameId': serializer.toJson<String>(nameId),
      'aliases': serializer.toJson<List<String>>(aliases),
      'nameEn': serializer.toJson<String>(nameEn),
      'category': serializer.toJson<String>(
        $IngredientCatalogsTable.$convertercategory.toJson(category),
      ),
      'emoji': serializer.toJson<String>(emoji),
      'photoAsset': serializer.toJson<String?>(photoAsset),
      'defaultUnit': serializer.toJson<String>(
        $IngredientCatalogsTable.$converterdefaultUnit.toJson(defaultUnit),
      ),
      'shelfLifeKulkas': serializer.toJson<int?>(shelfLifeKulkas),
      'shelfLifeFreezer': serializer.toJson<int?>(shelfLifeFreezer),
      'shelfLifeLemari': serializer.toJson<int?>(shelfLifeLemari),
      'shelfLifeSuhuRuang': serializer.toJson<int?>(shelfLifeSuhuRuang),
      'shelfLifeNote': serializer.toJson<String>(shelfLifeNote),
      'tips': serializer.toJson<List<String>>(tips),
      'quickTags': serializer.toJson<List<String>>(quickTags),
      'avgWeightPerUnitGrams': serializer.toJson<double?>(
        avgWeightPerUnitGrams,
      ),
      'typicalPriceIdr': serializer.toJson<int?>(typicalPriceIdr),
      'quickIdeaRecipeIds': serializer.toJson<List<String>>(quickIdeaRecipeIds),
    };
  }

  IngredientCatalog copyWith({
    String? id,
    String? nameId,
    List<String>? aliases,
    String? nameEn,
    IngredientCategory? category,
    String? emoji,
    Value<String?> photoAsset = const Value.absent(),
    Unit? defaultUnit,
    Value<int?> shelfLifeKulkas = const Value.absent(),
    Value<int?> shelfLifeFreezer = const Value.absent(),
    Value<int?> shelfLifeLemari = const Value.absent(),
    Value<int?> shelfLifeSuhuRuang = const Value.absent(),
    String? shelfLifeNote,
    List<String>? tips,
    List<String>? quickTags,
    Value<double?> avgWeightPerUnitGrams = const Value.absent(),
    Value<int?> typicalPriceIdr = const Value.absent(),
    List<String>? quickIdeaRecipeIds,
  }) => IngredientCatalog(
    id: id ?? this.id,
    nameId: nameId ?? this.nameId,
    aliases: aliases ?? this.aliases,
    nameEn: nameEn ?? this.nameEn,
    category: category ?? this.category,
    emoji: emoji ?? this.emoji,
    photoAsset: photoAsset.present ? photoAsset.value : this.photoAsset,
    defaultUnit: defaultUnit ?? this.defaultUnit,
    shelfLifeKulkas: shelfLifeKulkas.present
        ? shelfLifeKulkas.value
        : this.shelfLifeKulkas,
    shelfLifeFreezer: shelfLifeFreezer.present
        ? shelfLifeFreezer.value
        : this.shelfLifeFreezer,
    shelfLifeLemari: shelfLifeLemari.present
        ? shelfLifeLemari.value
        : this.shelfLifeLemari,
    shelfLifeSuhuRuang: shelfLifeSuhuRuang.present
        ? shelfLifeSuhuRuang.value
        : this.shelfLifeSuhuRuang,
    shelfLifeNote: shelfLifeNote ?? this.shelfLifeNote,
    tips: tips ?? this.tips,
    quickTags: quickTags ?? this.quickTags,
    avgWeightPerUnitGrams: avgWeightPerUnitGrams.present
        ? avgWeightPerUnitGrams.value
        : this.avgWeightPerUnitGrams,
    typicalPriceIdr: typicalPriceIdr.present
        ? typicalPriceIdr.value
        : this.typicalPriceIdr,
    quickIdeaRecipeIds: quickIdeaRecipeIds ?? this.quickIdeaRecipeIds,
  );
  IngredientCatalog copyWithCompanion(IngredientCatalogsCompanion data) {
    return IngredientCatalog(
      id: data.id.present ? data.id.value : this.id,
      nameId: data.nameId.present ? data.nameId.value : this.nameId,
      aliases: data.aliases.present ? data.aliases.value : this.aliases,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      category: data.category.present ? data.category.value : this.category,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      photoAsset: data.photoAsset.present
          ? data.photoAsset.value
          : this.photoAsset,
      defaultUnit: data.defaultUnit.present
          ? data.defaultUnit.value
          : this.defaultUnit,
      shelfLifeKulkas: data.shelfLifeKulkas.present
          ? data.shelfLifeKulkas.value
          : this.shelfLifeKulkas,
      shelfLifeFreezer: data.shelfLifeFreezer.present
          ? data.shelfLifeFreezer.value
          : this.shelfLifeFreezer,
      shelfLifeLemari: data.shelfLifeLemari.present
          ? data.shelfLifeLemari.value
          : this.shelfLifeLemari,
      shelfLifeSuhuRuang: data.shelfLifeSuhuRuang.present
          ? data.shelfLifeSuhuRuang.value
          : this.shelfLifeSuhuRuang,
      shelfLifeNote: data.shelfLifeNote.present
          ? data.shelfLifeNote.value
          : this.shelfLifeNote,
      tips: data.tips.present ? data.tips.value : this.tips,
      quickTags: data.quickTags.present ? data.quickTags.value : this.quickTags,
      avgWeightPerUnitGrams: data.avgWeightPerUnitGrams.present
          ? data.avgWeightPerUnitGrams.value
          : this.avgWeightPerUnitGrams,
      typicalPriceIdr: data.typicalPriceIdr.present
          ? data.typicalPriceIdr.value
          : this.typicalPriceIdr,
      quickIdeaRecipeIds: data.quickIdeaRecipeIds.present
          ? data.quickIdeaRecipeIds.value
          : this.quickIdeaRecipeIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngredientCatalog(')
          ..write('id: $id, ')
          ..write('nameId: $nameId, ')
          ..write('aliases: $aliases, ')
          ..write('nameEn: $nameEn, ')
          ..write('category: $category, ')
          ..write('emoji: $emoji, ')
          ..write('photoAsset: $photoAsset, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('shelfLifeKulkas: $shelfLifeKulkas, ')
          ..write('shelfLifeFreezer: $shelfLifeFreezer, ')
          ..write('shelfLifeLemari: $shelfLifeLemari, ')
          ..write('shelfLifeSuhuRuang: $shelfLifeSuhuRuang, ')
          ..write('shelfLifeNote: $shelfLifeNote, ')
          ..write('tips: $tips, ')
          ..write('quickTags: $quickTags, ')
          ..write('avgWeightPerUnitGrams: $avgWeightPerUnitGrams, ')
          ..write('typicalPriceIdr: $typicalPriceIdr, ')
          ..write('quickIdeaRecipeIds: $quickIdeaRecipeIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nameId,
    aliases,
    nameEn,
    category,
    emoji,
    photoAsset,
    defaultUnit,
    shelfLifeKulkas,
    shelfLifeFreezer,
    shelfLifeLemari,
    shelfLifeSuhuRuang,
    shelfLifeNote,
    tips,
    quickTags,
    avgWeightPerUnitGrams,
    typicalPriceIdr,
    quickIdeaRecipeIds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngredientCatalog &&
          other.id == this.id &&
          other.nameId == this.nameId &&
          other.aliases == this.aliases &&
          other.nameEn == this.nameEn &&
          other.category == this.category &&
          other.emoji == this.emoji &&
          other.photoAsset == this.photoAsset &&
          other.defaultUnit == this.defaultUnit &&
          other.shelfLifeKulkas == this.shelfLifeKulkas &&
          other.shelfLifeFreezer == this.shelfLifeFreezer &&
          other.shelfLifeLemari == this.shelfLifeLemari &&
          other.shelfLifeSuhuRuang == this.shelfLifeSuhuRuang &&
          other.shelfLifeNote == this.shelfLifeNote &&
          other.tips == this.tips &&
          other.quickTags == this.quickTags &&
          other.avgWeightPerUnitGrams == this.avgWeightPerUnitGrams &&
          other.typicalPriceIdr == this.typicalPriceIdr &&
          other.quickIdeaRecipeIds == this.quickIdeaRecipeIds);
}

class IngredientCatalogsCompanion extends UpdateCompanion<IngredientCatalog> {
  final Value<String> id;
  final Value<String> nameId;
  final Value<List<String>> aliases;
  final Value<String> nameEn;
  final Value<IngredientCategory> category;
  final Value<String> emoji;
  final Value<String?> photoAsset;
  final Value<Unit> defaultUnit;
  final Value<int?> shelfLifeKulkas;
  final Value<int?> shelfLifeFreezer;
  final Value<int?> shelfLifeLemari;
  final Value<int?> shelfLifeSuhuRuang;
  final Value<String> shelfLifeNote;
  final Value<List<String>> tips;
  final Value<List<String>> quickTags;
  final Value<double?> avgWeightPerUnitGrams;
  final Value<int?> typicalPriceIdr;
  final Value<List<String>> quickIdeaRecipeIds;
  final Value<int> rowid;
  const IngredientCatalogsCompanion({
    this.id = const Value.absent(),
    this.nameId = const Value.absent(),
    this.aliases = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.category = const Value.absent(),
    this.emoji = const Value.absent(),
    this.photoAsset = const Value.absent(),
    this.defaultUnit = const Value.absent(),
    this.shelfLifeKulkas = const Value.absent(),
    this.shelfLifeFreezer = const Value.absent(),
    this.shelfLifeLemari = const Value.absent(),
    this.shelfLifeSuhuRuang = const Value.absent(),
    this.shelfLifeNote = const Value.absent(),
    this.tips = const Value.absent(),
    this.quickTags = const Value.absent(),
    this.avgWeightPerUnitGrams = const Value.absent(),
    this.typicalPriceIdr = const Value.absent(),
    this.quickIdeaRecipeIds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IngredientCatalogsCompanion.insert({
    required String id,
    required String nameId,
    this.aliases = const Value.absent(),
    required String nameEn,
    required IngredientCategory category,
    required String emoji,
    this.photoAsset = const Value.absent(),
    required Unit defaultUnit,
    this.shelfLifeKulkas = const Value.absent(),
    this.shelfLifeFreezer = const Value.absent(),
    this.shelfLifeLemari = const Value.absent(),
    this.shelfLifeSuhuRuang = const Value.absent(),
    required String shelfLifeNote,
    this.tips = const Value.absent(),
    this.quickTags = const Value.absent(),
    this.avgWeightPerUnitGrams = const Value.absent(),
    this.typicalPriceIdr = const Value.absent(),
    this.quickIdeaRecipeIds = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nameId = Value(nameId),
       nameEn = Value(nameEn),
       category = Value(category),
       emoji = Value(emoji),
       defaultUnit = Value(defaultUnit),
       shelfLifeNote = Value(shelfLifeNote);
  static Insertable<IngredientCatalog> custom({
    Expression<String>? id,
    Expression<String>? nameId,
    Expression<String>? aliases,
    Expression<String>? nameEn,
    Expression<String>? category,
    Expression<String>? emoji,
    Expression<String>? photoAsset,
    Expression<String>? defaultUnit,
    Expression<int>? shelfLifeKulkas,
    Expression<int>? shelfLifeFreezer,
    Expression<int>? shelfLifeLemari,
    Expression<int>? shelfLifeSuhuRuang,
    Expression<String>? shelfLifeNote,
    Expression<String>? tips,
    Expression<String>? quickTags,
    Expression<double>? avgWeightPerUnitGrams,
    Expression<int>? typicalPriceIdr,
    Expression<String>? quickIdeaRecipeIds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameId != null) 'name_id': nameId,
      if (aliases != null) 'aliases': aliases,
      if (nameEn != null) 'name_en': nameEn,
      if (category != null) 'category': category,
      if (emoji != null) 'emoji': emoji,
      if (photoAsset != null) 'photo_asset': photoAsset,
      if (defaultUnit != null) 'default_unit': defaultUnit,
      if (shelfLifeKulkas != null) 'shelf_life_kulkas': shelfLifeKulkas,
      if (shelfLifeFreezer != null) 'shelf_life_freezer': shelfLifeFreezer,
      if (shelfLifeLemari != null) 'shelf_life_lemari': shelfLifeLemari,
      if (shelfLifeSuhuRuang != null)
        'shelf_life_suhu_ruang': shelfLifeSuhuRuang,
      if (shelfLifeNote != null) 'shelf_life_note': shelfLifeNote,
      if (tips != null) 'tips': tips,
      if (quickTags != null) 'quick_tags': quickTags,
      if (avgWeightPerUnitGrams != null)
        'avg_weight_per_unit_grams': avgWeightPerUnitGrams,
      if (typicalPriceIdr != null) 'typical_price_idr': typicalPriceIdr,
      if (quickIdeaRecipeIds != null)
        'quick_idea_recipe_ids': quickIdeaRecipeIds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IngredientCatalogsCompanion copyWith({
    Value<String>? id,
    Value<String>? nameId,
    Value<List<String>>? aliases,
    Value<String>? nameEn,
    Value<IngredientCategory>? category,
    Value<String>? emoji,
    Value<String?>? photoAsset,
    Value<Unit>? defaultUnit,
    Value<int?>? shelfLifeKulkas,
    Value<int?>? shelfLifeFreezer,
    Value<int?>? shelfLifeLemari,
    Value<int?>? shelfLifeSuhuRuang,
    Value<String>? shelfLifeNote,
    Value<List<String>>? tips,
    Value<List<String>>? quickTags,
    Value<double?>? avgWeightPerUnitGrams,
    Value<int?>? typicalPriceIdr,
    Value<List<String>>? quickIdeaRecipeIds,
    Value<int>? rowid,
  }) {
    return IngredientCatalogsCompanion(
      id: id ?? this.id,
      nameId: nameId ?? this.nameId,
      aliases: aliases ?? this.aliases,
      nameEn: nameEn ?? this.nameEn,
      category: category ?? this.category,
      emoji: emoji ?? this.emoji,
      photoAsset: photoAsset ?? this.photoAsset,
      defaultUnit: defaultUnit ?? this.defaultUnit,
      shelfLifeKulkas: shelfLifeKulkas ?? this.shelfLifeKulkas,
      shelfLifeFreezer: shelfLifeFreezer ?? this.shelfLifeFreezer,
      shelfLifeLemari: shelfLifeLemari ?? this.shelfLifeLemari,
      shelfLifeSuhuRuang: shelfLifeSuhuRuang ?? this.shelfLifeSuhuRuang,
      shelfLifeNote: shelfLifeNote ?? this.shelfLifeNote,
      tips: tips ?? this.tips,
      quickTags: quickTags ?? this.quickTags,
      avgWeightPerUnitGrams:
          avgWeightPerUnitGrams ?? this.avgWeightPerUnitGrams,
      typicalPriceIdr: typicalPriceIdr ?? this.typicalPriceIdr,
      quickIdeaRecipeIds: quickIdeaRecipeIds ?? this.quickIdeaRecipeIds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nameId.present) {
      map['name_id'] = Variable<String>(nameId.value);
    }
    if (aliases.present) {
      map['aliases'] = Variable<String>(
        $IngredientCatalogsTable.$converteraliases.toSql(aliases.value),
      );
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $IngredientCatalogsTable.$convertercategory.toSql(category.value),
      );
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (photoAsset.present) {
      map['photo_asset'] = Variable<String>(photoAsset.value);
    }
    if (defaultUnit.present) {
      map['default_unit'] = Variable<String>(
        $IngredientCatalogsTable.$converterdefaultUnit.toSql(defaultUnit.value),
      );
    }
    if (shelfLifeKulkas.present) {
      map['shelf_life_kulkas'] = Variable<int>(shelfLifeKulkas.value);
    }
    if (shelfLifeFreezer.present) {
      map['shelf_life_freezer'] = Variable<int>(shelfLifeFreezer.value);
    }
    if (shelfLifeLemari.present) {
      map['shelf_life_lemari'] = Variable<int>(shelfLifeLemari.value);
    }
    if (shelfLifeSuhuRuang.present) {
      map['shelf_life_suhu_ruang'] = Variable<int>(shelfLifeSuhuRuang.value);
    }
    if (shelfLifeNote.present) {
      map['shelf_life_note'] = Variable<String>(shelfLifeNote.value);
    }
    if (tips.present) {
      map['tips'] = Variable<String>(
        $IngredientCatalogsTable.$convertertips.toSql(tips.value),
      );
    }
    if (quickTags.present) {
      map['quick_tags'] = Variable<String>(
        $IngredientCatalogsTable.$converterquickTags.toSql(quickTags.value),
      );
    }
    if (avgWeightPerUnitGrams.present) {
      map['avg_weight_per_unit_grams'] = Variable<double>(
        avgWeightPerUnitGrams.value,
      );
    }
    if (typicalPriceIdr.present) {
      map['typical_price_idr'] = Variable<int>(typicalPriceIdr.value);
    }
    if (quickIdeaRecipeIds.present) {
      map['quick_idea_recipe_ids'] = Variable<String>(
        $IngredientCatalogsTable.$converterquickIdeaRecipeIds.toSql(
          quickIdeaRecipeIds.value,
        ),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientCatalogsCompanion(')
          ..write('id: $id, ')
          ..write('nameId: $nameId, ')
          ..write('aliases: $aliases, ')
          ..write('nameEn: $nameEn, ')
          ..write('category: $category, ')
          ..write('emoji: $emoji, ')
          ..write('photoAsset: $photoAsset, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('shelfLifeKulkas: $shelfLifeKulkas, ')
          ..write('shelfLifeFreezer: $shelfLifeFreezer, ')
          ..write('shelfLifeLemari: $shelfLifeLemari, ')
          ..write('shelfLifeSuhuRuang: $shelfLifeSuhuRuang, ')
          ..write('shelfLifeNote: $shelfLifeNote, ')
          ..write('tips: $tips, ')
          ..write('quickTags: $quickTags, ')
          ..write('avgWeightPerUnitGrams: $avgWeightPerUnitGrams, ')
          ..write('typicalPriceIdr: $typicalPriceIdr, ')
          ..write('quickIdeaRecipeIds: $quickIdeaRecipeIds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipesTable extends Recipes with TableInfo<$RecipesTable, Recipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('🍲'),
  );
  static const VerificationMeta _imageAssetMeta = const VerificationMeta(
    'imageAsset',
  );
  @override
  late final GeneratedColumn<String> imageAsset = GeneratedColumn<String>(
    'image_asset',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cookTimeMinMeta = const VerificationMeta(
    'cookTimeMin',
  );
  @override
  late final GeneratedColumn<int> cookTimeMin = GeneratedColumn<int>(
    'cook_time_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RecipeDifficulty, String>
  difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<RecipeDifficulty>($RecipesTable.$converterdifficulty);
  static const VerificationMeta _servingsMeta = const VerificationMeta(
    'servings',
  );
  @override
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
    'servings',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _estimatedCostIdrMeta = const VerificationMeta(
    'estimatedCostIdr',
  );
  @override
  late final GeneratedColumn<int> estimatedCostIdr = GeneratedColumn<int>(
    'estimated_cost_idr',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isQuickMeta = const VerificationMeta(
    'isQuick',
  );
  @override
  late final GeneratedColumn<bool> isQuick = GeneratedColumn<bool>(
    'is_quick',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_quick" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tags =
      GeneratedColumn<String>(
        'tags',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($RecipesTable.$convertertags);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> steps =
      GeneratedColumn<String>(
        'steps',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($RecipesTable.$convertersteps);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    emoji,
    imageAsset,
    cookTimeMin,
    difficulty,
    servings,
    estimatedCostIdr,
    isQuick,
    tags,
    steps,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recipe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    }
    if (data.containsKey('image_asset')) {
      context.handle(
        _imageAssetMeta,
        imageAsset.isAcceptableOrUnknown(data['image_asset']!, _imageAssetMeta),
      );
    }
    if (data.containsKey('cook_time_min')) {
      context.handle(
        _cookTimeMinMeta,
        cookTimeMin.isAcceptableOrUnknown(
          data['cook_time_min']!,
          _cookTimeMinMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cookTimeMinMeta);
    }
    if (data.containsKey('servings')) {
      context.handle(
        _servingsMeta,
        servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta),
      );
    }
    if (data.containsKey('estimated_cost_idr')) {
      context.handle(
        _estimatedCostIdrMeta,
        estimatedCostIdr.isAcceptableOrUnknown(
          data['estimated_cost_idr']!,
          _estimatedCostIdrMeta,
        ),
      );
    }
    if (data.containsKey('is_quick')) {
      context.handle(
        _isQuickMeta,
        isQuick.isAcceptableOrUnknown(data['is_quick']!, _isQuickMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recipe(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      imageAsset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_asset'],
      ),
      cookTimeMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cook_time_min'],
      )!,
      difficulty: $RecipesTable.$converterdifficulty.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}difficulty'],
        )!,
      ),
      servings: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}servings'],
      )!,
      estimatedCostIdr: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_cost_idr'],
      )!,
      isQuick: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_quick'],
      )!,
      tags: $RecipesTable.$convertertags.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tags'],
        )!,
      ),
      steps: $RecipesTable.$convertersteps.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}steps'],
        )!,
      ),
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RecipeDifficulty, String, String>
  $converterdifficulty = const EnumNameConverter<RecipeDifficulty>(
    RecipeDifficulty.values,
  );
  static TypeConverter<List<String>, String> $convertertags =
      const StringListConverter();
  static TypeConverter<List<String>, String> $convertersteps =
      const StringListConverter();
}

class Recipe extends DataClass implements Insertable<Recipe> {
  final String id;
  final String title;
  final String emoji;
  final String? imageAsset;
  final int cookTimeMin;
  final RecipeDifficulty difficulty;
  final int servings;
  final int estimatedCostIdr;

  /// Automatically true when [cookTimeMin] is below 15 minutes.
  final bool isQuick;
  final List<String> tags;
  final List<String> steps;
  const Recipe({
    required this.id,
    required this.title,
    required this.emoji,
    this.imageAsset,
    required this.cookTimeMin,
    required this.difficulty,
    required this.servings,
    required this.estimatedCostIdr,
    required this.isQuick,
    required this.tags,
    required this.steps,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['emoji'] = Variable<String>(emoji);
    if (!nullToAbsent || imageAsset != null) {
      map['image_asset'] = Variable<String>(imageAsset);
    }
    map['cook_time_min'] = Variable<int>(cookTimeMin);
    {
      map['difficulty'] = Variable<String>(
        $RecipesTable.$converterdifficulty.toSql(difficulty),
      );
    }
    map['servings'] = Variable<int>(servings);
    map['estimated_cost_idr'] = Variable<int>(estimatedCostIdr);
    map['is_quick'] = Variable<bool>(isQuick);
    {
      map['tags'] = Variable<String>($RecipesTable.$convertertags.toSql(tags));
    }
    {
      map['steps'] = Variable<String>(
        $RecipesTable.$convertersteps.toSql(steps),
      );
    }
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      title: Value(title),
      emoji: Value(emoji),
      imageAsset: imageAsset == null && nullToAbsent
          ? const Value.absent()
          : Value(imageAsset),
      cookTimeMin: Value(cookTimeMin),
      difficulty: Value(difficulty),
      servings: Value(servings),
      estimatedCostIdr: Value(estimatedCostIdr),
      isQuick: Value(isQuick),
      tags: Value(tags),
      steps: Value(steps),
    );
  }

  factory Recipe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recipe(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      emoji: serializer.fromJson<String>(json['emoji']),
      imageAsset: serializer.fromJson<String?>(json['imageAsset']),
      cookTimeMin: serializer.fromJson<int>(json['cookTimeMin']),
      difficulty: $RecipesTable.$converterdifficulty.fromJson(
        serializer.fromJson<String>(json['difficulty']),
      ),
      servings: serializer.fromJson<int>(json['servings']),
      estimatedCostIdr: serializer.fromJson<int>(json['estimatedCostIdr']),
      isQuick: serializer.fromJson<bool>(json['isQuick']),
      tags: serializer.fromJson<List<String>>(json['tags']),
      steps: serializer.fromJson<List<String>>(json['steps']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'emoji': serializer.toJson<String>(emoji),
      'imageAsset': serializer.toJson<String?>(imageAsset),
      'cookTimeMin': serializer.toJson<int>(cookTimeMin),
      'difficulty': serializer.toJson<String>(
        $RecipesTable.$converterdifficulty.toJson(difficulty),
      ),
      'servings': serializer.toJson<int>(servings),
      'estimatedCostIdr': serializer.toJson<int>(estimatedCostIdr),
      'isQuick': serializer.toJson<bool>(isQuick),
      'tags': serializer.toJson<List<String>>(tags),
      'steps': serializer.toJson<List<String>>(steps),
    };
  }

  Recipe copyWith({
    String? id,
    String? title,
    String? emoji,
    Value<String?> imageAsset = const Value.absent(),
    int? cookTimeMin,
    RecipeDifficulty? difficulty,
    int? servings,
    int? estimatedCostIdr,
    bool? isQuick,
    List<String>? tags,
    List<String>? steps,
  }) => Recipe(
    id: id ?? this.id,
    title: title ?? this.title,
    emoji: emoji ?? this.emoji,
    imageAsset: imageAsset.present ? imageAsset.value : this.imageAsset,
    cookTimeMin: cookTimeMin ?? this.cookTimeMin,
    difficulty: difficulty ?? this.difficulty,
    servings: servings ?? this.servings,
    estimatedCostIdr: estimatedCostIdr ?? this.estimatedCostIdr,
    isQuick: isQuick ?? this.isQuick,
    tags: tags ?? this.tags,
    steps: steps ?? this.steps,
  );
  Recipe copyWithCompanion(RecipesCompanion data) {
    return Recipe(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      imageAsset: data.imageAsset.present
          ? data.imageAsset.value
          : this.imageAsset,
      cookTimeMin: data.cookTimeMin.present
          ? data.cookTimeMin.value
          : this.cookTimeMin,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      servings: data.servings.present ? data.servings.value : this.servings,
      estimatedCostIdr: data.estimatedCostIdr.present
          ? data.estimatedCostIdr.value
          : this.estimatedCostIdr,
      isQuick: data.isQuick.present ? data.isQuick.value : this.isQuick,
      tags: data.tags.present ? data.tags.value : this.tags,
      steps: data.steps.present ? data.steps.value : this.steps,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recipe(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('emoji: $emoji, ')
          ..write('imageAsset: $imageAsset, ')
          ..write('cookTimeMin: $cookTimeMin, ')
          ..write('difficulty: $difficulty, ')
          ..write('servings: $servings, ')
          ..write('estimatedCostIdr: $estimatedCostIdr, ')
          ..write('isQuick: $isQuick, ')
          ..write('tags: $tags, ')
          ..write('steps: $steps')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    emoji,
    imageAsset,
    cookTimeMin,
    difficulty,
    servings,
    estimatedCostIdr,
    isQuick,
    tags,
    steps,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recipe &&
          other.id == this.id &&
          other.title == this.title &&
          other.emoji == this.emoji &&
          other.imageAsset == this.imageAsset &&
          other.cookTimeMin == this.cookTimeMin &&
          other.difficulty == this.difficulty &&
          other.servings == this.servings &&
          other.estimatedCostIdr == this.estimatedCostIdr &&
          other.isQuick == this.isQuick &&
          other.tags == this.tags &&
          other.steps == this.steps);
}

class RecipesCompanion extends UpdateCompanion<Recipe> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> emoji;
  final Value<String?> imageAsset;
  final Value<int> cookTimeMin;
  final Value<RecipeDifficulty> difficulty;
  final Value<int> servings;
  final Value<int> estimatedCostIdr;
  final Value<bool> isQuick;
  final Value<List<String>> tags;
  final Value<List<String>> steps;
  final Value<int> rowid;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.emoji = const Value.absent(),
    this.imageAsset = const Value.absent(),
    this.cookTimeMin = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.servings = const Value.absent(),
    this.estimatedCostIdr = const Value.absent(),
    this.isQuick = const Value.absent(),
    this.tags = const Value.absent(),
    this.steps = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipesCompanion.insert({
    required String id,
    required String title,
    this.emoji = const Value.absent(),
    this.imageAsset = const Value.absent(),
    required int cookTimeMin,
    required RecipeDifficulty difficulty,
    this.servings = const Value.absent(),
    this.estimatedCostIdr = const Value.absent(),
    this.isQuick = const Value.absent(),
    this.tags = const Value.absent(),
    this.steps = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       cookTimeMin = Value(cookTimeMin),
       difficulty = Value(difficulty);
  static Insertable<Recipe> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? emoji,
    Expression<String>? imageAsset,
    Expression<int>? cookTimeMin,
    Expression<String>? difficulty,
    Expression<int>? servings,
    Expression<int>? estimatedCostIdr,
    Expression<bool>? isQuick,
    Expression<String>? tags,
    Expression<String>? steps,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (emoji != null) 'emoji': emoji,
      if (imageAsset != null) 'image_asset': imageAsset,
      if (cookTimeMin != null) 'cook_time_min': cookTimeMin,
      if (difficulty != null) 'difficulty': difficulty,
      if (servings != null) 'servings': servings,
      if (estimatedCostIdr != null) 'estimated_cost_idr': estimatedCostIdr,
      if (isQuick != null) 'is_quick': isQuick,
      if (tags != null) 'tags': tags,
      if (steps != null) 'steps': steps,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? emoji,
    Value<String?>? imageAsset,
    Value<int>? cookTimeMin,
    Value<RecipeDifficulty>? difficulty,
    Value<int>? servings,
    Value<int>? estimatedCostIdr,
    Value<bool>? isQuick,
    Value<List<String>>? tags,
    Value<List<String>>? steps,
    Value<int>? rowid,
  }) {
    return RecipesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      imageAsset: imageAsset ?? this.imageAsset,
      cookTimeMin: cookTimeMin ?? this.cookTimeMin,
      difficulty: difficulty ?? this.difficulty,
      servings: servings ?? this.servings,
      estimatedCostIdr: estimatedCostIdr ?? this.estimatedCostIdr,
      isQuick: isQuick ?? this.isQuick,
      tags: tags ?? this.tags,
      steps: steps ?? this.steps,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (imageAsset.present) {
      map['image_asset'] = Variable<String>(imageAsset.value);
    }
    if (cookTimeMin.present) {
      map['cook_time_min'] = Variable<int>(cookTimeMin.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(
        $RecipesTable.$converterdifficulty.toSql(difficulty.value),
      );
    }
    if (servings.present) {
      map['servings'] = Variable<int>(servings.value);
    }
    if (estimatedCostIdr.present) {
      map['estimated_cost_idr'] = Variable<int>(estimatedCostIdr.value);
    }
    if (isQuick.present) {
      map['is_quick'] = Variable<bool>(isQuick.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(
        $RecipesTable.$convertertags.toSql(tags.value),
      );
    }
    if (steps.present) {
      map['steps'] = Variable<String>(
        $RecipesTable.$convertersteps.toSql(steps.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('emoji: $emoji, ')
          ..write('imageAsset: $imageAsset, ')
          ..write('cookTimeMin: $cookTimeMin, ')
          ..write('difficulty: $difficulty, ')
          ..write('servings: $servings, ')
          ..write('estimatedCostIdr: $estimatedCostIdr, ')
          ..write('isQuick: $isQuick, ')
          ..write('tags: $tags, ')
          ..write('steps: $steps, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipeIngredientsTable extends RecipeIngredients
    with TableInfo<$RecipeIngredientsTable, RecipeIngredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeIngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catalogIdMeta = const VerificationMeta(
    'catalogId',
  );
  @override
  late final GeneratedColumn<String> catalogId = GeneratedColumn<String>(
    'catalog_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Unit, String> unit =
      GeneratedColumn<String>(
        'unit',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Unit>($RecipeIngredientsTable.$converterunit);
  static const VerificationMeta _isOptionalMeta = const VerificationMeta(
    'isOptional',
  );
  @override
  late final GeneratedColumn<bool> isOptional = GeneratedColumn<bool>(
    'is_optional',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_optional" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isStapleMeta = const VerificationMeta(
    'isStaple',
  );
  @override
  late final GeneratedColumn<bool> isStaple = GeneratedColumn<bool>(
    'is_staple',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_staple" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    catalogId,
    name,
    amount,
    unit,
    isOptional,
    isStaple,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeIngredient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('catalog_id')) {
      context.handle(
        _catalogIdMeta,
        catalogId.isAcceptableOrUnknown(data['catalog_id']!, _catalogIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('is_optional')) {
      context.handle(
        _isOptionalMeta,
        isOptional.isAcceptableOrUnknown(data['is_optional']!, _isOptionalMeta),
      );
    }
    if (data.containsKey('is_staple')) {
      context.handle(
        _isStapleMeta,
        isStaple.isAcceptableOrUnknown(data['is_staple']!, _isStapleMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeIngredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeIngredient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      catalogId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      unit: $RecipeIngredientsTable.$converterunit.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unit'],
        )!,
      ),
      isOptional: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_optional'],
      )!,
      isStaple: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_staple'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $RecipeIngredientsTable createAlias(String alias) {
    return $RecipeIngredientsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Unit, String, String> $converterunit =
      const EnumNameConverter<Unit>(Unit.values);
}

class RecipeIngredient extends DataClass
    implements Insertable<RecipeIngredient> {
  final String id;
  final String recipeId;
  final String? catalogId;
  final String name;
  final double amount;
  final Unit unit;
  final bool isOptional;

  /// Salt, sugar, oil and water are assumed to always be available.
  final bool isStaple;
  final int sortOrder;
  const RecipeIngredient({
    required this.id,
    required this.recipeId,
    this.catalogId,
    required this.name,
    required this.amount,
    required this.unit,
    required this.isOptional,
    required this.isStaple,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recipe_id'] = Variable<String>(recipeId);
    if (!nullToAbsent || catalogId != null) {
      map['catalog_id'] = Variable<String>(catalogId);
    }
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    {
      map['unit'] = Variable<String>(
        $RecipeIngredientsTable.$converterunit.toSql(unit),
      );
    }
    map['is_optional'] = Variable<bool>(isOptional);
    map['is_staple'] = Variable<bool>(isStaple);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  RecipeIngredientsCompanion toCompanion(bool nullToAbsent) {
    return RecipeIngredientsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      catalogId: catalogId == null && nullToAbsent
          ? const Value.absent()
          : Value(catalogId),
      name: Value(name),
      amount: Value(amount),
      unit: Value(unit),
      isOptional: Value(isOptional),
      isStaple: Value(isStaple),
      sortOrder: Value(sortOrder),
    );
  }

  factory RecipeIngredient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeIngredient(
      id: serializer.fromJson<String>(json['id']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      catalogId: serializer.fromJson<String?>(json['catalogId']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      unit: $RecipeIngredientsTable.$converterunit.fromJson(
        serializer.fromJson<String>(json['unit']),
      ),
      isOptional: serializer.fromJson<bool>(json['isOptional']),
      isStaple: serializer.fromJson<bool>(json['isStaple']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recipeId': serializer.toJson<String>(recipeId),
      'catalogId': serializer.toJson<String?>(catalogId),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'unit': serializer.toJson<String>(
        $RecipeIngredientsTable.$converterunit.toJson(unit),
      ),
      'isOptional': serializer.toJson<bool>(isOptional),
      'isStaple': serializer.toJson<bool>(isStaple),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  RecipeIngredient copyWith({
    String? id,
    String? recipeId,
    Value<String?> catalogId = const Value.absent(),
    String? name,
    double? amount,
    Unit? unit,
    bool? isOptional,
    bool? isStaple,
    int? sortOrder,
  }) => RecipeIngredient(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    catalogId: catalogId.present ? catalogId.value : this.catalogId,
    name: name ?? this.name,
    amount: amount ?? this.amount,
    unit: unit ?? this.unit,
    isOptional: isOptional ?? this.isOptional,
    isStaple: isStaple ?? this.isStaple,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  RecipeIngredient copyWithCompanion(RecipeIngredientsCompanion data) {
    return RecipeIngredient(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      catalogId: data.catalogId.present ? data.catalogId.value : this.catalogId,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      isOptional: data.isOptional.present
          ? data.isOptional.value
          : this.isOptional,
      isStaple: data.isStaple.present ? data.isStaple.value : this.isStaple,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeIngredient(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('catalogId: $catalogId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('isOptional: $isOptional, ')
          ..write('isStaple: $isStaple, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recipeId,
    catalogId,
    name,
    amount,
    unit,
    isOptional,
    isStaple,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeIngredient &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.catalogId == this.catalogId &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.isOptional == this.isOptional &&
          other.isStaple == this.isStaple &&
          other.sortOrder == this.sortOrder);
}

class RecipeIngredientsCompanion extends UpdateCompanion<RecipeIngredient> {
  final Value<String> id;
  final Value<String> recipeId;
  final Value<String?> catalogId;
  final Value<String> name;
  final Value<double> amount;
  final Value<Unit> unit;
  final Value<bool> isOptional;
  final Value<bool> isStaple;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const RecipeIngredientsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.catalogId = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.isOptional = const Value.absent(),
    this.isStaple = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeIngredientsCompanion.insert({
    required String id,
    required String recipeId,
    this.catalogId = const Value.absent(),
    required String name,
    required double amount,
    required Unit unit,
    this.isOptional = const Value.absent(),
    this.isStaple = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recipeId = Value(recipeId),
       name = Value(name),
       amount = Value(amount),
       unit = Value(unit);
  static Insertable<RecipeIngredient> custom({
    Expression<String>? id,
    Expression<String>? recipeId,
    Expression<String>? catalogId,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? unit,
    Expression<bool>? isOptional,
    Expression<bool>? isStaple,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (catalogId != null) 'catalog_id': catalogId,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (isOptional != null) 'is_optional': isOptional,
      if (isStaple != null) 'is_staple': isStaple,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeIngredientsCompanion copyWith({
    Value<String>? id,
    Value<String>? recipeId,
    Value<String?>? catalogId,
    Value<String>? name,
    Value<double>? amount,
    Value<Unit>? unit,
    Value<bool>? isOptional,
    Value<bool>? isStaple,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return RecipeIngredientsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      catalogId: catalogId ?? this.catalogId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      isOptional: isOptional ?? this.isOptional,
      isStaple: isStaple ?? this.isStaple,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (catalogId.present) {
      map['catalog_id'] = Variable<String>(catalogId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(
        $RecipeIngredientsTable.$converterunit.toSql(unit.value),
      );
    }
    if (isOptional.present) {
      map['is_optional'] = Variable<bool>(isOptional.value);
    }
    if (isStaple.present) {
      map['is_staple'] = Variable<bool>(isStaple.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeIngredientsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('catalogId: $catalogId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('isOptional: $isOptional, ')
          ..write('isStaple: $isStaple, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BarcodeCacheTable extends BarcodeCache
    with TableInfo<$BarcodeCacheTable, BarcodeCacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BarcodeCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<IngredientCategory, String>
  category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<IngredientCategory>($BarcodeCacheTable.$convertercategory);
  static const VerificationMeta _quantityTextMeta = const VerificationMeta(
    'quantityText',
  );
  @override
  late final GeneratedColumn<String> quantityText = GeneratedColumn<String>(
    'quantity_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<BarcodeSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<BarcodeSource>($BarcodeCacheTable.$convertersource);
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    barcode,
    name,
    brand,
    category,
    quantityText,
    source,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'barcode_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<BarcodeCacheEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    } else if (isInserting) {
      context.missing(_barcodeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('quantity_text')) {
      context.handle(
        _quantityTextMeta,
        quantityText.isAcceptableOrUnknown(
          data['quantity_text']!,
          _quantityTextMeta,
        ),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {barcode};
  @override
  BarcodeCacheEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BarcodeCacheEntry(
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      category: $BarcodeCacheTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      quantityText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quantity_text'],
      ),
      source: $BarcodeCacheTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $BarcodeCacheTable createAlias(String alias) {
    return $BarcodeCacheTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<IngredientCategory, String, String>
  $convertercategory = const EnumNameConverter<IngredientCategory>(
    IngredientCategory.values,
  );
  static JsonTypeConverter2<BarcodeSource, String, String> $convertersource =
      const EnumNameConverter<BarcodeSource>(BarcodeSource.values);
}

class BarcodeCacheEntry extends DataClass
    implements Insertable<BarcodeCacheEntry> {
  final String barcode;
  final String name;
  final String? brand;
  final IngredientCategory category;
  final String? quantityText;
  final BarcodeSource source;
  final DateTime fetchedAt;
  const BarcodeCacheEntry({
    required this.barcode,
    required this.name,
    this.brand,
    required this.category,
    this.quantityText,
    required this.source,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['barcode'] = Variable<String>(barcode);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    {
      map['category'] = Variable<String>(
        $BarcodeCacheTable.$convertercategory.toSql(category),
      );
    }
    if (!nullToAbsent || quantityText != null) {
      map['quantity_text'] = Variable<String>(quantityText);
    }
    {
      map['source'] = Variable<String>(
        $BarcodeCacheTable.$convertersource.toSql(source),
      );
    }
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  BarcodeCacheCompanion toCompanion(bool nullToAbsent) {
    return BarcodeCacheCompanion(
      barcode: Value(barcode),
      name: Value(name),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      category: Value(category),
      quantityText: quantityText == null && nullToAbsent
          ? const Value.absent()
          : Value(quantityText),
      source: Value(source),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory BarcodeCacheEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BarcodeCacheEntry(
      barcode: serializer.fromJson<String>(json['barcode']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      category: $BarcodeCacheTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      quantityText: serializer.fromJson<String?>(json['quantityText']),
      source: $BarcodeCacheTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'barcode': serializer.toJson<String>(barcode),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'category': serializer.toJson<String>(
        $BarcodeCacheTable.$convertercategory.toJson(category),
      ),
      'quantityText': serializer.toJson<String?>(quantityText),
      'source': serializer.toJson<String>(
        $BarcodeCacheTable.$convertersource.toJson(source),
      ),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  BarcodeCacheEntry copyWith({
    String? barcode,
    String? name,
    Value<String?> brand = const Value.absent(),
    IngredientCategory? category,
    Value<String?> quantityText = const Value.absent(),
    BarcodeSource? source,
    DateTime? fetchedAt,
  }) => BarcodeCacheEntry(
    barcode: barcode ?? this.barcode,
    name: name ?? this.name,
    brand: brand.present ? brand.value : this.brand,
    category: category ?? this.category,
    quantityText: quantityText.present ? quantityText.value : this.quantityText,
    source: source ?? this.source,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  BarcodeCacheEntry copyWithCompanion(BarcodeCacheCompanion data) {
    return BarcodeCacheEntry(
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      category: data.category.present ? data.category.value : this.category,
      quantityText: data.quantityText.present
          ? data.quantityText.value
          : this.quantityText,
      source: data.source.present ? data.source.value : this.source,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BarcodeCacheEntry(')
          ..write('barcode: $barcode, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('category: $category, ')
          ..write('quantityText: $quantityText, ')
          ..write('source: $source, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    barcode,
    name,
    brand,
    category,
    quantityText,
    source,
    fetchedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BarcodeCacheEntry &&
          other.barcode == this.barcode &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.category == this.category &&
          other.quantityText == this.quantityText &&
          other.source == this.source &&
          other.fetchedAt == this.fetchedAt);
}

class BarcodeCacheCompanion extends UpdateCompanion<BarcodeCacheEntry> {
  final Value<String> barcode;
  final Value<String> name;
  final Value<String?> brand;
  final Value<IngredientCategory> category;
  final Value<String?> quantityText;
  final Value<BarcodeSource> source;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const BarcodeCacheCompanion({
    this.barcode = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.category = const Value.absent(),
    this.quantityText = const Value.absent(),
    this.source = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BarcodeCacheCompanion.insert({
    required String barcode,
    required String name,
    this.brand = const Value.absent(),
    required IngredientCategory category,
    this.quantityText = const Value.absent(),
    required BarcodeSource source,
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : barcode = Value(barcode),
       name = Value(name),
       category = Value(category),
       source = Value(source),
       fetchedAt = Value(fetchedAt);
  static Insertable<BarcodeCacheEntry> custom({
    Expression<String>? barcode,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? category,
    Expression<String>? quantityText,
    Expression<String>? source,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (barcode != null) 'barcode': barcode,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (category != null) 'category': category,
      if (quantityText != null) 'quantity_text': quantityText,
      if (source != null) 'source': source,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BarcodeCacheCompanion copyWith({
    Value<String>? barcode,
    Value<String>? name,
    Value<String?>? brand,
    Value<IngredientCategory>? category,
    Value<String?>? quantityText,
    Value<BarcodeSource>? source,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return BarcodeCacheCompanion(
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      quantityText: quantityText ?? this.quantityText,
      source: source ?? this.source,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $BarcodeCacheTable.$convertercategory.toSql(category.value),
      );
    }
    if (quantityText.present) {
      map['quantity_text'] = Variable<String>(quantityText.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $BarcodeCacheTable.$convertersource.toSql(source.value),
      );
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BarcodeCacheCompanion(')
          ..write('barcode: $barcode, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('category: $category, ')
          ..write('quantityText: $quantityText, ')
          ..write('source: $source, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShoppingListItemsTable extends ShoppingListItems
    with TableInfo<$ShoppingListItemsTable, ShoppingListItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingListItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Unit, String> unit =
      GeneratedColumn<String>(
        'unit',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Unit>($ShoppingListItemsTable.$converterunit);
  static const VerificationMeta _isCheckedMeta = const VerificationMeta(
    'isChecked',
  );
  @override
  late final GeneratedColumn<bool> isChecked = GeneratedColumn<bool>(
    'is_checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_checked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ShoppingSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ShoppingSource>($ShoppingListItemsTable.$convertersource);
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    quantity,
    unit,
    isChecked,
    source,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_list_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingListItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('is_checked')) {
      context.handle(
        _isCheckedMeta,
        isChecked.isAcceptableOrUnknown(data['is_checked']!, _isCheckedMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingListItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingListItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unit: $ShoppingListItemsTable.$converterunit.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unit'],
        )!,
      ),
      isChecked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_checked'],
      )!,
      source: $ShoppingListItemsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ShoppingListItemsTable createAlias(String alias) {
    return $ShoppingListItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Unit, String, String> $converterunit =
      const EnumNameConverter<Unit>(Unit.values);
  static JsonTypeConverter2<ShoppingSource, String, String> $convertersource =
      const EnumNameConverter<ShoppingSource>(ShoppingSource.values);
}

class ShoppingListItem extends DataClass
    implements Insertable<ShoppingListItem> {
  final String id;
  final String name;
  final double quantity;
  final Unit unit;
  final bool isChecked;
  final ShoppingSource source;
  final int sortOrder;
  final DateTime createdAt;
  const ShoppingListItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.isChecked,
    required this.source,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<double>(quantity);
    {
      map['unit'] = Variable<String>(
        $ShoppingListItemsTable.$converterunit.toSql(unit),
      );
    }
    map['is_checked'] = Variable<bool>(isChecked);
    {
      map['source'] = Variable<String>(
        $ShoppingListItemsTable.$convertersource.toSql(source),
      );
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ShoppingListItemsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingListItemsCompanion(
      id: Value(id),
      name: Value(name),
      quantity: Value(quantity),
      unit: Value(unit),
      isChecked: Value(isChecked),
      source: Value(source),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory ShoppingListItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingListItem(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: $ShoppingListItemsTable.$converterunit.fromJson(
        serializer.fromJson<String>(json['unit']),
      ),
      isChecked: serializer.fromJson<bool>(json['isChecked']),
      source: $ShoppingListItemsTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(
        $ShoppingListItemsTable.$converterunit.toJson(unit),
      ),
      'isChecked': serializer.toJson<bool>(isChecked),
      'source': serializer.toJson<String>(
        $ShoppingListItemsTable.$convertersource.toJson(source),
      ),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ShoppingListItem copyWith({
    String? id,
    String? name,
    double? quantity,
    Unit? unit,
    bool? isChecked,
    ShoppingSource? source,
    int? sortOrder,
    DateTime? createdAt,
  }) => ShoppingListItem(
    id: id ?? this.id,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    isChecked: isChecked ?? this.isChecked,
    source: source ?? this.source,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  ShoppingListItem copyWithCompanion(ShoppingListItemsCompanion data) {
    return ShoppingListItem(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      isChecked: data.isChecked.present ? data.isChecked.value : this.isChecked,
      source: data.source.present ? data.source.value : this.source,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListItem(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('isChecked: $isChecked, ')
          ..write('source: $source, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    quantity,
    unit,
    isChecked,
    source,
    sortOrder,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingListItem &&
          other.id == this.id &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.isChecked == this.isChecked &&
          other.source == this.source &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class ShoppingListItemsCompanion extends UpdateCompanion<ShoppingListItem> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> quantity;
  final Value<Unit> unit;
  final Value<bool> isChecked;
  final Value<ShoppingSource> source;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ShoppingListItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.isChecked = const Value.absent(),
    this.source = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingListItemsCompanion.insert({
    required String id,
    required String name,
    this.quantity = const Value.absent(),
    required Unit unit,
    this.isChecked = const Value.absent(),
    required ShoppingSource source,
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       unit = Value(unit),
       source = Value(source),
       createdAt = Value(createdAt);
  static Insertable<ShoppingListItem> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<bool>? isChecked,
    Expression<String>? source,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (isChecked != null) 'is_checked': isChecked,
      if (source != null) 'source': source,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingListItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<double>? quantity,
    Value<Unit>? unit,
    Value<bool>? isChecked,
    Value<ShoppingSource>? source,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ShoppingListItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      isChecked: isChecked ?? this.isChecked,
      source: source ?? this.source,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(
        $ShoppingListItemsTable.$converterunit.toSql(unit.value),
      );
    }
    if (isChecked.present) {
      map['is_checked'] = Variable<bool>(isChecked.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $ShoppingListItemsTable.$convertersource.toSql(source.value),
      );
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('isChecked: $isChecked, ')
          ..write('source: $source, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedOnlineRecipesTable extends CachedOnlineRecipes
    with TableInfo<$CachedOnlineRecipesTable, CachedOnlineRecipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedOnlineRecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMealMeta = const VerificationMeta('idMeal');
  @override
  late final GeneratedColumn<String> idMeal = GeneratedColumn<String>(
    'id_meal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [idMeal, json, fetchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_online_recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedOnlineRecipe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_meal')) {
      context.handle(
        _idMealMeta,
        idMeal.isAcceptableOrUnknown(data['id_meal']!, _idMealMeta),
      );
    } else if (isInserting) {
      context.missing(_idMealMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idMeal};
  @override
  CachedOnlineRecipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedOnlineRecipe(
      idMeal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_meal'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $CachedOnlineRecipesTable createAlias(String alias) {
    return $CachedOnlineRecipesTable(attachedDatabase, alias);
  }
}

class CachedOnlineRecipe extends DataClass
    implements Insertable<CachedOnlineRecipe> {
  /// TheMealDB `idMeal`.
  final String idMeal;

  /// Raw JSON returned by `/lookup.php`.
  final String json;
  final DateTime fetchedAt;
  const CachedOnlineRecipe({
    required this.idMeal,
    required this.json,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_meal'] = Variable<String>(idMeal);
    map['json'] = Variable<String>(json);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  CachedOnlineRecipesCompanion toCompanion(bool nullToAbsent) {
    return CachedOnlineRecipesCompanion(
      idMeal: Value(idMeal),
      json: Value(json),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory CachedOnlineRecipe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedOnlineRecipe(
      idMeal: serializer.fromJson<String>(json['idMeal']),
      json: serializer.fromJson<String>(json['json']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idMeal': serializer.toJson<String>(idMeal),
      'json': serializer.toJson<String>(json),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  CachedOnlineRecipe copyWith({
    String? idMeal,
    String? json,
    DateTime? fetchedAt,
  }) => CachedOnlineRecipe(
    idMeal: idMeal ?? this.idMeal,
    json: json ?? this.json,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  CachedOnlineRecipe copyWithCompanion(CachedOnlineRecipesCompanion data) {
    return CachedOnlineRecipe(
      idMeal: data.idMeal.present ? data.idMeal.value : this.idMeal,
      json: data.json.present ? data.json.value : this.json,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedOnlineRecipe(')
          ..write('idMeal: $idMeal, ')
          ..write('json: $json, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idMeal, json, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedOnlineRecipe &&
          other.idMeal == this.idMeal &&
          other.json == this.json &&
          other.fetchedAt == this.fetchedAt);
}

class CachedOnlineRecipesCompanion extends UpdateCompanion<CachedOnlineRecipe> {
  final Value<String> idMeal;
  final Value<String> json;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const CachedOnlineRecipesCompanion({
    this.idMeal = const Value.absent(),
    this.json = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedOnlineRecipesCompanion.insert({
    required String idMeal,
    required String json,
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : idMeal = Value(idMeal),
       json = Value(json),
       fetchedAt = Value(fetchedAt);
  static Insertable<CachedOnlineRecipe> custom({
    Expression<String>? idMeal,
    Expression<String>? json,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (idMeal != null) 'id_meal': idMeal,
      if (json != null) 'json': json,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedOnlineRecipesCompanion copyWith({
    Value<String>? idMeal,
    Value<String>? json,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return CachedOnlineRecipesCompanion(
      idMeal: idMeal ?? this.idMeal,
      json: json ?? this.json,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idMeal.present) {
      map['id_meal'] = Variable<String>(idMeal.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedOnlineRecipesCompanion(')
          ..write('idMeal: $idMeal, ')
          ..write('json: $json, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PantryItemsTable pantryItems = $PantryItemsTable(this);
  late final $UsageLogsTable usageLogs = $UsageLogsTable(this);
  late final $IngredientCatalogsTable ingredientCatalogs =
      $IngredientCatalogsTable(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $RecipeIngredientsTable recipeIngredients =
      $RecipeIngredientsTable(this);
  late final $BarcodeCacheTable barcodeCache = $BarcodeCacheTable(this);
  late final $ShoppingListItemsTable shoppingListItems =
      $ShoppingListItemsTable(this);
  late final $CachedOnlineRecipesTable cachedOnlineRecipes =
      $CachedOnlineRecipesTable(this);
  late final Index pantryExpiryIdx = Index(
    'pantry_expiry_idx',
    'CREATE INDEX pantry_expiry_idx ON pantry_items (expiry_date)',
  );
  late final Index pantryStatusIdx = Index(
    'pantry_status_idx',
    'CREATE INDEX pantry_status_idx ON pantry_items (status)',
  );
  late final Index pantryLocationIdx = Index(
    'pantry_location_idx',
    'CREATE INDEX pantry_location_idx ON pantry_items (storage_location)',
  );
  late final Index usageItemIdx = Index(
    'usage_item_idx',
    'CREATE INDEX usage_item_idx ON usage_logs (pantry_item_id)',
  );
  late final Index usageLoggedIdx = Index(
    'usage_logged_idx',
    'CREATE INDEX usage_logged_idx ON usage_logs (logged_at)',
  );
  late final Index catalogNameIdx = Index(
    'catalog_name_idx',
    'CREATE INDEX catalog_name_idx ON ingredient_catalogs (name_id)',
  );
  late final Index recipeQuickIdx = Index(
    'recipe_quick_idx',
    'CREATE INDEX recipe_quick_idx ON recipes (is_quick)',
  );
  late final Index recipeIngredientRecipeIdx = Index(
    'recipe_ingredient_recipe_idx',
    'CREATE INDEX recipe_ingredient_recipe_idx ON recipe_ingredients (recipe_id)',
  );
  late final Index shoppingCheckedIdx = Index(
    'shopping_checked_idx',
    'CREATE INDEX shopping_checked_idx ON shopping_list_items (is_checked)',
  );
  late final PantryDao pantryDao = PantryDao(this as AppDatabase);
  late final UsageLogDao usageLogDao = UsageLogDao(this as AppDatabase);
  late final CatalogDao catalogDao = CatalogDao(this as AppDatabase);
  late final RecipeDao recipeDao = RecipeDao(this as AppDatabase);
  late final ShoppingListDao shoppingListDao = ShoppingListDao(
    this as AppDatabase,
  );
  late final BarcodeCacheDao barcodeCacheDao = BarcodeCacheDao(
    this as AppDatabase,
  );
  late final OnlineRecipeDao onlineRecipeDao = OnlineRecipeDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    pantryItems,
    usageLogs,
    ingredientCatalogs,
    recipes,
    recipeIngredients,
    barcodeCache,
    shoppingListItems,
    cachedOnlineRecipes,
    pantryExpiryIdx,
    pantryStatusIdx,
    pantryLocationIdx,
    usageItemIdx,
    usageLoggedIdx,
    catalogNameIdx,
    recipeQuickIdx,
    recipeIngredientRecipeIdx,
    shoppingCheckedIdx,
  ];
}

typedef $$PantryItemsTableCreateCompanionBuilder =
    PantryItemsCompanion Function({
      required String id,
      Value<String?> catalogId,
      required String name,
      Value<String> emoji,
      Value<String?> photoAsset,
      required IngredientCategory category,
      required double quantity,
      required Unit unit,
      Value<int?> weightGrams,
      required StorageLocation storageLocation,
      required DateTime purchaseDate,
      required DateTime expiryDate,
      required ExpirySource expirySource,
      Value<int?> priceIdr,
      Value<String?> barcode,
      Value<String?> note,
      Value<bool> notifyEnabled,
      Value<PantryStatus> status,
      Value<DateTime?> statusChangedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$PantryItemsTableUpdateCompanionBuilder =
    PantryItemsCompanion Function({
      Value<String> id,
      Value<String?> catalogId,
      Value<String> name,
      Value<String> emoji,
      Value<String?> photoAsset,
      Value<IngredientCategory> category,
      Value<double> quantity,
      Value<Unit> unit,
      Value<int?> weightGrams,
      Value<StorageLocation> storageLocation,
      Value<DateTime> purchaseDate,
      Value<DateTime> expiryDate,
      Value<ExpirySource> expirySource,
      Value<int?> priceIdr,
      Value<String?> barcode,
      Value<String?> note,
      Value<bool> notifyEnabled,
      Value<PantryStatus> status,
      Value<DateTime?> statusChangedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$PantryItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PantryItemsTable> {
  $$PantryItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catalogId => $composableBuilder(
    column: $table.catalogId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoAsset => $composableBuilder(
    column: $table.photoAsset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<IngredientCategory, IngredientCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Unit, Unit, String> get unit =>
      $composableBuilder(
        column: $table.unit,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StorageLocation, StorageLocation, String>
  get storageLocation => $composableBuilder(
    column: $table.storageLocation,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ExpirySource, ExpirySource, String>
  get expirySource => $composableBuilder(
    column: $table.expirySource,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get priceIdr => $composableBuilder(
    column: $table.priceIdr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notifyEnabled => $composableBuilder(
    column: $table.notifyEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PantryStatus, PantryStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get statusChangedAt => $composableBuilder(
    column: $table.statusChangedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PantryItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PantryItemsTable> {
  $$PantryItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catalogId => $composableBuilder(
    column: $table.catalogId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoAsset => $composableBuilder(
    column: $table.photoAsset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storageLocation => $composableBuilder(
    column: $table.storageLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expirySource => $composableBuilder(
    column: $table.expirySource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceIdr => $composableBuilder(
    column: $table.priceIdr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notifyEnabled => $composableBuilder(
    column: $table.notifyEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get statusChangedAt => $composableBuilder(
    column: $table.statusChangedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PantryItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PantryItemsTable> {
  $$PantryItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get catalogId =>
      $composableBuilder(column: $table.catalogId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get photoAsset => $composableBuilder(
    column: $table.photoAsset,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<IngredientCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Unit, String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<StorageLocation, String>
  get storageLocation => $composableBuilder(
    column: $table.storageLocation,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ExpirySource, String> get expirySource =>
      $composableBuilder(
        column: $table.expirySource,
        builder: (column) => column,
      );

  GeneratedColumn<int> get priceIdr =>
      $composableBuilder(column: $table.priceIdr, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get notifyEnabled => $composableBuilder(
    column: $table.notifyEnabled,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PantryStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get statusChangedAt => $composableBuilder(
    column: $table.statusChangedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$PantryItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PantryItemsTable,
          PantryItem,
          $$PantryItemsTableFilterComposer,
          $$PantryItemsTableOrderingComposer,
          $$PantryItemsTableAnnotationComposer,
          $$PantryItemsTableCreateCompanionBuilder,
          $$PantryItemsTableUpdateCompanionBuilder,
          (
            PantryItem,
            BaseReferences<_$AppDatabase, $PantryItemsTable, PantryItem>,
          ),
          PantryItem,
          PrefetchHooks Function()
        > {
  $$PantryItemsTableTableManager(_$AppDatabase db, $PantryItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PantryItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PantryItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PantryItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> catalogId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<String?> photoAsset = const Value.absent(),
                Value<IngredientCategory> category = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<Unit> unit = const Value.absent(),
                Value<int?> weightGrams = const Value.absent(),
                Value<StorageLocation> storageLocation = const Value.absent(),
                Value<DateTime> purchaseDate = const Value.absent(),
                Value<DateTime> expiryDate = const Value.absent(),
                Value<ExpirySource> expirySource = const Value.absent(),
                Value<int?> priceIdr = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> notifyEnabled = const Value.absent(),
                Value<PantryStatus> status = const Value.absent(),
                Value<DateTime?> statusChangedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PantryItemsCompanion(
                id: id,
                catalogId: catalogId,
                name: name,
                emoji: emoji,
                photoAsset: photoAsset,
                category: category,
                quantity: quantity,
                unit: unit,
                weightGrams: weightGrams,
                storageLocation: storageLocation,
                purchaseDate: purchaseDate,
                expiryDate: expiryDate,
                expirySource: expirySource,
                priceIdr: priceIdr,
                barcode: barcode,
                note: note,
                notifyEnabled: notifyEnabled,
                status: status,
                statusChangedAt: statusChangedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> catalogId = const Value.absent(),
                required String name,
                Value<String> emoji = const Value.absent(),
                Value<String?> photoAsset = const Value.absent(),
                required IngredientCategory category,
                required double quantity,
                required Unit unit,
                Value<int?> weightGrams = const Value.absent(),
                required StorageLocation storageLocation,
                required DateTime purchaseDate,
                required DateTime expiryDate,
                required ExpirySource expirySource,
                Value<int?> priceIdr = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> notifyEnabled = const Value.absent(),
                Value<PantryStatus> status = const Value.absent(),
                Value<DateTime?> statusChangedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PantryItemsCompanion.insert(
                id: id,
                catalogId: catalogId,
                name: name,
                emoji: emoji,
                photoAsset: photoAsset,
                category: category,
                quantity: quantity,
                unit: unit,
                weightGrams: weightGrams,
                storageLocation: storageLocation,
                purchaseDate: purchaseDate,
                expiryDate: expiryDate,
                expirySource: expirySource,
                priceIdr: priceIdr,
                barcode: barcode,
                note: note,
                notifyEnabled: notifyEnabled,
                status: status,
                statusChangedAt: statusChangedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PantryItemsTable, PantryItem>(table),
                  BaseReferences<_$AppDatabase, $PantryItemsTable, PantryItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PantryItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PantryItemsTable,
      PantryItem,
      $$PantryItemsTableFilterComposer,
      $$PantryItemsTableOrderingComposer,
      $$PantryItemsTableAnnotationComposer,
      $$PantryItemsTableCreateCompanionBuilder,
      $$PantryItemsTableUpdateCompanionBuilder,
      (
        PantryItem,
        BaseReferences<_$AppDatabase, $PantryItemsTable, PantryItem>,
      ),
      PantryItem,
      PrefetchHooks Function()
    >;
typedef $$UsageLogsTableCreateCompanionBuilder = UsageLogsCompanion Function({
  required String id,
  required String pantryItemId,
  required UsageAction action,
  required double quantityChanged,
  Value<int> valueIdr,
  Value<bool> isEstimate,
  Value<int> weightGrams,
  required IngredientCategory category,
  Value<WasteReason?> reasonWasted,
  required DateTime loggedAt,
  Value<int> rowid,
});
typedef $$UsageLogsTableUpdateCompanionBuilder = UsageLogsCompanion Function({
  Value<String> id,
  Value<String> pantryItemId,
  Value<UsageAction> action,
  Value<double> quantityChanged,
  Value<int> valueIdr,
  Value<bool> isEstimate,
  Value<int> weightGrams,
  Value<IngredientCategory> category,
  Value<WasteReason?> reasonWasted,
  Value<DateTime> loggedAt,
  Value<int> rowid,
});

class $$UsageLogsTableFilterComposer
    extends Composer<_$AppDatabase, $UsageLogsTable> {
  $$UsageLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pantryItemId => $composableBuilder(
    column: $table.pantryItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<UsageAction, UsageAction, String> get action =>
      $composableBuilder(
        column: $table.action,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get quantityChanged => $composableBuilder(
    column: $table.quantityChanged,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get valueIdr => $composableBuilder(
    column: $table.valueIdr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEstimate => $composableBuilder(
    column: $table.isEstimate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<IngredientCategory, IngredientCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<WasteReason?, WasteReason, String>
  get reasonWasted => $composableBuilder(
    column: $table.reasonWasted,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsageLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $UsageLogsTable> {
  $$UsageLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pantryItemId => $composableBuilder(
    column: $table.pantryItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantityChanged => $composableBuilder(
    column: $table.quantityChanged,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valueIdr => $composableBuilder(
    column: $table.valueIdr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEstimate => $composableBuilder(
    column: $table.isEstimate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonWasted => $composableBuilder(
    column: $table.reasonWasted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsageLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsageLogsTable> {
  $$UsageLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pantryItemId => $composableBuilder(
    column: $table.pantryItemId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<UsageAction, String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<double> get quantityChanged => $composableBuilder(
    column: $table.quantityChanged,
    builder: (column) => column,
  );

  GeneratedColumn<int> get valueIdr =>
      $composableBuilder(column: $table.valueIdr, builder: (column) => column);

  GeneratedColumn<bool> get isEstimate => $composableBuilder(
    column: $table.isEstimate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<IngredientCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WasteReason?, String> get reasonWasted =>
      $composableBuilder(
        column: $table.reasonWasted,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);
}

class $$UsageLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsageLogsTable,
          UsageLog,
          $$UsageLogsTableFilterComposer,
          $$UsageLogsTableOrderingComposer,
          $$UsageLogsTableAnnotationComposer,
          $$UsageLogsTableCreateCompanionBuilder,
          $$UsageLogsTableUpdateCompanionBuilder,
          (UsageLog, BaseReferences<_$AppDatabase, $UsageLogsTable, UsageLog>),
          UsageLog,
          PrefetchHooks Function()
        > {
  $$UsageLogsTableTableManager(_$AppDatabase db, $UsageLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsageLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsageLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsageLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> pantryItemId = const Value.absent(),
                Value<UsageAction> action = const Value.absent(),
                Value<double> quantityChanged = const Value.absent(),
                Value<int> valueIdr = const Value.absent(),
                Value<bool> isEstimate = const Value.absent(),
                Value<int> weightGrams = const Value.absent(),
                Value<IngredientCategory> category = const Value.absent(),
                Value<WasteReason?> reasonWasted = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsageLogsCompanion(
                id: id,
                pantryItemId: pantryItemId,
                action: action,
                quantityChanged: quantityChanged,
                valueIdr: valueIdr,
                isEstimate: isEstimate,
                weightGrams: weightGrams,
                category: category,
                reasonWasted: reasonWasted,
                loggedAt: loggedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String pantryItemId,
                required UsageAction action,
                required double quantityChanged,
                Value<int> valueIdr = const Value.absent(),
                Value<bool> isEstimate = const Value.absent(),
                Value<int> weightGrams = const Value.absent(),
                required IngredientCategory category,
                Value<WasteReason?> reasonWasted = const Value.absent(),
                required DateTime loggedAt,
                Value<int> rowid = const Value.absent(),
              }) => UsageLogsCompanion.insert(
                id: id,
                pantryItemId: pantryItemId,
                action: action,
                quantityChanged: quantityChanged,
                valueIdr: valueIdr,
                isEstimate: isEstimate,
                weightGrams: weightGrams,
                category: category,
                reasonWasted: reasonWasted,
                loggedAt: loggedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsageLogsTable, UsageLog>(table),
                  BaseReferences<_$AppDatabase, $UsageLogsTable, UsageLog>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsageLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsageLogsTable,
      UsageLog,
      $$UsageLogsTableFilterComposer,
      $$UsageLogsTableOrderingComposer,
      $$UsageLogsTableAnnotationComposer,
      $$UsageLogsTableCreateCompanionBuilder,
      $$UsageLogsTableUpdateCompanionBuilder,
      (UsageLog, BaseReferences<_$AppDatabase, $UsageLogsTable, UsageLog>),
      UsageLog,
      PrefetchHooks Function()
    >;
typedef $$IngredientCatalogsTableCreateCompanionBuilder =
    IngredientCatalogsCompanion Function({
      required String id,
      required String nameId,
      Value<List<String>> aliases,
      required String nameEn,
      required IngredientCategory category,
      required String emoji,
      Value<String?> photoAsset,
      required Unit defaultUnit,
      Value<int?> shelfLifeKulkas,
      Value<int?> shelfLifeFreezer,
      Value<int?> shelfLifeLemari,
      Value<int?> shelfLifeSuhuRuang,
      required String shelfLifeNote,
      Value<List<String>> tips,
      Value<List<String>> quickTags,
      Value<double?> avgWeightPerUnitGrams,
      Value<int?> typicalPriceIdr,
      Value<List<String>> quickIdeaRecipeIds,
      Value<int> rowid,
    });
typedef $$IngredientCatalogsTableUpdateCompanionBuilder =
    IngredientCatalogsCompanion Function({
      Value<String> id,
      Value<String> nameId,
      Value<List<String>> aliases,
      Value<String> nameEn,
      Value<IngredientCategory> category,
      Value<String> emoji,
      Value<String?> photoAsset,
      Value<Unit> defaultUnit,
      Value<int?> shelfLifeKulkas,
      Value<int?> shelfLifeFreezer,
      Value<int?> shelfLifeLemari,
      Value<int?> shelfLifeSuhuRuang,
      Value<String> shelfLifeNote,
      Value<List<String>> tips,
      Value<List<String>> quickTags,
      Value<double?> avgWeightPerUnitGrams,
      Value<int?> typicalPriceIdr,
      Value<List<String>> quickIdeaRecipeIds,
      Value<int> rowid,
    });

class $$IngredientCatalogsTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientCatalogsTable> {
  $$IngredientCatalogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameId => $composableBuilder(
    column: $table.nameId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get aliases => $composableBuilder(
    column: $table.aliases,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<IngredientCategory, IngredientCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoAsset => $composableBuilder(
    column: $table.photoAsset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Unit, Unit, String> get defaultUnit =>
      $composableBuilder(
        column: $table.defaultUnit,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get shelfLifeKulkas => $composableBuilder(
    column: $table.shelfLifeKulkas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shelfLifeFreezer => $composableBuilder(
    column: $table.shelfLifeFreezer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shelfLifeLemari => $composableBuilder(
    column: $table.shelfLifeLemari,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shelfLifeSuhuRuang => $composableBuilder(
    column: $table.shelfLifeSuhuRuang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shelfLifeNote => $composableBuilder(
    column: $table.shelfLifeNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tips =>
      $composableBuilder(
        column: $table.tips,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get quickTags => $composableBuilder(
    column: $table.quickTags,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get avgWeightPerUnitGrams => $composableBuilder(
    column: $table.avgWeightPerUnitGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get typicalPriceIdr => $composableBuilder(
    column: $table.typicalPriceIdr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get quickIdeaRecipeIds => $composableBuilder(
    column: $table.quickIdeaRecipeIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$IngredientCatalogsTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientCatalogsTable> {
  $$IngredientCatalogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameId => $composableBuilder(
    column: $table.nameId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aliases => $composableBuilder(
    column: $table.aliases,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoAsset => $composableBuilder(
    column: $table.photoAsset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultUnit => $composableBuilder(
    column: $table.defaultUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shelfLifeKulkas => $composableBuilder(
    column: $table.shelfLifeKulkas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shelfLifeFreezer => $composableBuilder(
    column: $table.shelfLifeFreezer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shelfLifeLemari => $composableBuilder(
    column: $table.shelfLifeLemari,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shelfLifeSuhuRuang => $composableBuilder(
    column: $table.shelfLifeSuhuRuang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shelfLifeNote => $composableBuilder(
    column: $table.shelfLifeNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tips => $composableBuilder(
    column: $table.tips,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quickTags => $composableBuilder(
    column: $table.quickTags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgWeightPerUnitGrams => $composableBuilder(
    column: $table.avgWeightPerUnitGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get typicalPriceIdr => $composableBuilder(
    column: $table.typicalPriceIdr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quickIdeaRecipeIds => $composableBuilder(
    column: $table.quickIdeaRecipeIds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IngredientCatalogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientCatalogsTable> {
  $$IngredientCatalogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameId =>
      $composableBuilder(column: $table.nameId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get aliases =>
      $composableBuilder(column: $table.aliases, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumnWithTypeConverter<IngredientCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get photoAsset => $composableBuilder(
    column: $table.photoAsset,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Unit, String> get defaultUnit =>
      $composableBuilder(
        column: $table.defaultUnit,
        builder: (column) => column,
      );

  GeneratedColumn<int> get shelfLifeKulkas => $composableBuilder(
    column: $table.shelfLifeKulkas,
    builder: (column) => column,
  );

  GeneratedColumn<int> get shelfLifeFreezer => $composableBuilder(
    column: $table.shelfLifeFreezer,
    builder: (column) => column,
  );

  GeneratedColumn<int> get shelfLifeLemari => $composableBuilder(
    column: $table.shelfLifeLemari,
    builder: (column) => column,
  );

  GeneratedColumn<int> get shelfLifeSuhuRuang => $composableBuilder(
    column: $table.shelfLifeSuhuRuang,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shelfLifeNote => $composableBuilder(
    column: $table.shelfLifeNote,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get tips =>
      $composableBuilder(column: $table.tips, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get quickTags =>
      $composableBuilder(column: $table.quickTags, builder: (column) => column);

  GeneratedColumn<double> get avgWeightPerUnitGrams => $composableBuilder(
    column: $table.avgWeightPerUnitGrams,
    builder: (column) => column,
  );

  GeneratedColumn<int> get typicalPriceIdr => $composableBuilder(
    column: $table.typicalPriceIdr,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String>
  get quickIdeaRecipeIds => $composableBuilder(
    column: $table.quickIdeaRecipeIds,
    builder: (column) => column,
  );
}

class $$IngredientCatalogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientCatalogsTable,
          IngredientCatalog,
          $$IngredientCatalogsTableFilterComposer,
          $$IngredientCatalogsTableOrderingComposer,
          $$IngredientCatalogsTableAnnotationComposer,
          $$IngredientCatalogsTableCreateCompanionBuilder,
          $$IngredientCatalogsTableUpdateCompanionBuilder,
          (
            IngredientCatalog,
            BaseReferences<
              _$AppDatabase,
              $IngredientCatalogsTable,
              IngredientCatalog
            >,
          ),
          IngredientCatalog,
          PrefetchHooks Function()
        > {
  $$IngredientCatalogsTableTableManager(
    _$AppDatabase db,
    $IngredientCatalogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientCatalogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientCatalogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientCatalogsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nameId = const Value.absent(),
                Value<List<String>> aliases = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<IngredientCategory> category = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<String?> photoAsset = const Value.absent(),
                Value<Unit> defaultUnit = const Value.absent(),
                Value<int?> shelfLifeKulkas = const Value.absent(),
                Value<int?> shelfLifeFreezer = const Value.absent(),
                Value<int?> shelfLifeLemari = const Value.absent(),
                Value<int?> shelfLifeSuhuRuang = const Value.absent(),
                Value<String> shelfLifeNote = const Value.absent(),
                Value<List<String>> tips = const Value.absent(),
                Value<List<String>> quickTags = const Value.absent(),
                Value<double?> avgWeightPerUnitGrams = const Value.absent(),
                Value<int?> typicalPriceIdr = const Value.absent(),
                Value<List<String>> quickIdeaRecipeIds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientCatalogsCompanion(
                id: id,
                nameId: nameId,
                aliases: aliases,
                nameEn: nameEn,
                category: category,
                emoji: emoji,
                photoAsset: photoAsset,
                defaultUnit: defaultUnit,
                shelfLifeKulkas: shelfLifeKulkas,
                shelfLifeFreezer: shelfLifeFreezer,
                shelfLifeLemari: shelfLifeLemari,
                shelfLifeSuhuRuang: shelfLifeSuhuRuang,
                shelfLifeNote: shelfLifeNote,
                tips: tips,
                quickTags: quickTags,
                avgWeightPerUnitGrams: avgWeightPerUnitGrams,
                typicalPriceIdr: typicalPriceIdr,
                quickIdeaRecipeIds: quickIdeaRecipeIds,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nameId,
                Value<List<String>> aliases = const Value.absent(),
                required String nameEn,
                required IngredientCategory category,
                required String emoji,
                Value<String?> photoAsset = const Value.absent(),
                required Unit defaultUnit,
                Value<int?> shelfLifeKulkas = const Value.absent(),
                Value<int?> shelfLifeFreezer = const Value.absent(),
                Value<int?> shelfLifeLemari = const Value.absent(),
                Value<int?> shelfLifeSuhuRuang = const Value.absent(),
                required String shelfLifeNote,
                Value<List<String>> tips = const Value.absent(),
                Value<List<String>> quickTags = const Value.absent(),
                Value<double?> avgWeightPerUnitGrams = const Value.absent(),
                Value<int?> typicalPriceIdr = const Value.absent(),
                Value<List<String>> quickIdeaRecipeIds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientCatalogsCompanion.insert(
                id: id,
                nameId: nameId,
                aliases: aliases,
                nameEn: nameEn,
                category: category,
                emoji: emoji,
                photoAsset: photoAsset,
                defaultUnit: defaultUnit,
                shelfLifeKulkas: shelfLifeKulkas,
                shelfLifeFreezer: shelfLifeFreezer,
                shelfLifeLemari: shelfLifeLemari,
                shelfLifeSuhuRuang: shelfLifeSuhuRuang,
                shelfLifeNote: shelfLifeNote,
                tips: tips,
                quickTags: quickTags,
                avgWeightPerUnitGrams: avgWeightPerUnitGrams,
                typicalPriceIdr: typicalPriceIdr,
                quickIdeaRecipeIds: quickIdeaRecipeIds,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IngredientCatalogsTable, IngredientCatalog>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $IngredientCatalogsTable,
                    IngredientCatalog
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IngredientCatalogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientCatalogsTable,
      IngredientCatalog,
      $$IngredientCatalogsTableFilterComposer,
      $$IngredientCatalogsTableOrderingComposer,
      $$IngredientCatalogsTableAnnotationComposer,
      $$IngredientCatalogsTableCreateCompanionBuilder,
      $$IngredientCatalogsTableUpdateCompanionBuilder,
      (
        IngredientCatalog,
        BaseReferences<
          _$AppDatabase,
          $IngredientCatalogsTable,
          IngredientCatalog
        >,
      ),
      IngredientCatalog,
      PrefetchHooks Function()
    >;
typedef $$RecipesTableCreateCompanionBuilder = RecipesCompanion Function({
  required String id,
  required String title,
  Value<String> emoji,
  Value<String?> imageAsset,
  required int cookTimeMin,
  required RecipeDifficulty difficulty,
  Value<int> servings,
  Value<int> estimatedCostIdr,
  Value<bool> isQuick,
  Value<List<String>> tags,
  Value<List<String>> steps,
  Value<int> rowid,
});
typedef $$RecipesTableUpdateCompanionBuilder = RecipesCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> emoji,
  Value<String?> imageAsset,
  Value<int> cookTimeMin,
  Value<RecipeDifficulty> difficulty,
  Value<int> servings,
  Value<int> estimatedCostIdr,
  Value<bool> isQuick,
  Value<List<String>> tags,
  Value<List<String>> steps,
  Value<int> rowid,
});

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cookTimeMin => $composableBuilder(
    column: $table.cookTimeMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RecipeDifficulty, RecipeDifficulty, String>
  get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedCostIdr => $composableBuilder(
    column: $table.estimatedCostIdr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isQuick => $composableBuilder(
    column: $table.isQuick,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tags =>
      $composableBuilder(
        column: $table.tags,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cookTimeMin => $composableBuilder(
    column: $table.cookTimeMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedCostIdr => $composableBuilder(
    column: $table.estimatedCostIdr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isQuick => $composableBuilder(
    column: $table.isQuick,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cookTimeMin => $composableBuilder(
    column: $table.cookTimeMin,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<RecipeDifficulty, String> get difficulty =>
      $composableBuilder(
        column: $table.difficulty,
        builder: (column) => column,
      );

  GeneratedColumn<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<int> get estimatedCostIdr => $composableBuilder(
    column: $table.estimatedCostIdr,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isQuick =>
      $composableBuilder(column: $table.isQuick, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);
}

class $$RecipesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipesTable,
          Recipe,
          $$RecipesTableFilterComposer,
          $$RecipesTableOrderingComposer,
          $$RecipesTableAnnotationComposer,
          $$RecipesTableCreateCompanionBuilder,
          $$RecipesTableUpdateCompanionBuilder,
          (Recipe, BaseReferences<_$AppDatabase, $RecipesTable, Recipe>),
          Recipe,
          PrefetchHooks Function()
        > {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<String?> imageAsset = const Value.absent(),
                Value<int> cookTimeMin = const Value.absent(),
                Value<RecipeDifficulty> difficulty = const Value.absent(),
                Value<int> servings = const Value.absent(),
                Value<int> estimatedCostIdr = const Value.absent(),
                Value<bool> isQuick = const Value.absent(),
                Value<List<String>> tags = const Value.absent(),
                Value<List<String>> steps = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion(
                id: id,
                title: title,
                emoji: emoji,
                imageAsset: imageAsset,
                cookTimeMin: cookTimeMin,
                difficulty: difficulty,
                servings: servings,
                estimatedCostIdr: estimatedCostIdr,
                isQuick: isQuick,
                tags: tags,
                steps: steps,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String> emoji = const Value.absent(),
                Value<String?> imageAsset = const Value.absent(),
                required int cookTimeMin,
                required RecipeDifficulty difficulty,
                Value<int> servings = const Value.absent(),
                Value<int> estimatedCostIdr = const Value.absent(),
                Value<bool> isQuick = const Value.absent(),
                Value<List<String>> tags = const Value.absent(),
                Value<List<String>> steps = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion.insert(
                id: id,
                title: title,
                emoji: emoji,
                imageAsset: imageAsset,
                cookTimeMin: cookTimeMin,
                difficulty: difficulty,
                servings: servings,
                estimatedCostIdr: estimatedCostIdr,
                isQuick: isQuick,
                tags: tags,
                steps: steps,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecipesTable, Recipe>(table),
                  BaseReferences<_$AppDatabase, $RecipesTable, Recipe>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipesTable,
      Recipe,
      $$RecipesTableFilterComposer,
      $$RecipesTableOrderingComposer,
      $$RecipesTableAnnotationComposer,
      $$RecipesTableCreateCompanionBuilder,
      $$RecipesTableUpdateCompanionBuilder,
      (Recipe, BaseReferences<_$AppDatabase, $RecipesTable, Recipe>),
      Recipe,
      PrefetchHooks Function()
    >;
typedef $$RecipeIngredientsTableCreateCompanionBuilder =
    RecipeIngredientsCompanion Function({
      required String id,
      required String recipeId,
      Value<String?> catalogId,
      required String name,
      required double amount,
      required Unit unit,
      Value<bool> isOptional,
      Value<bool> isStaple,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$RecipeIngredientsTableUpdateCompanionBuilder =
    RecipeIngredientsCompanion Function({
      Value<String> id,
      Value<String> recipeId,
      Value<String?> catalogId,
      Value<String> name,
      Value<double> amount,
      Value<Unit> unit,
      Value<bool> isOptional,
      Value<bool> isStaple,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$RecipeIngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catalogId => $composableBuilder(
    column: $table.catalogId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Unit, Unit, String> get unit =>
      $composableBuilder(
        column: $table.unit,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isOptional => $composableBuilder(
    column: $table.isOptional,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStaple => $composableBuilder(
    column: $table.isStaple,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecipeIngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catalogId => $composableBuilder(
    column: $table.catalogId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOptional => $composableBuilder(
    column: $table.isOptional,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStaple => $composableBuilder(
    column: $table.isStaple,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipeIngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<String> get catalogId =>
      $composableBuilder(column: $table.catalogId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Unit, String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get isOptional => $composableBuilder(
    column: $table.isOptional,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isStaple =>
      $composableBuilder(column: $table.isStaple, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$RecipeIngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeIngredientsTable,
          RecipeIngredient,
          $$RecipeIngredientsTableFilterComposer,
          $$RecipeIngredientsTableOrderingComposer,
          $$RecipeIngredientsTableAnnotationComposer,
          $$RecipeIngredientsTableCreateCompanionBuilder,
          $$RecipeIngredientsTableUpdateCompanionBuilder,
          (
            RecipeIngredient,
            BaseReferences<
              _$AppDatabase,
              $RecipeIngredientsTable,
              RecipeIngredient
            >,
          ),
          RecipeIngredient,
          PrefetchHooks Function()
        > {
  $$RecipeIngredientsTableTableManager(
    _$AppDatabase db,
    $RecipeIngredientsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeIngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeIngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeIngredientsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<String?> catalogId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<Unit> unit = const Value.absent(),
                Value<bool> isOptional = const Value.absent(),
                Value<bool> isStaple = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeIngredientsCompanion(
                id: id,
                recipeId: recipeId,
                catalogId: catalogId,
                name: name,
                amount: amount,
                unit: unit,
                isOptional: isOptional,
                isStaple: isStaple,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String recipeId,
                Value<String?> catalogId = const Value.absent(),
                required String name,
                required double amount,
                required Unit unit,
                Value<bool> isOptional = const Value.absent(),
                Value<bool> isStaple = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeIngredientsCompanion.insert(
                id: id,
                recipeId: recipeId,
                catalogId: catalogId,
                name: name,
                amount: amount,
                unit: unit,
                isOptional: isOptional,
                isStaple: isStaple,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecipeIngredientsTable, RecipeIngredient>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RecipeIngredientsTable,
                    RecipeIngredient
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecipeIngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeIngredientsTable,
      RecipeIngredient,
      $$RecipeIngredientsTableFilterComposer,
      $$RecipeIngredientsTableOrderingComposer,
      $$RecipeIngredientsTableAnnotationComposer,
      $$RecipeIngredientsTableCreateCompanionBuilder,
      $$RecipeIngredientsTableUpdateCompanionBuilder,
      (
        RecipeIngredient,
        BaseReferences<
          _$AppDatabase,
          $RecipeIngredientsTable,
          RecipeIngredient
        >,
      ),
      RecipeIngredient,
      PrefetchHooks Function()
    >;
typedef $$BarcodeCacheTableCreateCompanionBuilder =
    BarcodeCacheCompanion Function({
      required String barcode,
      required String name,
      Value<String?> brand,
      required IngredientCategory category,
      Value<String?> quantityText,
      required BarcodeSource source,
      required DateTime fetchedAt,
      Value<int> rowid,
    });
typedef $$BarcodeCacheTableUpdateCompanionBuilder =
    BarcodeCacheCompanion Function({
      Value<String> barcode,
      Value<String> name,
      Value<String?> brand,
      Value<IngredientCategory> category,
      Value<String?> quantityText,
      Value<BarcodeSource> source,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$BarcodeCacheTableFilterComposer
    extends Composer<_$AppDatabase, $BarcodeCacheTable> {
  $$BarcodeCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<IngredientCategory, IngredientCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get quantityText => $composableBuilder(
    column: $table.quantityText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BarcodeSource, BarcodeSource, String>
  get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BarcodeCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $BarcodeCacheTable> {
  $$BarcodeCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quantityText => $composableBuilder(
    column: $table.quantityText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BarcodeCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $BarcodeCacheTable> {
  $$BarcodeCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumnWithTypeConverter<IngredientCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get quantityText => $composableBuilder(
    column: $table.quantityText,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<BarcodeSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$BarcodeCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BarcodeCacheTable,
          BarcodeCacheEntry,
          $$BarcodeCacheTableFilterComposer,
          $$BarcodeCacheTableOrderingComposer,
          $$BarcodeCacheTableAnnotationComposer,
          $$BarcodeCacheTableCreateCompanionBuilder,
          $$BarcodeCacheTableUpdateCompanionBuilder,
          (
            BarcodeCacheEntry,
            BaseReferences<
              _$AppDatabase,
              $BarcodeCacheTable,
              BarcodeCacheEntry
            >,
          ),
          BarcodeCacheEntry,
          PrefetchHooks Function()
        > {
  $$BarcodeCacheTableTableManager(_$AppDatabase db, $BarcodeCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BarcodeCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BarcodeCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BarcodeCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> barcode = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<IngredientCategory> category = const Value.absent(),
                Value<String?> quantityText = const Value.absent(),
                Value<BarcodeSource> source = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BarcodeCacheCompanion(
                barcode: barcode,
                name: name,
                brand: brand,
                category: category,
                quantityText: quantityText,
                source: source,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String barcode,
                required String name,
                Value<String?> brand = const Value.absent(),
                required IngredientCategory category,
                Value<String?> quantityText = const Value.absent(),
                required BarcodeSource source,
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => BarcodeCacheCompanion.insert(
                barcode: barcode,
                name: name,
                brand: brand,
                category: category,
                quantityText: quantityText,
                source: source,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BarcodeCacheTable, BarcodeCacheEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $BarcodeCacheTable,
                    BarcodeCacheEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BarcodeCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BarcodeCacheTable,
      BarcodeCacheEntry,
      $$BarcodeCacheTableFilterComposer,
      $$BarcodeCacheTableOrderingComposer,
      $$BarcodeCacheTableAnnotationComposer,
      $$BarcodeCacheTableCreateCompanionBuilder,
      $$BarcodeCacheTableUpdateCompanionBuilder,
      (
        BarcodeCacheEntry,
        BaseReferences<_$AppDatabase, $BarcodeCacheTable, BarcodeCacheEntry>,
      ),
      BarcodeCacheEntry,
      PrefetchHooks Function()
    >;
typedef $$ShoppingListItemsTableCreateCompanionBuilder =
    ShoppingListItemsCompanion Function({
      required String id,
      required String name,
      Value<double> quantity,
      required Unit unit,
      Value<bool> isChecked,
      required ShoppingSource source,
      Value<int> sortOrder,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ShoppingListItemsTableUpdateCompanionBuilder =
    ShoppingListItemsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<double> quantity,
      Value<Unit> unit,
      Value<bool> isChecked,
      Value<ShoppingSource> source,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ShoppingListItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingListItemsTable> {
  $$ShoppingListItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Unit, Unit, String> get unit =>
      $composableBuilder(
        column: $table.unit,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isChecked => $composableBuilder(
    column: $table.isChecked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ShoppingSource, ShoppingSource, String>
  get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShoppingListItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingListItemsTable> {
  $$ShoppingListItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isChecked => $composableBuilder(
    column: $table.isChecked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShoppingListItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingListItemsTable> {
  $$ShoppingListItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Unit, String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get isChecked =>
      $composableBuilder(column: $table.isChecked, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ShoppingSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ShoppingListItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingListItemsTable,
          ShoppingListItem,
          $$ShoppingListItemsTableFilterComposer,
          $$ShoppingListItemsTableOrderingComposer,
          $$ShoppingListItemsTableAnnotationComposer,
          $$ShoppingListItemsTableCreateCompanionBuilder,
          $$ShoppingListItemsTableUpdateCompanionBuilder,
          (
            ShoppingListItem,
            BaseReferences<
              _$AppDatabase,
              $ShoppingListItemsTable,
              ShoppingListItem
            >,
          ),
          ShoppingListItem,
          PrefetchHooks Function()
        > {
  $$ShoppingListItemsTableTableManager(
    _$AppDatabase db,
    $ShoppingListItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingListItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingListItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingListItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<Unit> unit = const Value.absent(),
                Value<bool> isChecked = const Value.absent(),
                Value<ShoppingSource> source = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingListItemsCompanion(
                id: id,
                name: name,
                quantity: quantity,
                unit: unit,
                isChecked: isChecked,
                source: source,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<double> quantity = const Value.absent(),
                required Unit unit,
                Value<bool> isChecked = const Value.absent(),
                required ShoppingSource source,
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ShoppingListItemsCompanion.insert(
                id: id,
                name: name,
                quantity: quantity,
                unit: unit,
                isChecked: isChecked,
                source: source,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShoppingListItemsTable, ShoppingListItem>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ShoppingListItemsTable,
                    ShoppingListItem
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShoppingListItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingListItemsTable,
      ShoppingListItem,
      $$ShoppingListItemsTableFilterComposer,
      $$ShoppingListItemsTableOrderingComposer,
      $$ShoppingListItemsTableAnnotationComposer,
      $$ShoppingListItemsTableCreateCompanionBuilder,
      $$ShoppingListItemsTableUpdateCompanionBuilder,
      (
        ShoppingListItem,
        BaseReferences<
          _$AppDatabase,
          $ShoppingListItemsTable,
          ShoppingListItem
        >,
      ),
      ShoppingListItem,
      PrefetchHooks Function()
    >;
typedef $$CachedOnlineRecipesTableCreateCompanionBuilder =
    CachedOnlineRecipesCompanion Function({
      required String idMeal,
      required String json,
      required DateTime fetchedAt,
      Value<int> rowid,
    });
typedef $$CachedOnlineRecipesTableUpdateCompanionBuilder =
    CachedOnlineRecipesCompanion Function({
      Value<String> idMeal,
      Value<String> json,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$CachedOnlineRecipesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedOnlineRecipesTable> {
  $$CachedOnlineRecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get idMeal => $composableBuilder(
    column: $table.idMeal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedOnlineRecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedOnlineRecipesTable> {
  $$CachedOnlineRecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get idMeal => $composableBuilder(
    column: $table.idMeal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedOnlineRecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedOnlineRecipesTable> {
  $$CachedOnlineRecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get idMeal =>
      $composableBuilder(column: $table.idMeal, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$CachedOnlineRecipesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedOnlineRecipesTable,
          CachedOnlineRecipe,
          $$CachedOnlineRecipesTableFilterComposer,
          $$CachedOnlineRecipesTableOrderingComposer,
          $$CachedOnlineRecipesTableAnnotationComposer,
          $$CachedOnlineRecipesTableCreateCompanionBuilder,
          $$CachedOnlineRecipesTableUpdateCompanionBuilder,
          (
            CachedOnlineRecipe,
            BaseReferences<
              _$AppDatabase,
              $CachedOnlineRecipesTable,
              CachedOnlineRecipe
            >,
          ),
          CachedOnlineRecipe,
          PrefetchHooks Function()
        > {
  $$CachedOnlineRecipesTableTableManager(
    _$AppDatabase db,
    $CachedOnlineRecipesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedOnlineRecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedOnlineRecipesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedOnlineRecipesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> idMeal = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedOnlineRecipesCompanion(
                idMeal: idMeal,
                json: json,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String idMeal,
                required String json,
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedOnlineRecipesCompanion.insert(
                idMeal: idMeal,
                json: json,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedOnlineRecipesTable, CachedOnlineRecipe>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedOnlineRecipesTable,
                    CachedOnlineRecipe
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedOnlineRecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedOnlineRecipesTable,
      CachedOnlineRecipe,
      $$CachedOnlineRecipesTableFilterComposer,
      $$CachedOnlineRecipesTableOrderingComposer,
      $$CachedOnlineRecipesTableAnnotationComposer,
      $$CachedOnlineRecipesTableCreateCompanionBuilder,
      $$CachedOnlineRecipesTableUpdateCompanionBuilder,
      (
        CachedOnlineRecipe,
        BaseReferences<
          _$AppDatabase,
          $CachedOnlineRecipesTable,
          CachedOnlineRecipe
        >,
      ),
      CachedOnlineRecipe,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PantryItemsTableTableManager get pantryItems =>
      $$PantryItemsTableTableManager(_db, _db.pantryItems);
  $$UsageLogsTableTableManager get usageLogs =>
      $$UsageLogsTableTableManager(_db, _db.usageLogs);
  $$IngredientCatalogsTableTableManager get ingredientCatalogs =>
      $$IngredientCatalogsTableTableManager(_db, _db.ingredientCatalogs);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$RecipeIngredientsTableTableManager get recipeIngredients =>
      $$RecipeIngredientsTableTableManager(_db, _db.recipeIngredients);
  $$BarcodeCacheTableTableManager get barcodeCache =>
      $$BarcodeCacheTableTableManager(_db, _db.barcodeCache);
  $$ShoppingListItemsTableTableManager get shoppingListItems =>
      $$ShoppingListItemsTableTableManager(_db, _db.shoppingListItems);
  $$CachedOnlineRecipesTableTableManager get cachedOnlineRecipes =>
      $$CachedOnlineRecipesTableTableManager(_db, _db.cachedOnlineRecipes);
}
