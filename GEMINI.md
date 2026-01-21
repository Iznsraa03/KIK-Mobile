# GEMINI.md - Konteks Proyek Flutter: Jelajah KI Sulsel

## Ringkasan Proyek

**Jelajah KI Sulsel** adalah aplikasi seluler yang dibangun dengan Flutter. Tujuan utamanya adalah untuk menyediakan platform bagi pengguna untuk menjelajahi, mencari, dan melihat data Kekayaan Intelektual (KI) yang terdaftar di wilayah Sulawesi Selatan, Indonesia.

Berdasarkan nama file, dependensi, dan aset (khususnya logo "kemenhum"), aplikasi ini tampaknya merupakan proyek resmi atau inisiatif yang terkait dengan **Kementerian Hukum dan Hak Asasi Manusia (Kemenkumham)**.

### Fitur Utama

- **Eksplorasi KI:** Pengguna dapat menelusuri berbagai kategori Kekayaan Intelektual.
- **Pencarian:** Fungsi pencarian untuk menemukan data KI tertentu.
- **Detail KI:** Tampilan detail untuk setiap entri KI.
- **Peta:** Kemungkinan untuk memvisualisasikan data KI secara geografis.
- **Statistik:** Menampilkan statistik terkait data KI.

### Arsitektur & Teknologi

Proyek ini mengikuti arsitektur yang bersih dan terstruktur dengan baik, memisahkan antara lapisan presentasi (UI), logika bisnis (repositori), dan sumber data (API).

- **Framework:** Flutter
- **Bahasa:** Dart
- **Manajemen State:** (Tidak teridentifikasi secara eksplisit, kemungkinan menggunakan state management bawaan Flutter seperti `StatefulWidget` atau `Provider` yang perlu diinvestigasi lebih lanjut)
- **Networking:** Menggunakan package `http` untuk komunikasi dengan API eksternal.
- **UI:** Didesain dengan Material Design, menggunakan `google_fonts` untuk tipografi, dan memiliki tema kustom yang terinspirasi dari identitas visual Kemenkumham.
- **Struktur Direktori `lib`:**
    - `api/`: Mengelola semua logika komunikasi jaringan (client, model, konfigurasi).
    - `repositories/`: Bertindak sebagai perantara antara UI dan sumber data (API), mengabstraksi logika pengambilan data.
    - `screens/`: Berisi semua layar atau halaman utama aplikasi.
    - `widgets/`: Komponen UI yang dapat digunakan kembali di seluruh aplikasi.
    - `data/`: Berisi data dummy, kemungkinan untuk pengembangan dan pengujian awal.

## Membangun dan Menjalankan Proyek

Instruksi standar untuk menjalankan proyek Flutter berlaku di sini.

1.  **Ambil Dependensi:**
    Pastikan semua dependensi proyek terpasang dengan benar.
    ```bash
    flutter pub get
    ```

2.  **Jalankan Aplikasi:**
    Jalankan aplikasi pada emulator atau perangkat fisik yang terhubung.
    ```bash
    flutter run
    ```

3.  **Jalankan Tes (jika ada):**
    Untuk menjalankan unit test yang ada di direktori `test/`.
    ```bash
    flutter test
    ```

## Konvensi Pengembangan

- **Linting:** Proyek ini menggunakan `flutter_lints` untuk memastikan kualitas kode dan praktik pengkodean yang baik. Aturan linting dikonfigurasi di `analysis_options.yaml`.
- **Struktur Kode:** Kode diorganisir dengan jelas berdasarkan fitur dan lapisan (UI, repositori, API), yang memudahkan navigasi dan pemeliharaan.
- **Manajemen Aset:** Semua aset seperti gambar, logo, dan font diorganisir dengan rapi di dalam direktori `assets/`.
- **Theming:** Aplikasi menggunakan sistem tema terpusat di `lib/main.dart`, memungkinkan konsistensi visual yang mudah di seluruh aplikasi.
