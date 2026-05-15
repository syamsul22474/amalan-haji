# GEMINI GUIDELINES: AMALAN HAJI

Dokumen ini berfungsi sebagai panduan utama bagi **Gemini CLI** (AI Assistant) dalam memahami konteks, arsitektur, dan standar pengembangan proyek **Amalan Haji**.

## 1. Ringkasan Proyek
Aplikasi mobile (Flutter) panduan ibadah haji 8-13 Dzulhijjah.
- **Platform**: Android & iOS.
- **Prinsip**: Offline-first, No Backend.
- **Data**: Hardcoded amalan haji (Statis).

## 2. Tech Stack Utama
- **Framework**: Flutter (Dart).
- **State Management**: Riverpod (`flutter_riverpod`).
- **Local Storage**: Hive (`hive`, `hive_flutter`).
- **HTTP Client**: Dio (untuk Aladhan API).
- **Notifikasi Lokal**: `flutter_local_notifications` + `timezone` + `flutter_timezone`.
- **UI/UX**: Dark Mode default, Gold Accent, Poppins & Amiri Fonts.

## 3. Standar Coding & Arsitektur
- **Struktur Folder**: Ikuti pola `core/`, `features/`, dan `shared/`.
- **State Management**: Selalu gunakan `ProviderScope` dan `ConsumerWidget`/`ConsumerStatefulWidget`.
- **Naming Convention**: Gunakan camelCase untuk variabel/fungsi, PascalCase untuk class, dan snake_case untuk asset.
- **Error Handling**: Selalu sertakan fallback (terutama pada `PrayerTimeService`).

## 4. Simulasi Waktu (ClockService)
Fitur kritis untuk pengujian.
- Semua logika UI yang bergantung pada waktu harus menggunakan `clockProvider`, bukan `DateTime.now()` secara langsung.
- `clockProvider` menyimpan `now` dan status `isSimulationMode` (mode real-time vs simulasi).
- Saat mode simulasi aktif, aplikasi wajib menampilkan banner peringatan (oranye) di semua halaman utama (Home/Detail/Progress/Settings).
- Penjadwalan notifikasi berjalan hanya saat mode simulasi non-aktif (agar tidak menyesatkan saat pengujian).

## 5. Metadata Proyek
- **Bundle ID**: `id.zoma.amalan_haji`
- **Developer Context**: Fokus pada user experience jamaah haji Indonesia.

## 6. Implementasi Terbaru (Ringkas)
- **Kalender Umm al-Qura**: Menggunakan standar resmi Arab Saudi dengan fitur `HijriAdjustment` yang dipersistenkan di Hive.
- **Home Dashboard**: Redesain progres menggunakan kartu horizontal (Hari Ini, Rukun, Wajib) dengan desain Glassmorphism dan interaksi Bottom Sheet untuk amalan tersisa. Mengganti nama aplikasi menjadi "Ceklis Amalan Haji".
- **Validasi Amalan**:
    - **Time & Date Lock**: Amalan terkunci jika belum masuk tanggal Hijriah atau jam pelaksanaannya.
    - **Warning Snackbar**: Pesan edukatif saat mencoba mencentang amalan yang terkunci.
    - **Uncheck Protection**: Dialog konfirmasi saat membatalkan status amalan yang sudah selesai.
    - **Auto-check Logic**: Amalan "Tahallul Awal" dan "Tahallul Tsani" dicentang otomatis oleh sistem (mengunci interaksi manual dari pengguna) berdasarkan progres penyelesaian amalan Lontar Jumrah Aqabah, Bercukur, Thawaf Ifadhah, dan Sa'i.
    - **Sequential Dependency**: Proteksi urutan amalan (seperti Lontar Jumrah Ula -> Wustho -> Aqabah) menggunakan `dependsOnAmalanId` untuk mencegah pengerjaan amalan yang melompati urutan.
- **Ongoing Amalan**: Fitur monitoring amalan berkelanjutan (seperti Talbiyah) yang berakhir berdasarkan dependency amalan lain (seperti Lontar Jumrah Aqabah).
- **Date Header**: Tampilan real-time jam simulasi untuk memudahkan pengujian.
- **Pembaruan Data & Logika Nafar**:
    - **Nafar Awal Logic**: Validasi waktu "Meninggalkan Mina" di tanggal 12 (harus sebelum Maghrib). Kegagalan Nafar Awal akan memunculkan kembali Tab Tanggal 13 agar jamaah bisa menyelesaikan ritual Nafar Tsani.
    - **Tab Pulang**: Penambahan tab khusus "Pulang" (ID hari 99) untuk ritual Thawaf Wada' agar tidak terikat tanggal tertentu.
    - **Jenis Amalan Pilihan & Status**: Menambahkan kategori `pilihan` (badge biru) untuk "Nafar Awal" dan kategori `status` (badge teal) untuk "Tahallul Awal/Tsani". Kategori `status` dikecualikan dari seluruh perhitungan progres (Wajib Haji & Progres Harian).
    - **Fix Lock 99**: Pengecualian proteksi tanggal untuk amalan dengan hariDzulhijjah 99 agar tidak terkunci secara otomatis.
    - **Landscape Scrolling**: Implementasi scroll vertikal tunggal pada Home Dashboard untuk mencegah overflow pada mode landscape.
- **Prayer Times Offline Caching**:
    - Memperbarui waktu sholat default (*hardcode*) untuk menyesuaikan dengan waktu aktual musim haji akhir Mei 2026.
    - Implementasi *caching* otomatis ke Hive (`prayer_times_cache`). Jika ada internet, jadwal diunduh dan disimpan; jika *offline*, jadwal dimuat dari cache lokal tanpa *error*.
    - Menambahkan label "*Waktu sholat untuk wilayah Makkah" di dasbor untuk mencegah kerancuan zona waktu bagi jamaah.

## 7. Distribusi & CI/CD (Firebase App Distribution)
- **Tools**: Menggunakan `firebase-tools` (lokal) dan `flutterfire_cli`.
- **Workflow**: 
    1. Login via `npx firebase login`.
    2. Konfigurasi via `flutterfire configure`.
    3. Eksekusi script `./scripts/distribute_android.sh` untuk otomatisasi build & upload APK ke grup "testers".
