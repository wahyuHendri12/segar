# Aset Store — Segar

Daftar aset yang harus disiapkan sebelum mengunggah ke Google Play dan App
Store, lengkap dengan spesifikasi dan daftar screenshot.

Aset yang sudah dibuat otomatis ada di `docs/rilis/assets/`:

| File | Ukuran | Status |
| --- | --- | --- |
| `play-icon-512.png` | 512×512, RGB tanpa alpha | Siap unggah ke Play |
| `feature-graphic-1024x500.png` | 1024×500, RGB tanpa alpha | Siap unggah ke Play |

Sumber ikon: `assets/branding/app_icon.svg`. Launcher Android dan AppIcon iOS
sudah memakai ikon kustom yang sama.

## Ikon aplikasi

### Google Play

| Spesifikasi | Nilai |
| --- | --- |
| Ukuran | 512×512 px |
| Format | PNG 32-bit |
| Alpha | Tidak perlu (file yang disediakan sudah RGB) |
| Ukuran file | ≤ 1 MB |
| Isi | Logo penuh, tanpa teks kecil, tanpa sudut membulat buatan sendiri |

File: `docs/rilis/assets/play-icon-512.png`.

### App Store

| Spesifikasi | Nilai |
| --- | --- |
| Ukuran | 1024×1024 px |
| Format | PNG |
| Alpha | **Tidak boleh** ada transparansi |
| Sudut | Jangan membulatkan sendiri; sistem yang membulatkan |

File yang sudah ada:
`ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png`
(RGB, tanpa alpha).

### Android adaptive icon

Sudah ada di `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml`.
Periksa tampilan pada peluncur Android 8+ (ikon bulat/squircle) sebelum rilis.
Jika ingin adaptive icon penuh, tambahkan foreground/background terpisah; ikon
saat ini memakai gambar penuh sehingga bisa terpotong di beberapa peluncur.

## Feature graphic (Play)

| Spesifikasi | Nilai |
| --- | --- |
| Ukuran | 1024×500 px |
| Format | PNG atau JPEG |
| Alpha | Tidak boleh |
| Ukuran file | ≤ 15 MB |
| Teks | Tetap terbaca saat gambar diperkecil; hindari teks di tepi |

File: `docs/rilis/assets/feature-graphic-1024x500.png`.

Jika ingin membuat variasi, jaga area tengah tetap aman karena Play dapat
memotong gambar di beberapa penempatan.

## Screenshot Google Play

| Jenis | Jumlah | Ukuran | Format |
| --- | --- | --- | --- |
| Ponsel | 2–8 | 16:9 atau 9:16, sisi terpendek ≥ 320 px, terpanjang ≤ 3840 px | PNG/JPEG, ≤ 8 MB |
| Tablet 7" | 2–8 | ≥ 1024×600 px | PNG/JPEG |
| Tablet 10" | 2–8 | ≥ 1280×800 px | PNG/JPEG |

Screenshot tablet sangat disarankan karena aplikasi mendukung tablet
(`TARGETED_DEVICE_FAMILY = "1,2"`). Play dapat memakai screenshot ponsel untuk
tablet, tetapi hasilnya kurang rapi.

## Screenshot App Store

| Perangkat | Ukuran portrait yang diterima | Wajib? |
| --- | --- | --- |
| iPhone 6.9" | 1320×2868 atau 1290×2796 | Ya |
| iPhone 6.5" | 1284×2778 atau 1242×2688 | Opsional, untuk perangkat lebih kecil |
| iPad 13" | 2064×2752 | Ya, karena aplikasi mendukung iPad |

- 2–10 screenshot per ukuran.
- Format PNG/JPEG, tanpa alpha.
- Jangan menambahkan bingkai perangkat yang mengandung merek lain.
- Cek ulang ukuran wajib di App Store Connect saat upload; Apple kadang
  memperbarui daftarnya.

## Daftar 8 screenshot

Urutan ini dibuat sebagai alur cerita: masalah → solusi → hasil.

