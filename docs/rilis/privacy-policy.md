# Kebijakan Privasi Segar

Terakhir diperbarui: 11 November 2026
Berlaku sejak: 11 November 2026

Segar ("aplikasi", "kami") adalah aplikasi pendamping dapur yang dikembangkan
oleh **[NAMA PENGEMBANG]**. Kebijakan ini menjelaskan data apa yang diproses
aplikasi, di mana data disimpan, dan kapan data keluar dari perangkatmu.

## Ringkasan

- Tidak ada akun, login, iklan, analitik, atau pelacakan.
- Data pantry, riwayat pemakaian, daftar belanja, dan pengaturan disimpan di
  perangkatmu sendiri.
- Internet hanya dipakai saat kamu memakai dua fitur opsional: cari produk
  lewat barcode dan cari resep online.
- Kami tidak memiliki server dan tidak menerima salinan datamu.

## Data yang disimpan di perangkat

Aplikasi menyimpan data berikut di database lokal (SQLite) pada perangkat:

| Data | Isi |
| --- | --- |
| Profil | Nama panggilan yang kamu isi saat onboarding |
| Pantry | Nama bahan, jumlah, satuan, kategori, lokasi penyimpanan, tanggal beli, tanggal kedaluwarsa, dan sumber tanggal |
| Riwayat pemakaian | Aksi pakai/buang, jumlah, perkiraan nilai, dan alasan pembuangan |
| Daftar belanja | Nama bahan, jumlah, satuan, dan status sudah dibeli |
| Pengaturan | Tema, pengaturan notifikasi (jam, ambang hari, jam tenang), dan sakelar fitur online |
| Cache | Hasil pencarian barcode dan detail resep online, agar bisa dibuka lagi saat offline |

Data ini tidak dikirim ke kami. Data hanya keluar dari perangkat jika kamu
memilih **Bagikan file cadangan** (file JSON yang kamu tentukan tujuannya),
atau jika sistem operasi menyertakannya dalam cadangan perangkat (lihat bagian
"Cadangan sistem").

## Data yang dikirim ke internet

Dua fitur berikut bersifat opsional, bisa dimatikan di **Pengaturan**, dan
hanya berjalan saat kamu memintanya:

| Fitur | Data yang dikirim | Tujuan | Layanan |
| --- | --- | --- | --- |
| Cari produk lewat barcode | Nomor barcode | Mengambil nama, kategori, dan ukuran produk | [Open Food Facts](https://world.openfoodfacts.org/) |
| Cari resep online | Kata kunci pencarian | Mencari resep berdasarkan kata kunci | [TheMealDB](https://www.themealdb.com/) |
| Menampilkan gambar resep | Permintaan gambar (URL) | Menampilkan foto resep | CDN TheMealDB |

Catatan:

- Isi pantry, riwayat, daftar belanja, nama panggilan, dan pengaturan **tidak
  pernah** ikut terkirim.
- Seperti permintaan internet pada umumnya, penyedia layanan dapat melihat
  alamat IP, waktu permintaan, dan user agent. Kami tidak menerima, menyimpan,
  atau memakai informasi tersebut.
- Hasil pencarian disimpan sebagai cache di perangkat. Cache resep dianggap
  kedaluwarsa setelah 14 hari dan cache barcode setelah 30 hari; keduanya bisa
  dihapus kapan saja lewat **Pengaturan → Hapus cache online**.
- Jika fitur online dimatikan atau perangkat sedang offline, aplikasi tetap
  berfungsi penuh memakai data lokal dan cache yang ada.

## Izin platform

| Izin | Dipakai untuk | Wajib? |
| --- | --- | --- |
| Internet (Android) | Dua fitur online di atas | Tidak, hanya saat fitur online aktif |
| Kamera (Android & iOS) | Memindai barcode kemasan | Tidak, bisa ketik manual |
| Notifikasi (Android 13+) | Pengingat kedaluwarsa | Tidak, bisa ditolak |
| Terima boot selesai (Android) | Menjadwalkan ulang pengingat setelah HP dinyalakan ulang | Tidak |
| Getar (Android) | Getaran notifikasi | Tidak |
| Pustaka foto (iOS) | Memilih berkas cadangan saat pemulihan | Tidak |

Aplikasi tidak meminta akses lokasi, kontak, mikrofon, atau riwayat
panggilan/SMS.

## Berbagi data

- Kami tidak menjual, menyewakan, atau membagikan datamu kepada pihak ketiga.
- Tidak ada SDK iklan, analitik, atau pelaporan crash pihak ketiga.
- Satu-satunya transfer data keluar perangkat adalah permintaan ke Open Food
  Facts dan TheMealDB yang kamu picu sendiri, seperti dijelaskan di atas.

## Penyimpanan dan penghapusan

- Data tersimpan selama aplikasi terpasang.
- **Pengaturan → Hapus semua data** menghapus seluruh data pantry, riwayat,
  daftar belanja, serta cache barcode dan resep online. Pengaturan (tema,
  pengingat, sakelar fitur online) dan nama panggilan tetap disimpan.
- Menghapus (uninstall) aplikasi menghapus semua data lokal, termasuk
  pengaturan dan nama panggilan.
- Karena kami tidak memiliki server, tidak ada data yang perlu dihapus di sisi
  kami.

## Cadangan sistem

Jika kamu mengaktifkan cadangan otomatis perangkat (Android Auto Backup atau
iCloud Backup), sistem operasi dapat menyertakan data aplikasi dalam cadangan
tersebut. Cadangan itu dikelola sepenuhnya oleh sistem operasi dan akun
platformmu; kami tidak memiliki akses ke dalamnya. Kamu bisa mematikannya di
pengaturan perangkat.

Ekspor cadangan di dalam aplikasi menghasilkan file JSON yang hanya kamu yang
menentukan ke mana file itu dibagikan.

## Hak kamu

Sesuai UU Pelindungan Data Pribadi (UU 27/2022), kamu berhak mengakses,
memperbaiki, dan menghapus data pribadimu. Karena semua data ada di
perangkatmu, hak tersebut bisa kamu jalankan langsung di aplikasi:

- **Akses & perbaikan** — buka layar Pantry atau Pengaturan.
- **Penghapusan** — Pengaturan → Hapus semua data, atau hapus aplikasi.
- **Portabilitas** — Pengaturan → Cadangan & pemulihan → Bagikan file cadangan.

## Anak-anak

Segar tidak ditujukan untuk anak di bawah 13 tahun dan tidak dengan sengaja
mengumpulkan data dari anak-anak. Aplikasi tidak memiliki akun atau fitur
sosial.

## Perubahan kebijakan

Jika ada perubahan material, versi baru akan diterbitkan di halaman ini dengan
tanggal pembaruan yang baru. Perubahan berlaku sejak tanggal yang tertera.

## Kontak

Pertanyaan tentang kebijakan ini atau data pribadimu:

- Pengembang: **[NAMA PENGEMBANG]**
- Email: **[EMAIL KONTAK]**
- Halaman ini: **[URL KEBIJAKAN PRIVASI]**

---

> Sebelum dipublikasikan, ganti semua placeholder `[NAMA PENGEMBANG]`,
> `[EMAIL KONTAK]`, dan `[URL KEBIJAKAN PRIVASI]` dengan data sebenarnya.
> Lihat `docs/rilis/README.md` untuk cara memasang halaman ini.
