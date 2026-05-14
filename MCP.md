# MCP (MODEL CONTEXT PROTOCOL): AMALAN HAJI

Dokumen ini mendokumentasikan protokol konteks, arsitektur layanan, dan standar data untuk sinkronisasi pemahaman antara developer dan AI.

## 1. Arsitektur Layanan (Service Layer)

| Service | Tanggung Jawab |
|---|---|
| **StorageService** | Manajemen data lokal via Hive (Checklist progres). |
| **PrayerTimeService** | Integrasi Aladhan API & Fallback Offline. |
| **ClockService** | Manajemen state waktu (Real-time & Simulasi). |
| **NotificationService** | Penjadwalan pengingat lokal berdasarkan waktu sholat. |

## 2. Alur Data (Data Flow)
1. **Clock** memancarkan waktu aktif.
2. **PrayerTimeProvider** mendengarkan waktu aktif -> Fetch API/Fallback.
3. **AmalanProvider** memfilter data berdasarkan hari Dzulhijjah saat ini.
4. **UI** me-render komponen berdasarkan gabungan state tersebut.

## 3. Protokol Penyimpanan (Hive)
- **Box Name**: `amalan_checklist`
- **Key Pattern**: `hari_{dzulhijjah}_{amalanId}`
- **Value**: `bool` (true = selesai).

## 4. Best Practices
- **Atomic Operations**: Pastikan update status amalan bersifat atomik di state notifier dan storage.
- **UI Performance**: Gunakan `const` constructor dan hindari rebuild yang tidak perlu.
- **Asset Management**: Pastikan asset Lottie dan SVG terdaftar di `pubspec.yaml`.
