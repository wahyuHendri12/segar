# Checklist Rilis — Segar 1.0.0

Status per 11 November 2026. Tanda `[x]` berarti sudah dikerjakan di repo,
`[ ]` berarti masih harus dilakukan sebelum aplikasi bisa dipublikasikan.

## Ringkasan status

| Area | Status | Catatan |
| --- | --- | --- |
| Fitur Tahap A–H | Selesai | Semua fitur inti berjalan |
| `flutter analyze` | Selesai | Bersih |
| `flutter test` | Selesai | 329 test lulus |
| Uji responsif | Selesai | 6 perangkat × 5 skala teks |
| Dokumen rilis | Sebagian | Privacy policy, data safety, listing, aset |
| Identitas aplikasi | Belum | Masih `com.example.segar` |
| Signing produksi | Belum | Masih debug signing |
| AAB | Belum | Belum pernah dibuild |
| QA perangkat nyata | Belum | Notifikasi, kamera, backup, safe area |
| Aset store | Sebagian | Ikon & feature graphic siap; screenshot belum |
| Privacy policy online | Belum | Masih placeholder dan belum di-hosting |
| Upload ke store | Belum | Menunggu semua di atas |

## 1. Identitas aplikasi

- [ ] Ganti `applicationId` dan `namespace` Android dari `com.example.segar`
      menjadi ID final, misalnya `id.segar.app`.
  - `android/app/build.gradle.kts`
  - `android/app/src/main/kotlin/com/example/segar/MainActivity.kt` (pindahkan
    folder sesuai package)
- [ ] Ganti `PRODUCT_BUNDLE_IDENTIFIER` iOS menjadi ID final yang sama.
  - `ios/Runner.xcodeproj/project.pbxproj`
- [ ] Pastikan nama tampilan konsisten: `android:label="Segar"` dan
      `CFBundleDisplayName = Segar`.
- [ ] Siapkan akun developer Google Play dan Apple Developer Program.
- [ ] Daftarkan aplikasi baru di Play Console dan App Store Connect **setelah**
      ID final ditentukan (ID tidak bisa diubah setelah dibuat).

> Jangan membuat listing dengan `com.example.segar`. Play menolak ID contoh,
> dan mengganti ID setelah rilis berarti aplikasi baru dengan data pengguna
> yang terpisah.

## 2. Signing & build Android

- [ ] Buat keystore unggah produksi:
  ```bash
  keytool -genkey -v \
    -keystore ~/segar-upload.jks \
    -keyalg RSA -keysize 2048 -validity 10000 \
    -alias upload
  ```
- [ ] Simpan keystore di tempat aman dan **jangan** commit ke repo.
- [ ] Buat `android/key.properties` (masukkan ke `.gitignore`):
  ```properties
  storePassword=...
  keyPassword=...
  keyAlias=upload
  storeFile=/absolute/path/segar-upload.jks
  ```
- [ ] Ubah `android/app/build.gradle.kts` agar release memakai signing config
      produksi, bukan `signingConfigs.getByName("debug")`.
- [ ] Daftarkan aplikasi di Play Console dan aktifkan **Play App Signing**.
- [ ] Build AAB:
  ```bash
  flutter build appbundle --release
  ```
  Output: `build/app/outputs/bundle/release/app-release.aab`
- [ ] Periksa ukuran AAB (batas Play: 200 MB untuk base module).
- [ ] Build APK sideload per ABI (opsional, untuk tester manual):
  ```bash
  flutter build apk --release --split-per-abi
  ```
- [ ] Verifikasi signature AAB/APK memakai sertifikat produksi:
  ```bash
  apksigner verify --print-certs build/app/outputs/bundle/release/app-release.aab
  ```
- [ ] Verifikasi dukungan 16 KB page size (syarat Play untuk target SDK 35+):
  ```bash
  zipalign -c -P 16 -v 4 build/app/outputs/flutter-apk/app-release.apk
  ```
  Status saat ini: APK debug-signed yang ada **lulus** pemeriksaan 16 KB.

Catatan: APK release saat ini 86 MB karena universal (arm64-v8a, armeabi-v7a,
x86_64 + ML Kit `barhopper`). Gunakan AAB untuk Play dan `--split-per-abi`
untuk sideload.

## 3. QA perangkat nyata

Widget test tidak menyentuh bagian native/OS. Uji minimal di satu HP Android
dan satu iPhone:

### Notifikasi

- [ ] Izin notifikasi muncul dan bisa ditolak tanpa crash.
- [ ] Pengingat terjadwal pada jam yang dipilih.
- [ ] Ambang hari (`warnDays`) mengubah waktu pengingat.
- [ ] Jam tenang menunda notifikasi ke luar rentang.
- [ ] Notifikasi tetap muncul setelah HP di-reboot (Android).
- [ ] Tap notifikasi membuka detail bahan yang benar.
- [ ] Notifikasi hilang saat bahan dihapus atau tanggal diubah.

