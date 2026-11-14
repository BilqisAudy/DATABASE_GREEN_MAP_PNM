# Praktikum Modul 11 – Eksplorasi DBMS Lanjutan

**Proyek:** Green Map PNM (Sistem Pemetaan dan Identifikasi Tanaman Kampus 2 PNM, SDG 15 Ekosistem Daratan)
**Kelas:** 1C D4 TRPL, Politeknik Negeri Madiun

**Anggota:**
1. Bilqis Audynova Prasanty (264311063)
2. Cindika Zahira Thitania Putri (264311064)
3. Yaya Winda Salma (264311087)

## Struktur Folder

```
praktikum_modul11/
├── sql/
│   ├── 01_database.sql
│   ├── 02_tabel.sql
│   ├── 03_data_awal.sql
│   ├── 04_pengujian_json.sql
│   └── 05_pemodelan_objek.sql
├── dokumentasi/
│   ├── Modul 11 Tahap 1.pdf
│   ├── MODUL 11 Tahap 2.pdf
│   ├── Modul 11 Tahap 3.pdf
│   ├── Modul 11 Tahap 4.pdf
│   ├── MODUL 11 Tahap 5.pdf
│   └── DOKUMENTASI_MODUL11.pdf
├── diagram/
│   └── pemodelan_objek.png
└── README.md
```

## Cara Menjalankan

DBMS: MySQL/MariaDB (Laragon), antarmuka phpMyAdmin. Jalankan file di folder `sql/` berurutan lewat tab SQL:

1. `01_database.sql` – membuat database `praktikum_modul11`
2. `02_tabel.sql` – membuat tabel `kategori` dan `tanaman` (atribut bertipe JSON)
3. `03_data_awal.sql` – mengisi kategori dan tiga tanaman dengan atribut JSON berbeda
4. `04_pengujian_json.sql` – membaca, mengubah, menambah, menghapus, dan mencari atribut JSON
5. `05_pemodelan_objek.sql` – memetakan objek Tanaman ke tabel `tanaman_objek` dan menggabungkannya dengan data relasional

## Dokumentasi

| File | Isi |
|------|-----|
| `Modul 11 Tahap 1.pdf` | Perkembangan dan kelengkapan DBMS, perbandingan dan pemilihan DBMS |
| `MODUL 11 Tahap 2.pdf` | Mengenal basis data berorientasi objek dan JSON |
| `Modul 11 Tahap 3.pdf` | Implementasi basis data dengan fitur JSON |
| `Modul 11 Tahap 4.pdf` | Pemodelan data berorientasi objek |
| `MODUL 11 Tahap 5.pdf` | Analisis lingkup penerapan basis data |
| `DOKUMENTASI_MODUL11.pdf` | Dokumentasi Modul 11 |

## Diagram

![Pemodelan objek Tanaman](diagram/pemodelan_objek.png)

`diagram/pemodelan_objek.png` menunjukkan objek Tanaman dan turunannya (Pohon, TanamanHias, TanamanObat).
