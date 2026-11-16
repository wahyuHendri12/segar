# Data Safety & App Privacy — Segar

Panduan mengisi formulir **Data safety** (Google Play Console) dan **App
Privacy** (App Store Connect) untuk Segar versi `1.0.0+1`.

Dokumen ini adalah jawaban yang disarankan, bukan jawaban resmi. Cocokkan
kembali dengan kode sebelum submit; jika ada fitur baru yang mengirim data,
perbarui dokumen ini dan formulirnya.

- Kebijakan privasi: `privacy-policy.md` / `privacy-policy.html`
- Versi aplikasi: `1.0.0+1`
- Target SDK Android: 36 (minSdk 24)
- Tidak ada akun, iklan, analitik, atau crash reporting pihak ketiga

## Ringkasan data

| Data | Disimpan di perangkat | Dikirim keluar | Penerima |
| --- | --- | --- | --- |
| Nama panggilan | Ya (SharedPreferences) | Tidak | — |
| Isi pantry | Ya (SQLite) | Tidak | — |
| Riwayat pemakaian | Ya (SQLite) | Tidak | — |
| Daftar belanja | Ya (SQLite) | Tidak | — |
| Pengaturan & pengingat | Ya (SharedPreferences) | Tidak | — |
| Nomor barcode | Cache 30 hari | Hanya saat pengguna memindai/mencari | Open Food Facts |
| Kata kunci resep | Cache 14 hari | Hanya saat pengguna mencari resep | TheMealDB |
| Gambar resep | Cache gambar platform | Saat resep online dibuka | CDN TheMealDB |

Tidak ada data yang dikirim ke server milik pengembang, karena pengembang tidak
memiliki server.

## Google Play — Data safety

### Pertanyaan pembuka

| Pertanyaan | Jawaban |
| --- | --- |
| Does your app collect or share any of the required user data types? | **Yes** (lihat catatan konservatif di bawah) |
| Is all of the user data collected by your app encrypted in transit? | **Yes** — semua endpoint memakai HTTPS |
| Do you provide a way for users to request that their data is deleted? | **Yes** — Pengaturan → Hapus semua data, atau uninstall |
| Do you have a privacy policy? | **Yes** — isi URL hasil hosting `privacy-policy.html` |

Catatan: jika tim hukum/store reviewer setuju bahwa barcode dan kata kunci
hanya diproses *ephemeral* (tidak disimpan pengembang, hanya diteruskan untuk
memenuhi permintaan), formulir boleh diisi **No** untuk "collect or share".
Rekomendasi kami tetap **Yes** agar tidak dianggap menyembunyikan transfer data
ke pihak ketiga. Yang dilaporkan hanya dua jenis data di bawah.

### Data types yang dipilih

| Kategori Play | Data type | Collected | Shared | Ephemeral | Optional | Purpose |
| --- | --- | --- | --- | --- | --- | --- |
| App activity | In-app search history | Yes | Yes | Yes | Yes | App functionality |
| App info & performance | — | No | No | — | — | — |
| Personal info | — | No | No | — | — | — |
| Location | — | No | No | — | — | — |
| Photos & videos | — | No | No | — | — | — |
| Files & docs | — | No | No | — | — | — |
| Contacts, calendar, messages | — | No | No | — | — | — |
| Health & fitness | — | No | No | — | — | — |
| Financial info | — | No | No | — | — | — |
| Device or other IDs | — | No | No | — | — | — |

Detail "In-app search history":

- **Collected**: kata kunci yang diketik di layar resep online. Tidak
  disimpan di server pengembang.
- **Shared**: dikirim ke TheMealDB hanya untuk memenuhi pencarian.
- **Processed ephemerally**: ya, tidak disimpan setelah respons diterima.
- **Optional**: ya. Aplikasi tetap berfungsi penuh tanpa fitur online, dan
  sakelar ada di Pengaturan.
- **Purpose**: App functionality.
- **Encrypted in transit**: ya (HTTPS).
- **Barcode**: bukan kategori data pribadi di Play (identifier produk
  kemasan), tetapi tetap dikirim ke Open Food Facts. Jika reviewer meminta
  dilaporkan, masukkan sebagai *Other app activity* dengan purpose App
  functionality, shared, ephemeral.

### Security practices