### Kamera & barcode

- [ ] Izin kamera muncul sekali dan alasan jelas.
- [ ] Barcode terbaca saat cahaya cukup.
- [ ] Barcode tidak dikenal menampilkan pesan yang jelas.
- [ ] Input manual tetap bisa dipakai tanpa kamera.
- [ ] Fitur online dimatikan: pemindaian tidak mengirim request.

### Backup & pemulihan

- [ ] Ekspor membuka share sheet dan file JSON bisa disimpan.
- [ ] Impor dari file picker memulihkan pantry, riwayat, belanja, pengaturan.
- [ ] File rusak/versi salah ditolak dengan pesan yang jelas.
- [ ] Impor tidak menduplikasi data.

### Tampilan & perangkat

- [ ] Safe area iPhone (notch, home indicator) tidak menutup tombol.
- [ ] Mode gelap di HP asli.
- [ ] Skala teks 200% di HP asli tidak memotong teks penting.
- [ ] Rotasi dikunci portrait.
- [ ] Tablet: layout dua kolom/lebar tidak aneh.
- [ ] Mode pesawat: aplikasi tetap berfungsi penuh.
- [ ] Ganti zona waktu: countdown dan pengingat tetap masuk akal.
- [ ] Hapus semua data: pantry/riwayat/belanja/cache hilang, pengaturan tetap.

## 4. Kepatuhan & store

- [ ] Ganti placeholder di `privacy-policy.md` dan `privacy-policy.html`.
- [ ] Hosting kebijakan privasi dan salin URL final.
- [ ] Isi Data safety Play sesuai `data-safety.md`.
- [ ] Isi App Privacy Apple sesuai `data-safety.md`.
- [ ] Selesaikan content rating IARC.
- [ ] Isi listing sesuai `store-listing.md`.
- [ ] Unggah ikon 512×512 (`assets/play-icon-512.png`).
- [ ] Unggah feature graphic 1024×500 (`assets/feature-graphic-1024x500.png`).
- [ ] Ambil dan unggah screenshot sesuai `assets-checklist.md`.
- [ ] Siapkan halaman dukungan/kontak yang aktif.
- [ ] Periksa kebijakan `android:allowBackup="true"` sudah dijelaskan di
      kebijakan privasi (sudah).
- [ ] Pastikan tidak ada SDK analitik/iklan/crash baru di `pubspec.yaml`.

## 5. Distribusi

### Google Play

- [ ] Upload AAB ke **Internal testing**.
- [ ] Uji unduhan dari Play di minimal 2 perangkat.
- [ ] Naik ke **Closed testing**. Akun developer personal baru wajib
      mengumpulkan **12 tester selama 14 hari** sebelum bisa production.
- [ ] Siapkan catatan rilis dan rollout bertahap (mis. 10% → 50% → 100%).
- [ ] Upload ke **Production** setelah semua checklist selesai.

### App Store

- [ ] Buka `ios/Runner.xcworkspace` di macOS.
- [ ] Set Team, bundle ID final, dan provisioning profile.
- [ ] `flutter build ipa --release`
- [ ] Unggah lewat Xcode Organizer atau Transporter.
- [ ] Uji lewat **TestFlight**.
- [ ] Isi App Privacy, age rating, export compliance, dan screenshot.
- [ ] Submit for review.

## 6. Rilis & pasca-rilis

- [ ] Naikkan versi di `pubspec.yaml`, misalnya `1.0.0+2` untuk build
      berikutnya. Jangan mengunggah build number yang sama dua kali.
- [ ] Tulis changelog di `docs/rilis/` atau `CHANGELOG.md`.
- [ ] Tag versi di git (repo saat ini belum memakai git).
- [ ] Pantau email dukungan dan ulasan store.
- [ ] Siapkan rencana patch untuk bug kritis.

## 7. Gap yang diketahui

Hal-hal berikut **belum ada** dan harus diselesaikan sebelum rilis publik:

1. `applicationId`/bundle ID masih `com.example.segar`.
2. Release masih ditandatangani dengan debug key.
3. Belum ada `key.properties` atau keystore produksi.
4. Belum ada AAB.
5. Belum ada QA di perangkat fisik.
6. Screenshot store belum diambil.
7. Privacy policy belum di-hosting dan masih berisi placeholder.
8. Belum ada CI (analyze + test otomatis).
9. Repo belum diinisialisasi sebagai git repository.
10. iOS build belum pernah dicoba (butuh macOS/Xcode).

## Perintah verifikasi cepat

```bash
flutter analyze
flutter test
flutter build appbundle --release
flutter build apk --release --split-per-abi

# signature
apksigner verify --print-certs build/app/outputs/bundle/release/app-release.aab

# 16 KB page size
zipalign -c -P 16 -v 4 build/app/outputs/flutter-apk/app-release.apk
```
