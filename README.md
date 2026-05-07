<div align="center">
  <h1>Age + Gender Estimation in Flutter with TensorFlow Lite</h1>
</div>

Adaptasi Flutter dari proyek Android [Age-Gender_Estimation_TF-Android](https://github.com/shubham0204/Age-Gender_Estimation_TF-Android) untuk estimasi usia dan klasifikasi jenis kelamin menggunakan TensorFlow Lite.

---

### **Daftar Isi**

* [Ringkasan](#-ringkasan)
* [Fitur Utama](#-fitur-utama)
* [Cara Penggunaan](#-cara-penggunaan)
* [Model TensorFlow Lite (Vanilla vs. Lite)](#-model-tensorflow-lite)
* [Konfigurasi Proyek](#-konfigurasi-proyek)
* [Setup & Instalasi](#-setup--instalasi)

---

## Ringkasan

Aplikasi ini mendeteksi wajah dalam gambar menggunakan **Google ML Kit Face Detection** dan kemudian menggunakan dua model **TensorFlow Lite** yang berbeda untuk memperkirakan usia dan mengklasifikasikan jenis kelamin dari wajah yang terdeteksi.

Aplikasi ini mendukung berbagai varian model (Quantized, Non-quantized, dan Lite) serta akselerasi hardware seperti GPU Delegate untuk performa yang lebih cepat.

---

## Fitur Utama

*   **Deteksi Wajah Real-time**: Menggunakan Google ML Kit untuk deteksi wajah yang akurat.
*   **Estimasi Usia & Jenis Kelamin**: Prediksi ganda dalam satu alur kerja.
*   **Dukungan Multi-Model**: Pilih antara model standar (Vanilla) atau model yang dioptimalkan (Lite).
*   **Akselerasi GPU**: Mendukung delegasi GPU pada Android dan iOS untuk inferensi yang lebih cepat.
*   **Cross-Platform**: Dikembangkan dengan Flutter untuk berjalan di Android dan iOS.

---

## Cara Penggunaan

1.  **Inisialisasi Model**: Saat pertama kali dibuka, pilih varian model yang diinginkan (misalnya: *Quantized* atau *Lite Non-quantized*).
2.  **Opsi Akselerasi**: Aktifkan "Gunakan GPU" jika perangkat Anda mendukungnya untuk mempercepat waktu inferensi.
3.  **Ambil Gambar**: Gunakan tombol kamera atau galeri untuk memilih foto.
4.  **Proses**: Aplikasi akan mendeteksi wajah, melakukan pemrosesan awal (resize & normalisasi), dan menampilkan hasil estimasi usia serta jenis kelamin beserta waktu inferensi.
5.  **Reinisialisasi**: Anda dapat mengubah model kapan saja dengan menekan tombol "Reinitialize".

---

## Model TensorFlow Lite

Kami menyediakan dua varian utama untuk setiap model:

### 1. Model Vanilla
Model standar dengan akurasi tinggi namun memiliki jumlah parameter yang lebih banyak.
*   **Age Estimation**: Input `200 * 200`, output ternormalisasi `(0, 1]` yang dikalikan dengan faktor `116`.
*   **Gender Classification**: Input `128 * 128`, output distribusi probabilitas untuk `Laki-laki` dan `Perempuan`.

### 2. Model Lite
Varian yang lebih ringan menggunakan *Separable Convolutions* untuk mengurangi parameter dan mempercepat waktu inferensi, dengan sedikit penurunan akurasi.

| Jenis Model | Fitur Utama |
| :--- | :--- |
| **Quantized** | Ukuran file lebih kecil, dioptimalkan untuk perangkat mobile. |
| **Non-quantized** | Presisi float32 penuh untuk akurasi yang lebih konsisten. |

---

## Konfigurasi Proyek

Aplikasi ini menggunakan dependensi utama berikut:

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_mlkit_face_detection: ^0.13.2 # Deteksi Wajah
  tflite_flutter: ^0.12.1              # Inferensi TFLite
  image_picker: ^1.1.2                 # Pengambilan Gambar
  image: ^4.3.0                        # Pemrosesan Gambar (Resize/Normalize)
```

---

## Setup & Instalasi

1.  **Clone Repositori**:
    ```bash
    git clone <repository-url>
    cd flutter_demo_application
    ```

2.  **Instal Dependensi**:
    ```bash
    flutter pub get
    ```

3.  **Aset Model**:
    Pastikan model `.tflite` berada di folder `assets/models/` sesuai dengan konfigurasi di `pubspec.yaml`.

4.  **Jalankan Aplikasi**:
    ```bash
    flutter run
    ```

---

## Lisensi

Proyek ini mengikuti lisensi dari repositori asli. Silakan merujuk ke [proyek asli](https://github.com/shubham0204/Age-Gender_Estimation_TF-Android) untuk informasi lebih lanjut mengenai model dan dataset.

---

> Proyek ini dikembangkan sebagai bagian dari tutorial pembelajaran pengembangan aplikasi Flutter berbasis Machine Learning.
