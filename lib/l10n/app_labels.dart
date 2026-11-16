import '../data/local/enums.dart';
import 'app_localizations.dart';

/// Central mapping from persisted enums to Indonesian UI labels.
extension AppLabels on AppLocalizations {
  String unitLabel(Unit unit) {
    return switch (unit) {
      Unit.pcs => unitPcs,
      Unit.gram => unitGram,
      Unit.kg => unitKg,
      Unit.ml => unitMl,
      Unit.liter => unitLiter,
      Unit.ikat => unitIkat,
      Unit.bungkus => unitBungkus,
      Unit.botol => unitBotol,
      Unit.kaleng => unitKaleng,
      Unit.butir => unitButir,
      Unit.siung => unitSiung,
    };
  }

  String categoryLabel(IngredientCategory category) {
    return switch (category) {
      IngredientCategory.sayur => categorySayur,
      IngredientCategory.buah => categoryBuah,
      IngredientCategory.daging => categoryDaging,
      IngredientCategory.ikanSeafood => categoryIkanSeafood,
      IngredientCategory.telurSusu => categoryTelurSusu,
      IngredientCategory.bumbu => categoryBumbu,
      IngredientCategory.bahanKering => categoryBahanKering,
      IngredientCategory.minuman => categoryMinuman,
      IngredientCategory.makananOlahan => categoryMakananOlahan,
      IngredientCategory.lainnya => categoryLainnya,
    };
  }

  String storageLabel(StorageLocation location) {
    return switch (location) {
      StorageLocation.kulkas => locationKulkas,
      StorageLocation.freezer => locationFreezer,
      StorageLocation.lemari => locationLemari,
      StorageLocation.suhuRuang => locationSuhuRuang,
    };
  }

  String difficultyLabel(RecipeDifficulty difficulty) {
    return switch (difficulty) {
      RecipeDifficulty.mudah => difficultyEasy,
      RecipeDifficulty.sedang => difficultyMedium,
      RecipeDifficulty.sulit => difficultyHard,
    };
  }

  String wasteReasonName(WasteReason reason) {
    return switch (reason) {
      WasteReason.basi => wasteReasonBasi,
      WasteReason.lupa => wasteReasonLupa,
      WasteReason.terlaluBanyak => wasteReasonTerlaluBanyak,
      WasteReason.rasaBerubah => wasteReasonRasaBerubah,
      WasteReason.lainnya => wasteReasonLainnya,
    };
  }

  String shoppingSourceLabel(ShoppingSource source) {
    return switch (source) {
      ShoppingSource.manual => shoppingListSourceManual,
      ShoppingSource.habis => shoppingListSourceHabis,
      ShoppingSource.dariResep => shoppingListSourceResep,
    };
  }

  String expirySourceLabel(ExpirySource source) {
    return switch (source) {
      ExpirySource.estimasi => expirySourceEstimasi,
      ExpirySource.manual => expirySourceManual,
      ExpirySource.kemasan => expirySourceKemasan,
    };
  }

  /// Compact label used by [StatusBadge].
  String expiryBadgeLabel(ExpiryStatus status, int daysLeft) {
    return switch (status) {
      ExpiryStatus.aman => statusDaysLeft(daysLeft),
      ExpiryStatus.hampirBasi =>
        daysLeft == 1 ? statusExpiresTomorrow : statusExpiresInDays(daysLeft),
      ExpiryStatus.basiHariIni => detailExpiresToday,
      ExpiryStatus.sudahBasi =>
        daysLeft == -1
            ? statusExpiredYesterday
            : statusExpiredDaysAgo(daysLeft.abs()),
    };
  }

  /// Headline used inside the detail countdown ring.
  String expiryHeadline(ExpiryStatus status, int daysLeft) {
    return switch (status) {
      ExpiryStatus.aman => detailDaysLeft(daysLeft),
      ExpiryStatus.hampirBasi =>
        daysLeft == 1 ? detailExpiresTomorrow : detailExpiresInDays(daysLeft),
      ExpiryStatus.basiHariIni => detailExpiresToday,
      ExpiryStatus.sudahBasi =>
        daysLeft == -1
            ? detailExpiredYesterday
            : detailExpiredDaysAgo(daysLeft.abs()),
    };
  }
}
