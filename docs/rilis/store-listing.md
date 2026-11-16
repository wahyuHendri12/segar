# Store Listing — Segar

Teks siap tempel untuk Google Play Console dan App Store Connect. Semua teks
berbahasa Indonesia karena aplikasi hanya menyediakan locale `id`.

- Nama aplikasi: **Segar**
- Versi: `1.0.0+1`
- Kategori: **Food & Drink** (Play), **Food & Drink** (App Store)
- Bahasa utama: Indonesia (`id`)
- Placeholder yang harus diganti: `[NAMA PENGEMBANG]`, `[EMAIL KONTAK]`,
  `[URL KEBIJAKAN PRIVASI]`, `[URL DUKUNGAN]`

## Google Play

### Nama aplikasi (maks. 30 karakter)

```
Segar — Pantry & Resep
```

22 karakter. Jika tanda "—" bermasalah di listing tertentu, pakai
`Segar: Pantry & Resep`.

### Deskripsi singkat (maks. 80 karakter)

```
Catat stok bahan, ingatkan sebelum basi, masak dari isi dapurmu.
```

64 karakter.

### Deskripsi lengkap (maks. 4.000 karakter)

```
Segar adalah pendamping dapur yang membantu kamu memakai bahan sebelum basi.

Catat bahan yang kamu beli, lihat mana yang harus segera dimasak, dan temukan
resep yang cocok dengan isi dapur. Semua tanpa akun, tanpa iklan, dan tanpa
koneksi internet.

APA YANG BISA KAMU LAKUKAN

• Pantry rapi — simpan nama bahan, jumlah, lokasi penyimpanan, tanggal beli,
  dan tanggal kedaluwarsa. Status "Segera pakai", "Aman", dan "Sudah basi"
  dihitung otomatis.

• Pengingat kedaluwarsa — atur jam pengingat, ambang hari, dan jam tenang.
  Notifikasi berjalan lokal di perangkat, termasuk setelah HP dinyalakan ulang.

• Resep dari stokmu — 12 resep Indonesia dengan skor kecocokan. Masak sebuah
  resep akan mengurangi stok, dan bisa dibatalkan kalau salah pencet.

• Daftar belanja — tambah manual, centang yang sudah dibeli, atau tarik bahan
  yang kurang dari sebuah resep.

• Statistik penghematan — lihat berapa bahan yang terselamatkan, berapa yang
  terbuang, dan kebiasaan dapurmu per minggu.

• Pindai barcode — arahkan kamera ke kemasan untuk mengambil nama dan kategori
  produk. Bisa juga ketik nomornya manual.

• Cadangan & pemulihan — ekspor semua data ke satu file JSON dan pulihkan kapan
  saja.

• Tema terang & gelap — nyaman dipakai siang atau malam, dengan dukungan
  ukuran teks besar.

PRIVASI DULU

Data pantry, riwayat, daftar belanja, dan pengaturan disimpan di HP-mu sendiri
memakai database lokal. Tidak ada akun, login, Firebase, iklan, analitik, atau
pelacakan.

Internet hanya dipakai untuk dua fitur opsional yang bisa kamu matikan:
mencari produk lewat Open Food Facts dan mencari resep lewat TheMealDB. Saat
fitur itu dipakai, hanya nomor barcode atau kata kunci pencarian yang dikirim.
Isi pantry dan data pribadimu tidak pernah ikut terkirim.

Aplikasi tetap berfungsi penuh tanpa internet. Hasil pencarian online disimpan
sebagai cache supaya bisa dibuka lagi saat offline.

COCOK UNTUK

• Anak kos dan pasangan yang ingin mengurangi makanan terbuang.
• Orang tua yang mengatur stok dapur mingguan.
• Siapa pun yang sering lupa bahan di kulkas.

Segar dibuat offline-first: pantry rapi, makanan terselamatkan.

Kebijakan privasi: [URL KEBIJAKAN PRIVASI]
Kontak: [EMAIL KONTAK]
```

Panjang ±2.200 karakter, masih jauh di bawah 4.000.

### Kategori & tag

| Field | Nilai |
| --- | --- |
| Category | Food & Drink |
| Tags (maks. 5) | Cooking, Food, Lifestyle, Productivity |
| Contact email | `[EMAIL KONTAK]` |
| Website | `[URL DUKUNGAN]` |
| Privacy policy | `[URL KEBIJAKAN PRIVASI]` |

### Content rating (IARC)

Jawab **No** untuk semua pertanyaan sensitif:

| Pertanyaan | Jawaban |
| --- | --- |
| Violence, blood, sexual content, nudity | No |
| Profanity, drugs, alcohol, tobacco | No |
| Gambling, simulated gambling | No |
| Horror, fear | No |
| User interaction / user-generated content | No |
| Shares user location | No |
| Allows purchase of digital goods | No |
| Contains ads | No |
| Unrestricted web access | No |

Perkiraan hasil: **Everyone / PEGI 3 / IARC 3+**. Aplikasi tidak punya konten
yang perlu peringatan.

### What's new (maks. 500 karakter)

