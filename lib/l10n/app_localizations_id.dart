// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'Segar';

  @override
  String get appTagline => 'Pantry rapi, makanan terselamatkan.';

  @override
  String get onboardingPrivacy => 'Datamu tersimpan di HP ini saja.';

  @override
  String get onboardingStart => 'Mulai Sekarang';

  @override
  String get onboardingSkip => 'Lewati';

  @override
  String get navHome => 'Beranda';

  @override
  String get navRecipes => 'Resep';

  @override
  String get navAdd => 'Tambah';

  @override
  String get navStats => 'Statistik';

  @override
  String get navProfile => 'Profil';

  @override
  String homeGreeting(String name) {
    return 'Halo, $name! 👋';
  }

  @override
  String get homeSubtitle => 'Ini ringkasan pantry segarmu hari ini.';

  @override
  String get homeSectionStatus => 'Status dapur';

  @override
  String get statusSoon => 'Segera pakai';

  @override
  String get statusSafe => 'Aman';

  @override
  String get statusExpired => 'Sudah basi';

  @override
  String get emptyPantryTitle => 'Pantry masih kosong';

  @override
  String get emptyPantryBody =>
      'Tambahkan bahan pertama supaya Segar bisa mengingatkanmu sebelum terlambat.';

  @override
  String get addFirstItem => 'Tambah bahan pertama';

  @override
  String get recipesTitle => 'Olah Sebelum Basi';

  @override
  String get recipesSubtitle =>
      'Saran masakan dari bahan yang paling perlu diselamatkan.';

  @override
  String get recipesEmptyTitle => 'Belum ada saran resep';

  @override
  String get recipesEmptyBody =>
      'Tambahkan bahan ke pantry dulu, lalu Segar akan mencarikan resep yang cocok.';

  @override
  String get recipesSmartMatchLabel => 'SMART MATCH KULKAS';

  @override
  String get recipesSmartMatchAuto => 'Auto-Sync';

  @override
  String recipesSmartMatchBody(int rescued, int total) {
    return '$rescued dari $total bahan hampir basi bisa diselamatkan';
  }

  @override
  String get recipesSmartMatchEmpty =>
      'Belum ada bahan yang mendesak. Tetap masak dari stokmu!';

  @override
  String recipesFilterAll(int count) {
    return 'Semua Resep ($count)';
  }

  @override
  String get recipesFilterQuick => 'Kilat < 15 Menit';

  @override
  String get recipesFilterKos => 'Menu Kosan';

  @override
  String get recipesFilterSoup => 'Kuah Segar';

  @override
  String get recipesFilterStirFry => 'Tumisan';

  @override
  String get recipesSearchTitle => 'Punya bahan lain?';

  @override
  String get recipesSearchBody => 'Ketik bahan untuk mencari ide resep.';

  @override
  String get recipesSearchHint => 'Contoh: tahu, wortel, keju...';

  @override
  String get recipesSearchEmptyTitle => 'Resep tidak ditemukan';

  @override
  String get recipesSearchEmptyBody => 'Coba kata kunci atau kategori lain.';

  @override
  String get recipesNoPantryTitle => 'Pantry masih kosong';

  @override
  String get recipesNoPantryBody =>
      'Tambahkan bahan dulu supaya Segar bisa mencarikan resep yang pas.';

  @override
  String get recipesAddItemAction => 'Tambah bahan';

  @override
  String get recipesLoadError => 'Gagal memuat saran resep.';

  @override
  String recipesAvailableCount(int owned, int total) {
    return '$owned dari $total bahan tersedia';
  }

  @override
  String recipesMissingCount(int count) {
    return 'Kurang $count bahan';
  }

  @override
  String get recipesCompleteBadge => 'Bahan lengkap';

  @override
  String recipesMatchPercent(int score) {
    return '$score% cocok';
  }

  @override
  String recipesUrgentRescue(int count) {
    return '$count bahan segera dipakai';
  }

  @override
  String recipeCookTimeValue(int minutes) {
    return '$minutes menit';
  }

  @override
  String recipeServingsValue(int count) {
    return '$count porsi';
  }

  @override
  String get difficultyEasy => 'Mudah';

  @override
  String get difficultyMedium => 'Sedang';

  @override
  String get difficultyHard => 'Sulit';

  @override
  String get statsTitle => 'Penghematan & Jejak Dapur';

  @override
  String get statsSubtitle => 'Lihat dampak baik dari kebiasaan memasakmu.';

  @override
  String get statsEmptyTitle => 'Belum ada statistik';

  @override
  String get statsEmptyBody =>
      'Statistik akan muncul setelah kamu menandai bahan terpakai atau terbuang.';

  @override
  String get settingsTitle => 'Profil & Pengaturan';

  @override
  String get settingsSubtitle => 'Atur pengalaman Segar sesuai kebiasaanmu.';

  @override
  String get defaultUserName => 'Teman Segar';

  @override
  String get themeTitle => 'Tampilan';

  @override
  String get themeSystem => 'Ikuti sistem';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get aboutTitle => 'Tentang Segar';

  @override
  String get aboutDataTitle => 'Tentang data';

  @override
  String get aboutAttributionOff => 'Data produk dari Open Food Facts (ODbL).';

  @override
  String get aboutAttributionMealDb => 'Resep tambahan dari TheMealDB.';

  @override
  String aboutVersion(String version) {
    return 'Versi $version';
  }

  @override
  String get notificationsHelpTitle => 'Pengingat tidak muncul?';

  @override
  String get notifSettingsTitle => 'Notifikasi';

  @override
  String get notifEnableLabel => 'Aktifkan pengingat';

  @override
  String get notifEnableBody =>
      'Ingatkan sebelum bahan mendekati tanggal basi.';

  @override
  String get notifTimeLabel => 'Jam pengingat';

  @override
  String get notifTimeBody => 'Pengingat dikirim sekali sehari pada jam ini.';

  @override
  String get notifWarnLabel => 'Ingatkan sebelum';

  @override
  String get notifWarnBody => 'Pilih berapa hari sebelum tanggal basi.';

  @override
  String notifWarnDays(int days) {
    return '$days hari';
  }

  @override
  String get notifQuietTitle => 'Jam tenang';

  @override
  String get notifQuietBody =>
      'Tunda pengingat agar tidak mengganggu waktu istirahat.';

  @override
  String get notifQuietStart => 'Mulai';

  @override
  String get notifQuietEnd => 'Selesai';

  @override
  String get notifHelpEntry => 'Panduan pengingat';

  @override
  String get notifPermissionDenied =>
      'Izin notifikasi belum diberikan. Aktifkan lewat pengaturan HP.';

  @override
  String get notifOpenSettingsAction => 'Pengaturan';

  @override
  String get notifPermissionGranted => 'Notifikasi siap digunakan.';

  @override
  String get notifTestTitle => 'Coba notifikasi';

  @override
  String get notifTestBody => 'Kirim notifikasi percobaan sekarang.';

  @override
  String get notifTestSent => 'Notifikasi percobaan dikirim.';

  @override
  String get notifTestFailed =>
      'Gagal mengirim notifikasi percobaan. Periksa izin notifikasi.';

  @override
  String notifTitleSoon(String name) {
    return '$name segera basi';
  }

  @override
  String notifBodySoon(int days) {
    return 'Tinggal $days hari. Yuk pakai sebelum terbuang.';
  }

  @override
  String notifTitleToday(String name) {
    return '$name basi hari ini';
  }

  @override
  String get notifBodyToday => 'Segera pakai atau olah bahan ini hari ini.';

  @override
  String get notifTestNotificationTitle => 'Segar siap mengingatkanmu';

  @override
  String get notifTestNotificationBody =>
      'Ini contoh pengingat kesegaran bahan.';

  @override
  String get notificationsHelpIntro =>
      'Pengingat Segar bekerja tanpa internet. Jika notifikasi tidak muncul, biasanya ada izin atau penghemat baterai yang menghalangi.';

  @override
  String get notificationsHelpStepsTitle => 'Langkah cepat';

  @override
  String get notificationsHelpStepPermission =>
      'Pastikan izin notifikasi untuk Segar sudah diizinkan di pengaturan HP.';

  @override
  String get notificationsHelpStepBattery =>
      'Matikan penghemat baterai atau atur Segar sebagai aplikasi yang tidak dibatasi.';

  @override
  String get notificationsHelpStepAutostart =>
      'Izinkan autostart agar pengingat tetap terjadwal setelah HP dimulai ulang.';

  @override
  String get notificationsHelpBrandsTitle => 'Panduan merek HP';

  @override
  String get notificationsHelpBrandsBody =>
      'Xiaomi: Autostart + tanpa batasan baterai. Oppo/Realme: Izinkan auto-launch. Vivo: Autostart + background power. Samsung: keluarkan Segar dari daftar aplikasi tidur.';

  @override
  String get notificationsHelpOpenSettings => 'Buka pengaturan aplikasi';

  @override
  String get notificationsHelpTest => 'Kirim notifikasi percobaan';

  @override
  String get notificationsHelpTestSent =>
      'Notifikasi percobaan dikirim. Cek laci notifikasi.';

  @override
  String get notificationsHelpTestFailed =>
      'Notifikasi percobaan gagal dikirim.';

  @override
  String get notificationsHelpPermissionTitle => 'Status izin';

  @override
  String get notificationsHelpPermissionOn => 'Izin notifikasi aktif.';

  @override
  String get notificationsHelpPermissionOff => 'Izin notifikasi belum aktif.';

  @override
  String get notificationsHelpEnablePermission => 'Minta izin notifikasi';

  @override
  String get backupTitle => 'Cadangan & pemulihan';

  @override
  String get addItemTitle => 'Tambah Bahan';

  @override
  String get itemDetailTitle => 'Detail Bahan';

  @override
  String get recipeDetailTitle => 'Detail Resep';

  @override
  String get recipeDetailServingsTitle => 'Atur porsi';

  @override
  String get recipeDetailServingsHint => 'Jumlah bahan menyesuaikan otomatis.';

  @override
  String get recipeDetailDecreaseServings => 'Kurangi porsi';

  @override
  String get recipeDetailIncreaseServings => 'Tambah porsi';

  @override
  String get recipeDetailIngredientsTitle => 'Bahan-bahan';

  @override
  String recipeDetailIngredientsCount(int owned, int total) {
    return '$owned dari $total bahan tersedia';
  }

  @override
  String get recipeDetailStepsTitle => 'Cara membuat';

  @override
  String recipeDetailStepLabel(int index) {
    return 'Langkah $index';
  }

  @override
  String get recipeDetailAvailable => 'Tersedia';

  @override
  String get recipeDetailMissing => 'Belum ada';

  @override
  String get recipeDetailOptional => 'Opsional';

  @override
  String get recipeDetailStaple => 'Bahan dasar';

  @override
  String get recipeDetailUrgent => 'Segera dipakai';

  @override
  String get recipeDetailMissingTitle => 'Bahan belum lengkap';

  @override
  String recipeDetailMissingBody(int count) {
    return 'Kamu masih punya $count bahan lain yang bisa dipakai.';
  }

  @override
  String get recipeDetailCook => 'Masak sekarang';

  @override
  String get recipeDetailCookPartial => 'Masak dengan bahan tersedia';

  @override
  String get recipeDetailCookSheetTitle => 'Masak resep ini?';

  @override
  String get recipeDetailCookSheetBody =>
      'Bahan yang dicentang akan dikurangi dari pantry.';

  @override
  String get recipeDetailCookSheetEmpty =>
      'Belum ada bahan yang bisa dikurangi.';

  @override
  String get recipeDetailCookConfirm => 'Masak & kurangi stok';

  @override
  String get recipeDetailCookSuccess =>
      'Resep dimasak. Stok pantry diperbarui.';

  @override
  String get recipeDetailCookNothing => 'Tidak ada bahan yang dipilih.';

  @override
  String get recipeDetailSelectAll => 'Pilih semua';

  @override
  String recipeDetailSelectedCount(int count) {
    return '$count bahan dipilih';
  }

  @override
  String get recipeDetailNotFoundTitle => 'Resep tidak ditemukan';

  @override
  String get recipeDetailNotFoundBody =>
      'Resep ini mungkin sudah tidak tersedia.';

  @override
  String get recipeDetailLoadError => 'Gagal memuat resep.';

  @override
  String get recipeDetailCostLabel => 'Estimasi biaya';

  @override
  String get recipeDetailTimeLabel => 'Waktu masak';

  @override
  String get recipeDetailDifficultyLabel => 'Tingkat kesulitan';

  @override
  String recipeDetailMatchLabel(int score) {
    return '$score% cocok';
  }

  @override
  String get shoppingListTitle => 'Daftar Belanja';

  @override
  String get genericBack => 'Kembali';

  @override
  String get genericClose => 'Tutup';

  @override
  String get dataPrivacyTitle => 'Privasi';

  @override
  String get dataPrivacyBody =>
      'Data pantry disimpan lokal di perangkat ini. Hanya nomor barcode atau kata kunci pencarian yang dikirim saat fitur online diaktifkan.';

  @override
  String get genericCancel => 'Batal';

  @override
  String get genericSave => 'Simpan';

  @override
  String get genericDelete => 'Hapus';

  @override
  String get genericEdit => 'Ubah';

  @override
  String get genericRetry => 'Coba lagi';

  @override
  String get genericAll => 'Semua';

  @override
  String get homeSearchHint => 'Cari bahan...';

  @override
  String get homeSortExpiry => 'Paling cepat basi';

  @override
  String get homeSortName => 'Nama A-Z';

  @override
  String get homeSortNewest => 'Terbaru';

  @override
  String get homeSortTooltip => 'Urutkan bahan';

  @override
  String get homeUrgentTitle => 'Segera dipakai';

  @override
  String get homeSafeTitle => 'Kondisi aman';

  @override
  String get homeExpiredTitle => 'Sudah basi';

  @override
  String get homeItemsTitle => 'Bahan di pantry';

  @override
  String homeItemsCount(int count) {
    return '$count bahan';
  }

  @override
  String get homeNoResultsTitle => 'Bahan tidak ditemukan';

  @override
  String get homeNoResultsBody =>
      'Coba kata kunci lain atau ubah filter lokasi.';

  @override
  String get homeClearFilters => 'Hapus filter';

  @override
  String get homeReminderTitle => 'PENGINGAT HARI INI';

  @override
  String homeReminderBody(int count) {
    return '$count bahan perlu segera dipakai.';
  }

  @override
  String get homeLoadError => 'Gagal memuat pantry.';

  @override
  String get homeStatusUpdate => 'Diperbarui otomatis';

  @override
  String get formEditTitle => 'Ubah Bahan';

  @override
  String get formSubtitle => 'Catat bahan supaya Segar bisa mengingatkanmu.';

  @override
  String get formPopularTitle => 'Bahan populer';

  @override
  String get formSearchCatalog => 'Cari di katalog';

  @override
  String get formNameLabel => 'Nama bahan';

  @override
  String get formNameHint => 'Contoh: Bayam hijau';

  @override
  String get formNameRequired => 'Nama bahan wajib diisi.';

  @override
  String get formQuantityLabel => 'Jumlah';

  @override
  String get formQuantityInvalid => 'Jumlah harus lebih dari 0.';

  @override
  String get formUnitLabel => 'Satuan';

  @override
  String get formCategoryLabel => 'Kategori';

  @override
  String get formPurchaseDateLabel => 'Tanggal beli';

  @override
  String get formExpiryDateLabel => 'Tanggal basi';

  @override
  String get formExpiryEstimate => 'Estimasi otomatis';

  @override
  String get formExpiryManual => 'Diatur manual';

  @override
  String get formPriceLabel => 'Harga (opsional)';

  @override
  String get formPriceHint => 'Contoh: 5000';

  @override
  String get formPriceInvalid => 'Harga harus berupa angka.';

  @override
  String get formNoteLabel => 'Catatan (opsional)';

  @override
  String get formNoteHint => 'Contoh: beli di pasar pagi';

  @override
  String get formNotifyLabel => 'Ingatkan sebelum basi';

  @override
  String get formNotifyBody => 'Pengingat mengikuti pengaturan notifikasi.';

  @override
  String get formSave => 'Simpan bahan';

  @override
  String get formUpdate => 'Simpan perubahan';

  @override
  String get formSaved => 'Bahan berhasil disimpan.';

  @override
  String get formUpdated => 'Perubahan berhasil disimpan.';

  @override
  String get formSaveError => 'Gagal menyimpan bahan. Coba lagi.';

  @override
  String get formExpiryBeforePurchase =>
      'Tanggal basi tidak boleh sebelum tanggal beli.';

  @override
  String formShelfLifeInfo(String location, int days) {
    return 'Umur simpan di $location: $days hari';
  }

  @override
  String get formShelfLifeUnknown =>
      'Belum ada estimasi umur simpan untuk lokasi ini.';

  @override
  String get formSectionDetails => 'Detail bahan';

  @override
  String get formSectionStorage => 'Penyimpanan';

  @override
  String get formSectionOptional => 'Tambahan';

  @override
  String get formCustomIngredient => 'Bahan manual';

  @override
  String get formCatalogSearchHint => 'Cari bahan...';

  @override
  String get formCatalogEmpty =>
      'Bahan tidak ditemukan. Kamu tetap bisa menambahkannya manual.';

  @override
  String get detailFreshness => 'Status kesegaran';

  @override
  String detailDaysLeft(int days) {
    return 'Sisa $days hari';
  }

  @override
  String get detailExpiresToday => 'Basi hari ini';

  @override
  String get detailExpiresTomorrow => 'Basi besok';

  @override
  String detailExpiresInDays(int days) {
    return 'Basi $days hari lagi';
  }

  @override
  String detailExpiredDaysAgo(int days) {
    return 'Basi $days hari lalu';
  }

  @override
  String get detailExpiredYesterday => 'Basi kemarin';

  @override
  String get detailQuantity => 'Jumlah';

  @override
  String get detailCategory => 'Kategori';

  @override
  String get detailStorage => 'Lokasi simpan';

  @override
  String get detailPurchasedOn => 'Dibeli';

  @override
  String get detailExpiresOn => 'Tanggal basi';

  @override
  String get detailPrice => 'Harga';

  @override
  String get detailNote => 'Catatan';

  @override
  String get detailTipsTitle => 'Tips penyimpanan';

  @override
  String get detailNoTips => 'Belum ada tips untuk bahan ini.';

  @override
  String get detailActionsTitle => 'Aksi cepat';

  @override
  String get detailInfoTitle => 'Informasi bahan';

  @override
  String get detailShelfLife => 'Umur simpan';

  @override
  String get detailNotifOn => 'Pengingat aktif';

  @override
  String get detailNotifOff => 'Pengingat mati';

  @override
  String get detailValueHint =>
      'Nilai dihitung dari harga bahan atau estimasi katalog.';

  @override
  String get detailMarkUsed => 'Tandai terpakai';

  @override
  String get detailMarkWasted => 'Tandai terbuang';

  @override
  String get detailPartial => 'Pakai sebagian';

  @override
  String get detailEdit => 'Ubah bahan';

  @override
  String get detailDelete => 'Hapus bahan';

  @override
  String get detailNotFoundTitle => 'Bahan tidak ditemukan';

  @override
  String get detailNotFoundBody => 'Bahan ini mungkin sudah dihapus.';

  @override
  String get detailLoadError => 'Gagal memuat detail bahan.';

  @override
  String get actionUsedSuccess => 'Bahan ditandai terpakai.';

  @override
  String get actionWastedSuccess => 'Bahan ditandai terbuang.';

  @override
  String get actionPartialSuccess => 'Pemakaian sebagian dicatat.';

  @override
  String get actionDeleted => 'Bahan dihapus dari pantry.';

  @override
  String get actionUndo => 'Urungkan';

  @override
  String get actionFailed => 'Aksi gagal. Coba lagi.';

  @override
  String valueSaved(String amount) {
    return 'Nilai terselamatkan: $amount';
  }

  @override
  String valueWasted(String amount) {
    return 'Nilai terbuang: $amount';
  }

  @override
  String get valueEstimateSuffix => ' (estimasi)';

  @override
  String get deleteConfirmTitle => 'Hapus bahan?';

  @override
  String get deleteConfirmBody =>
      'Bahan akan dihapus dari pantry. Riwayat pemakaian tetap disimpan.';

  @override
  String get deleteConfirmAction => 'Hapus';

  @override
  String get partialSheetTitle => 'Pakai sebagian';

  @override
  String partialSheetBody(String name) {
    return 'Berapa banyak $name yang dipakai?';
  }

  @override
  String get partialUsedLabel => 'Jumlah dipakai';

  @override
  String get partialQuickQuarter => '¼';

  @override
  String get partialQuickHalf => '½';

  @override
  String get partialQuickAll => 'Semua';

  @override
  String get partialSave => 'Catat pemakaian';

  @override
  String get partialInvalid =>
      'Jumlah harus lebih dari 0 dan tidak melebihi stok.';

  @override
  String partialRemaining(String amount, String unit) {
    return 'Sisa stok: $amount $unit';
  }

  @override
  String get wasteSheetTitle => 'Tandai terbuang';

  @override
  String get wasteSheetBody => 'Pilih alasan supaya statistikmu lebih akurat.';

  @override
  String get wasteReasonBasi => 'Basi';

  @override
  String get wasteReasonLupa => 'Lupa';

  @override
  String get wasteReasonTerlaluBanyak => 'Terlalu banyak';

  @override
  String get wasteReasonRasaBerubah => 'Rasa berubah';

  @override
  String get wasteReasonLainnya => 'Lainnya';

  @override
  String get wasteSave => 'Tandai terbuang';

  @override
  String get unitPcs => 'pcs';

  @override
  String get unitGram => 'gram';

  @override
  String get unitKg => 'kg';

  @override
  String get unitMl => 'ml';

  @override
  String get unitLiter => 'liter';

  @override
  String get unitIkat => 'ikat';

  @override
  String get unitBungkus => 'bungkus';

  @override
  String get unitBotol => 'botol';

  @override
  String get unitKaleng => 'kaleng';

  @override
  String get unitButir => 'butir';

  @override
  String get unitSiung => 'siung';

  @override
  String get categorySayur => 'Sayur';

  @override
  String get categoryBuah => 'Buah';

  @override
  String get categoryDaging => 'Daging';

  @override
  String get categoryIkanSeafood => 'Ikan & seafood';

  @override
  String get categoryTelurSusu => 'Telur & susu';

  @override
  String get categoryBumbu => 'Bumbu';

  @override
  String get categoryBahanKering => 'Bahan kering';

  @override
  String get categoryMinuman => 'Minuman';

  @override
  String get categoryMakananOlahan => 'Makanan olahan';

  @override
  String get categoryLainnya => 'Lainnya';

  @override
  String get locationKulkas => 'Kulkas';

  @override
  String get locationFreezer => 'Freezer';

  @override
  String get locationLemari => 'Lemari';

  @override
  String get locationSuhuRuang => 'Suhu ruang';

  @override
  String get expirySourceEstimasi => 'Estimasi otomatis';

  @override
  String get expirySourceManual => 'Diatur manual';

  @override
  String get expirySourceKemasan => 'Dari kemasan';

  @override
  String statusDaysLeft(int days) {
    return 'Sisa $days hari';
  }

  @override
  String get statusExpiresTomorrow => 'Basi besok';

  @override
  String statusExpiresInDays(int days) {
    return 'Basi $days hari lagi';
  }

  @override
  String statusExpiredDaysAgo(int days) {
    return 'Basi $days hari lalu';
  }

  @override
  String get statusExpiredYesterday => 'Basi kemarin';

  @override
  String get statsPeriodWeek => 'Minggu Ini';

  @override
  String get statsPeriodMonth => 'Bulan Ini';

  @override
  String get statsPeriodThreeMonths => '3 Bulan';

  @override
  String get statsPeriodAll => 'Semua';

  @override
  String get statsSavedLabel => 'Total uang makanan diselamatkan';

  @override
  String statsSavedPercent(int percent) {
    return '$percent% bahan berhasil dimasak tepat waktu';
  }

  @override
  String get statsUsedTitle => 'Dimasak';

  @override
  String get statsWastedTitle => 'Terbuang';

  @override
  String statsItemCount(int count) {
    return '$count bahan';
  }

  @override
  String get statsEstimateNote =>
      'Sebagian nilai memakai estimasi harga pasar.';

  @override
  String get statsDistributionTitle => 'Distribusi Bahan Makanan';

  @override
  String statsDistributionTotal(int count) {
    return '$count bahan';
  }

  @override
  String get statsDistributionSaved => 'Diselamatkan';

  @override
  String get statsDistributionWasted => 'Terbuang';

  @override
  String get statsTotalItemsLabel => 'total bahan';

  @override
  String get statsTrendTitle => 'Tren Pemakaian vs Pembuangan';

  @override
  String get statsTrendSaved => 'Diselamatkan';

  @override
  String get statsTrendWasted => 'Terbuang';

  @override
  String get statsTrendEmpty =>
      'Grafik akan muncul setelah ada catatan pemakaian.';

  @override
  String get statsImpactTitle => 'Dampak Nyata Kebiasaanmu';

  @override
  String get statsImpactKgLabel => 'Sampah makanan dicegah';

  @override
  String statsImpactKgValue(String kg) {
    return '$kg kg';
  }

  @override
  String get statsImpactPortionLabel => 'Setara porsi nasi rames';

  @override
  String statsImpactPortionValue(String portions) {
    return '$portions porsi';
  }

  @override
  String get statsMotivationEmpty =>
      'Tandai bahan yang terpakai atau terbuang untuk mulai melihat dampakmu.';

  @override
  String statsMotivationExcellent(int percent, String kg, String portions) {
    return 'Keren! $percent% bahanmu terselamatkan. Kamu mengurangi $kg kg sampah makanan, setara $portions porsi nasi rames.';
  }

  @override
  String statsMotivationGood(int percent, String kg, String portions) {
    return 'Bagus! $percent% bahanmu terselamatkan. Sudah $kg kg sampah makanan yang kamu cegah, setara $portions porsi nasi rames.';
  }

  @override
  String statsMotivationLowWaste(String kg, String portions) {
    return 'Sedikit demi sedikit pasti terbiasa. $kg kg sampah makanan sudah kamu cegah, setara $portions porsi nasi rames.';
  }

  @override
  String get statsMotivationLearning =>
      'Tidak apa-apa, ini catatan untuk belajar. Mulai lagi dari bahan berikutnya, ya.';

  @override
  String get statsCategoryTitle => 'Efisiensi per Kategori';

  @override
  String get statsCategorySubtitle =>
      'Kategori dengan efisiensi terbaik tampil lebih dulu.';

  @override
  String statsCategoryUsage(int used, int total) {
    return '$used dari $total bahan digunakan';
  }

  @override
  String get statsCategoryNoWaste => 'Tidak ada bahan terbuang';

  @override
  String statsCategoryEfficiency(int percent) {
    return '$percent%';
  }

  @override
  String get statsWasteReasonTitle => 'Alasan Terbuang';

  @override
  String statsWasteReasonSubtitle(String reason) {
    return 'Paling sering: $reason';
  }

  @override
  String statsWasteReasonCount(int count) {
    return '$count kali';
  }

  @override
  String get statsInsightTitle => 'Insight Belanja Minggu Depan';

  @override
  String get statsInsightAllGood =>
      'Semua kategori sudah terkelola baik. Pertahankan kebiasaan ini!';

  @override
  String get statsInsightSayur =>
      'Sayur paling sering terbuang. Coba beli lebih sedikit tapi lebih sering.';

  @override
  String get statsInsightBuah =>
      'Buah paling sering terbuang. Pilih yang matangnya pas dan simpan di kulkas.';

  @override
  String get statsInsightDaging =>
      'Daging paling sering terbuang. Bagi porsi kecil dan simpan di freezer.';

  @override
  String get statsInsightIkanSeafood =>
      'Ikan dan seafood paling sering terbuang. Masak atau bekukan di hari yang sama.';

  @override
  String get statsInsightTelurSusu =>
      'Telur dan susu paling sering terbuang. Catat tanggal bukanya di wadah.';

  @override
  String get statsInsightBumbu =>
      'Bumbu paling sering terbuang. Beli dalam jumlah kecil atau tanam yang mudah.';

  @override
  String get statsInsightBahanKering =>
      'Bahan kering paling sering terbuang. Simpan di wadah kedap udara.';

  @override
  String get statsInsightMinuman =>
      'Minuman paling sering terbuang. Beli sesuai kebutuhan mingguan.';

  @override
  String get statsInsightMakananOlahan =>
      'Makanan olahan paling sering terbuang. Cek stok sebelum membeli lagi.';

  @override
  String get statsInsightLainnya =>
      'Ada bahan yang sering terbuang. Cek stok sebelum berbelanja lagi, ya.';

  @override
  String get statsStreakTitle => 'Streak Tanpa Buang';

  @override
  String statsStreakDays(int days) {
    return '$days hari';
  }

  @override
  String statsStreakBody(String date) {
    return 'Tidak ada bahan yang terbuang sejak $date.';
  }

  @override
  String get statsStreakClean => 'Belum ada bahan yang terbuang. Pertahankan!';

  @override
  String get statsPeriodEmptyTitle => 'Belum ada catatan di periode ini';

  @override
  String get statsPeriodEmptyBody =>
      'Coba pilih periode lain atau tandai bahan terpakai.';

  @override
  String get statsShowAll => 'Lihat semua';

  @override
  String get barcodeSectionTitle => 'Isi cepat dengan barcode';

  @override
  String get barcodeSectionBody =>
      'Pindai kemasan atau ketik nomornya. Data produk diambil dari Open Food Facts saat fitur online aktif.';

  @override
  String get barcodeSectionAction => 'Pindai / ketik barcode';

  @override
  String barcodeAttached(String barcode) {
    return 'Barcode: $barcode';
  }

  @override
  String get barcodeClearAction => 'Hapus barcode';

  @override
  String get barcodeSheetTitle => 'Cari lewat barcode';

  @override
  String get barcodeSheetBody =>
      'Masukkan 8–14 digit angka atau pindai kemasan.';

  @override
  String get barcodeFieldLabel => 'Nomor barcode';

  @override
  String get barcodeFieldHint => 'Contoh: 8991002101234';

  @override
  String get barcodeLookupAction => 'Cari produk';

  @override
  String get barcodeScanAction => 'Pindai';

  @override
  String get barcodeLookingUp => 'Mencari produk…';

  @override
  String get barcodeInvalid => 'Barcode harus 8–14 digit angka.';

  @override
  String get barcodeNotFound =>
      'Produk tidak ditemukan. Kamu tetap bisa mengisi nama sendiri.';

  @override
  String get barcodeOffline =>
      'Sedang offline. Coba lagi saat ada internet atau isi nama manual.';

  @override
  String get barcodeDisabled =>
      'Fitur online dimatikan. Aktifkan di Pengaturan atau isi nama manual.';

  @override
  String get barcodeError => 'Gagal mencari produk. Coba lagi nanti.';

  @override
  String get barcodeUseAction => 'Pakai data ini';

  @override
  String get barcodeCacheBadge => 'Dari cache';

  @override
  String barcodeBrand(String brand) {
    return 'Merek: $brand';
  }

  @override
  String barcodeQuantity(String quantity) {
    return 'Isi: $quantity';
  }

  @override
  String get barcodeManualHint =>
      'Tidak menemukan produknya? Isi nama, kategori, dan tanggal kedaluwarsa secara manual.';

  @override
  String get barcodeManualTitle => 'Ketik barcode';

  @override
  String get barcodeScanTitle => 'Pindai Barcode';

  @override
  String get barcodeScanHint => 'Arahkan kamera ke barcode kemasan.';

  @override
  String get barcodeScanTorch => 'Senter';

  @override
  String get barcodeScanManual => 'Ketik manual';

  @override
  String get barcodeScanError =>
      'Kamera tidak bisa dibuka. Ketik barcode secara manual.';

  @override
  String get onlineSectionTitle => 'Fitur Online';

  @override
  String get onlineBarcodeLabel => 'Cari produk lewat barcode';

  @override
  String get onlineBarcodeBody =>
      'Mengirim nomor barcode ke Open Food Facts saat kamu memintanya.';

  @override
  String get onlineRecipeLabel => 'Cari resep online';

  @override
  String get onlineRecipeBody =>
      'Mengirim kata kunci ke TheMealDB saat kamu mencari resep.';

  @override
  String get onlineClearCache => 'Hapus cache online';

  @override
  String get onlineClearCacheBody =>
      'Hapus data produk dan resep yang tersimpan dari internet.';

  @override
  String get onlineCacheCleared => 'Cache online dihapus.';

  @override
  String get onlineOpenSettings => 'Buka Pengaturan';

  @override
  String get onlineRecipesTitle => 'Resep Online';

  @override
  String get onlineRecipesSubtitle =>
      'Cari inspirasi dari TheMealDB. Hasil disimpan agar bisa dibuka lagi tanpa internet.';

  @override
  String get onlineRecipesSearchLabel => 'Kata kunci';

  @override
  String get onlineRecipesSearchHint => 'Cari resep, misalnya chicken';

  @override
  String get onlineRecipesSearchAction => 'Cari';

  @override
  String get onlineRecipesIdleTitle => 'Cari resep dari internet';

  @override
  String get onlineRecipesIdleBody =>
      'Ketik kata kunci lalu tekan Cari. Resep yang dibuka akan di-cache untuk dipakai offline.';

  @override
  String get onlineRecipesEmptyTitle => 'Resep tidak ditemukan';

  @override
  String get onlineRecipesEmptyBody =>
      'Coba kata kunci lain dalam bahasa Inggris.';

  @override
  String get onlineRecipesOfflineTitle => 'Tidak ada koneksi';

  @override
  String get onlineRecipesOfflineBody =>
      'Resep online butuh internet. Resep lokal tetap bisa dipakai.';

  @override
  String get onlineRecipesDisabledTitle => 'Fitur online dimatikan';

  @override
  String get onlineRecipesDisabledBody =>
      'Aktifkan pencarian resep online di Pengaturan.';

  @override
  String get onlineRecipesErrorTitle => 'Gagal memuat resep';

  @override
  String get onlineRecipesErrorBody => 'Periksa koneksi lalu coba lagi.';

  @override
  String onlineRecipeIngredientCount(int count) {
    return '$count bahan';
  }

  @override
  String get onlineRecipeOpenAction => 'Lihat resep';

  @override
  String get onlineRecipeDetailTitle => 'Detail Resep Online';

  @override
  String get onlineRecipeIngredients => 'Bahan';

  @override
  String get onlineRecipeSteps => 'Cara membuat';

  @override
  String get onlineRecipeNoSteps => 'Langkah memasak belum tersedia.';

  @override
  String get onlineRecipeNotFoundTitle => 'Resep tidak ditemukan';

  @override
  String get onlineRecipeNotFoundBody =>
      'Resep mungkin sudah dihapus dari TheMealDB.';

  @override
  String get onlineRecipeEntryTitle => 'Cari resep online';

  @override
  String get onlineRecipeEntryBody =>
      'Butuh inspirasi lain? Cari resep dari TheMealDB.';

  @override
  String get onlineRecipeEntryDisabled =>
      'Fitur online dimatikan. Aktifkan untuk mencari resep dari internet.';

  @override
  String get onboardingSlide1Title => 'Catat stok dapurmu';

  @override
  String get onboardingSlide1Body =>
      'Tambah bahan dengan cepat, lengkap dengan tanggal basi dan lokasi simpan.';

  @override
  String get onboardingSlide2Title => 'Pengingat sebelum basi';

  @override
  String get onboardingSlide2Body =>
      'Segar mengingatkanmu beberapa hari sebelum bahan mendekati tanggal basi.';

  @override
  String get onboardingSlide3Title => 'Masak sebelum terbuang';

  @override
  String get onboardingSlide3Body =>
      'Dapatkan saran resep dari bahan yang paling perlu diselamatkan.';

  @override
  String get onboardingNameTitle => 'Siapa nama panggilanmu?';

  @override
  String get onboardingNameBody =>
      'Segar akan menyapamu dengan nama ini. Bisa diubah kapan saja di Pengaturan.';

  @override
  String get onboardingNameLabel => 'Nama panggilan';

  @override
  String get onboardingNameHint => 'Contoh: Dina';

  @override
  String get onboardingNext => 'Lanjut';

  @override
  String onboardingPageLabel(Object current, Object total) {
    return 'Halaman $current dari $total';
  }

  @override
  String get backupSubtitle =>
      'Simpan data pantry ke file, lalu pulihkan kapan saja.';

  @override
  String backupLastAt(Object date) {
    return 'Terakhir dicadangkan: $date';
  }

  @override
  String get backupNever => 'Belum pernah dicadangkan.';

  @override
  String get backupExportTitle => 'Buat cadangan';

  @override
  String get backupExportBody =>
      'File berisi bahan, riwayat pemakaian, dan daftar belanja. Simpan di tempat aman.';

  @override
  String get backupExportAction => 'Bagikan file cadangan';

  @override
  String get backupExportSuccess => 'Cadangan berhasil dibuat.';

  @override
  String get backupExportFailed => 'Gagal membuat cadangan. Coba lagi.';

  @override
  String get backupRestoreTitle => 'Pulihkan cadangan';

  @override
  String get backupRestoreBody =>
      'Pilih file cadangan Segar. Data saat ini akan diganti dengan isi file.';

  @override
  String get backupRestoreAction => 'Pilih file cadangan';

  @override
  String get backupRestoreConfirmTitle => 'Pulihkan data dari file?';

  @override
  String backupRestoreConfirmBody(Object items, Object logs, Object shopping) {
    return 'File berisi $items bahan, $logs riwayat, dan $shopping daftar belanja. Data saat ini akan diganti.';
  }

  @override
  String get backupRestoreSuccess => 'Cadangan berhasil dipulihkan.';

  @override
  String get backupRestoreInvalid =>
      'File cadangan tidak valid atau tidak didukung.';

  @override
  String get backupRestoreFailed => 'Gagal memulihkan cadangan. Coba lagi.';

  @override
  String get backupRestoreCancelled => 'Pemulihan dibatalkan.';

  @override
  String get backupFileSubject => 'Cadangan Segar';

  @override
  String get profileEditTitle => 'Ubah nama panggilan';

  @override
  String get profileEditLabel => 'Nama panggilan';

  @override
  String get profileEditHint => 'Contoh: Dina';

  @override
  String get profileEditSaved => 'Nama berhasil diperbarui.';

  @override
  String get settingsDataTitle => 'Data';

  @override
  String get settingsShoppingSubtitle => 'Catat bahan yang perlu dibeli.';

  @override
  String get settingsResetTitle => 'Hapus semua data';

  @override
  String get settingsResetBody =>
      'Hapus bahan, riwayat, dan daftar belanja dari perangkat ini.';

  @override
  String get settingsResetConfirmTitle => 'Hapus semua data?';

  @override
  String get settingsResetConfirmBody =>
      'Semua bahan, riwayat pemakaian, dan daftar belanja akan dihapus permanen. Pengaturan tetap disimpan.';

  @override
  String get settingsResetAction => 'Hapus data';

  @override
  String get settingsResetSuccess => 'Semua data berhasil dihapus.';

  @override
  String get settingsResetFailed => 'Gagal menghapus data. Coba lagi.';

  @override
  String get shoppingListEmptyTitle => 'Daftar belanja masih kosong';

  @override
  String get shoppingListEmptyBody =>
      'Tambahkan bahan manual atau dari resep yang belum lengkap.';

  @override
  String get shoppingListAddTitle => 'Tambah bahan belanja';

  @override
  String get shoppingListAddAction => 'Tambah';

  @override
  String get shoppingListNameLabel => 'Nama bahan';

  @override
  String get shoppingListNameHint => 'Contoh: Bayam';

  @override
  String get shoppingListNameRequired => 'Nama bahan wajib diisi.';

  @override
  String get shoppingListQuantityLabel => 'Jumlah';

  @override
  String get shoppingListQuantityInvalid => 'Jumlah harus lebih dari 0.';

  @override
  String get shoppingListUnitLabel => 'Satuan';

  @override
  String get shoppingListAddSuccess => 'Bahan ditambahkan ke daftar belanja.';

  @override
  String shoppingListCheckedCount(Object checked, Object total) {
    return '$checked dari $total sudah dibeli';
  }

  @override
  String get shoppingListClearChecked => 'Hapus yang sudah dibeli';

  @override
  String get shoppingListClearCheckedSuccess =>
      'Item yang sudah dibeli dihapus.';

  @override
  String get shoppingListClearAll => 'Kosongkan daftar';

  @override
  String get shoppingListClearAllConfirmTitle => 'Kosongkan daftar belanja?';

  @override
  String get shoppingListClearAllConfirmBody =>
      'Semua item di daftar belanja akan dihapus.';

  @override
  String get shoppingListDeleteSuccess => 'Item dihapus dari daftar belanja.';

  @override
  String get shoppingListEditTitle => 'Ubah item belanja';

  @override
  String get shoppingListSourceManual => 'Manual';

  @override
  String get shoppingListSourceHabis => 'Stok habis';

  @override
  String get shoppingListSourceResep => 'Dari resep';

  @override
  String get shoppingListAddFromRecipe =>
      'Tambahkan bahan kurang ke daftar belanja';

  @override
  String shoppingListAddedFromRecipe(Object count) {
    return '$count bahan ditambahkan ke daftar belanja.';
  }

  @override
  String get profileEditRequired => 'Nama panggilan wajib diisi.';

  @override
  String get shoppingListNoNewItems => 'Bahan sudah ada di daftar belanja.';
}
