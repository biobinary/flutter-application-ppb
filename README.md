# Tugas Pertemuan 3

| Nama                   | NRP        | Kelas   |
| ---------------------- | ---------- | ------- |
| Muhammad Ammar Ghifari | 5025231109 | PPB (E) |

---

## Deskripsi Proyek

Proyek ini adalah aplikasi Flutter sederhana yang dibangun sebagai bagian dari tugas kuliah untuk memahami dan mengeksplorasi berbagai widget dasar Flutter. Aplikasi ini menampilkan satu halaman utama yang memuat gambar acak dari internet, kotak deskripsi, baris ikon kategori, dan sebuah counter interaktif yang bisa ditekan.

Tujuan utama proyek ini bukan membuat aplikasi yang kompleks, melainkan membiasakan diri dengan cara kerja widget-widget umum di Flutter — mulai dari layout sederhana seperti `Row` dan `Column`, hingga konsep state management dasar dengan `StatefulWidget`.

---

## Penjelasan Widget

### 1. `MaterialApp`

`MaterialApp` adalah widget paling atas (root) dari seluruh aplikasi. Ia bertanggung jawab untuk mengatur konfigurasi global seperti judul aplikasi, tema warna, dan halaman pertama yang ditampilkan saat aplikasi dibuka.

Di proyek ini, tema warna dibuat dari `ColorScheme.fromSeed` dengan warna dasar ungu tua (`Colors.deepPurple`), dan halaman utamanya adalah `RowColumnPage`.

```dart
MaterialApp(
  title: 'Flutter Demo',
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
  ),
  home: const RowColumnPage(),
)
```

> **Catatan:** `useMaterial3: true` mengaktifkan desain terbaru Material You dari Google, yang memberikan tampilan lebih modern dibandingkan Material 2.

---

### 2. `Scaffold`

`Scaffold` adalah "kerangka" halaman standar dalam Flutter. Ia menyediakan slot-slot siap pakai untuk elemen-elemen umum seperti `AppBar` di bagian atas, `body` untuk konten utama, hingga `floatingActionButton` dan `bottomNavigationBar`.

Dengan menggunakan `Scaffold`, kita tidak perlu membangun tata letak halaman dari nol — cukup isi slot yang tersedia.

```dart
Scaffold(
  appBar: AppBar(...),
  body: Column(...),
)
```

---

### 3. `AppBar`

`AppBar` adalah bilah navigasi yang tampil di bagian paling atas layar. Biasanya berisi judul halaman, tombol kembali (jika ada), dan aksi-aksi tambahan di sisi kanan.

Pada aplikasi ini, `AppBar` menampilkan teks "My First App" yang diposisikan di tengah dengan warna latar oranye muda yang cukup mencolok.

```dart
AppBar(
  title: const Text(
    'My First App',
    style: TextStyle(color: Colors.black),
  ),
  backgroundColor: Colors.orange[200],
  centerTitle: true,
)
```

| Properti          | Nilai                   | Fungsi                              |
| ----------------- | ----------------------- | ----------------------------------- |
| `title`           | `Text('My First App')`  | Teks judul yang ditampilkan         |
| `backgroundColor` | `Colors.orange[200]`    | Warna latar belakang AppBar         |
| `centerTitle`     | `true`                  | Memposisikan judul tepat di tengah  |

---

### 4. `Column`

`Column` adalah widget layout yang menyusun anak-anaknya (`children`) secara **vertikal** — dari atas ke bawah. Ini adalah salah satu widget tata letak yang paling sering dipakai di Flutter.