| # | Layar | Yang disiapkan | Caption singkat |
| --- | --- | --- | --- |
| 1 | Pantry (Home) | 5–7 bahan dengan campuran status "Segera pakai", "Aman", "Sudah basi"; nama panggilan "Dina" | **Semua stok dapur, satu layar.** |
| 2 | Tambah bahan | Form terisi: "Bayam", 1 ikat, Kulkas, kedaluwarsa 2 hari lagi | **Catat bahan baru dalam hitungan detik.** |
| 3 | Detail bahan | Bahan berstatus "Segera pakai" dengan countdown dan tombol Pakai/Buang | **Tahu persis kapan harus dipakai.** |
| 4 | Resep — Smart Match | Kartu "Nasi Goreng Spesial" dengan skor kecocokan tinggi | **Resep yang cocok dengan isi dapurmu.** |
| 5 | Statistik | Grafik mingguan + "bahan terselamatkan" dan streak | **Lihat bahan yang berhasil diselamatkan.** |
| 6 | Daftar belanja | Beberapa item, sebagian sudah dicentang | **Belanja hanya yang benar-benar kurang.** |
| 7 | Cadangan & privasi | Kartu cadangan + teks "Datamu tersimpan di HP ini saja." | **Data di HP-mu. Tanpa akun, tanpa iklan.** |
| 8 | Mode gelap | Pantry atau detail resep dalam tema gelap | **Nyaman dipakai siang dan malam.** |

Caption di atas adalah teks pendek untuk banner. Jika ingin menambahkan teks
di dalam gambar, gunakan font Plus Jakarta Sans dan warna brand `#2E9E5B`.

### Alternatif screenshot ke-8

Jika ingin menonjolkan fitur online:

- Layar pindai barcode dengan kamera aktif (jangan tampilkan barcode asli
  milik orang lain).
- Layar resep online dengan hasil pencarian "ayam".

## Cara mengambil screenshot

1. Jalankan build release agar tidak ada banner debug:
   ```bash
   flutter run --release
   ```
2. Gunakan data demo, bukan data pribadi. Onboarding memakai nama "Dina".
3. Set skala teks perangkat ke **1.0×** untuk screenshot utama. Screenshot
   teks besar hanya jika ingin menonjolkan aksesibilitas.
4. Tema terang untuk screenshot 1–7, tema gelap untuk screenshot 8.
5. Bersihkan status bar: jam `09:41`, baterai penuh, matikan notifikasi lain.
6. Pastikan orientasi portrait.
7. Ambil screenshot:
   - Android: `adb exec-out screencap -p > home.png`
   - iOS: tombol samping + volume atas, lalu ekspor dari Photos.
8. Simpan ke `docs/rilis/assets/screenshots/` dengan pola nama:
   ```
   play-phone-01-home.png
   play-phone-02-add-item.png
   ...
   play-tablet-01-home.png
   ios-6.9-01-home.png
   ios-ipad-01-home.png
   ```
9. Periksa tidak ada teks terpotong, keyboard tertutup, dan tidak ada data
   pribadi.

### Ukuran emulator/simulator yang disarankan

| Tujuan | Contoh perangkat |
| --- | --- |
| Play ponsel | Pixel 7 (1080×2400) |
| Play tablet 7" | Nexus 7 (1200×1920) |
| Play tablet 10" | Pixel Tablet (2560×1600) |
| App Store iPhone 6.9" | iPhone 16 Pro Max |
| App Store iPad 13" | iPad Pro 13-inch (M4) |

## Checklist aset

- [ ] `play-icon-512.png` sudah diperiksa di atas latar terang dan gelap.
- [ ] `feature-graphic-1024x500.png` sudah diperiksa; teks tidak terpotong.
- [ ] 8 screenshot ponsel sudah diambil dan diberi nama.
- [ ] 2–8 screenshot tablet sudah diambil.
- [ ] Screenshot iPhone 6.9" sudah diambil.
- [ ] Screenshot iPad 13" sudah diambil.
- [ ] Tidak ada data pribadi, notifikasi, atau keyboard di screenshot.
- [ ] Tidak ada placeholder `[...]` di teks banner.
- [ ] Ukuran dan format file sesuai tabel di atas.
