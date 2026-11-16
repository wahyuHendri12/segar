# Dokumen Rilis Segar

Folder ini berisi semua materi yang dibutuhkan untuk mempublikasikan Segar ke
Google Play dan App Store. Semua dokumen berbahasa Indonesia agar konsisten
dengan aplikasi.

## Isi folder

| File | Isi |
| --- | --- |
| `privacy-policy.md` | Sumber kebijakan privasi (Markdown) |
| `privacy-policy.html` | Versi siap hosting untuk URL Play/App Store |
| `data-safety.md` | Jawaban Data safety Play + App Privacy Apple |
| `store-listing.md` | Judul, deskripsi, kategori, content rating, what's new |
| `assets-checklist.md` | Spesifikasi ikon, feature graphic, dan 8 screenshot |
| `release-checklist.md` | Checklist Tahap I dan status kesiapan rilis |
| `assets/play-icon-512.png` | Ikon Play 512×512 |
| `assets/feature-graphic-1024x500.png` | Feature graphic Play 1024×500 |

## Placeholder yang wajib diganti

Cari dan ganti semua placeholder berikut sebelum publish:

| Placeholder | Diganti dengan |
| --- | --- |
| `[NAMA PENGEMBANG]` | Nama kamu atau nama studio |
| `[EMAIL KONTAK]` | Email dukungan yang aktif dan dipantau |
| `[URL KEBIJAKAN PRIVASI]` | URL hasil hosting `privacy-policy.html` |
| `[URL DUKUNGAN]` | Halaman dukungan/portofolio (boleh sama dengan URL privasi) |

Periksa dengan:

```bash
grep -rn "\[NAMA PENGEMBANG\]\|\[EMAIL KONTAK\]\|\[URL KEBIJAKAN PRIVASI\]\|\[URL DUKUNGAN\]" docs/rilis
```

Jika perintah di atas tidak mengeluarkan apa pun, semua placeholder sudah
hilang. Ingat: placeholder juga muncul di `privacy-policy.html` dan
`store-listing.md`.

## Hosting kebijakan privasi

Play Console dan App Store Connect mewajibkan URL publik yang bisa dibuka tanpa
login. `privacy-policy.html` sudah mandiri (tanpa CSS/JS eksternal), responsif,
dan mendukung mode gelap.

### Opsi A — GitHub Pages (gratis)

1. Inisialisasi git dan push project ke GitHub (repo boleh privat selama Pages
   diaktifkan; halaman tetap publik).
2. Buka **Settings → Pages**.
3. Pada **Build and deployment → Source**, pilih **Deploy from a branch**.
4. Pilih branch `main` dan folder **`/docs`**, lalu **Save**.
5. Tunggu 1–2 menit. URL akan berbentuk:

   ```
   https://<username>.github.io/<nama-repo>/rilis/privacy-policy.html
   ```

6. Buka URL di browser HP dan desktop, lalu salin ke Play Console dan App Store
   Connect.

Catatan: GitHub Pages memakai folder `/docs` sebagai root situs. Karena file
berada di `docs/rilis/`, path URL **selalu** menyertakan `/rilis/`.

Jika memakai custom domain, URL menjadi:

```
https://<domain-kamu>/rilis/privacy-policy.html
```

### Opsi B — Netlify Drop (paling cepat)

1. Buka <https://app.netlify.com/drop>.
2. Seret folder `docs/rilis` ke halaman tersebut.
3. Salin URL yang diberikan, misalnya
   `https://segar-abc123.netlify.app/privacy-policy.html`.
4. Simpan URL itu di `store-listing.md` dan formulir store.

### Opsi C — Cloudflare Pages / Vercel

Keduanya bisa memakai repo yang sama. Set **build command** kosong dan
**output directory** `docs/rilis`. URL mengikuti domain yang diberikan.

### Setelah hosting

- [ ] URL bisa dibuka tanpa login.
- [ ] Tampilan rapi di layar HP (tabel berubah menjadi kartu).
- [ ] Mode gelap terbaca.
- [ ] Tidak ada placeholder.
- [ ] Tanggal "Terakhir diperbarui" sudah benar.
- [ ] URL yang sama dipakai di Play Console, App Store Connect, dan listing.

## Alur memperbarui kebijakan privasi

`privacy-policy.md` adalah sumber utama; `privacy-policy.html` adalah
tampilan publik. Keduanya harus selalu sinkron.

1. Edit `privacy-policy.md`.
2. Terapkan perubahan yang sama ke `privacy-policy.html` (struktur HTML-nya
   sederhana: heading, paragraf, list, tabel).
3. Perbarui tanggal di kedua file:
   ```
   Terakhir diperbarui: <tanggal>
   Berlaku sejak: <tanggal>
   ```
4. Commit, push, dan tunggu GitHub Pages/Netlify men-deploy ulang.
5. Jika isi data berubah, perbarui juga `data-safety.md` dan formulir Data
   safety di Play Console.

## Urutan rilis yang disarankan

1. **Identitas + keystore + AAB** — prasyarat semua langkah lain.
2. **QA manual** di 2 perangkat (Android + iPhone).
3. **Hosting privacy policy** dan ganti placeholder.
4. **Ambil screenshot** dan lengkapi aset.
5. **Isi listing + Data safety + content rating**.
6. **Upload ke internal testing**, lalu closed testing, lalu production.
7. **iOS**: build di macOS → TestFlight → review.

Detail per langkah ada di `release-checklist.md`.

## Konvensi penulisan

- Bahasa Indonesia, sapaan "kamu", tanpa singkatan yang tidak umum.
- Nama fitur mengikuti label di aplikasi (lihat `lib/l10n/app_id.arb`).
- Jangan menjanjikan fitur yang belum ada.
- Jangan menyebut "gratis selamanya", "terbaik", atau klaim yang tidak bisa
  dibuktikan.
- Sebut pihak ketiga dengan namanya: Open Food Facts dan TheMealDB.
- Tanggal memakai format `11 November 2026`.

## Catatan hukum singkat

Dokumen ini bukan nasihat hukum. Sebelum rilis komersial, pastikan:

- Kebijakan privasi sesuai UU Pelindungan Data Pribadi (UU 27/2022).
- Jika kamu memakai nama badan usaha, cantumkan identitas yang benar.
- Email kontak benar-benar dipantau; Play dan Apple bisa menggunakannya untuk
  menghubungi kamu.
- Jika nanti menambahkan analitik, iklan, login, atau server, kebijakan dan
  formulir Data safety **harus** diperbarui sebelum build diunggah.