Di aplikasi ini, `Column` digunakan sebagai wadah utama halaman yang menampung semua blok konten secara berurutan ke bawah.

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.center,
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    // konten disusun dari atas ke bawah di sini
  ],
)
```

| Properti               | Fungsi                                                     |
| ---------------------- | ---------------------------------------------------------- |
| `mainAxisAlignment`    | Mengatur posisi anak-anak pada sumbu **vertikal** (atas-bawah) |
| `crossAxisAlignment`   | Mengatur posisi anak-anak pada sumbu **horizontal** (kiri-kanan) |

---

### 5. `Row`

`Row` adalah kebalikan dari `Column` — ia menyusun anak-anaknya secara **horizontal**, dari kiri ke kanan. Pada aplikasi ini, `Row` digunakan untuk membuat deretan ikon kategori (Food, Scenery, People) yang berjajar ke samping.

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    Column(children: [Icon(Icons.food_bank), Text("Food")]),
    Column(children: [Icon(Icons.landscape), Text("Scenery")]),
    Column(children: [Icon(Icons.people), Text("People")]),
  ],
)
```

Nilai `MainAxisAlignment.spaceEvenly` membuat jarak antar ikon terdistribusi merata secara otomatis — tanpa perlu menghitung margin secara manual.

---

### 6. `Container`

`Container` adalah widget serbaguna yang bisa dibilang seperti "kotak div" di Flutter. Fungsinya adalah membungkus sebuah widget sekaligus memberikan berbagai gaya visual padanya, seperti warna latar, jarak dalam (`padding`), jarak luar (`margin`), ukuran, hingga batas tepi (border).

Pada aplikasi ini, `Container` dipakai berkali-kali untuk membungkus berbagai bagian konten dan memberi warna yang berbeda-beda.

```dart
Container(
  width: MediaQuery.of(context).size.width,
  margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
  padding: EdgeInsets.all(20.0),
  color: Colors.pink[200],
  child: Text('What image is that', style: TextStyle(fontSize: 16)),
)
```

| Properti   | Fungsi                                                       |
| ---------- | ------------------------------------------------------------ |
| `width`    | Mengatur lebar kontainer                                     |
| `margin`   | Jarak antara kontainer dengan widget di luar                 |
| `padding`  | Jarak antara tepi kontainer dengan konten di dalamnya        |
| `color`    | Warna latar belakang kontainer                               |
| `child`    | Widget yang ada di dalam kontainer                           |

---

### 7. `AspectRatio`

`AspectRatio` adalah widget yang memaksa widget anaknya untuk mengikuti rasio ukuran tertentu. Ini sangat berguna ketika kita ingin memastikan sebuah elemen selalu berbentuk persegi atau proporsi tertentu, terlepas dari ukuran layar.

Nilai `aspectRatio: 1.0` berarti lebar dan tinggi kontainer akan selalu sama — sehingga terbentuk kotak persegi sempurna.

```dart
AspectRatio(
  aspectRatio: 1.0, // lebar : tinggi = 1 : 1
  child: Container(...),
)
```

> **Tips:** Nilai `aspectRatio: 16/9` akan membuat kotak berrasio layar widescreen, seperti video YouTube.

---

### 8. `Center`

`Center` adalah widget sederhana yang menempatkan widget anaknya tepat di tengah-tengah area yang tersedia. Tidak ada konfigurasi tambahan yang rumit — cukup bungkus widget yang ingin dipusatkan, dan Flutter akan mengurusnya secara otomatis.

```dart
Center(
  child: Image.network(
    'https://picsum.photos/200',
    fit: BoxFit.cover,
    width: 500,
  ),
)
```

---

### 9. `Image.network`

`Image.network` adalah widget khusus untuk memuat dan menampilkan gambar dari internet menggunakan URL. Widget ini akan melakukan request ke URL yang diberikan dan merender gambarnya begitu data berhasil diunduh.

Pada aplikasi ini, gambar diambil dari layanan `picsum.photos` yang menyediakan gambar acak sebagai placeholder.

```dart
Image.network(
  'https://picsum.photos/200',
  fit: BoxFit.cover,
  width: 500,
)
```

Properti `fit: BoxFit.cover` memastikan gambar mengisi ruang yang tersedia tanpa terdistorsi — jika perlu, bagian tepi gambar akan dipotong secara otomatis.

