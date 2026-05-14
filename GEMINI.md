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
- **AmalanCard**: badge (RUKUN/WAJIB/SUNNAH), status pill (BELUM/CEK/SELESAI), lock “Belum waktunya” berdasarkan `waktuTrigger`, navigasi ke detail, animasi centang (Lottie dengan fallback ikon).
- **Detail/Progress/Settings**: halaman detail lebih lengkap, ringkasan progress total & per-hari, settings simulasi tanggal/jam + reset checklist.
- **Notifikasi Sholat**: schedule pengingat Subuh/Dzuhur/Ashar/Maghrib/Isya, dibatalkan saat mode simulasi aktif.