| Pertanyaan | Jawaban |
| --- | --- |
| Data encrypted in transit | Yes |
| Data deletion request | Yes (in-app) |
| Committed to Play Families policy | No — aplikasi tidak ditujukan untuk anak |
| Independent security review | No |
| Data used for advertising | No |
| Data used for analytics | No |
| Data used for personalization | No |
| Data used for fraud prevention | No |

### Yang **tidak** perlu dicentang

- Advertising or marketing
- Analytics
- Developer communications
- Account management
- Personalization
- Fraud prevention, security, and compliance
- App functionality untuk data lokal (pantry, riwayat, belanja) karena tidak
  pernah keluar dari perangkat

## Apple — App Privacy

Rekomendasi konservatif (samakan dengan Play):

| Kategori Apple | Data type | Collected | Linked to you | Tracking | Purpose |
| --- | --- | --- | --- | --- | --- |
| Usage data | Search history | Yes | No | No | App functionality |

- **Tracking**: No. Tidak ada ATT prompt, tidak ada SDK iklan, tidak ada
  penggabungan data dengan data pihak ketiga untuk iklan.
- **Data linked to you**: No. Tidak ada identitas, akun, atau device ID yang
  dikirim.
- **Data used to track you**: No.
- **Barcode**: bukan kategori data pribadi Apple; tidak perlu dilaporkan
  sebagai data type terpisah.

Alternatif paling minimal: pilih **Data Not Collected** jika tim memutuskan
bahwa permintaan real-time ke Open Food Facts/TheMealDB tidak dianggap
"collection" oleh Apple. Jangan pilih opsi ini jika nanti ada SDK pihak ketiga
yang menyimpan data.

## Justifikasi izin

### Android (`AndroidManifest.xml`)

| Izin | Alasan untuk reviewer | Wajib? |
| --- | --- | --- |
| `INTERNET` | Hanya untuk lookup barcode Open Food Facts dan resep TheMealDB yang dipicu pengguna | Tidak, fitur bisa dimatikan |
| `CAMERA` | Memindai barcode kemasan | Tidak, barcode bisa diketik manual |
| `POST_NOTIFICATIONS` | Pengingat kedaluwarsa bahan (notifikasi lokal) | Tidak, bisa ditolak |
| `RECEIVE_BOOT_COMPLETED` | Menjadwalkan ulang pengingat setelah perangkat dinyalakan ulang | Tidak |
| `VIBRATE` | Getaran pada notifikasi | Tidak |

- `android.hardware.camera` dideklarasikan `required="false"`, jadi perangkat
  tanpa kamera tetap bisa memasang aplikasi.
- Tidak ada `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`, `READ_CONTACTS`,
  `RECORD_AUDIO`, `READ_SMS`, atau `READ_PHONE_STATE`.

### iOS (`Info.plist`)

| Key | String yang dipakai | Alasan |
| --- | --- | --- |
| `NSCameraUsageDescription` | Lihat `Info.plist` | Memindai barcode kemasan |
| `NSPhotoLibraryUsageDescription` | Lihat `Info.plist` | Memilih berkas cadangan saat pemulihan |

- Tidak ada `NSLocationWhenInUseUsageDescription`, `NSContactsUsageDescription`,
  `NSMicrophoneUsageDescription`, `NSHealthShareUsageDescription`, atau
  `NSUserTrackingUsageDescription`.
- Aplikasi portrait-only; tidak ada fitur yang butuh orientasi lain.

## Catatan Auto Backup Android

`android:allowBackup="true"` membuat sistem operasi **dapat** menyertakan
database aplikasi dalam Android Auto Backup. Ini bukan transfer ke pengembang,
tetapi tetap perlu disebut di kebijakan privasi (sudah ada di bagian "Cadangan
sistem"). Jika ingin menghindari sepenuhnya, ubah menjadi `allowBackup="false"`
— tetapi ekspor/impor manual tetap tersedia di dalam aplikasi.

## Checklist sebelum submit formulir

- [ ] URL kebijakan privasi sudah aktif dan bisa dibuka tanpa login.
- [ ] Kebijakan privasi menyebut Open Food Facts dan TheMealDB.
- [ ] Placeholder `[NAMA PENGEMBANG]`, `[EMAIL KONTAK]`, `[URL KEBIJAKAN PRIVASI]` sudah diganti.
- [ ] Tidak ada SDK baru (analitik/iklan/crash) sejak dokumen ini ditulis.
- [ ] Jawaban Play dan Apple konsisten satu sama lain.
- [ ] Data safety diisi ulang jika fitur online berubah.
