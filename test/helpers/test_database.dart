import 'package:drift/native.dart';
import 'package:segar/data/local/database.dart';

/// Opens a fresh in-memory database for a single test.
AppDatabase openTestDatabase() => AppDatabase(NativeDatabase.memory());
