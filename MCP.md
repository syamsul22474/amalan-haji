# MCP (MODEL CONTEXT PROTOCOL): AMALAN HAJI

Dokumen ini mendokumentasikan protokol konteks, arsitektur layanan, dan standar data untuk sinkronisasi pemahaman antara developer dan AI.

## 1. Arsitektur Layanan (Service Layer)

| Service | Tanggung Jawab |
|---|---|
| **StorageService** | Manajemen data lokal via Hive (Checklist progres). |
| **PrayerTimeService** | Integrasi Aladhan API & Fallback Offline. |
| **ClockService** | Manajemen state waktu (Real-time & Simulasi) melalui `clockProvider` (`now` + `isSimulationMode`). |
| **NotificationService** | Penjadwalan pengingat lokal berdasarkan waktu sholat (hanya saat mode simulasi non-aktif). |

## 2. Alur Data (Data Flow)
1. **Clock** memancarkan state waktu aktif (`now`) + flag `isSimulationMode`.
2. **PrayerTimeProvider** hanya memicu fetch saat *tanggal berubah* (day-key), lalu fetch via `PrayerTimeService` (API/fallback).
3. **NotificationService** mendengarkan hasil `PrayerTimeProvider` dan:
   - schedule pengingat sholat (Subuh/Dzuhur/Ashar/Maghrib/Isya) saat `isSimulationMode == false`
   - cancel pengingat saat `isSimulationMode == true`
4. **CurrentDayProvider** mengikuti hijri day dari clock (auto), tetapi berhenti override jika user memilih hari secara manual.
5. **AmalanProvider** menyajikan daftar amalan + status checklist dari Hive; update checklist dilakukan atomik (tulis storage + update state).
6. **UI** merender komponen berdasarkan gabungan state tersebut (termasuk banner simulasi dan state “Belum waktunya” di AmalanCard).

## 3. Protokol Penyimpanan (Hive)
- **Box Name**: `amalan_checklist`
- **Key Pattern**: `hari_{dzulhijjah}_{amalanId}`
- **Value**: `bool` (true = selesai).

## 4. Best Practices
- **Atomic Operations**: Pastikan update status amalan bersifat atomik di state notifier dan storage.
- **UI Performance**: Gunakan `const` constructor dan hindari rebuild yang tidak perlu.
- **Asset Management**: Pastikan asset Lottie dan SVG terdaftar di `pubspec.yaml`.
- **Simulasi Waktu**: Jangan jadwalkan notifikasi pada mode simulasi; tampilkan banner simulasi secara konsisten.
- **Prayer Time Re-fetch**: Hindari refetch tiap detik; gunakan day-key (tahun/bulan/hari) untuk invalidasi provider.