| Nilai `BoxFit` | Perilaku                                              |
| -------------- | ----------------------------------------------------- |
| `cover`        | Mengisi area, bagian tepi mungkin terpotong           |
| `contain`      | Gambar penuh tampil tanpa terpotong, bisa ada sisa ruang |
| `fill`         | Gambar diregangkan untuk mengisi area (bisa distorsi) |

---

### 10. `Text`

`Text` adalah widget paling dasar untuk menampilkan teks di layar. Meskipun sederhana, ia memiliki banyak opsi styling melalui properti `style` yang menggunakan `TextStyle`.

```dart
Text(
  'What image is that',
  style: TextStyle(fontSize: 16),
)
```

Beberapa properti `TextStyle` yang sering digunakan:

```dart
TextStyle(
  fontSize: 16,             // ukuran huruf
  fontWeight: FontWeight.bold,  // ketebalan huruf
  color: Colors.black,      // warna teks
  letterSpacing: 1.2,       // jarak antar huruf
)
```

---

### 11. `Icon` dan `IconButton`

**`Icon`** menampilkan ikon dari koleksi bawaan Flutter Material Icons. Cukup berikan nama ikon dan Flutter akan merendernya sebagai simbol vektor yang tajam di semua ukuran layar.

```dart
Icon(Icons.food_bank)        // ikon piring/makanan
Icon(Icons.landscape)        // ikon pemandangan
Icon(Icons.people)           // ikon kelompok orang
```

**`IconButton`** adalah `Icon` yang sudah dilengkapi kemampuan interaktif — bisa diklik. Widget ini secara otomatis menyediakan area sentuh yang cukup luas dan efek ripple saat ditekan. Di aplikasi ini, `IconButton` digunakan untuk tombol tambah pada counter.

```dart
IconButton(
  onPressed: _incrementCounter,  // fungsi yang dipanggil saat ditekan
  icon: Icon(Icons.add, color: Colors.black, size: 16),
)
```

---

### 12. `StatefulWidget` — Pada `CounterCard`

`StatefulWidget` adalah tipe widget yang bisa "mengingat" data dan memperbarui tampilannya secara otomatis saat data tersebut berubah. Berbeda dengan `StatelessWidget` yang tampilannya statis, `StatefulWidget` cocok untuk elemen yang berinteraksi dengan pengguna.

Pada aplikasi ini, `CounterCard` adalah `StatefulWidget` yang menyimpan nilai counter (`_counter`). Setiap kali tombol `+` ditekan, fungsi `setState()` dipanggil untuk memperbarui nilai dan memicu render ulang tampilan.

```dart
class _CounterCardState extends State<CounterCard> {
  int _counter = 0; // state yang disimpan

  void _incrementCounter() {
    setState(() {
      _counter++; // nilai diubah → UI otomatis diperbarui
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // ...
      child: Row(
        children: [
          Text("Counter here: $_counter"),
          IconButton(
            onPressed: _incrementCounter,
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
```

> **Kunci konsep:** `setState()` adalah cara Flutter tahu bahwa ada data yang berubah dan tampilan perlu dirender ulang. Tanpa `setState()`, nilai `_counter` mungkin berubah di memori, tapi UI tidak akan ikut berubah.

---

## Cara Menjalankan Aplikasi

Pastikan Flutter SDK sudah terpasang di komputer. Kemudian jalankan perintah berikut di terminal:

```bash
# Clone atau buka folder proyek
cd nama-folder-proyek

# Ambil semua dependency
flutter pub get

# Jalankan aplikasi (pastikan emulator atau perangkat sudah aktif)
flutter run
```

---

## Tampilan Aplikasi

![Screenshot Aplikasi](images/screenshot.png)

---

## Referensi

- [Dokumentasi Resmi Flutter](https://docs.flutter.dev/ui/widgets)
- [Flutter Widget Catalog](https://docs.flutter.dev/reference/widgets)
- [Material Design Icons](https://fonts.google.com/icons)