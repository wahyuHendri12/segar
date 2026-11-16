import 'dart:convert';

import 'package:drift/drift.dart';

/// Stores a list of strings as a JSON array in a text column.
///
/// Used for catalog aliases, tips, quick tags and recipe steps/tags.
class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.trim().isEmpty) return const <String>[];
    final decoded = jsonDecode(fromDb);
    if (decoded is! List) return const <String>[];
    return decoded.whereType<String>().toList(growable: false);
  }

  @override
  String toSql(List<String> value) => jsonEncode(value);
}
