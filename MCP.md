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
2. **HijriProvider** menghitung tanggal Hijriah Umm al-Qura berdasarkan `now` dan `HijriAdjustment` dari storage.
3. **PrayerTimeProvider** hanya memicu fetch saat *tanggal berubah* (day-key), lalu fetch via `PrayerTimeService` (API/fallback).
4. **NotificationService** mendengarkan hasil `PrayerTimeProvider` dan:
   - schedule pengingat sholat saat `isSimulationMode == false`.
   - cancel pengingat saat `isSimulationMode == true`.
5. **AmalanProvider** menyajikan daftar amalan + status checklist dari Hive.
6. **Validation Logic**: `AmalanCard` dan `DetailPage` memvalidasi `now` vs `triggerTime` (jam) DAN `hijriDate` vs `amalan.hariDzulhijjah` (tanggal) DAN `dependsOnAmalanId` (urutan ritual) untuk menentukan status kunci. **Exemption**: Amalan dengan `hariDzulhijjah == 99` (Tab Pulang) mengecualikan validasi tanggal otomatis.
7. **Auto-check Logic**: Provider `amalanProvider` secara otomatis mengalkulasi dan mencentang "Tahallul Awal" dan "Tahallul Tsani" berdasarkan status gabungan dari amalan spesifik (Jumrah, Cukur, Thawaf, Sa'i). Amalan ini memiliki kategori `status` dan dikecualikan dari agregasi progres.
8. **Ongoing Logic**: Filter dinamis pada `OngoingAmalanSheet` yang mengecek status `endConditionAmalanId` secara reaktif.
9. **Nafar Logic**: Logic dinamis untuk transisi antara Nafar Awal dan Nafar Tsani (Tanggal 12 vs 13) berdasarkan status checkbox "Nafar Awal" dan validasi waktu Maghrib pada amalan "Meninggalkan Mina".
10. **UI Scroll Logic**: Home Dashboard menggunakan `ListView` utama untuk menyatukan header dan list, memastikan kompatibilitas scroll pada layar kecil dan mode landscape.

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
