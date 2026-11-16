import 'dart:convert';

import '../local/database.dart';

/// Thrown when a file is not a Segar backup or uses an unsupported version.
class BackupFormatException implements Exception {
  const BackupFormatException(this.message);

  final String message;

  @override
  String toString() => 'BackupFormatException: $message';
}

/// User preferences that travel with a backup.
///
/// Every field is nullable so old backup files can omit newer settings.
class BackupSettings {
  const BackupSettings({
    this.userName,
    this.themeMode,
    this.notificationsEnabled,
    this.notifyHour,
    this.notifyMinute,
    this.warnDays,
    this.quietStartHour,
    this.quietEndHour,
    this.onlineBarcodeEnabled,
    this.onlineRecipeEnabled,
  });

  final String? userName;
  final String? themeMode;
  final bool? notificationsEnabled;
  final int? notifyHour;
  final int? notifyMinute;
  final int? warnDays;
  final int? quietStartHour;
  final int? quietEndHour;
  final bool? onlineBarcodeEnabled;
  final bool? onlineRecipeEnabled;

  bool get isEmpty => toJson().isEmpty;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (userName != null) 'userName': userName,
      if (themeMode != null) 'themeMode': themeMode,
      if (notificationsEnabled != null)
        'notificationsEnabled': notificationsEnabled,
      if (notifyHour != null) 'notifyHour': notifyHour,
      if (notifyMinute != null) 'notifyMinute': notifyMinute,
      if (warnDays != null) 'warnDays': warnDays,
      if (quietStartHour != null) 'quietStartHour': quietStartHour,
      if (quietEndHour != null) 'quietEndHour': quietEndHour,
      if (onlineBarcodeEnabled != null)
        'onlineBarcodeEnabled': onlineBarcodeEnabled,
      if (onlineRecipeEnabled != null)
        'onlineRecipeEnabled': onlineRecipeEnabled,
    };
  }

  factory BackupSettings.fromJson(Object? json) {
    if (json is! Map) return const BackupSettings();
    return BackupSettings(
      userName: json['userName'] as String?,
      themeMode: json['themeMode'] as String?,
      notificationsEnabled: json['notificationsEnabled'] as bool?,
      notifyHour: (json['notifyHour'] as num?)?.toInt(),
      notifyMinute: (json['notifyMinute'] as num?)?.toInt(),
      warnDays: (json['warnDays'] as num?)?.toInt(),
      quietStartHour: (json['quietStartHour'] as num?)?.toInt(),
      quietEndHour: (json['quietEndHour'] as num?)?.toInt(),
      onlineBarcodeEnabled: json['onlineBarcodeEnabled'] as bool?,
      onlineRecipeEnabled: json['onlineRecipeEnabled'] as bool?,
    );
  }
}

/// Complete local snapshot written to a `.json` file.
class BackupPayload {
  const BackupPayload({
    required this.exportedAt,
    required this.appVersion,
    required this.pantryItems,
    required this.usageLogs,
    required this.shoppingList,
    required this.settings,
  });

  static const formatName = 'segar-backup';
  static const currentVersion = 1;

  final DateTime exportedAt;
  final String appVersion;
  final List<PantryItem> pantryItems;
  final List<UsageLog> usageLogs;
  final List<ShoppingListItem> shoppingList;
  final BackupSettings settings;

  String encode() {
    return const JsonEncoder.withIndent('  ').convert(toJson());
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'format': formatName,
      'version': currentVersion,
      'appVersion': appVersion,
      'exportedAt': exportedAt.toIso8601String(),
      'pantryItems': pantryItems
          .map((item) => item.toJson())
          .toList(growable: false),
      'usageLogs': usageLogs.map((log) => log.toJson()).toList(growable: false),
      'shoppingList': shoppingList
          .map((item) => item.toJson())
          .toList(growable: false),
      'settings': settings.toJson(),
    };
  }

  factory BackupPayload.decode(String source) {
    final Object? decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException {
      throw const BackupFormatException('File bukan JSON yang valid.');
    }
    if (decoded is! Map) {
      throw const BackupFormatException('Struktur file cadangan tidak cocok.');
    }
    return BackupPayload.fromJson(Map<String, dynamic>.from(decoded));
  }

  factory BackupPayload.fromJson(Map<String, dynamic> json) {
    if (json['format'] != formatName) {
      throw const BackupFormatException('Format cadangan tidak dikenal.');
    }
    final version = json['version'];
    if (version is! num || version.toInt() < 1) {
      throw const BackupFormatException('Versi cadangan tidak valid.');
    }
    if (version.toInt() > currentVersion) {
      throw const BackupFormatException(
        'Cadangan dibuat oleh versi Segar yang lebih baru.',
      );
    }

    return BackupPayload(
      exportedAt:
          DateTime.tryParse(json['exportedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      appVersion: json['appVersion'] as String? ?? 'unknown',
      pantryItems: _decodeList(json['pantryItems'], PantryItem.fromJson),
      usageLogs: _decodeList(json['usageLogs'], UsageLog.fromJson),
      shoppingList: _decodeList(
        json['shoppingList'],
        ShoppingListItem.fromJson,
      ),
      settings: BackupSettings.fromJson(json['settings']),
    );
  }

  static List<T> _decodeList<T>(
    Object? raw,
    T Function(Map<String, dynamic> json) decode,
  ) {
    if (raw == null) return <T>[];
    if (raw is! List) {
      throw const BackupFormatException('Daftar data cadangan tidak valid.');
    }
    try {
      return raw
          .map((entry) {
            if (entry is! Map) {
              throw const BackupFormatException('Isi data cadangan rusak.');
            }
            return decode(Map<String, dynamic>.from(entry));
          })
          .toList(growable: false);
    } on BackupFormatException {
      rethrow;
    } on Object {
      throw const BackupFormatException('Isi data cadangan tidak cocok.');
    }
  }
}
