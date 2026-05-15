# Panduan Distribusi Aplikasi via Firebase App Distribution

Dokumen ini berisi langkah-langkah untuk mendistribusikan aplikasi **Amalan Haji** ke para tester menggunakan Firebase App Distribution.

## 1. Persiapan Awal (Sudah Terinstal)
Sistem Anda saat ini sudah dilengkapi dengan:
- **Firebase CLI** (Global via Homebrew).
- **FlutterFire CLI** (Lokasi: `/Users/syam/.pub-cache/bin/flutterfire`).
- **Script Distribusi** (Lokasi: `./scripts/distribute_android.sh`).

## 2. Langkah-langkah Distribusi

### A. Jika ada Perubahan Source Code (Update Aplikasi)
Setiap kali Anda melakukan perubahan fitur atau perbaikan bug dan ingin mengirimkan versi terbaru ke tester, ikuti langkah ini:

1.  **Naikkan Versi (Opsional tapi Disarankan)**:
    Buka file `pubspec.yaml` dan naikkan angka versi atau build.
    Contoh: `version: 1.0.0+1` menjadi `version: 1.0.0+2`.
2.  **Jalankan Script Distribusi**:
    Buka terminal di root project dan jalankan:
    ```bash
    ./scripts/distribute_android.sh
    ```
    Script ini akan otomatis:
    - Mem-build APK Release terbaru.
    - Mengunggah APK ke Firebase.
    - Mengirim notifikasi ke semua tester di grup "testers".

---

### B. Menambah atau Mengelola Tester

#### Cara 1: Menambah Email secara Manual
1.  Buka [Firebase Console](https://console.firebase.google.com/).
2.  Pilih menu **Release & Monitor** > **App Distribution**.
3.  Klik tab **Testers & Groups**.
4.  Pilih grup **testers** dan tambahkan email baru di sana.

#### Cara 2: Menggunakan Invite Link (Public Link)
Jika ingin membagikan link ke grup WhatsApp:
1.  Di tab **Testers & Groups**, klik **Invite links**.
2.  Klik **New invite link**.
3.  Pilih grup **testers**.
4.  Salin link yang muncul dan bagikan ke calon tester.

---

## 3. Cara Tester Menginstal Aplikasi
1.  Tester membuka link undangan atau email dari Firebase di HP Android mereka.
2.  Mereka harus login dengan akun Google mereka.
3.  Tester akan diminta menginstal aplikasi **Google App Tester**.
4.  Di dalam aplikasi App Tester tersebut, mereka bisa mengunduh dan menginstal aplikasi **Ceklist Amalan Haji**.

---

## 4. Perintah Berguna Lainnya

- **Cek Status Login**:
  ```bash
  firebase login:list
  ```
- **Login Ulang (Jika Token Expired)**:
  ```bash
  firebase login --reauth
  ```
- **Konfigurasi Ulang (Jika Tambah Platform/Project Baru)**:
  ```bash
  /Users/syam/.pub-cache/bin/flutterfire configure
  ```

---
*Dokumen ini dibuat otomatis oleh Antigravity untuk membantu alur kerja tim developer Amalan Haji.*