```
Rilis pertama Segar.

• Pantry dengan status kedaluwarsa otomatis
• Pengingat lokal dengan jam tenang
• 12 resep Indonesia dengan skor kecocokan
• Daftar belanja dan statistik penghematan
• Pindai barcode dan cari resep online (opsional)
• Cadangan & pemulihan data
• Tema terang dan gelap, dukungan teks besar
```

### Catatan pengujian untuk reviewer Play

```
Aplikasi tidak memerlukan akun atau login.

Alur uji cepat:
1. Onboarding: isi nama panggilan apa saja, lanjutkan.
2. Pantry: ketuk tombol +, pilih bahan, isi jumlah dan tanggal kedaluwarsa,
   simpan.
3. Ketuk kartu bahan untuk melihat detail dan hitung mundur.
4. Resep: buka tab Resep, pilih "Nasi Goreng Spesial", lalu "Masak".
5. Pengaturan: coba tema gelap, skala teks, dan Hapus semua data.
6. Barcode: buka tombol pindai. Kamera hanya dipakai di layar ini. Jika
   emulator tidak punya kamera, ketik barcode manual (contoh: 8991002101234).
7. Fitur online bisa dimatikan di Pengaturan → Fitur Online. Aplikasi tetap
   berfungsi penuh tanpa internet.

Tidak ada pembayaran, langganan, atau iklan.
```

## App Store Connect

### Nama (maks. 30 karakter)

```
Segar — Pantry & Resep
```

### Subtitle (maks. 30 karakter)

```
Pantry rapi, hemat makanan
```

26 karakter.

### Promotional text (maks. 170 karakter)

```
Catat stok, ingatkan sebelum basi, dan masak dari isi dapurmu. Offline-first, tanpa akun, tanpa iklan. Data pantry tersimpan di HP-mu.
```

### Keywords (maks. 100 karakter, dipisah koma)

```
pantry,stok bahan,kedaluwarsa,resep indonesia,daftar belanja,hemat,offline,dapur
```

80 karakter. Jangan ulangi nama aplikasi di keywords.

### Description (maks. 4.000 karakter)

Gunakan teks yang sama dengan deskripsi lengkap Google Play di atas, lalu ganti
bagian "Kebijakan privasi" dan "Kontak" dengan URL yang sama.

### URL wajib

| Field | Nilai |
| --- | --- |
| Privacy Policy URL | `[URL KEBIJAKAN PRIVASI]` |
| Support URL | `[URL DUKUNGAN]` |
| Marketing URL (opsional) | `[URL DUKUNGAN]` |
| Copyright | `© 2026 [NAMA PENGEMBANG]` |

### App Privacy

Ikuti `data-safety.md` bagian Apple. Ringkasnya: **Usage data → Search history**,
tidak linked, tidak tracking, purpose App functionality. Tidak ada ATT prompt.

### Age rating

- Semua kategori konten: **None / No**.
- Hasil perkiraan: **4+**.
- Tidak ada user-generated content, chat, atau tautan keluar yang bisa dibuka
  bebas (tautan hanya ke Open Food Facts/TheMealDB di teks kebijakan).

### Export compliance

- Menggunakan HTTPS standar (bukan enkripsi kustom).
- Pilih **Yes** untuk "uses encryption", lalu ajukan pengecualian standar
  (category 5, part 2) atau jawab sesuai panduan App Store Connect.
- Tidak ada fitur kriptografi buatan sendiri.

### Catatan untuk App Review

```
Segar is an offline-first pantry app. No account or login is required.

Quick review path:
1. Complete onboarding with any nickname.
2. Add a pantry item with an expiry date.
3. Open the item detail to see the countdown.
4. Open Recipes, choose a recipe, tap "Masak" (Cook).
5. Settings: toggle dark mode and large text, then try "Hapus semua data".
6. Barcode scanner uses the camera only on that screen. If the simulator has
   no camera, enter a barcode manually (e.g. 8991002101234).
7. Online features can be disabled in Settings; the app remains fully usable
   offline.

No ads, subscriptions, or in-app purchases.
```

## Lokalisasi & konsistensi

- Hanya locale `id` yang didukung. Jangan menambahkan locale lain di listing
  sebelum ARB-nya tersedia.
- Gunakan tanda pisah "—" dan tanda kutip lurus agar tidak berubah saat
  ditempel.
- Nama "Segar" harus sama di listing, ikon, `android:label`, dan
  `CFBundleDisplayName`.
- Versi di listing harus sama dengan `pubspec.yaml` (`1.0.0+1`).

## Checklist sebelum publish

- [ ] Nama, deskripsi singkat, dan deskripsi lengkap sudah ditempel.
- [ ] Minimal 2 screenshot ponsel dan 2 screenshot tablet (Play).
- [ ] Ikon 512×512 dan feature graphic 1024×500 sudah diunggah.
- [ ] Content rating sudah selesai (IARC).
- [ ] Data safety sudah diisi dan cocok dengan kebijakan privasi.
- [ ] URL kebijakan privasi aktif.
- [ ] Email kontak aktif dan dipantau.
- [ ] What's new sudah diisi.
- [ ] Tidak ada placeholder `[...]` yang tersisa.
