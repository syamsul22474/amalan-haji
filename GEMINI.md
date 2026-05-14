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
- **UI/UX**: Dark Mode default, Gold Accent, Poppins & Amiri Fonts.

## 3. Standar Coding & Arsitektur
- **Struktur Folder**: Ikuti pola `core/`, `features/`, dan `shared/`.
- **State Management**: Selalu gunakan `ProviderScope` dan `ConsumerWidget`/`ConsumerStatefulWidget`.
- **Naming Convention**: Gunakan camelCase untuk variabel/fungsi, PascalCase untuk class, dan snake_case untuk asset.
- **Error Handling**: Selalu sertakan fallback (terutama pada `PrayerTimeService`).

## 4. Simulasi Waktu (ClockService)
Fitur kritis untuk pengujian. Semua logika yang bergantung pada waktu harus menggunakan `clockProvider`, bukan `DateTime.now()` secara langsung.

## 5. Metadata Proyek
- **Bundle ID**: `id.zoma.amalan_haji`
- **Developer Context**: Fokus pada user experience jamaah haji Indonesia.
