# PROJECT REQUIREMENT DOCUMENT
## Aplikasi Mobile: **AMALAN HAJI**
### Panduan Checklist Ibadah Haji Berbasis Flutter

---

| Atribut | Detail |
|---|---|
| **Platform** | Android & iOS (Flutter) |
| **Framework** | Flutter + Dart |
| **Backend** | Tidak diperlukan (Offline-first) |
| **External API** | Aladhan API (Waktu Sholat Makkah) |
| **Versi Dokumen** | v1.1 — Mei 2025 |

---

## Daftar Isi

1. [Ringkasan Eksekutif](#1-ringkasan-eksekutif)
2. [Domain Knowledge: Data Amalan Haji](#2-domain-knowledge-data-amalan-haji)
3. [Arsitektur Teknis](#3-arsitektur-teknis)
4. [Model Data](#4-model-data-data-models)
5. [Integrasi API Eksternal](#5-integrasi-api-eksternal)
6. [Fitur Simulasi Tanggal & Jam](#6-fitur-simulasi-tanggal--jam)
7. [Spesifikasi UI/UX](#7-spesifikasi-uiux)
8. [Fitur Notifikasi & Pengingat](#8-fitur-notifikasi--pengingat)
9. [Package UI & Panduan Penggunaan](#9-package-ui--panduan-penggunaan)
10. [Alur Logika Bisnis](#10-alur-logika-bisnis)
11. [Rencana Pengembangan (Roadmap)](#11-rencana-pengembangan-development-roadmap)
12. [Konfigurasi pubspec.yaml](#12-konfigurasi-pubspecyaml)
13. [Catatan Penting untuk AI Coder](#13-catatan-penting-untuk-ai-coder)

---

## 1. Ringkasan Eksekutif

Dokumen ini merupakan Project Requirement Document (PRD) lengkap untuk pembangunan aplikasi mobile bernama **AMALAN HAJI**. Aplikasi ini dirancang untuk membantu jamaah haji Indonesia dalam melaksanakan seluruh rangkaian ibadah haji dengan benar, terstruktur, dan terdokumentasi dengan baik.

### 1.1 Latar Belakang

Ibadah haji merupakan rukun Islam kelima yang memiliki rangkaian amalan sangat kompleks, berlangsung dalam waktu singkat (6 hari aktif: 8–13 Dzulhijjah), dan terbagi dalam tiga kategori keutamaan syariat yaitu **Rukun**, **Wajib**, dan **Sunnah**. Jamaah haji seringkali kesulitan memantau amalan mana yang sudah atau belum dilaksanakan, serta tidak selalu mengetahui waktu-waktu kritis yang dikaitkan dengan jadwal sholat di Makkah.

### 1.2 Tujuan Aplikasi

- Menjadi panduan interaktif seluruh amalan haji dari 8 s.d. 13 Dzulhijjah
- Menampilkan checklist harian yang dapat dicentang oleh user
- Membedakan secara visual amalan Rukun, Wajib, dan Sunnah
- Menampilkan waktu sholat Makkah secara real-time dari API eksternal
- Memberikan notifikasi pengingat amalan berdasarkan waktu sholat
- Menyediakan fitur simulasi tanggal/jam untuk keperluan testing
- **Kalender Umm al-Qura**: Standar kalender Hijriah resmi Arab Saudi dengan fitur penyesuaian (adjustment) hari.
- **Validasi Cerdas**: Mencegah pengerjaan amalan sebelum waktunya (berdasarkan tanggal dan jam).
- **Proteksi Data**: Konfirmasi dialog saat membatalkan (uncheck) status amalan yang sudah selesai.
- **Amalan Berlangsung**: Menu khusus untuk memantau amalan berkelanjutan (multi-day) hingga kondisi berakhirnya terpenuhi.

### 1.3 Target Pengguna

Jamaah haji Indonesia, calon jamaah haji yang ingin belajar, dan pembimbing/mutawwif yang mendampingi rombongan.

---

## 2. Domain Knowledge: Data Amalan Haji

Seluruh data amalan bersifat **statis** berdasarkan ketentuan syariat Islam dan direferensikan dari kitab *Hadis-Hadis Seputar Ibadah Haji dari Sahih Bukhari dan Muslim*. Data ini di-hardcode langsung di dalam kode Dart, **tidak memerlukan database server**.

### 2.1 Kategori Amalan

| Kategori | Badge | Warna | Keterangan |
|---|---|---|---|
| **RUKUN** | `[RUKUN]` | 🔴 Merah `#C62828` | Tidak sah jika ditinggalkan |
| **WAJIB** | `[WAJIB]` | 🟠 Oranye `#E65100` | Sah tapi wajib bayar dam jika ditinggal |
| **SUNNAH** | `[SUNNAH]` | 🟢 Hijau `#2E7D32` | Dianjurkan untuk menyempurnakan pahala |
| **PILIHAN** | `[PILIHAN]` | 🔵 Biru `Colors.blue` | Pilihan manasik (seperti Nafar Awal) |
| **STATUS** | `[STATUS]` | 💠 Teal `Colors.teal` | Indikator status (tidak masuk hitungan progres) |

---

### 2.2 Master Data Amalan Per Hari

#### Hari ke-1: 8 Dzulhijjah (Hari Tarwiyah)

| No | Nama Amalan | Kategori | Keterangan |
|---|---|---|---|
| 1 | Memakai Wewangian sebelum Ihram | SUNNAH | Disunahkan memakai minyak wangi di badan |
| 2 | Ihram dari Miqat / Tempat Tinggal | **RUKUN** | Niat ihram disertai mandi & memakai wewangian |
| 3 | Mengucapkan Talbiyah | SUNNAH | Mulai ihram hingga lontar Jumrah Aqabah |
| 4 | Berangkat ke Mina | SUNNAH | Mabit di Mina malam 8 Dzulhijjah |
| 5 | Sholat 5 Waktu di Mina (Qashar) | SUNNAH | Dzuhur, Ashar, Maghrib, Isya, Subuh — qashar tanpa jamak |

#### Hari ke-2: 9 Dzulhijjah (Hari Arafah)

| No | Nama Amalan | Kategori | Keterangan |
|---|---|---|---|
| 1 | Bertolak ke Arafah setelah Subuh | SUNNAH | Berangkat setelah matahari terbit |
| 2 | Sholat Dzuhur & Ashar Jamak Qashar | SUNNAH | Dijamak taqdim, diqashar di Arafah |
| 3 | Wukuf di Arafah | **RUKUN** | Rukun: Hadir di Arafah. Wajib: Hadir di Arafah dari tergelincir matahari hingga terbenam |
| 4 | Perbanyak Dzikir & Doa di Arafah | SUNNAH | Menghadap kiblat, angkat tangan |
| 5 | Bertolak ke Muzdalifah setelah Maghrib | SUNNAH | Berangkat setelah matahari terbenam dengan tenang |
| 6 | Mabit di Muzdalifah | **WAJIB** | Menginap hingga terbit fajar |
| 7 | Sholat Maghrib & Isya Jamak Takhir Qashar | SUNNAH | Di Muzdalifah, satu azan dua iqamat |

#### Hari ke-3: 10 Dzulhijjah (Idul Adha / Hari Nahr)

| No | Nama Amalan | Kategori | Keterangan |
|---|---|---|---|
| 1 | Sholat Subuh di Awal Waktu | SUNNAH | Di Muzdalifah, lebih awal dari biasanya |
| 2 | Berdoa Kepada Allah hingga menjelang terbit matahari | SUNNAH | Sebelum matahari terbit |
| 3 | Bertolak ke Mina sebelum Matahari Terbit | SUNNAH | Berangkat sebelum matahari terbit |
| 4 | Lontar Jumrah Aqabah | **WAJIB** | 7 batu, bertakbir setiap lemparan. Waktu: Tengah malam 10 Dzul s.d sebelum Subuh 11 Dzul |
| 5 | Menyembelih Hewan Kurban (Hadyu) | **WAJIB** | Diwajibkan bagi yang berhaji Tamattu dan Qiron. Waktu: 10 s.d terbenam 13 Dzul |
| 6 | Bercukur/Potong Rambut | **WAJIB** | Cukur atau potong rambut merata (mencukur rambut dari segala sisi kepala) |
| 7 | Thawaf Ifadhah | **RUKUN** | 7 putaran Ka'bah, tidak disunahkan roml. Sunnah siang 10 Dzul. |
| 8 | Sa'i Shafa-Marwah | **RUKUN** | 7 kali, berlari kecil di lembah al-Masil |
| 9 | Tahallul Awal | STATUS | Dihalalkan segala sesuatu kecuali hal yang berkaitan dengan wanita |
| 10 | Tahallul Tsani | STATUS | Telah halal segala yang sebelumnya diharamkan saat ihram |
| 11 | Mabit di Mina malam 11 Dzulhijjah | **WAJIB** | Kembali ke Mina setelah Thawaf Ifadhah |

#### Hari ke-4: 11 Dzulhijjah (Tasyriq Pertama)

| No | Nama Amalan | Kategori | Keterangan |
|---|---|---|---|
| 1 | Lontar Jumrah Ula (Sughra) | **WAJIB** | 7 batu setelah Dzuhur, berdoa setelahnya |
| 2 | Lontar Jumrah Wustha | **WAJIB** | 7 batu setelah Ula, berdoa setelahnya (Dilakukan setelah Ula) |
| 3 | Lontar Jumrah Aqabah (Kubra) | **WAJIB** | 7 batu, tidak berdoa setelahnya (Dilakukan setelah Wustha) |
| 4 | Mabit di Mina malam 12 Dzulhijjah | **WAJIB** | Menginap di Mina |

#### Hari ke-5: 12 Dzulhijjah (Tasyriq Kedua)

| No | Nama Amalan | Kategori | Keterangan |
|---|---|---|---|
| 1 | Lontar Jumrah Ula (Sughra) | **WAJIB** | 7 batu setelah Dzuhur, berdoa setelahnya |
| 2 | Lontar Jumrah Wustha | **WAJIB** | 7 batu setelah Ula, berdoa setelahnya (Dilakukan setelah Ula) |
| 3 | Lontar Jumrah Aqabah (Kubra) | **WAJIB** | 7 batu, tidak berdoa setelahnya (Dilakukan setelah Wustha) |
| 4 | Nafar Awal (Opsional) | **WAJIB** | Boleh meninggalkan Mina sebelum Maghrib |
| 5 | Mabit di Mina malam 13 Dzulhijjah | **WAJIB** | Bagi yang tidak mengambil Nafar Awal |
| 6 | Meninggalkan Mina | **WAJIB** | Bagi yang Nafar Awal, dilakukan sebelum Maghrib |
| 7 | Thawaf Wada' | **WAJIB** | Bagi yang Nafar Awal (Selesai Haji) |

> [!IMPORTANT]
> **Logika Nafar Awal**:
> - Jika "Nafar Awal" dicentang, amalan "Meninggalkan Mina" muncul di Tanggal 12.
> - Tab Tanggal 13 akan disembunyikan jika Nafar Awal berhasil dilakukan sebelum Maghrib.
> - Jika "Meninggalkan Mina" dilakukan **setelah Maghrib**, sistem akan mendeteksi sebagai kegagalan Nafar Awal dan memunculkan kembali Tab Tanggal 13 untuk ritual Nafar Tsani.

#### Hari ke-6: 13 Dzulhijjah (Tasyriq Ketiga — Nafar Tsani)

| No | Nama Amalan | Kategori | Keterangan |
|---|---|---|---|
| 1 | Lontar Jumrah Ula (Sughra) | **WAJIB** | Bagi yang Nafar Tsani, setelah Dzuhur |
| 2 | Lontar Jumrah Wustha | **WAJIB** | 7 batu setelah Ula, berdoa setelahnya (Dilakukan setelah Ula) |
| 3 | Lontar Jumrah Aqabah (Kubra) | **WAJIB** | 7 batu, tidak berdoa setelahnya (Dilakukan setelah Wustha) |
| 4 | Meninggalkan Mina | **WAJIB** | Setelah selesai lontar |

#### Tab Pulang (Ritual Terakhir)

| No | Nama Amalan | Kategori | Keterangan |
|---|---|---|---|
| 1 | Thawaf Wada' | **WAJIB** | Amalan terakhir sebelum meninggalkan Makkah |

> [!NOTE]
> **Tab Pulang**: Tab ini khusus untuk ritual terakhir haji yang waktunya tidak terikat pada tanggal tertentu, melainkan pada saat jamaah akan benar-benar meninggalkan Makkah.

---

## 3. Arsitektur Teknis

### 3.1 Prinsip Utama: Offline-First, No Backend Required

> Aplikasi bekerja penuh **tanpa server backend** (tidak perlu Laravel, FastAPI, Node.js, dll). Satu-satunya koneksi internet yang dibutuhkan adalah untuk mengambil jadwal waktu sholat dari Aladhan API. Seluruh data amalan disimpan hardcoded di Dart, dan progress checklist user disimpan di local storage (Hive) di dalam perangkat user.

```
┌─────────────────────────────────────────────────────┐
│                   Flutter App                        │
│                                                      │
│   ┌────────────────┐          ┌──────────────────┐   │
│   │   Hive (Lokal) │◄────────►│  Aladhan API     │   │
│   │                │          │  (Internet)      │   │
│   │  - Checklist   │          │                  │   │
│   │  - Progress    │          │  - Waktu Sholat  │   │
│   └────────────────┘          └──────────────────┘   │
│                                                      │
│   ┌────────────────────────────────────────────┐     │
│   │  amalan_data.dart (Hardcoded, Static)      │     │
│   │  Semua data amalan 8-13 Dzulhijjah         │     │
│   └────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────┘
         Tidak ada server di tengah-tengah ✅
```

---

### 3.2 Tech Stack Lengkap

| Kategori | Teknologi / Package | Versi | Fungsi |
|---|---|---|---|
| Core Framework | Flutter SDK (stable) | Latest stable | Framework utama cross-platform |
| Core Language | Dart | 3.x | Bahasa pemrograman |
| State Management | `flutter_riverpod` | `^2.5.1` | Global state: amalan, waktu, simulasi |
| Local Storage | `hive` + `hive_flutter` | `^2.2.3` | Simpan checklist user secara lokal |
| HTTP Client | `dio` | `^5.4.3` | Fetch waktu sholat dari Aladhan API |
| Kalender Hijriah | `hijri` | `^2.0.1` | Konversi & tampilkan tanggal Dzulhijjah |
| Format Tanggal | `intl` | `^0.19.0` | Format jam, tanggal lokal |
| Notifikasi | `flutter_local_notifications` | `^17.2.2` | Reminder amalan berdasarkan waktu sholat |
| Font | `google_fonts` | `^6.2.1` | Poppins (modern), Amiri (Arab nuansa) |
| Animasi | `flutter_animate` | `^4.5.0` | Animasi fade, slide komponen |
| Animasi Lottie | `lottie` | `^3.1.2` | Animasi centang & ilustrasi Ka'bah |
| Loading State | `shimmer` | `^3.0.0` | Skeleton loading saat fetch API |
| Progress | `percent_indicator` | `^4.2.3` | Progress ring % amalan selesai per hari |
| Efek Kaca | `glassmorphism` | `^3.0.0` | Efek blur card modern |
| Bottom Nav | `salomon_bottom_bar` | `^3.3.2` | Bottom navigation minimalis |
| Celebration | `confetti` | `^0.7.0` | Konfeti saat semua amalan selesai |
| Theme | `flex_color_scheme` | `^7.3.1` | Material 3 theme builder |
| Icon SVG | `flutter_svg` | `^2.0.10+1` | Icon SVG custom (bulan sabit, Ka'bah) |
| Simulasi Waktu | `clock` (custom service) | — | Override `DateTime.now()` untuk testing |

---

### 3.3 Struktur Folder Project

```
lib/
├── main.dart                         # Entry point app
├── core/
│   ├── constants/
│   │   ├── amalan_data.dart          # Master data amalan (hardcoded)
│   │   ├── app_colors.dart           # Palet warna tema
│   │   └── app_strings.dart          # String/teks konstan
│   ├── models/
│   │   ├── amalan.dart               # Model data amalan
│   │   ├── amalan_hari.dart          # Kumpulan amalan per hari
│   │   └── prayer_time.dart          # Model waktu sholat
│   ├── services/
│   │   ├── prayer_time_service.dart  # Fetch & cache Aladhan API
│   │   ├── storage_service.dart      # CRUD Hive (checklist)
│   │   ├── notification_service.dart # Jadwal notifikasi lokal
│   │   └── clock_service.dart        # Simulasi tanggal/jam
│   └── providers/                    # Riverpod providers
│       ├── amalan_provider.dart
│       ├── prayer_time_provider.dart
│       └── clock_provider.dart
├── features/
│   ├── splash/                       # Splash screen
│   ├── home/
│   │   ├── home_page.dart            # Halaman utama (timeline)
│   │   └── widgets/
│   │       ├── amalan_card.dart      # Card amalan + badge
│   │       ├── day_selector.dart     # Pilih hari (8-13 Dzulhijjah)
│   │       └── waktu_sholat_bar.dart # Bar waktu sholat Makkah
│   ├── detail/
│   │   └── amalan_detail_page.dart   # Detail amalan lengkap
│   ├── progress/
│   │   └── progress_page.dart        # Ringkasan & progress chart
│   └── settings/
│       └── settings_page.dart        # Simulasi waktu & pengaturan
└── shared/
    └── widgets/
        ├── badge_widget.dart          # Badge RUKUN/WAJIB/SUNNAH
        ├── loading_shimmer.dart
        └── empty_state_widget.dart
```

---

## 4. Model Data (Data Models)

### 4.1 Enum JenisAmalan

```dart
enum JenisAmalan {
  rukun,   // Wajib — tidak sah jika ditinggalkan
  wajib,   // Harus dikerjakan — bayar dam jika ditinggal
  sunnah,  // Dianjurkan — menyempurnakan pahala
  pilihan, // Pilihan manasik (e.g. Nafar Awal)
  status,  // Indikator status (e.g. Tahallul) — tidak masuk progres
}
```

### 4.2 Model Amalan

```dart
class Amalan {
  final String id;               // Unique identifier, e.g. 'wukuf_arafah'
  final String nama;             // Nama amalan
  final String deskripsi;        // Penjelasan singkat
  final String dalil;            // Referensi hadis (opsional)
  final JenisAmalan jenis;       // rukun / wajib / sunnah
  final int hariDzulhijjah;      // 8, 9, 10, 11, 12, atau 13
  final int? hariDzulhijjahEnd;  // Batas akhir hari (untuk amalan multi-day)
  final String? endConditionAmalanId; // Dependency amalan lain untuk berhenti (misal: talbiyah berhenti saat aqabah selesai)
  final String? waktuTrigger;    // 'fajr'|'syuruq'|'dhuhr'|'asr'|'maghrib'|'isha'
  final String? waktuKeterangan; // e.g. "Setelah matahari terbenam"
  final bool sudahDilakukan;     // State checklist (tersimpan di Hive)
  final int urutan;              // Urutan tampil dalam hari

  const Amalan({
    required this.id,
    required this.nama,
    required this.deskripsi,
    this.dalil = '',
    required this.jenis,
    required this.hariDzulhijjah,
    this.waktuTrigger,
    this.waktuKeterangan,
    this.sudahDilakukan = false,
    required this.urutan,
  });

  Amalan copyWith({bool? sudahDilakukan}) => Amalan(
    id: id, nama: nama, deskripsi: deskripsi, dalil: dalil,
    jenis: jenis, hariDzulhijjah: hariDzulhijjah,
    waktuTrigger: waktuTrigger, waktuKeterangan: waktuKeterangan,
    sudahDilakukan: sudahDilakukan ?? this.sudahDilakukan,
    urutan: urutan,
  );
}
```

### 4.3 Model PrayerTime

```dart
class PrayerTime {
  final DateTime fajr;     // Subuh / Fajar
  final DateTime syuruq;   // Terbit matahari
  final DateTime dhuhr;    // Dzuhur
  final DateTime asr;      // Ashar
  final DateTime maghrib;  // Maghrib
  final DateTime isha;     // Isya
  final DateTime date;     // Tanggal data ini berlaku

  const PrayerTime({
    required this.fajr, required this.syuruq, required this.dhuhr,
    required this.asr, required this.maghrib, required this.isha,
    required this.date,
  });

  factory PrayerTime.fromJson(Map<String, dynamic> json, DateTime date) {
    // Parse format HH:mm dari Aladhan API
    // Konversi ke Asia/Riyadh timezone
  }
}
```

### 4.4 Struktur Penyimpanan Hive

```dart
// Key format: 'hari_{dzulhijjah}_{amalanId}'
// Contoh: 'hari_9_wukuf_arafah' = true/false

class StorageService {
  static const _boxName = 'amalan_checklist';

  Future<void> setAmalanStatus(int hari, String amalanId, bool status) async {
    final box = await Hive.openBox(_boxName);
    await box.put('hari_${hari}_${amalanId}', status);
  }

  Future<bool> getAmalanStatus(int hari, String amalanId) async {
    final box = await Hive.openBox(_boxName);
    return box.get('hari_${hari}_${amalanId}', defaultValue: false);
  }

  Future<void> resetAllChecklist() async {
    final box = await Hive.openBox(_boxName);
    await box.clear();
  }
}
```

---

## 5. Integrasi API Eksternal

### 5.1 Aladhan API — Waktu Sholat Makkah

> **Endpoint:**
> ```
> GET https://api.aladhan.com/v1/timingsByCity
>     ?city=Makkah
>     &country=SA
>     &method=4
>     &date={DD-MM-YYYY}
> ```
> API ini **gratis**, tidak memerlukan API Key, dan mendukung parameter tanggal spesifik untuk simulasi.

**Contoh Response JSON:**

```json
{
  "code": 200,
  "data": {
    "timings": {
      "Fajr":    "04:32",
      "Sunrise": "05:58",
      "Dhuhr":   "12:15",
      "Asr":     "15:37",
      "Maghrib": "18:32",
      "Isha":    "20:02"
    },
    "date": {
      "gregorian": { "date": "14-05-2025" }
    }
  }
}
```

### 5.2 Implementasi PrayerTimeService

```dart
class PrayerTimeService {
  static const _baseUrl = 'https://api.aladhan.com/v1/timingsByCity';
  final Dio _dio;

  Future<PrayerTime> fetchWaktuSholat(DateTime tanggal) async {
    final dateStr = DateFormat('dd-MM-yyyy').format(tanggal);

    try {
      final response = await _dio.get(_baseUrl, queryParameters: {
        'city':    'Makkah',
        'country': 'SA',
        'method':  '4',  // Umm Al-Qura (resmi Saudi)
        'date':    dateStr,
      });

      if (response.statusCode == 200) {
        final timings = response.data['data']['timings'];
        return PrayerTime.fromJson(timings, tanggal);
      }
      throw Exception('Gagal mengambil jadwal sholat');

    } on DioException {
      // Jika offline, kembalikan data fallback default
      return _getDefaultPrayerTime(tanggal);
    }
  }

  PrayerTime _getDefaultPrayerTime(DateTime tanggal) {
    return PrayerTime(
      fajr:    DateTime(tanggal.year, tanggal.month, tanggal.day, 4, 32),
      syuruq:  DateTime(tanggal.year, tanggal.month, tanggal.day, 5, 58),
      dhuhr:   DateTime(tanggal.year, tanggal.month, tanggal.day, 12, 15),
      asr:     DateTime(tanggal.year, tanggal.month, tanggal.day, 15, 37),
      maghrib: DateTime(tanggal.year, tanggal.month, tanggal.day, 18, 32),
      isha:    DateTime(tanggal.year, tanggal.month, tanggal.day, 20, 2),
      date:    tanggal,
    );
  }
}
```

---

## 6. Fitur Simulasi Tanggal & Jam

Fitur simulasi memungkinkan developer dan tester untuk mengubah tanggal dan jam secara manual tanpa harus menunggu waktu sesungguhnya. Sangat penting untuk menguji fitur yang terikat waktu seperti notifikasi, tampilan amalan per hari, dan perubahan UI berdasarkan waktu sholat.

### 6.1 ClockService Implementation

```dart
final clockProvider = StateNotifierProvider<ClockNotifier, DateTime>((ref) {
  return ClockNotifier();
});

class ClockNotifier extends StateNotifier<DateTime> {
  ClockNotifier() : super(DateTime.now());

  bool _isSimulationMode = false;
  Timer? _realTimeTimer;

  // Mode normal: update setiap detik
  void startRealTime() {
    _isSimulationMode = false;
    _realTimeTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => state = DateTime.now(),
    );
  }

  // Mode simulasi: set tanggal/jam manual
  void setSimulatedTime(DateTime simulatedTime) {
    _isSimulationMode = true;
    _realTimeTimer?.cancel();
    state = simulatedTime;
  }

  void addHours(int hours) {
    if (_isSimulationMode) state = state.add(Duration(hours: hours));
  }

  void addDays(int days) {
    if (_isSimulationMode) state = state.add(Duration(days: days));
  }

  bool get isSimulationMode => _isSimulationMode;
}
```

### 6.2 UI Settings — Fitur Simulasi

- Toggle switch **"Mode Simulasi"** dengan warna oranye saat aktif
- Date picker untuk memilih tanggal Dzulhijjah (8–13)
- Time picker untuk mengatur jam secara manual
- Tombol quick-set: *"Waktu Dzuhur"*, *"Waktu Maghrib"*, *"Hari Tarwiyah"*, dll
- Banner peringatan di top app selama mode simulasi aktif
- Tombol **"Reset ke Waktu Sekarang"** untuk keluar dari mode simulasi

---

## 7. Spesifikasi UI/UX

### 7.1 Palet Warna Utama

| Nama Warna | Hex | Penggunaan |
|---|---|---|
| Gold (Primary) | `#D4AF37` | Aksen utama, header, icon penting |
| Dark Background | `#1A1A2E` | Background utama (dark mode) |
| Card Background | `#16213E` | Latar belakang card |
| RUKUN — Merah | `#C62828` | Badge dan aksen amalan Rukun |
| WAJIB — Oranye | `#E65100` | Badge dan aksen amalan Wajib |
| SUNNAH — Hijau | `#2E7D32` | Badge dan aksen amalan Sunnah |
| Text Primary | `#ECEFF1` | Teks utama di dark mode |
| Text Secondary | `#90A4AE` | Teks sekunder / deskripsi |

### 7.2 Tipografi

| Elemen | Font | Ukuran | Style |
|---|---|---|---|
| App Title | Poppins | 24sp | Bold, Gold |
| Heading Hari | Poppins | 20sp | SemiBold, White |
| Nama Amalan | Poppins | 16sp | Medium, White |
| Deskripsi | Poppins | 13sp | Regular, Grey |
| Badge Label | Poppins | 10sp | Bold, Caps, Colored |
| Waktu Sholat | Poppins | 14sp | SemiBold, Gold |
| Teks Arab | Amiri | 18sp | Regular, White |

---

### 7.3 Spesifikasi Halaman

#### Halaman 1: Home / Timeline (Halaman Utama)

Menampilkan amalan untuk hari yang sedang berlangsung. Halaman ini menggunakan scroll vertikal tunggal untuk mendukung tampilan landscape.

- **Header:** Tanggal Hijriah Umm al-Qura (misal *"9 Dzulhijjah 1446 H"*) + Tanggal Masehi + Jam Aktif (Simulasi/Real).
- **Bar Waktu Sholat:** 6 waktu sholat Makkah dalam scroll horizontal.
- **Progress Dashboard (Horizontal):** 
    - **Hari Ini**: Progres harian.
    - **Total Rukun**: Progres kumulatif seluruh rukun.
    - **Total Wajib**: Progres kumulatif seluruh wajib.
- **Interactive Sheets**: Klik pada kartu rukun/wajib untuk melihat detail amalan yang tersisa.
- **Ongoing Menu**: Icon khusus untuk melihat amalan berkelanjutan yang sedang aktif.
- **Day Selector:** Tab/chip untuk beralih antar hari (8–13 Dzulhijjah).
- **List Amalan:** Kartu-kartu amalan berurutan dengan badge jenis.
- Otomatis scroll ke hari yang sedang berjalan berdasarkan tanggal Hijriah.

#### Halaman 2: Detail Amalan

Muncul saat user tap kartu amalan.

- Nama amalan besar di atas
- Badge jenis (RUKUN / WAJIB / SUNNAH) dengan warna khas
- Deskripsi panjang tentang tata cara pelaksanaan
- Dalil / referensi hadis yang mendasari amalan
- Keterangan waktu pelaksanaan (misal: *setelah Dzuhur*)
- Tombol centang besar di bawah: **"Tandai Sudah Dilakukan"**

#### Halaman 3: Progress Summary

Ringkasan visual progress ibadah haji secara keseluruhan.

- Chart bar per hari (8–13 Dzulhijjah): berapa % amalan selesai
- Breakdown: berapa amalan Rukun/Wajib/Sunnah yang sudah/belum
- Tombol reset semua checklist
- Animasi konfeti saat 100% amalan hari itu selesai 🎉

#### Halaman 4: Settings / Simulasi

- Toggle Mode Simulasi (dengan banner warning oranye)
- Date & Time picker untuk set waktu simulasi
- **Hijri Adjustment**: Pengaturan koreksi hari Hijriah (± hari) yang tersimpan permanen.
- Quick buttons: set ke setiap hari haji (Tarwiyah, Arafah, dll)
- Tombol Reset ke waktu nyata
- Info versi aplikasi

---

### 7.4 Spesifikasi Komponen AmalanCard

```
Spesifikasi Visual Kartu Amalan
─────────────────────────────────────────────────
padding        : 16dp semua sisi
borderRadius   : 12dp
elevation      : 4dp
marginBottom   : 12dp
background     : Glassmorphism (blur: 15, opacity: 0.15)

Layout (kiri → kanan):
  [Checkbox]  [Badge Jenis]  [Nama + Deskripsi]  [Icon Waktu]

State: sudah dicentang
  background   : Lebih gelap / opacity 0.5
  namaAmalan   : Strikethrough (teks dicoret)
  checkbox      : Terisi dengan animasi Lottie checkmark ✅

Interaksi:
  onTap         → Buka halaman Detail Amalan
  onCheckbox    → Toggle status + simpan ke Hive + animasi
```

### 7.5 Spesifikasi Komponen WaktuSholatBar

```
Bar horizontal scroll waktu sholat Makkah
─────────────────────────────────────────────────
Waktu ditampilkan : Fajr, Syuruq, Dhuhr, Asr, Maghrib, Isha
Waktu aktif saat ini : di-highlight warna Gold
Loading state    : Shimmer effect
Error / offline  : Tampilkan waktu default + icon warning
Format waktu     : HH:mm WAS (Waktu Arab Saudi)
```

---

## 8. Fitur Notifikasi & Pengingat

Menggunakan `flutter_local_notifications` untuk notifikasi lokal tanpa server push. Notifikasi dijadwalkan setelah jadwal waktu sholat berhasil di-fetch.

### 8.1 Jadwal Notifikasi

| Trigger | Judul Notifikasi | Isi Notifikasi | Hari |
|---|---|---|---|
| Fajr (Subuh) | Selamat Pagi, Jamaah Haji! | Hari Tarwiyah — Bersiap menuju Mina | 8 Dzul |
| Syuruq (Terbit) | Saatnya Berangkat! | Bertolak dari Mina menuju Arafah sekarang | 9 Dzul |
| Dhuhr (Dzuhur) | Waktu Wukuf! | Wukuf di Arafah — Perbanyak doa & dzikir | 9 Dzul |
| Maghrib | Bertolak ke Muzdalifah | Matahari telah terbenam, saatnya ke Muzdalifah | 9 Dzul |
| Fajr (Subuh) | Hari Idul Adha! | Bertolak ke Mina untuk lontar Jumrah Aqabah | 10 Dzul |
| Dhuhr (Dzuhur) | Waktu Lontar Jumrah | Saatnya melontar 3 Jumrah secara berurutan | 11–13 Dzul |

### 8.2 Catatan Implementasi

- Notifikasi dijadwalkan ulang setiap hari setelah fetch waktu sholat
- Notifikasi hanya aktif pada tanggal Hijriah yang relevan (8–13 Dzulhijjah)
- Saat **mode simulasi aktif**, notifikasi **TIDAK** dijadwalkan
- User dapat menonaktifkan notifikasi dari Settings
- Gunakan channel terpisah: `"amalan_haji_channel"`

---

## 9. Package UI & Panduan Penggunaan

### 9.1 Daftar Package UI

| Package | Versi | Prioritas | Kegunaan Spesifik |
|---|---|---|---|
| `google_fonts` | `^6.2.1` | **WAJIB** | Font Poppins (teks) + Amiri (nuansa Arab) |
| `flutter_animate` | `^4.5.0` | **WAJIB** | Animasi fadeIn, slideX pada card amalan |
| `lottie` | `^3.1.2` | **WAJIB** | Animasi centang (checkmark) & Ka'bah |
| `shimmer` | `^3.0.0` | **WAJIB** | Skeleton loading saat fetch API sholat |
| `percent_indicator` | `^4.2.3` | **WAJIB** | Progress ring % amalan selesai per hari |
| `hijri` | `^2.0.1` | **WAJIB** | Deteksi & tampilkan tanggal Dzulhijjah |
| `glassmorphism` | `^3.0.0` | DIANJURKAN | Efek blur card untuk tampilan modern |
| `flex_color_scheme` | `^7.3.1` | DIANJURKAN | Material 3 theme dengan palet islami |
| `confetti` | `^0.7.0` | DIANJURKAN | Konfeti saat semua amalan hari selesai |
| `flutter_slidable` | `^3.1.0` | OPSIONAL | Swipe card amalan untuk aksi cepat |
| `salomon_bottom_bar` | `^3.3.2` | OPSIONAL | Bottom nav minimalis modern |
| `flutter_svg` | `^2.0.10+1` | OPSIONAL | Icon SVG: Ka'bah, bulan sabit, bintang |

### 9.2 Contoh Penggunaan flutter_animate

```dart
// Animasi masuk card amalan
AmalanCard(amalan: amalan)
  .animate(delay: (index * 80).ms)
  .fadeIn(duration: 400.ms)
  .slideX(begin: -0.15, curve: Curves.easeOut);
```

### 9.3 Contoh Penggunaan Lottie

```dart
// Animasi centang saat amalan selesai
Lottie.asset(
  'assets/lotties/checkmark.json',
  width: 48,
  height: 48,
  repeat: false,
  controller: _animationController,
);
```

---

## 10. Alur Logika Bisnis

### 10.1 Logika Deteksi Hari Haji Aktif

```dart
int getHariHajiAktif(DateTime now) {
  final hijri = HijriCalendar.fromDate(now);

  // Pastikan bulan Dzulhijjah (bulan ke-12 Hijriah)
  if (hijri.hMonth != 12) return -1; // Bukan musim haji

  // Hanya tampilkan hari 8-13
  if (hijri.hDay >= 8 && hijri.hDay <= 13) {
    return hijri.hDay;
  }

  return -1; // Di luar rentang haji
}

// Dalam mode simulasi → gunakan tanggal dari clockProvider
// Dalam mode normal  → gunakan DateTime.now() dari clockProvider
```

### 10.2 Logika Tampil Amalan Berdasarkan Waktu

```dart
AmalanCardState getAmalanState(
  Amalan amalan,
  DateTime now,
  PrayerTime prayerTime,
) {
  if (amalan.sudahDilakukan) return AmalanCardState.selesai;

  if (amalan.waktuTrigger != null) {
    final triggerTime = _getWaktuByName(amalan.waktuTrigger!, prayerTime);

    if (now.isAfter(triggerTime)) {
      return AmalanCardState.perluDikerjakan; // Highlight merah/oranye
    }
    return AmalanCardState.belumWaktunya;     // Greyed out
  }

  return AmalanCardState.perluDikerjakan;
}

enum AmalanCardState { belumWaktunya, perluDikerjakan, selesai }
```

### 10.3 Flow Checklist & Persistensi

```dart
Future<void> onAmalanChecked(Amalan amalan, bool isChecked) async {
  // 1. Update local state (Riverpod)
  state = state.map((a) =>
    a.id == amalan.id ? a.copyWith(sudahDilakukan: isChecked) : a
  ).toList();

  // 2. Simpan ke Hive
  await storageService.setAmalanStatus(
    amalan.hariDzulhijjah, amalan.id, isChecked,
  );

  // 3. Cek apakah semua amalan hari itu selesai
  final semuaSelesai = state
    .where((a) => a.hariDzulhijjah == amalan.hariDzulhijjah)
    .every((a) => a.sudahDilakukan);

  // 4. Trigger animasi konfeti jika semua selesai
  if (semuaSelesai) confettiController.play();
}
```

---

## 11. Rencana Pengembangan (Development Roadmap)

| Fase | Scope | Estimasi | Output |
|---|---|---|---|
| **Fase 1** | Setup project, struktur folder, model data, master data amalan hardcoded | 1–2 hari | Fondasi project siap |
| **Fase 2** | Integrasi Hive (storage), ClockService (simulasi waktu), PrayerTimeService (Aladhan API) | 1–2 hari | Service layer siap |
| **Fase 3** | UI Halaman Home: day selector, list amalan, waktu sholat bar, progress ring | 2–3 hari | Halaman utama fungsional |
| **Fase 4** | Komponen AmalanCard dengan badge, checklist, animasi centang (Lottie) | 1–2 hari | Interaksi checklist berjalan |
| **Fase 5** | Halaman Detail Amalan, Halaman Progress Summary dengan chart | 1–2 hari | Semua halaman selesai |
| **Fase 6** | Halaman Settings + UI simulasi tanggal/jam | 1 hari | Fitur simulasi berjalan |
| **Fase 7** | Sistem notifikasi lokal (flutter_local_notifications) | 1 hari | Reminder berfungsi |
| **Fase 8** | Polish UI: glassmorphism, animasi flutter_animate, konfeti, dark theme | 2–3 hari | Tampilan final premium |
| **Fase 9** | Testing menyeluruh di Android & iOS, bug fix | 2–3 hari | App siap distribusi |

**Total estimasi: 12–19 hari kerja**

---

## 12. Konfigurasi pubspec.yaml

```yaml
name: amalan_haji
description: Aplikasi panduan dan checklist ibadah haji
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # HTTP & API
  dio: ^5.4.3

  # Kalender & Waktu
  hijri: ^2.0.1
  intl: ^0.19.0

  # Notifikasi
  flutter_local_notifications: ^17.2.2

  # UI & Font
  google_fonts: ^6.2.1
  flex_color_scheme: ^7.3.1
  flutter_svg: ^2.0.10+1
  flutter_animate: ^4.5.0
  lottie: ^3.1.2
  shimmer: ^3.0.0
  glassmorphism: ^3.0.0
  confetti: ^0.7.0
  percent_indicator: ^4.2.3
  salomon_bottom_bar: ^3.3.2
  flutter_slidable: ^3.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  hive_generator: ^2.0.1
  build_runner: ^2.4.9
  riverpod_generator: ^2.4.0

flutter:
  uses-material-design: true
  assets:
    - assets/lotties/
    - assets/icons/
    - assets/images/
```

---

## 13. Catatan Penting untuk AI Coder

> ⚠️ **BACA SEBELUM CODING** — Bagian ini berisi constraint dan keputusan desain yang **HARUS** diikuti selama pengembangan untuk menghindari perubahan arsitektur di tengah jalan.

### 13.1 Prinsip yang TIDAK BOLEH Dilanggar

- ❌ **TIDAK ADA** backend server (Laravel, FastAPI, Node.js, Firebase, dll)
- ❌ **TIDAK ADA** autentikasi / login user — ini aplikasi single user
- ❌ **TIDAK ADA** sinkronisasi antar perangkat — data hanya lokal
- ❌ Data amalan haji **TIDAK BOLEH** diambil dari API — harus hardcoded di Dart
- ❌ Simulasi waktu **TIDAK BOLEH** mengubah device time — gunakan `ClockService`
- ❌ Semua teks bahasa Indonesia, kecuali teks doa/dalil dalam bahasa Arab

### 13.2 Keputusan Teknis yang Sudah Ditetapkan

- ✅ State management: **Riverpod** (BUKAN Provider, BLoC, atau GetX)
- ✅ Local storage: **Hive** (BUKAN SQLite atau SharedPreferences untuk checklist)
- ✅ HTTP client: **Dio** (BUKAN http package standar)
- ✅ Tema: **Dark mode** sebagai default (latar gelap elegan, aksen gold)
- ✅ Navigasi: **GoRouter** atau Navigator 2.0 dengan bottom navigation 4 tab

### 13.3 Edge Cases yang HARUS Ditangani

| Edge Case | Penanganan |
|---|---|
| **Offline / no internet** | Fallback ke data waktu sholat default, app tetap berfungsi penuh |
| **Bukan musim haji** | Tampilkan pesan informatif bahwa fitur aktif saat musim haji |
| **Reset data** | User bisa reset seluruh checklist dari halaman Settings |
| **Mode simulasi aktif** | Banner warning oranye harus **selalu** terlihat di semua halaman |
| **Lontar Jumrah hari 11–13** | Tampilkan 3 jumrah terpisah (Ula, Wustha, Aqabah), bukan 1 amalan |
| **Nafar Awal vs Nafar Tsani** | Amalan hari ke-13 hanya tampil jika user pilih Nafar Tsani |
| **Wanita haid** | Thawaf Wada' tidak wajib — tandai dengan label khusus |

### 13.4 Urutan File yang Disarankan untuk Dibuat

1. `pubspec.yaml` — tambahkan semua dependency
2. `lib/core/constants/app_colors.dart` — definisi warna
3. `lib/core/models/amalan.dart` — model data
4. `lib/core/constants/amalan_data.dart` — master data semua amalan (8–13 Dzulhijjah)
5. `lib/core/services/clock_service.dart` — simulasi waktu
6. `lib/core/services/storage_service.dart` — Hive CRUD
7. `lib/core/services/prayer_time_service.dart` — Aladhan API
8. `lib/core/providers/*.dart` — semua Riverpod providers
9. `lib/shared/widgets/badge_widget.dart` — badge RUKUN/WAJIB/SUNNAH
10. `lib/features/home/widgets/amalan_card.dart` — komponen card utama
11. `lib/features/home/home_page.dart` — halaman utama
12. `lib/features/detail/amalan_detail_page.dart` — detail amalan
13. `lib/features/progress/progress_page.dart` — progress summary
14. `lib/features/settings/settings_page.dart` — settings & simulasi
15. `lib/main.dart` — setup Hive, ProviderScope, tema, routing

---

*PRD Aplikasi AMALAN HAJI | v1.0 | Mei 2025*
*Dokumen ini dihasilkan dari sesi diskusi desain aplikasi Flutter.*
