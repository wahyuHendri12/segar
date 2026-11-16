/// Domain enums shared by the local database, repositories and UI.
///
/// The enum entry names are persisted in SQLite (`textEnum`), so renaming an
/// entry is a schema migration. Keep the names stable.
library;

enum IngredientCategory {
  sayur,
  buah,
  daging,
  ikanSeafood,
  telurSusu,
  bumbu,
  bahanKering,
  minuman,
  makananOlahan,
  lainnya,
}

enum Unit {
  pcs,
  gram,
  kg,
  ml,
  liter,
  ikat,
  bungkus,
  botol,
  kaleng,
  butir,
  siung,
}

enum StorageLocation { kulkas, freezer, lemari, suhuRuang }

enum ExpirySource { estimasi, manual, kemasan }

enum PantryStatus { aktif, terpakai, terbuang }

enum UsageAction { dipakai, dibuang, dikurangi }

enum WasteReason { basi, lupa, terlaluBanyak, rasaBerubah, lainnya }

enum RecipeDifficulty { mudah, sedang, sulit }

enum ExpiryStatus { aman, hampirBasi, basiHariIni, sudahBasi }

enum ShoppingSource { manual, habis, dariResep }

enum BarcodeSource { lokal, off }

/// Sorting options for the pantry list.
enum PantrySort { expiryAsc, nameAsc, newest }

/// Period selector on the statistics screen.
enum StatsPeriod { mingguIni, bulanIni, tigaBulan, semua }
