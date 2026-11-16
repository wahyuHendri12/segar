import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('id')];

  /// Nama aplikasi
  ///
  /// In id, this message translates to:
  /// **'Segar'**
  String get appName;

  /// Tagline singkat aplikasi
  ///
  /// In id, this message translates to:
  /// **'Pantry rapi, makanan terselamatkan.'**
  String get appTagline;

  /// Janji privasi onboarding
  ///
  /// In id, this message translates to:
  /// **'Datamu tersimpan di HP ini saja.'**
  String get onboardingPrivacy;

  /// Tombol utama onboarding
  ///
  /// In id, this message translates to:
  /// **'Mulai Sekarang'**
  String get onboardingStart;

  /// Tombol lewati onboarding
  ///
  /// In id, this message translates to:
  /// **'Lewati'**
  String get onboardingSkip;

  /// Label navigasi Beranda
  ///
  /// In id, this message translates to:
  /// **'Beranda'**
  String get navHome;

  /// Label navigasi Resep
  ///
  /// In id, this message translates to:
  /// **'Resep'**
  String get navRecipes;

  /// Label aksesibilitas tombol tambah
  ///
  /// In id, this message translates to:
  /// **'Tambah'**
  String get navAdd;

  /// Label navigasi Statistik
  ///
  /// In id, this message translates to:
  /// **'Statistik'**
  String get navStats;

  /// Label navigasi Profil
  ///
  /// In id, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// Sapaan di Beranda
  ///
  /// In id, this message translates to:
  /// **'Halo, {name}! 👋'**
  String homeGreeting(String name);

  /// Subjudul Beranda
  ///
  /// In id, this message translates to:
  /// **'Ini ringkasan pantry segarmu hari ini.'**
  String get homeSubtitle;

  /// Judul bagian status dapur
  ///
  /// In id, this message translates to:
  /// **'Status dapur'**
  String get homeSectionStatus;

  /// Status bahan hampir basi
  ///
  /// In id, this message translates to:
  /// **'Segera pakai'**
  String get statusSoon;

  /// Status bahan aman
  ///
  /// In id, this message translates to:
  /// **'Aman'**
  String get statusSafe;

  /// Status bahan sudah basi
  ///
  /// In id, this message translates to:
  /// **'Sudah basi'**
  String get statusExpired;

  /// Judul state kosong Beranda
  ///
  /// In id, this message translates to:
  /// **'Pantry masih kosong'**
  String get emptyPantryTitle;

  /// Penjelasan state kosong Beranda
  ///
  /// In id, this message translates to:
  /// **'Tambahkan bahan pertama supaya Segar bisa mengingatkanmu sebelum terlambat.'**
  String get emptyPantryBody;

  /// Tombol state kosong Beranda
  ///
  /// In id, this message translates to:
  /// **'Tambah bahan pertama'**
  String get addFirstItem;

  /// Judul layar Resep
  ///
  /// In id, this message translates to:
  /// **'Olah Sebelum Basi'**
  String get recipesTitle;

  /// Subjudul layar Resep
  ///
  /// In id, this message translates to:
  /// **'Saran masakan dari bahan yang paling perlu diselamatkan.'**
  String get recipesSubtitle;

  /// Judul state kosong Resep
  ///
  /// In id, this message translates to:
  /// **'Belum ada saran resep'**
  String get recipesEmptyTitle;

  /// Penjelasan state kosong Resep
  ///
  /// In id, this message translates to:
  /// **'Tambahkan bahan ke pantry dulu, lalu Segar akan mencarikan resep yang cocok.'**
  String get recipesEmptyBody;

  /// Label kartu smart match resep
  ///
  /// In id, this message translates to:
  /// **'SMART MATCH KULKAS'**
  String get recipesSmartMatchLabel;

  /// Label sinkronisasi otomatis smart match
  ///
  /// In id, this message translates to:
  /// **'Auto-Sync'**
  String get recipesSmartMatchAuto;

  /// Ringkasan bahan hampir basi yang bisa diselamatkan resep
  ///
  /// In id, this message translates to:
  /// **'{rescued} dari {total} bahan hampir basi bisa diselamatkan'**
  String recipesSmartMatchBody(int rescued, int total);

  /// Ringkasan smart match saat tidak ada bahan mendesak
  ///
  /// In id, this message translates to:
  /// **'Belum ada bahan yang mendesak. Tetap masak dari stokmu!'**
  String get recipesSmartMatchEmpty;

  /// Chip filter semua resep
  ///
  /// In id, this message translates to:
  /// **'Semua Resep ({count})'**
  String recipesFilterAll(int count);

  /// Chip filter resep kilat
  ///
  /// In id, this message translates to:
  /// **'Kilat < 15 Menit'**
  String get recipesFilterQuick;

  /// Chip filter menu kosan
  ///
  /// In id, this message translates to:
  /// **'Menu Kosan'**
  String get recipesFilterKos;

  /// Chip filter resep kuah
  ///
  /// In id, this message translates to:
  /// **'Kuah Segar'**
  String get recipesFilterSoup;

  /// Chip filter resep tumis
  ///
  /// In id, this message translates to:
  /// **'Tumisan'**
  String get recipesFilterStirFry;

  /// Judul pencarian bahan pada layar resep
  ///
  /// In id, this message translates to:
  /// **'Punya bahan lain?'**
  String get recipesSearchTitle;

  /// Penjelasan pencarian bahan resep
  ///
  /// In id, this message translates to:
  /// **'Ketik bahan untuk mencari ide resep.'**
  String get recipesSearchBody;

  /// Hint pencarian bahan resep
  ///
  /// In id, this message translates to:
  /// **'Contoh: tahu, wortel, keju...'**
  String get recipesSearchHint;

  /// Judul state kosong hasil pencarian resep
  ///
  /// In id, this message translates to:
  /// **'Resep tidak ditemukan'**
  String get recipesSearchEmptyTitle;

  /// Penjelasan state kosong hasil pencarian resep
  ///
  /// In id, this message translates to:
  /// **'Coba kata kunci atau kategori lain.'**
  String get recipesSearchEmptyBody;

  /// Judul state kosong resep saat pantry kosong
  ///
  /// In id, this message translates to:
  /// **'Pantry masih kosong'**
  String get recipesNoPantryTitle;

  /// Penjelasan state kosong resep saat pantry kosong
  ///
  /// In id, this message translates to:
  /// **'Tambahkan bahan dulu supaya Segar bisa mencarikan resep yang pas.'**
  String get recipesNoPantryBody;

  /// Tombol menambah bahan dari layar resep
  ///
  /// In id, this message translates to:
  /// **'Tambah bahan'**
  String get recipesAddItemAction;

  /// Pesan gagal memuat daftar resep
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat saran resep.'**
  String get recipesLoadError;

  /// Ringkasan ketersediaan bahan resep
  ///
  /// In id, this message translates to:
  /// **'{owned} dari {total} bahan tersedia'**
  String recipesAvailableCount(int owned, int total);

  /// Jumlah bahan resep yang belum tersedia
  ///
  /// In id, this message translates to:
  /// **'Kurang {count} bahan'**
  String recipesMissingCount(int count);

  /// Badge resep yang semua bahan wajibnya tersedia
  ///
  /// In id, this message translates to:
  /// **'Bahan lengkap'**
  String get recipesCompleteBadge;

  /// Persentase kecocokan resep dengan isi pantry
  ///
  /// In id, this message translates to:
  /// **'{score}% cocok'**
  String recipesMatchPercent(int score);

  /// Jumlah bahan mendesak yang diselamatkan sebuah resep
  ///
  /// In id, this message translates to:
  /// **'{count} bahan segera dipakai'**
  String recipesUrgentRescue(int count);

  /// Durasi memasak resep
  ///
  /// In id, this message translates to:
  /// **'{minutes} menit'**
  String recipeCookTimeValue(int minutes);

  /// Jumlah porsi resep
  ///
  /// In id, this message translates to:
  /// **'{count} porsi'**
  String recipeServingsValue(int count);

  /// Tingkat kesulitan mudah
  ///
  /// In id, this message translates to:
  /// **'Mudah'**
  String get difficultyEasy;

  /// Tingkat kesulitan sedang
  ///
  /// In id, this message translates to:
  /// **'Sedang'**
  String get difficultyMedium;

  /// Tingkat kesulitan sulit
  ///
  /// In id, this message translates to:
  /// **'Sulit'**
  String get difficultyHard;

  /// Judul layar Statistik
  ///
  /// In id, this message translates to:
  /// **'Penghematan & Jejak Dapur'**
  String get statsTitle;

  /// Subjudul layar Statistik
  ///
  /// In id, this message translates to:
  /// **'Lihat dampak baik dari kebiasaan memasakmu.'**
  String get statsSubtitle;

  /// Judul state kosong Statistik
  ///
  /// In id, this message translates to:
  /// **'Belum ada statistik'**
  String get statsEmptyTitle;

  /// Penjelasan state kosong Statistik
  ///
  /// In id, this message translates to:
  /// **'Statistik akan muncul setelah kamu menandai bahan terpakai atau terbuang.'**
  String get statsEmptyBody;

  /// Judul layar pengaturan
  ///
  /// In id, this message translates to:
  /// **'Profil & Pengaturan'**
  String get settingsTitle;

  /// Subjudul layar pengaturan
  ///
  /// In id, this message translates to:
  /// **'Atur pengalaman Segar sesuai kebiasaanmu.'**
  String get settingsSubtitle;

  /// Nama panggilan default
  ///
  /// In id, this message translates to:
  /// **'Teman Segar'**
  String get defaultUserName;

  /// Judul pengaturan tema
  ///
  /// In id, this message translates to:
  /// **'Tampilan'**
  String get themeTitle;

  /// Opsi tema mengikuti sistem
  ///
  /// In id, this message translates to:
  /// **'Ikuti sistem'**
  String get themeSystem;

  /// Opsi tema terang
  ///
  /// In id, this message translates to:
  /// **'Terang'**
  String get themeLight;

  /// Opsi tema gelap
  ///
  /// In id, this message translates to:
  /// **'Gelap'**
  String get themeDark;

  /// Judul layar tentang
  ///
  /// In id, this message translates to:
  /// **'Tentang Segar'**
  String get aboutTitle;

  /// Judul bagian atribusi data
  ///
  /// In id, this message translates to:
  /// **'Tentang data'**
  String get aboutDataTitle;

  /// Atribusi Open Food Facts
  ///
  /// In id, this message translates to:
  /// **'Data produk dari Open Food Facts (ODbL).'**
  String get aboutAttributionOff;

  /// Atribusi TheMealDB
  ///
  /// In id, this message translates to:
  /// **'Resep tambahan dari TheMealDB.'**
  String get aboutAttributionMealDb;

  /// Versi aplikasi
  ///
  /// In id, this message translates to:
  /// **'Versi {version}'**
  String aboutVersion(String version);

  /// Judul bantuan notifikasi
  ///
  /// In id, this message translates to:
  /// **'Pengingat tidak muncul?'**
  String get notificationsHelpTitle;

  /// Judul bagian pengaturan notifikasi
  ///
  /// In id, this message translates to:
  /// **'Notifikasi'**
  String get notifSettingsTitle;

  /// Label sakelar notifikasi
  ///
  /// In id, this message translates to:
  /// **'Aktifkan pengingat'**
  String get notifEnableLabel;

  /// Penjelasan sakelar notifikasi
  ///
  /// In id, this message translates to:
  /// **'Ingatkan sebelum bahan mendekati tanggal basi.'**
  String get notifEnableBody;

  /// Label jam pengingat
  ///
  /// In id, this message translates to:
  /// **'Jam pengingat'**
  String get notifTimeLabel;

  /// Penjelasan jam pengingat
  ///
  /// In id, this message translates to:
  /// **'Pengingat dikirim sekali sehari pada jam ini.'**
  String get notifTimeBody;

  /// Label ambang pengingat
  ///
  /// In id, this message translates to:
  /// **'Ingatkan sebelum'**
  String get notifWarnLabel;

  /// Penjelasan ambang pengingat
  ///
  /// In id, this message translates to:
  /// **'Pilih berapa hari sebelum tanggal basi.'**
  String get notifWarnBody;

  /// Jumlah hari pengingat
  ///
  /// In id, this message translates to:
  /// **'{days} hari'**
  String notifWarnDays(int days);

  /// Judul jam tenang
  ///
  /// In id, this message translates to:
  /// **'Jam tenang'**
  String get notifQuietTitle;

  /// Penjelasan jam tenang
  ///
  /// In id, this message translates to:
  /// **'Tunda pengingat agar tidak mengganggu waktu istirahat.'**
  String get notifQuietBody;

  /// Label awal jam tenang
  ///
  /// In id, this message translates to:
  /// **'Mulai'**
  String get notifQuietStart;

  /// Label akhir jam tenang
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get notifQuietEnd;

  /// Entri menuju bantuan notifikasi
  ///
  /// In id, this message translates to:
  /// **'Panduan pengingat'**
  String get notifHelpEntry;

  /// Pesan izin notifikasi ditolak
  ///
  /// In id, this message translates to:
  /// **'Izin notifikasi belum diberikan. Aktifkan lewat pengaturan HP.'**
  String get notifPermissionDenied;

  /// Label aksi membuka pengaturan
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get notifOpenSettingsAction;

  /// Pesan izin notifikasi aktif
  ///
  /// In id, this message translates to:
  /// **'Notifikasi siap digunakan.'**
  String get notifPermissionGranted;

  /// Judul aksi coba notifikasi
  ///
  /// In id, this message translates to:
  /// **'Coba notifikasi'**
  String get notifTestTitle;

  /// Penjelasan aksi coba notifikasi
  ///
  /// In id, this message translates to:
  /// **'Kirim notifikasi percobaan sekarang.'**
  String get notifTestBody;

  /// Pesan notifikasi percobaan terkirim
  ///
  /// In id, this message translates to:
  /// **'Notifikasi percobaan dikirim.'**
  String get notifTestSent;

  /// Pesan notifikasi percobaan gagal
  ///
  /// In id, this message translates to:
  /// **'Gagal mengirim notifikasi percobaan. Periksa izin notifikasi.'**
  String get notifTestFailed;

  /// Judul notifikasi bahan hampir basi
  ///
  /// In id, this message translates to:
  /// **'{name} segera basi'**
  String notifTitleSoon(String name);

  /// Isi notifikasi bahan hampir basi
  ///
  /// In id, this message translates to:
  /// **'Tinggal {days} hari. Yuk pakai sebelum terbuang.'**
  String notifBodySoon(int days);

  /// Judul notifikasi bahan basi hari ini
  ///
  /// In id, this message translates to:
  /// **'{name} basi hari ini'**
  String notifTitleToday(String name);

  /// Isi notifikasi bahan basi hari ini
  ///
  /// In id, this message translates to:
  /// **'Segera pakai atau olah bahan ini hari ini.'**
  String get notifBodyToday;

  /// Judul notifikasi percobaan
  ///
  /// In id, this message translates to:
  /// **'Segar siap mengingatkanmu'**
  String get notifTestNotificationTitle;

  /// Isi notifikasi percobaan
  ///
  /// In id, this message translates to:
  /// **'Ini contoh pengingat kesegaran bahan.'**
  String get notifTestNotificationBody;

  /// Pengantar bantuan notifikasi
  ///
  /// In id, this message translates to:
  /// **'Pengingat Segar bekerja tanpa internet. Jika notifikasi tidak muncul, biasanya ada izin atau penghemat baterai yang menghalangi.'**
  String get notificationsHelpIntro;

  /// Judul langkah bantuan notifikasi
  ///
  /// In id, this message translates to:
  /// **'Langkah cepat'**
  String get notificationsHelpStepsTitle;

  /// Langkah izin notifikasi
  ///
  /// In id, this message translates to:
  /// **'Pastikan izin notifikasi untuk Segar sudah diizinkan di pengaturan HP.'**
  String get notificationsHelpStepPermission;

  /// Langkah penghemat baterai
  ///
  /// In id, this message translates to:
  /// **'Matikan penghemat baterai atau atur Segar sebagai aplikasi yang tidak dibatasi.'**
  String get notificationsHelpStepBattery;

  /// Langkah autostart
  ///
  /// In id, this message translates to:
  /// **'Izinkan autostart agar pengingat tetap terjadwal setelah HP dimulai ulang.'**
  String get notificationsHelpStepAutostart;

  /// Judul panduan merek HP
  ///
  /// In id, this message translates to:
  /// **'Panduan merek HP'**
  String get notificationsHelpBrandsTitle;

  /// Panduan singkat merek HP
  ///
  /// In id, this message translates to:
  /// **'Xiaomi: Autostart + tanpa batasan baterai. Oppo/Realme: Izinkan auto-launch. Vivo: Autostart + background power. Samsung: keluarkan Segar dari daftar aplikasi tidur.'**
  String get notificationsHelpBrandsBody;

  /// Tombol buka pengaturan aplikasi
  ///
  /// In id, this message translates to:
  /// **'Buka pengaturan aplikasi'**
  String get notificationsHelpOpenSettings;

  /// Tombol kirim notifikasi percobaan
  ///
  /// In id, this message translates to:
  /// **'Kirim notifikasi percobaan'**
  String get notificationsHelpTest;

  /// Pesan notifikasi percobaan terkirim dari bantuan
  ///
  /// In id, this message translates to:
  /// **'Notifikasi percobaan dikirim. Cek laci notifikasi.'**
  String get notificationsHelpTestSent;

  /// Pesan notifikasi percobaan gagal dari bantuan
  ///
  /// In id, this message translates to:
  /// **'Notifikasi percobaan gagal dikirim.'**
  String get notificationsHelpTestFailed;

  /// Judul status izin notifikasi
  ///
  /// In id, this message translates to:
  /// **'Status izin'**
  String get notificationsHelpPermissionTitle;

  /// Status izin notifikasi aktif
  ///
  /// In id, this message translates to:
  /// **'Izin notifikasi aktif.'**
  String get notificationsHelpPermissionOn;

  /// Status izin notifikasi belum aktif
  ///
  /// In id, this message translates to:
  /// **'Izin notifikasi belum aktif.'**
  String get notificationsHelpPermissionOff;

  /// Tombol minta izin notifikasi
  ///
  /// In id, this message translates to:
  /// **'Minta izin notifikasi'**
  String get notificationsHelpEnablePermission;

  /// Judul fitur cadangan
  ///
  /// In id, this message translates to:
  /// **'Cadangan & pemulihan'**
  String get backupTitle;

  /// Judul layar tambah bahan
  ///
  /// In id, this message translates to:
  /// **'Tambah Bahan'**
  String get addItemTitle;

  /// Judul layar detail bahan
  ///
  /// In id, this message translates to:
  /// **'Detail Bahan'**
  String get itemDetailTitle;

  /// Judul layar detail resep
  ///
  /// In id, this message translates to:
  /// **'Detail Resep'**
  String get recipeDetailTitle;

  /// Judul pengatur porsi resep
  ///
  /// In id, this message translates to:
  /// **'Atur porsi'**
  String get recipeDetailServingsTitle;

  /// Penjelasan pengatur porsi resep
  ///
  /// In id, this message translates to:
  /// **'Jumlah bahan menyesuaikan otomatis.'**
  String get recipeDetailServingsHint;

  /// Tooltip tombol kurangi porsi
  ///
  /// In id, this message translates to:
  /// **'Kurangi porsi'**
  String get recipeDetailDecreaseServings;

  /// Tooltip tombol tambah porsi
  ///
  /// In id, this message translates to:
  /// **'Tambah porsi'**
  String get recipeDetailIncreaseServings;

  /// Judul bagian bahan resep
  ///
  /// In id, this message translates to:
  /// **'Bahan-bahan'**
  String get recipeDetailIngredientsTitle;

  /// Ringkasan ketersediaan bahan pada detail resep
  ///
  /// In id, this message translates to:
  /// **'{owned} dari {total} bahan tersedia'**
  String recipeDetailIngredientsCount(int owned, int total);

  /// Judul bagian langkah memasak
  ///
  /// In id, this message translates to:
  /// **'Cara membuat'**
  String get recipeDetailStepsTitle;

  /// Label nomor langkah memasak
  ///
  /// In id, this message translates to:
  /// **'Langkah {index}'**
  String recipeDetailStepLabel(int index);

  /// Status bahan resep yang tersedia di pantry
  ///
  /// In id, this message translates to:
  /// **'Tersedia'**
  String get recipeDetailAvailable;

  /// Status bahan resep yang belum tersedia
  ///
  /// In id, this message translates to:
  /// **'Belum ada'**
  String get recipeDetailMissing;

  /// Penanda bahan opsional resep
  ///
  /// In id, this message translates to:
  /// **'Opsional'**
  String get recipeDetailOptional;

  /// Penanda bahan dasar yang biasanya sudah ada
  ///
  /// In id, this message translates to:
  /// **'Bahan dasar'**
  String get recipeDetailStaple;

  /// Penanda bahan resep yang hampir basi
  ///
  /// In id, this message translates to:
  /// **'Segera dipakai'**
  String get recipeDetailUrgent;

  /// Judul catatan bahan resep yang belum lengkap
  ///
  /// In id, this message translates to:
  /// **'Bahan belum lengkap'**
  String get recipeDetailMissingTitle;

  /// Penjelasan bahan resep yang belum tersedia
  ///
  /// In id, this message translates to:
  /// **'Kamu masih punya {count} bahan lain yang bisa dipakai.'**
  String recipeDetailMissingBody(int count);

  /// Tombol masak resep
  ///
  /// In id, this message translates to:
  /// **'Masak sekarang'**
  String get recipeDetailCook;

  /// Tombol masak saat sebagian bahan belum tersedia
  ///
  /// In id, this message translates to:
  /// **'Masak dengan bahan tersedia'**
  String get recipeDetailCookPartial;

  /// Judul sheet konfirmasi masak
  ///
  /// In id, this message translates to:
  /// **'Masak resep ini?'**
  String get recipeDetailCookSheetTitle;

  /// Penjelasan sheet konfirmasi masak
  ///
  /// In id, this message translates to:
  /// **'Bahan yang dicentang akan dikurangi dari pantry.'**
  String get recipeDetailCookSheetBody;

  /// Pesan saat tidak ada bahan resep yang cocok dengan pantry
  ///
  /// In id, this message translates to:
  /// **'Belum ada bahan yang bisa dikurangi.'**
  String get recipeDetailCookSheetEmpty;

  /// Tombol konfirmasi masak
  ///
  /// In id, this message translates to:
  /// **'Masak & kurangi stok'**
  String get recipeDetailCookConfirm;

  /// Pesan sukses memasak resep
  ///
  /// In id, this message translates to:
  /// **'Resep dimasak. Stok pantry diperbarui.'**
  String get recipeDetailCookSuccess;

  /// Pesan saat pengguna tidak memilih bahan untuk dimasak
  ///
  /// In id, this message translates to:
  /// **'Tidak ada bahan yang dipilih.'**
  String get recipeDetailCookNothing;

  /// Tombol memilih semua bahan pada sheet masak
  ///
  /// In id, this message translates to:
  /// **'Pilih semua'**
  String get recipeDetailSelectAll;

  /// Jumlah bahan terpilih pada sheet masak
  ///
  /// In id, this message translates to:
  /// **'{count} bahan dipilih'**
  String recipeDetailSelectedCount(int count);

  /// Judul resep tidak ditemukan
  ///
  /// In id, this message translates to:
  /// **'Resep tidak ditemukan'**
  String get recipeDetailNotFoundTitle;

  /// Penjelasan resep tidak ditemukan
  ///
  /// In id, this message translates to:
  /// **'Resep ini mungkin sudah tidak tersedia.'**
  String get recipeDetailNotFoundBody;

  /// Pesan gagal memuat detail resep
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat resep.'**
  String get recipeDetailLoadError;

  /// Label estimasi biaya resep
  ///
  /// In id, this message translates to:
  /// **'Estimasi biaya'**
  String get recipeDetailCostLabel;

  /// Label waktu masak resep
  ///
  /// In id, this message translates to:
  /// **'Waktu masak'**
  String get recipeDetailTimeLabel;

  /// Label tingkat kesulitan resep
  ///
  /// In id, this message translates to:
  /// **'Tingkat kesulitan'**
  String get recipeDetailDifficultyLabel;

  /// Persentase kecocokan resep pada detail
  ///
  /// In id, this message translates to:
  /// **'{score}% cocok'**
  String recipeDetailMatchLabel(int score);

  /// Judul layar daftar belanja
  ///
  /// In id, this message translates to:
  /// **'Daftar Belanja'**
  String get shoppingListTitle;

  /// Label tombol kembali
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get genericBack;

  /// Label tombol tutup
  ///
  /// In id, this message translates to:
  /// **'Tutup'**
  String get genericClose;

  /// Judul bagian privasi
  ///
  /// In id, this message translates to:
  /// **'Privasi'**
  String get dataPrivacyTitle;

  /// Penjelasan privasi
  ///
  /// In id, this message translates to:
  /// **'Data pantry disimpan lokal di perangkat ini. Hanya nomor barcode atau kata kunci pencarian yang dikirim saat fitur online diaktifkan.'**
  String get dataPrivacyBody;

  /// Tombol batal
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get genericCancel;

  /// Tombol simpan
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get genericSave;

  /// Tombol hapus
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get genericDelete;

  /// Tombol ubah
  ///
  /// In id, this message translates to:
  /// **'Ubah'**
  String get genericEdit;

  /// Tombol coba lagi
  ///
  /// In id, this message translates to:
  /// **'Coba lagi'**
  String get genericRetry;

  /// Label semua
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get genericAll;

  /// Hint pencarian bahan di Beranda
  ///
  /// In id, this message translates to:
  /// **'Cari bahan...'**
  String get homeSearchHint;

  /// Opsi urutkan berdasarkan tanggal basi
  ///
  /// In id, this message translates to:
  /// **'Paling cepat basi'**
  String get homeSortExpiry;

  /// Opsi urutkan berdasarkan nama
  ///
  /// In id, this message translates to:
  /// **'Nama A-Z'**
  String get homeSortName;

  /// Opsi urutkan berdasarkan waktu ditambahkan
  ///
  /// In id, this message translates to:
  /// **'Terbaru'**
  String get homeSortNewest;

  /// Tooltip tombol urutkan
  ///
  /// In id, this message translates to:
  /// **'Urutkan bahan'**
  String get homeSortTooltip;

  /// Judul grup bahan yang hampir basi
  ///
  /// In id, this message translates to:
  /// **'Segera dipakai'**
  String get homeUrgentTitle;

  /// Judul grup bahan yang masih aman
  ///
  /// In id, this message translates to:
  /// **'Kondisi aman'**
  String get homeSafeTitle;

  /// Judul grup bahan yang sudah basi
  ///
  /// In id, this message translates to:
  /// **'Sudah basi'**
  String get homeExpiredTitle;

  /// Judul daftar bahan di Beranda
  ///
  /// In id, this message translates to:
  /// **'Bahan di pantry'**
  String get homeItemsTitle;

  /// Jumlah bahan pada grup
  ///
  /// In id, this message translates to:
  /// **'{count} bahan'**
  String homeItemsCount(int count);

  /// Judul state kosong hasil pencarian
  ///
  /// In id, this message translates to:
  /// **'Bahan tidak ditemukan'**
  String get homeNoResultsTitle;

  /// Penjelasan state kosong hasil pencarian
  ///
  /// In id, this message translates to:
  /// **'Coba kata kunci lain atau ubah filter lokasi.'**
  String get homeNoResultsBody;

  /// Tombol menghapus filter Beranda
  ///
  /// In id, this message translates to:
  /// **'Hapus filter'**
  String get homeClearFilters;

  /// Judul banner pengingat Beranda
  ///
  /// In id, this message translates to:
  /// **'PENGINGAT HARI INI'**
  String get homeReminderTitle;

  /// Isi banner pengingat Beranda
  ///
  /// In id, this message translates to:
  /// **'{count} bahan perlu segera dipakai.'**
  String homeReminderBody(int count);

  /// Pesan gagal memuat pantry
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat pantry.'**
  String get homeLoadError;

  /// Keterangan status diperbarui otomatis
  ///
  /// In id, this message translates to:
  /// **'Diperbarui otomatis'**
  String get homeStatusUpdate;

  /// Judul layar ubah bahan
  ///
  /// In id, this message translates to:
  /// **'Ubah Bahan'**
  String get formEditTitle;

  /// Subjudul form bahan
  ///
  /// In id, this message translates to:
  /// **'Catat bahan supaya Segar bisa mengingatkanmu.'**
  String get formSubtitle;

  /// Judul pilihan bahan populer
  ///
  /// In id, this message translates to:
  /// **'Bahan populer'**
  String get formPopularTitle;

  /// Tombol membuka pencarian katalog
  ///
  /// In id, this message translates to:
  /// **'Cari di katalog'**
  String get formSearchCatalog;

  /// Label nama bahan
  ///
  /// In id, this message translates to:
  /// **'Nama bahan'**
  String get formNameLabel;

  /// Hint nama bahan
  ///
  /// In id, this message translates to:
  /// **'Contoh: Bayam hijau'**
  String get formNameHint;

  /// Validasi nama bahan
  ///
  /// In id, this message translates to:
  /// **'Nama bahan wajib diisi.'**
  String get formNameRequired;

  /// Label jumlah bahan
  ///
  /// In id, this message translates to:
  /// **'Jumlah'**
  String get formQuantityLabel;

  /// Validasi jumlah bahan
  ///
  /// In id, this message translates to:
  /// **'Jumlah harus lebih dari 0.'**
  String get formQuantityInvalid;

  /// Label satuan bahan
  ///
  /// In id, this message translates to:
  /// **'Satuan'**
  String get formUnitLabel;

  /// Label kategori bahan
  ///
  /// In id, this message translates to:
  /// **'Kategori'**
  String get formCategoryLabel;

  /// Label tanggal beli
  ///
  /// In id, this message translates to:
  /// **'Tanggal beli'**
  String get formPurchaseDateLabel;

  /// Label tanggal basi
  ///
  /// In id, this message translates to:
  /// **'Tanggal basi'**
  String get formExpiryDateLabel;

  /// Label tanggal basi hasil estimasi
  ///
  /// In id, this message translates to:
  /// **'Estimasi otomatis'**
  String get formExpiryEstimate;

  /// Label tanggal basi diatur manual
  ///
  /// In id, this message translates to:
  /// **'Diatur manual'**
  String get formExpiryManual;

  /// Label harga bahan
  ///
  /// In id, this message translates to:
  /// **'Harga (opsional)'**
  String get formPriceLabel;

  /// Hint harga bahan
  ///
  /// In id, this message translates to:
  /// **'Contoh: 5000'**
  String get formPriceHint;

  /// Validasi harga bahan
  ///
  /// In id, this message translates to:
  /// **'Harga harus berupa angka.'**
  String get formPriceInvalid;

  /// Label catatan bahan
  ///
  /// In id, this message translates to:
  /// **'Catatan (opsional)'**
  String get formNoteLabel;

  /// Hint catatan bahan
  ///
  /// In id, this message translates to:
  /// **'Contoh: beli di pasar pagi'**
  String get formNoteHint;

  /// Label pengingat notifikasi
  ///
  /// In id, this message translates to:
  /// **'Ingatkan sebelum basi'**
  String get formNotifyLabel;

  /// Penjelasan pengingat notifikasi
  ///
  /// In id, this message translates to:
  /// **'Pengingat mengikuti pengaturan notifikasi.'**
  String get formNotifyBody;

  /// Tombol simpan bahan baru
  ///
  /// In id, this message translates to:
  /// **'Simpan bahan'**
  String get formSave;

  /// Tombol simpan perubahan bahan
  ///
  /// In id, this message translates to:
  /// **'Simpan perubahan'**
  String get formUpdate;

  /// Pesan bahan berhasil disimpan
  ///
  /// In id, this message translates to:
  /// **'Bahan berhasil disimpan.'**
  String get formSaved;

  /// Pesan perubahan berhasil disimpan
  ///
  /// In id, this message translates to:
  /// **'Perubahan berhasil disimpan.'**
  String get formUpdated;

  /// Pesan gagal menyimpan bahan
  ///
  /// In id, this message translates to:
  /// **'Gagal menyimpan bahan. Coba lagi.'**
  String get formSaveError;

  /// Validasi tanggal basi
  ///
  /// In id, this message translates to:
  /// **'Tanggal basi tidak boleh sebelum tanggal beli.'**
  String get formExpiryBeforePurchase;

  /// Info umur simpan katalog
  ///
  /// In id, this message translates to:
  /// **'Umur simpan di {location}: {days} hari'**
  String formShelfLifeInfo(String location, int days);

  /// Info umur simpan tidak tersedia
  ///
  /// In id, this message translates to:
  /// **'Belum ada estimasi umur simpan untuk lokasi ini.'**
  String get formShelfLifeUnknown;

  /// Judul bagian detail form
  ///
  /// In id, this message translates to:
  /// **'Detail bahan'**
  String get formSectionDetails;

  /// Judul bagian penyimpanan form
  ///
  /// In id, this message translates to:
  /// **'Penyimpanan'**
  String get formSectionStorage;

  /// Judul bagian tambahan form
  ///
  /// In id, this message translates to:
  /// **'Tambahan'**
  String get formSectionOptional;

  /// Label bahan manual di luar katalog
  ///
  /// In id, this message translates to:
  /// **'Bahan manual'**
  String get formCustomIngredient;

  /// Hint pencarian katalog
  ///
  /// In id, this message translates to:
  /// **'Cari bahan...'**
  String get formCatalogSearchHint;

  /// Pesan katalog kosong
  ///
  /// In id, this message translates to:
  /// **'Bahan tidak ditemukan. Kamu tetap bisa menambahkannya manual.'**
  String get formCatalogEmpty;

  /// Judul status kesegaran
  ///
  /// In id, this message translates to:
  /// **'Status kesegaran'**
  String get detailFreshness;

  /// Sisa hari sebelum basi
  ///
  /// In id, this message translates to:
  /// **'Sisa {days} hari'**
  String detailDaysLeft(int days);

  /// Label basi hari ini
  ///
  /// In id, this message translates to:
  /// **'Basi hari ini'**
  String get detailExpiresToday;

  /// Label basi besok
  ///
  /// In id, this message translates to:
  /// **'Basi besok'**
  String get detailExpiresTomorrow;

  /// Label basi beberapa hari lagi
  ///
  /// In id, this message translates to:
  /// **'Basi {days} hari lagi'**
  String detailExpiresInDays(int days);

  /// Label sudah basi beberapa hari
  ///
  /// In id, this message translates to:
  /// **'Basi {days} hari lalu'**
  String detailExpiredDaysAgo(int days);

  /// Label sudah basi kemarin
  ///
  /// In id, this message translates to:
  /// **'Basi kemarin'**
  String get detailExpiredYesterday;

  /// Label jumlah di detail
  ///
  /// In id, this message translates to:
  /// **'Jumlah'**
  String get detailQuantity;

  /// Label kategori di detail
  ///
  /// In id, this message translates to:
  /// **'Kategori'**
  String get detailCategory;

  /// Label lokasi di detail
  ///
  /// In id, this message translates to:
  /// **'Lokasi simpan'**
  String get detailStorage;

  /// Label tanggal beli di detail
  ///
  /// In id, this message translates to:
  /// **'Dibeli'**
  String get detailPurchasedOn;

  /// Label tanggal basi di detail
  ///
  /// In id, this message translates to:
  /// **'Tanggal basi'**
  String get detailExpiresOn;

  /// Label harga di detail
  ///
  /// In id, this message translates to:
  /// **'Harga'**
  String get detailPrice;

  /// Label catatan di detail
  ///
  /// In id, this message translates to:
  /// **'Catatan'**
  String get detailNote;

  /// Judul tips penyimpanan
  ///
  /// In id, this message translates to:
  /// **'Tips penyimpanan'**
  String get detailTipsTitle;

  /// Pesan tips kosong
  ///
  /// In id, this message translates to:
  /// **'Belum ada tips untuk bahan ini.'**
  String get detailNoTips;

  /// Judul aksi cepat detail
  ///
  /// In id, this message translates to:
  /// **'Aksi cepat'**
  String get detailActionsTitle;

  /// Judul informasi bahan
  ///
  /// In id, this message translates to:
  /// **'Informasi bahan'**
  String get detailInfoTitle;

  /// Label umur simpan
  ///
  /// In id, this message translates to:
  /// **'Umur simpan'**
  String get detailShelfLife;

  /// Label pengingat aktif
  ///
  /// In id, this message translates to:
  /// **'Pengingat aktif'**
  String get detailNotifOn;

  /// Label pengingat mati
  ///
  /// In id, this message translates to:
  /// **'Pengingat mati'**
  String get detailNotifOff;

  /// Penjelasan perhitungan nilai
  ///
  /// In id, this message translates to:
  /// **'Nilai dihitung dari harga bahan atau estimasi katalog.'**
  String get detailValueHint;

  /// Aksi tandai terpakai
  ///
  /// In id, this message translates to:
  /// **'Tandai terpakai'**
  String get detailMarkUsed;

  /// Aksi tandai terbuang
  ///
  /// In id, this message translates to:
  /// **'Tandai terbuang'**
  String get detailMarkWasted;

  /// Aksi pakai sebagian
  ///
  /// In id, this message translates to:
  /// **'Pakai sebagian'**
  String get detailPartial;

  /// Aksi ubah bahan
  ///
  /// In id, this message translates to:
  /// **'Ubah bahan'**
  String get detailEdit;

  /// Aksi hapus bahan
  ///
  /// In id, this message translates to:
  /// **'Hapus bahan'**
  String get detailDelete;

  /// Judul bahan tidak ditemukan
  ///
  /// In id, this message translates to:
  /// **'Bahan tidak ditemukan'**
  String get detailNotFoundTitle;

  /// Penjelasan bahan tidak ditemukan
  ///
  /// In id, this message translates to:
  /// **'Bahan ini mungkin sudah dihapus.'**
  String get detailNotFoundBody;

  /// Pesan gagal memuat detail
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat detail bahan.'**
  String get detailLoadError;

  /// Pesan bahan terpakai
  ///
  /// In id, this message translates to:
  /// **'Bahan ditandai terpakai.'**
  String get actionUsedSuccess;

  /// Pesan bahan terbuang
  ///
  /// In id, this message translates to:
  /// **'Bahan ditandai terbuang.'**
  String get actionWastedSuccess;

  /// Pesan pemakaian sebagian
  ///
  /// In id, this message translates to:
  /// **'Pemakaian sebagian dicatat.'**
  String get actionPartialSuccess;

  /// Pesan bahan dihapus
  ///
  /// In id, this message translates to:
  /// **'Bahan dihapus dari pantry.'**
  String get actionDeleted;

  /// Aksi urungkan
  ///
  /// In id, this message translates to:
  /// **'Urungkan'**
  String get actionUndo;

  /// Pesan aksi gagal
  ///
  /// In id, this message translates to:
  /// **'Aksi gagal. Coba lagi.'**
  String get actionFailed;

  /// Nilai bahan yang diselamatkan
  ///
  /// In id, this message translates to:
  /// **'Nilai terselamatkan: {amount}'**
  String valueSaved(String amount);

  /// Nilai bahan yang terbuang
  ///
  /// In id, this message translates to:
  /// **'Nilai terbuang: {amount}'**
  String valueWasted(String amount);

  /// Penanda nilai estimasi
  ///
  /// In id, this message translates to:
  /// **' (estimasi)'**
  String get valueEstimateSuffix;

  /// Judul konfirmasi hapus
  ///
  /// In id, this message translates to:
  /// **'Hapus bahan?'**
  String get deleteConfirmTitle;

  /// Isi konfirmasi hapus
  ///
  /// In id, this message translates to:
  /// **'Bahan akan dihapus dari pantry. Riwayat pemakaian tetap disimpan.'**
  String get deleteConfirmBody;

  /// Tombol konfirmasi hapus
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get deleteConfirmAction;

  /// Judul sheet pakai sebagian
  ///
  /// In id, this message translates to:
  /// **'Pakai sebagian'**
  String get partialSheetTitle;

  /// Isi sheet pakai sebagian
  ///
  /// In id, this message translates to:
  /// **'Berapa banyak {name} yang dipakai?'**
  String partialSheetBody(String name);

  /// Label jumlah dipakai
  ///
  /// In id, this message translates to:
  /// **'Jumlah dipakai'**
  String get partialUsedLabel;

  /// Tombol cepat seperempat
  ///
  /// In id, this message translates to:
  /// **'¼'**
  String get partialQuickQuarter;

  /// Tombol cepat setengah
  ///
  /// In id, this message translates to:
  /// **'½'**
  String get partialQuickHalf;

  /// Tombol cepat semua
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get partialQuickAll;

  /// Tombol catat pemakaian
  ///
  /// In id, this message translates to:
  /// **'Catat pemakaian'**
  String get partialSave;

  /// Validasi jumlah pakai sebagian
  ///
  /// In id, this message translates to:
  /// **'Jumlah harus lebih dari 0 dan tidak melebihi stok.'**
  String get partialInvalid;

  /// Info sisa stok
  ///
  /// In id, this message translates to:
  /// **'Sisa stok: {amount} {unit}'**
  String partialRemaining(String amount, String unit);

  /// Judul sheet terbuang
  ///
  /// In id, this message translates to:
  /// **'Tandai terbuang'**
  String get wasteSheetTitle;

  /// Isi sheet terbuang
  ///
  /// In id, this message translates to:
  /// **'Pilih alasan supaya statistikmu lebih akurat.'**
  String get wasteSheetBody;

  /// Alasan basi
  ///
  /// In id, this message translates to:
  /// **'Basi'**
  String get wasteReasonBasi;

  /// Alasan lupa
  ///
  /// In id, this message translates to:
  /// **'Lupa'**
  String get wasteReasonLupa;

  /// Alasan terlalu banyak
  ///
  /// In id, this message translates to:
  /// **'Terlalu banyak'**
  String get wasteReasonTerlaluBanyak;

  /// Alasan rasa berubah
  ///
  /// In id, this message translates to:
  /// **'Rasa berubah'**
  String get wasteReasonRasaBerubah;

  /// Alasan lainnya
  ///
  /// In id, this message translates to:
  /// **'Lainnya'**
  String get wasteReasonLainnya;

  /// Tombol simpan alasan terbuang
  ///
  /// In id, this message translates to:
  /// **'Tandai terbuang'**
  String get wasteSave;

  /// Satuan pcs
  ///
  /// In id, this message translates to:
  /// **'pcs'**
  String get unitPcs;

  /// Satuan gram
  ///
  /// In id, this message translates to:
  /// **'gram'**
  String get unitGram;

  /// Satuan kg
  ///
  /// In id, this message translates to:
  /// **'kg'**
  String get unitKg;

  /// Satuan ml
  ///
  /// In id, this message translates to:
  /// **'ml'**
  String get unitMl;

  /// Satuan liter
  ///
  /// In id, this message translates to:
  /// **'liter'**
  String get unitLiter;

  /// Satuan ikat
  ///
  /// In id, this message translates to:
  /// **'ikat'**
  String get unitIkat;

  /// Satuan bungkus
  ///
  /// In id, this message translates to:
  /// **'bungkus'**
  String get unitBungkus;

  /// Satuan botol
  ///
  /// In id, this message translates to:
  /// **'botol'**
  String get unitBotol;

  /// Satuan kaleng
  ///
  /// In id, this message translates to:
  /// **'kaleng'**
  String get unitKaleng;

  /// Satuan butir
  ///
  /// In id, this message translates to:
  /// **'butir'**
  String get unitButir;

  /// Satuan siung
  ///
  /// In id, this message translates to:
  /// **'siung'**
  String get unitSiung;

  /// Kategori sayur
  ///
  /// In id, this message translates to:
  /// **'Sayur'**
  String get categorySayur;

  /// Kategori buah
  ///
  /// In id, this message translates to:
  /// **'Buah'**
  String get categoryBuah;

  /// Kategori daging
  ///
  /// In id, this message translates to:
  /// **'Daging'**
  String get categoryDaging;

  /// Kategori ikan dan seafood
  ///
  /// In id, this message translates to:
  /// **'Ikan & seafood'**
  String get categoryIkanSeafood;

  /// Kategori telur dan susu
  ///
  /// In id, this message translates to:
  /// **'Telur & susu'**
  String get categoryTelurSusu;

  /// Kategori bumbu
  ///
  /// In id, this message translates to:
  /// **'Bumbu'**
  String get categoryBumbu;

  /// Kategori bahan kering
  ///
  /// In id, this message translates to:
  /// **'Bahan kering'**
  String get categoryBahanKering;

  /// Kategori minuman
  ///
  /// In id, this message translates to:
  /// **'Minuman'**
  String get categoryMinuman;

  /// Kategori makanan olahan
  ///
  /// In id, this message translates to:
  /// **'Makanan olahan'**
  String get categoryMakananOlahan;

  /// Kategori lainnya
  ///
  /// In id, this message translates to:
  /// **'Lainnya'**
  String get categoryLainnya;

  /// Lokasi kulkas
  ///
  /// In id, this message translates to:
  /// **'Kulkas'**
  String get locationKulkas;

  /// Lokasi freezer
  ///
  /// In id, this message translates to:
  /// **'Freezer'**
  String get locationFreezer;

  /// Lokasi lemari
  ///
  /// In id, this message translates to:
  /// **'Lemari'**
  String get locationLemari;

  /// Lokasi suhu ruang
  ///
  /// In id, this message translates to:
  /// **'Suhu ruang'**
  String get locationSuhuRuang;

  /// Sumber tanggal estimasi
  ///
  /// In id, this message translates to:
  /// **'Estimasi otomatis'**
  String get expirySourceEstimasi;

  /// Sumber tanggal manual
  ///
  /// In id, this message translates to:
  /// **'Diatur manual'**
  String get expirySourceManual;

  /// Sumber tanggal kemasan
  ///
  /// In id, this message translates to:
  /// **'Dari kemasan'**
  String get expirySourceKemasan;

  /// Badge sisa hari
  ///
  /// In id, this message translates to:
  /// **'Sisa {days} hari'**
  String statusDaysLeft(int days);

  /// Badge basi besok
  ///
  /// In id, this message translates to:
  /// **'Basi besok'**
  String get statusExpiresTomorrow;

  /// Badge basi beberapa hari lagi
  ///
  /// In id, this message translates to:
  /// **'Basi {days} hari lagi'**
  String statusExpiresInDays(int days);

  /// Badge sudah basi beberapa hari
  ///
  /// In id, this message translates to:
  /// **'Basi {days} hari lalu'**
  String statusExpiredDaysAgo(int days);

  /// Badge sudah basi kemarin
  ///
  /// In id, this message translates to:
  /// **'Basi kemarin'**
  String get statusExpiredYesterday;

  /// Pilihan periode minggu ini
  ///
  /// In id, this message translates to:
  /// **'Minggu Ini'**
  String get statsPeriodWeek;

  /// Pilihan periode bulan ini
  ///
  /// In id, this message translates to:
  /// **'Bulan Ini'**
  String get statsPeriodMonth;

  /// Pilihan periode tiga bulan
  ///
  /// In id, this message translates to:
  /// **'3 Bulan'**
  String get statsPeriodThreeMonths;

  /// Pilihan periode semua waktu
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get statsPeriodAll;

  /// Label total penghematan pada kartu utama statistik
  ///
  /// In id, this message translates to:
  /// **'Total uang makanan diselamatkan'**
  String get statsSavedLabel;

  /// Persentase bahan yang diselamatkan
  ///
  /// In id, this message translates to:
  /// **'{percent}% bahan berhasil dimasak tepat waktu'**
  String statsSavedPercent(int percent);

  /// Judul statistik bahan dimasak
  ///
  /// In id, this message translates to:
  /// **'Dimasak'**
  String get statsUsedTitle;

  /// Judul statistik bahan terbuang
  ///
  /// In id, this message translates to:
  /// **'Terbuang'**
  String get statsWastedTitle;

  /// Jumlah bahan pada statistik
  ///
  /// In id, this message translates to:
  /// **'{count} bahan'**
  String statsItemCount(int count);

  /// Catatan nilai estimasi pada statistik
  ///
  /// In id, this message translates to:
  /// **'Sebagian nilai memakai estimasi harga pasar.'**
  String get statsEstimateNote;

  /// Judul grafik distribusi bahan
  ///
  /// In id, this message translates to:
  /// **'Distribusi Bahan Makanan'**
  String get statsDistributionTitle;

  /// Total bahan pada grafik distribusi
  ///
  /// In id, this message translates to:
  /// **'{count} bahan'**
  String statsDistributionTotal(int count);

  /// Legenda bahan diselamatkan
  ///
  /// In id, this message translates to:
  /// **'Diselamatkan'**
  String get statsDistributionSaved;

  /// Legenda bahan terbuang
  ///
  /// In id, this message translates to:
  /// **'Terbuang'**
  String get statsDistributionWasted;

  /// Label total bahan di tengah grafik distribusi
  ///
  /// In id, this message translates to:
  /// **'total bahan'**
  String get statsTotalItemsLabel;

  /// Judul grafik tren pemakaian dan pembuangan
  ///
  /// In id, this message translates to:
  /// **'Tren Pemakaian vs Pembuangan'**
  String get statsTrendTitle;

  /// Legenda tren bahan diselamatkan
  ///
  /// In id, this message translates to:
  /// **'Diselamatkan'**
  String get statsTrendSaved;

  /// Legenda tren bahan terbuang
  ///
  /// In id, this message translates to:
  /// **'Terbuang'**
  String get statsTrendWasted;

  /// Pesan grafik tren tanpa data
  ///
  /// In id, this message translates to:
  /// **'Grafik akan muncul setelah ada catatan pemakaian.'**
  String get statsTrendEmpty;

  /// Judul kartu dampak statistik
  ///
  /// In id, this message translates to:
  /// **'Dampak Nyata Kebiasaanmu'**
  String get statsImpactTitle;

  /// Label berat sampah makanan dicegah
  ///
  /// In id, this message translates to:
  /// **'Sampah makanan dicegah'**
  String get statsImpactKgLabel;

  /// Nilai berat sampah makanan dicegah
  ///
  /// In id, this message translates to:
  /// **'{kg} kg'**
  String statsImpactKgValue(String kg);

  /// Label porsi nasi rames setara
  ///
  /// In id, this message translates to:
  /// **'Setara porsi nasi rames'**
  String get statsImpactPortionLabel;

  /// Nilai porsi nasi rames setara
  ///
  /// In id, this message translates to:
  /// **'{portions} porsi'**
  String statsImpactPortionValue(String portions);

  /// Pesan motivasi tanpa data statistik
  ///
  /// In id, this message translates to:
  /// **'Tandai bahan yang terpakai atau terbuang untuk mulai melihat dampakmu.'**
  String get statsMotivationEmpty;

  /// Pesan motivasi penghematan sangat baik
  ///
  /// In id, this message translates to:
  /// **'Keren! {percent}% bahanmu terselamatkan. Kamu mengurangi {kg} kg sampah makanan, setara {portions} porsi nasi rames.'**
  String statsMotivationExcellent(int percent, String kg, String portions);

  /// Pesan motivasi penghematan baik
  ///
  /// In id, this message translates to:
  /// **'Bagus! {percent}% bahanmu terselamatkan. Sudah {kg} kg sampah makanan yang kamu cegah, setara {portions} porsi nasi rames.'**
  String statsMotivationGood(int percent, String kg, String portions);

  /// Pesan motivasi saat penghematan masih sedikit
  ///
  /// In id, this message translates to:
  /// **'Sedikit demi sedikit pasti terbiasa. {kg} kg sampah makanan sudah kamu cegah, setara {portions} porsi nasi rames.'**
  String statsMotivationLowWaste(String kg, String portions);

  /// Pesan motivasi tanpa penghematan
  ///
  /// In id, this message translates to:
  /// **'Tidak apa-apa, ini catatan untuk belajar. Mulai lagi dari bahan berikutnya, ya.'**
  String get statsMotivationLearning;

  /// Judul daftar efisiensi kategori
  ///
  /// In id, this message translates to:
  /// **'Efisiensi per Kategori'**
  String get statsCategoryTitle;

  /// Subjudul daftar efisiensi kategori
  ///
  /// In id, this message translates to:
  /// **'Kategori dengan efisiensi terbaik tampil lebih dulu.'**
  String get statsCategorySubtitle;

  /// Ringkasan pemakaian bahan per kategori
  ///
  /// In id, this message translates to:
  /// **'{used} dari {total} bahan digunakan'**
  String statsCategoryUsage(int used, int total);

  /// Keterangan kategori tanpa bahan terbuang
  ///
  /// In id, this message translates to:
  /// **'Tidak ada bahan terbuang'**
  String get statsCategoryNoWaste;

  /// Persentase efisiensi kategori
  ///
  /// In id, this message translates to:
  /// **'{percent}%'**
  String statsCategoryEfficiency(int percent);

  /// Judul daftar alasan bahan terbuang
  ///
  /// In id, this message translates to:
  /// **'Alasan Terbuang'**
  String get statsWasteReasonTitle;

  /// Alasan terbuang paling sering
  ///
  /// In id, this message translates to:
  /// **'Paling sering: {reason}'**
  String statsWasteReasonSubtitle(String reason);

  /// Jumlah kejadian alasan terbuang
  ///
  /// In id, this message translates to:
  /// **'{count} kali'**
  String statsWasteReasonCount(int count);

  /// Judul kartu insight belanja
  ///
  /// In id, this message translates to:
  /// **'Insight Belanja Minggu Depan'**
  String get statsInsightTitle;

  /// Insight saat semua kategori efisien
  ///
  /// In id, this message translates to:
  /// **'Semua kategori sudah terkelola baik. Pertahankan kebiasaan ini!'**
  String get statsInsightAllGood;

  /// Insight kategori sayur
  ///
  /// In id, this message translates to:
  /// **'Sayur paling sering terbuang. Coba beli lebih sedikit tapi lebih sering.'**
  String get statsInsightSayur;

  /// Insight kategori buah
  ///
  /// In id, this message translates to:
  /// **'Buah paling sering terbuang. Pilih yang matangnya pas dan simpan di kulkas.'**
  String get statsInsightBuah;

  /// Insight kategori daging
  ///
  /// In id, this message translates to:
  /// **'Daging paling sering terbuang. Bagi porsi kecil dan simpan di freezer.'**
  String get statsInsightDaging;

  /// Insight kategori ikan dan seafood
  ///
  /// In id, this message translates to:
  /// **'Ikan dan seafood paling sering terbuang. Masak atau bekukan di hari yang sama.'**
  String get statsInsightIkanSeafood;

  /// Insight kategori telur dan susu
  ///
  /// In id, this message translates to:
  /// **'Telur dan susu paling sering terbuang. Catat tanggal bukanya di wadah.'**
  String get statsInsightTelurSusu;

  /// Insight kategori bumbu
  ///
  /// In id, this message translates to:
  /// **'Bumbu paling sering terbuang. Beli dalam jumlah kecil atau tanam yang mudah.'**
  String get statsInsightBumbu;

  /// Insight kategori bahan kering
  ///
  /// In id, this message translates to:
  /// **'Bahan kering paling sering terbuang. Simpan di wadah kedap udara.'**
  String get statsInsightBahanKering;

  /// Insight kategori minuman
  ///
  /// In id, this message translates to:
  /// **'Minuman paling sering terbuang. Beli sesuai kebutuhan mingguan.'**
  String get statsInsightMinuman;

  /// Insight kategori makanan olahan
  ///
  /// In id, this message translates to:
  /// **'Makanan olahan paling sering terbuang. Cek stok sebelum membeli lagi.'**
  String get statsInsightMakananOlahan;

  /// Insight kategori lainnya
  ///
  /// In id, this message translates to:
  /// **'Ada bahan yang sering terbuang. Cek stok sebelum berbelanja lagi, ya.'**
  String get statsInsightLainnya;

  /// Judul kartu streak tanpa membuang bahan
  ///
  /// In id, this message translates to:
  /// **'Streak Tanpa Buang'**
  String get statsStreakTitle;

  /// Jumlah hari streak tanpa membuang bahan
  ///
  /// In id, this message translates to:
  /// **'{days} hari'**
  String statsStreakDays(int days);

  /// Keterangan streak sejak tanggal terakhir membuang
  ///
  /// In id, this message translates to:
  /// **'Tidak ada bahan yang terbuang sejak {date}.'**
  String statsStreakBody(String date);

  /// Keterangan streak saat belum pernah membuang bahan
  ///
  /// In id, this message translates to:
  /// **'Belum ada bahan yang terbuang. Pertahankan!'**
  String get statsStreakClean;

  /// Judul state kosong periode statistik
  ///
  /// In id, this message translates to:
  /// **'Belum ada catatan di periode ini'**
  String get statsPeriodEmptyTitle;

  /// Penjelasan state kosong periode statistik
  ///
  /// In id, this message translates to:
  /// **'Coba pilih periode lain atau tandai bahan terpakai.'**
  String get statsPeriodEmptyBody;

  /// Tombol menampilkan statistik semua periode
  ///
  /// In id, this message translates to:
  /// **'Lihat semua'**
  String get statsShowAll;

  /// Judul kartu barcode di form tambah bahan
  ///
  /// In id, this message translates to:
  /// **'Isi cepat dengan barcode'**
  String get barcodeSectionTitle;

  /// Penjelasan kartu barcode
  ///
  /// In id, this message translates to:
  /// **'Pindai kemasan atau ketik nomornya. Data produk diambil dari Open Food Facts saat fitur online aktif.'**
  String get barcodeSectionBody;

  /// Tombol membuka pencarian barcode
  ///
  /// In id, this message translates to:
  /// **'Pindai / ketik barcode'**
  String get barcodeSectionAction;

  /// Barcode yang sudah ditempel ke bahan
  ///
  /// In id, this message translates to:
  /// **'Barcode: {barcode}'**
  String barcodeAttached(String barcode);

  /// Tombol menghapus barcode dari form
  ///
  /// In id, this message translates to:
  /// **'Hapus barcode'**
  String get barcodeClearAction;

  /// Judul sheet pencarian barcode
  ///
  /// In id, this message translates to:
  /// **'Cari lewat barcode'**
  String get barcodeSheetTitle;

  /// Petunjuk singkat di sheet barcode
  ///
  /// In id, this message translates to:
  /// **'Masukkan 8–14 digit angka atau pindai kemasan.'**
  String get barcodeSheetBody;

  /// Label kolom barcode
  ///
  /// In id, this message translates to:
  /// **'Nomor barcode'**
  String get barcodeFieldLabel;

  /// Contoh isian barcode
  ///
  /// In id, this message translates to:
  /// **'Contoh: 8991002101234'**
  String get barcodeFieldHint;

  /// Tombol mencari produk dari barcode
  ///
  /// In id, this message translates to:
  /// **'Cari produk'**
  String get barcodeLookupAction;

  /// Tombol membuka kamera pemindai dari sheet barcode
  ///
  /// In id, this message translates to:
  /// **'Pindai'**
  String get barcodeScanAction;

  /// Status saat produk sedang dicari
  ///
  /// In id, this message translates to:
  /// **'Mencari produk…'**
  String get barcodeLookingUp;

  /// Pesan barcode tidak valid
  ///
  /// In id, this message translates to:
  /// **'Barcode harus 8–14 digit angka.'**
  String get barcodeInvalid;

  /// Pesan produk tidak ditemukan
  ///
  /// In id, this message translates to:
  /// **'Produk tidak ditemukan. Kamu tetap bisa mengisi nama sendiri.'**
  String get barcodeNotFound;

  /// Pesan saat perangkat offline
  ///
  /// In id, this message translates to:
  /// **'Sedang offline. Coba lagi saat ada internet atau isi nama manual.'**
  String get barcodeOffline;

  /// Pesan saat fitur barcode online dimatikan
  ///
  /// In id, this message translates to:
  /// **'Fitur online dimatikan. Aktifkan di Pengaturan atau isi nama manual.'**
  String get barcodeDisabled;

  /// Pesan kesalahan pencarian barcode
  ///
  /// In id, this message translates to:
  /// **'Gagal mencari produk. Coba lagi nanti.'**
  String get barcodeError;

  /// Tombol memakai hasil pencarian barcode
  ///
  /// In id, this message translates to:
  /// **'Pakai data ini'**
  String get barcodeUseAction;

  /// Label data yang berasal dari cache lokal
  ///
  /// In id, this message translates to:
  /// **'Dari cache'**
  String get barcodeCacheBadge;

  /// Merek produk dari barcode
  ///
  /// In id, this message translates to:
  /// **'Merek: {brand}'**
  String barcodeBrand(String brand);

  /// Isi kemasan produk
  ///
  /// In id, this message translates to:
  /// **'Isi: {quantity}'**
  String barcodeQuantity(String quantity);

  /// Pengingat bahwa form tetap bisa diisi manual
  ///
  /// In id, this message translates to:
  /// **'Tidak menemukan produknya? Isi nama, kategori, dan tanggal kedaluwarsa secara manual.'**
  String get barcodeManualHint;

  /// Judul dialog input barcode manual
  ///
  /// In id, this message translates to:
  /// **'Ketik barcode'**
  String get barcodeManualTitle;

  /// Judul layar pemindai barcode
  ///
  /// In id, this message translates to:
  /// **'Pindai Barcode'**
  String get barcodeScanTitle;

  /// Petunjuk di layar pemindai
  ///
  /// In id, this message translates to:
  /// **'Arahkan kamera ke barcode kemasan.'**
  String get barcodeScanHint;

  /// Tombol senter pemindai
  ///
  /// In id, this message translates to:
  /// **'Senter'**
  String get barcodeScanTorch;

  /// Tombol input barcode manual dari pemindai
  ///
  /// In id, this message translates to:
  /// **'Ketik manual'**
  String get barcodeScanManual;

  /// Pesan saat kamera gagal dibuka
  ///
  /// In id, this message translates to:
  /// **'Kamera tidak bisa dibuka. Ketik barcode secara manual.'**
  String get barcodeScanError;

  /// Judul bagian pengaturan fitur online
  ///
  /// In id, this message translates to:
  /// **'Fitur Online'**
  String get onlineSectionTitle;

  /// Label pengaturan barcode online
  ///
  /// In id, this message translates to:
  /// **'Cari produk lewat barcode'**
  String get onlineBarcodeLabel;

  /// Penjelasan barcode online
  ///
  /// In id, this message translates to:
  /// **'Mengirim nomor barcode ke Open Food Facts saat kamu memintanya.'**
  String get onlineBarcodeBody;

  /// Label pengaturan resep online
  ///
  /// In id, this message translates to:
  /// **'Cari resep online'**
  String get onlineRecipeLabel;

  /// Penjelasan resep online
  ///
  /// In id, this message translates to:
  /// **'Mengirim kata kunci ke TheMealDB saat kamu mencari resep.'**
  String get onlineRecipeBody;

  /// Aksi menghapus cache online
  ///
  /// In id, this message translates to:
  /// **'Hapus cache online'**
  String get onlineClearCache;

  /// Penjelasan aksi hapus cache
  ///
  /// In id, this message translates to:
  /// **'Hapus data produk dan resep yang tersimpan dari internet.'**
  String get onlineClearCacheBody;

  /// Konfirmasi cache online sudah dihapus
  ///
  /// In id, this message translates to:
  /// **'Cache online dihapus.'**
  String get onlineCacheCleared;

  /// Tombol menuju pengaturan fitur online
  ///
  /// In id, this message translates to:
  /// **'Buka Pengaturan'**
  String get onlineOpenSettings;

  /// Judul layar resep online
  ///
  /// In id, this message translates to:
  /// **'Resep Online'**
  String get onlineRecipesTitle;

  /// Subjudul layar resep online
  ///
  /// In id, this message translates to:
  /// **'Cari inspirasi dari TheMealDB. Hasil disimpan agar bisa dibuka lagi tanpa internet.'**
  String get onlineRecipesSubtitle;

  /// Label kolom pencarian resep online
  ///
  /// In id, this message translates to:
  /// **'Kata kunci'**
  String get onlineRecipesSearchLabel;

  /// Contoh pencarian resep online
  ///
  /// In id, this message translates to:
  /// **'Cari resep, misalnya chicken'**
  String get onlineRecipesSearchHint;

  /// Tombol mencari resep online
  ///
  /// In id, this message translates to:
  /// **'Cari'**
  String get onlineRecipesSearchAction;

  /// Judul state awal resep online
  ///
  /// In id, this message translates to:
  /// **'Cari resep dari internet'**
  String get onlineRecipesIdleTitle;

  /// Penjelasan state awal resep online
  ///
  /// In id, this message translates to:
  /// **'Ketik kata kunci lalu tekan Cari. Resep yang dibuka akan di-cache untuk dipakai offline.'**
  String get onlineRecipesIdleBody;

  /// Judul saat pencarian resep kosong
  ///
  /// In id, this message translates to:
  /// **'Resep tidak ditemukan'**
  String get onlineRecipesEmptyTitle;

  /// Penjelasan saat pencarian resep kosong
  ///
  /// In id, this message translates to:
  /// **'Coba kata kunci lain dalam bahasa Inggris.'**
  String get onlineRecipesEmptyBody;

  /// Judul state offline resep online
  ///
  /// In id, this message translates to:
  /// **'Tidak ada koneksi'**
  String get onlineRecipesOfflineTitle;

  /// Penjelasan state offline resep online
  ///
  /// In id, this message translates to:
  /// **'Resep online butuh internet. Resep lokal tetap bisa dipakai.'**
  String get onlineRecipesOfflineBody;

  /// Judul state fitur online dimatikan
  ///
  /// In id, this message translates to:
  /// **'Fitur online dimatikan'**
  String get onlineRecipesDisabledTitle;

  /// Penjelasan state fitur online dimatikan
  ///
  /// In id, this message translates to:
  /// **'Aktifkan pencarian resep online di Pengaturan.'**
  String get onlineRecipesDisabledBody;

  /// Judul kesalahan resep online
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat resep'**
  String get onlineRecipesErrorTitle;

  /// Penjelasan kesalahan resep online
  ///
  /// In id, this message translates to:
  /// **'Periksa koneksi lalu coba lagi.'**
  String get onlineRecipesErrorBody;

  /// Jumlah bahan resep online
  ///
  /// In id, this message translates to:
  /// **'{count} bahan'**
  String onlineRecipeIngredientCount(int count);

  /// Aksi membuka detail resep online
  ///
  /// In id, this message translates to:
  /// **'Lihat resep'**
  String get onlineRecipeOpenAction;

  /// Judul layar detail resep online
  ///
  /// In id, this message translates to:
  /// **'Detail Resep Online'**
  String get onlineRecipeDetailTitle;

  /// Judul bagian bahan resep online
  ///
  /// In id, this message translates to:
  /// **'Bahan'**
  String get onlineRecipeIngredients;

  /// Judul bagian langkah resep online
  ///
  /// In id, this message translates to:
  /// **'Cara membuat'**
  String get onlineRecipeSteps;

  /// Pesan saat resep online tidak punya langkah
  ///
  /// In id, this message translates to:
  /// **'Langkah memasak belum tersedia.'**
  String get onlineRecipeNoSteps;

  /// Judul saat detail resep online tidak ada
  ///
  /// In id, this message translates to:
  /// **'Resep tidak ditemukan'**
  String get onlineRecipeNotFoundTitle;

  /// Penjelasan saat detail resep online tidak ada
  ///
  /// In id, this message translates to:
  /// **'Resep mungkin sudah dihapus dari TheMealDB.'**
  String get onlineRecipeNotFoundBody;

  /// Judul kartu masuk resep online
  ///
  /// In id, this message translates to:
  /// **'Cari resep online'**
  String get onlineRecipeEntryTitle;

  /// Penjelasan kartu masuk resep online
  ///
  /// In id, this message translates to:
  /// **'Butuh inspirasi lain? Cari resep dari TheMealDB.'**
  String get onlineRecipeEntryBody;

  /// Penjelasan kartu resep online saat dimatikan
  ///
  /// In id, this message translates to:
  /// **'Fitur online dimatikan. Aktifkan untuk mencari resep dari internet.'**
  String get onlineRecipeEntryDisabled;

  /// Judul slide onboarding pertama
  ///
  /// In id, this message translates to:
  /// **'Catat stok dapurmu'**
  String get onboardingSlide1Title;

  /// Isi slide onboarding pertama
  ///
  /// In id, this message translates to:
  /// **'Tambah bahan dengan cepat, lengkap dengan tanggal basi dan lokasi simpan.'**
  String get onboardingSlide1Body;

  /// Judul slide onboarding kedua
  ///
  /// In id, this message translates to:
  /// **'Pengingat sebelum basi'**
  String get onboardingSlide2Title;

  /// Isi slide onboarding kedua
  ///
  /// In id, this message translates to:
  /// **'Segar mengingatkanmu beberapa hari sebelum bahan mendekati tanggal basi.'**
  String get onboardingSlide2Body;

  /// Judul slide onboarding ketiga
  ///
  /// In id, this message translates to:
  /// **'Masak sebelum terbuang'**
  String get onboardingSlide3Title;

  /// Isi slide onboarding ketiga
  ///
  /// In id, this message translates to:
  /// **'Dapatkan saran resep dari bahan yang paling perlu diselamatkan.'**
  String get onboardingSlide3Body;

  /// Judul slide nama onboarding
  ///
  /// In id, this message translates to:
  /// **'Siapa nama panggilanmu?'**
  String get onboardingNameTitle;

  /// Isi slide nama onboarding
  ///
  /// In id, this message translates to:
  /// **'Segar akan menyapamu dengan nama ini. Bisa diubah kapan saja di Pengaturan.'**
  String get onboardingNameBody;

  /// Label kolom nama panggilan
  ///
  /// In id, this message translates to:
  /// **'Nama panggilan'**
  String get onboardingNameLabel;

  /// Petunjuk kolom nama panggilan
  ///
  /// In id, this message translates to:
  /// **'Contoh: Dina'**
  String get onboardingNameHint;

  /// Tombol lanjut onboarding
  ///
  /// In id, this message translates to:
  /// **'Lanjut'**
  String get onboardingNext;

  /// Label aksesibilitas indikator halaman onboarding
  ///
  /// In id, this message translates to:
  /// **'Halaman {current} dari {total}'**
  String onboardingPageLabel(Object current, Object total);

  /// Subjudul layar cadangan
  ///
  /// In id, this message translates to:
  /// **'Simpan data pantry ke file, lalu pulihkan kapan saja.'**
  String get backupSubtitle;

  /// Keterangan waktu cadangan terakhir
  ///
  /// In id, this message translates to:
  /// **'Terakhir dicadangkan: {date}'**
  String backupLastAt(Object date);

  /// Keterangan bila belum ada cadangan
  ///
  /// In id, this message translates to:
  /// **'Belum pernah dicadangkan.'**
  String get backupNever;

  /// Judul bagian ekspor cadangan
  ///
  /// In id, this message translates to:
  /// **'Buat cadangan'**
  String get backupExportTitle;

  /// Penjelasan ekspor cadangan
  ///
  /// In id, this message translates to:
  /// **'File berisi bahan, riwayat pemakaian, dan daftar belanja. Simpan di tempat aman.'**
  String get backupExportBody;

  /// Tombol ekspor cadangan
  ///
  /// In id, this message translates to:
  /// **'Bagikan file cadangan'**
  String get backupExportAction;

  /// Pesan sukses ekspor cadangan
  ///
  /// In id, this message translates to:
  /// **'Cadangan berhasil dibuat.'**
  String get backupExportSuccess;

  /// Pesan gagal ekspor cadangan
  ///
  /// In id, this message translates to:
  /// **'Gagal membuat cadangan. Coba lagi.'**
  String get backupExportFailed;

  /// Judul bagian pemulihan cadangan
  ///
  /// In id, this message translates to:
  /// **'Pulihkan cadangan'**
  String get backupRestoreTitle;

  /// Penjelasan pemulihan cadangan
  ///
  /// In id, this message translates to:
  /// **'Pilih file cadangan Segar. Data saat ini akan diganti dengan isi file.'**
  String get backupRestoreBody;

  /// Tombol pemulihan cadangan
  ///
  /// In id, this message translates to:
  /// **'Pilih file cadangan'**
  String get backupRestoreAction;

  /// Judul konfirmasi pemulihan
  ///
  /// In id, this message translates to:
  /// **'Pulihkan data dari file?'**
  String get backupRestoreConfirmTitle;

  /// Isi konfirmasi pemulihan
  ///
  /// In id, this message translates to:
  /// **'File berisi {items} bahan, {logs} riwayat, dan {shopping} daftar belanja. Data saat ini akan diganti.'**
  String backupRestoreConfirmBody(Object items, Object logs, Object shopping);

  /// Pesan sukses pemulihan
  ///
  /// In id, this message translates to:
  /// **'Cadangan berhasil dipulihkan.'**
  String get backupRestoreSuccess;

  /// Pesan file cadangan tidak valid
  ///
  /// In id, this message translates to:
  /// **'File cadangan tidak valid atau tidak didukung.'**
  String get backupRestoreInvalid;

  /// Pesan gagal pemulihan
  ///
  /// In id, this message translates to:
  /// **'Gagal memulihkan cadangan. Coba lagi.'**
  String get backupRestoreFailed;

  /// Pesan pemulihan dibatalkan
  ///
  /// In id, this message translates to:
  /// **'Pemulihan dibatalkan.'**
  String get backupRestoreCancelled;

  /// Subjek berbagi file cadangan
  ///
  /// In id, this message translates to:
  /// **'Cadangan Segar'**
  String get backupFileSubject;

  /// Judul dialog ubah nama
  ///
  /// In id, this message translates to:
  /// **'Ubah nama panggilan'**
  String get profileEditTitle;

  /// Label kolom ubah nama
  ///
  /// In id, this message translates to:
  /// **'Nama panggilan'**
  String get profileEditLabel;

  /// Petunjuk kolom ubah nama
  ///
  /// In id, this message translates to:
  /// **'Contoh: Dina'**
  String get profileEditHint;

  /// Pesan sukses ubah nama
  ///
  /// In id, this message translates to:
  /// **'Nama berhasil diperbarui.'**
  String get profileEditSaved;

  /// Judul bagian data pengaturan
  ///
  /// In id, this message translates to:
  /// **'Data'**
  String get settingsDataTitle;

  /// Subjudul menu daftar belanja
  ///
  /// In id, this message translates to:
  /// **'Catat bahan yang perlu dibeli.'**
  String get settingsShoppingSubtitle;

  /// Judul menu hapus data
  ///
  /// In id, this message translates to:
  /// **'Hapus semua data'**
  String get settingsResetTitle;

  /// Penjelasan menu hapus data
  ///
  /// In id, this message translates to:
  /// **'Hapus bahan, riwayat, dan daftar belanja dari perangkat ini.'**
  String get settingsResetBody;

  /// Judul konfirmasi hapus data
  ///
  /// In id, this message translates to:
  /// **'Hapus semua data?'**
  String get settingsResetConfirmTitle;

  /// Isi konfirmasi hapus data
  ///
  /// In id, this message translates to:
  /// **'Semua bahan, riwayat pemakaian, dan daftar belanja akan dihapus permanen. Pengaturan tetap disimpan.'**
  String get settingsResetConfirmBody;

  /// Tombol konfirmasi hapus data
  ///
  /// In id, this message translates to:
  /// **'Hapus data'**
  String get settingsResetAction;

  /// Pesan sukses hapus data
  ///
  /// In id, this message translates to:
  /// **'Semua data berhasil dihapus.'**
  String get settingsResetSuccess;

  /// Pesan gagal hapus data
  ///
  /// In id, this message translates to:
  /// **'Gagal menghapus data. Coba lagi.'**
  String get settingsResetFailed;

  /// Judul state kosong daftar belanja
  ///
  /// In id, this message translates to:
  /// **'Daftar belanja masih kosong'**
  String get shoppingListEmptyTitle;

  /// Isi state kosong daftar belanja
  ///
  /// In id, this message translates to:
  /// **'Tambahkan bahan manual atau dari resep yang belum lengkap.'**
  String get shoppingListEmptyBody;

  /// Judul dialog tambah belanja
  ///
  /// In id, this message translates to:
  /// **'Tambah bahan belanja'**
  String get shoppingListAddTitle;

  /// Tombol tambah belanja
  ///
  /// In id, this message translates to:
  /// **'Tambah'**
  String get shoppingListAddAction;

  /// Label nama bahan belanja
  ///
  /// In id, this message translates to:
  /// **'Nama bahan'**
  String get shoppingListNameLabel;

  /// Petunjuk nama bahan belanja
  ///
  /// In id, this message translates to:
  /// **'Contoh: Bayam'**
  String get shoppingListNameHint;

  /// Validasi nama bahan belanja
  ///
  /// In id, this message translates to:
  /// **'Nama bahan wajib diisi.'**
  String get shoppingListNameRequired;

  /// Label jumlah belanja
  ///
  /// In id, this message translates to:
  /// **'Jumlah'**
  String get shoppingListQuantityLabel;

  /// Validasi jumlah belanja
  ///
  /// In id, this message translates to:
  /// **'Jumlah harus lebih dari 0.'**
  String get shoppingListQuantityInvalid;

  /// Label satuan belanja
  ///
  /// In id, this message translates to:
  /// **'Satuan'**
  String get shoppingListUnitLabel;

  /// Pesan sukses tambah belanja
  ///
  /// In id, this message translates to:
  /// **'Bahan ditambahkan ke daftar belanja.'**
  String get shoppingListAddSuccess;

  /// Ringkasan progres belanja
  ///
  /// In id, this message translates to:
  /// **'{checked} dari {total} sudah dibeli'**
  String shoppingListCheckedCount(Object checked, Object total);

  /// Tombol hapus item tercentang
  ///
  /// In id, this message translates to:
  /// **'Hapus yang sudah dibeli'**
  String get shoppingListClearChecked;

  /// Pesan sukses hapus item tercentang
  ///
  /// In id, this message translates to:
  /// **'Item yang sudah dibeli dihapus.'**
  String get shoppingListClearCheckedSuccess;

  /// Tombol kosongkan daftar belanja
  ///
  /// In id, this message translates to:
  /// **'Kosongkan daftar'**
  String get shoppingListClearAll;

  /// Judul konfirmasi kosongkan daftar
  ///
  /// In id, this message translates to:
  /// **'Kosongkan daftar belanja?'**
  String get shoppingListClearAllConfirmTitle;

  /// Isi konfirmasi kosongkan daftar
  ///
  /// In id, this message translates to:
  /// **'Semua item di daftar belanja akan dihapus.'**
  String get shoppingListClearAllConfirmBody;

  /// Pesan sukses hapus item
  ///
  /// In id, this message translates to:
  /// **'Item dihapus dari daftar belanja.'**
  String get shoppingListDeleteSuccess;

  /// Judul dialog ubah item belanja
  ///
  /// In id, this message translates to:
  /// **'Ubah item belanja'**
  String get shoppingListEditTitle;

  /// Label sumber item belanja manual
  ///
  /// In id, this message translates to:
  /// **'Manual'**
  String get shoppingListSourceManual;

  /// Label sumber item belanja dari stok habis
  ///
  /// In id, this message translates to:
  /// **'Stok habis'**
  String get shoppingListSourceHabis;

  /// Label sumber item belanja dari resep
  ///
  /// In id, this message translates to:
  /// **'Dari resep'**
  String get shoppingListSourceResep;

  /// Tombol tambah bahan kurang dari resep
  ///
  /// In id, this message translates to:
  /// **'Tambahkan bahan kurang ke daftar belanja'**
  String get shoppingListAddFromRecipe;

  /// Pesan sukses tambah bahan dari resep
  ///
  /// In id, this message translates to:
  /// **'{count} bahan ditambahkan ke daftar belanja.'**
  String shoppingListAddedFromRecipe(Object count);

  /// Validasi nama panggilan kosong
  ///
  /// In id, this message translates to:
  /// **'Nama panggilan wajib diisi.'**
  String get profileEditRequired;

  /// Pesan saat semua bahan resep sudah ada di daftar belanja
  ///
  /// In id, this message translates to:
  /// **'Bahan sudah ada di daftar belanja.'**
  String get shoppingListNoNewItems;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
