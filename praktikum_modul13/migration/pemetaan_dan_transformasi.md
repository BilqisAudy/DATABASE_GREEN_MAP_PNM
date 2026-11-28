# Pemetaan dan transformasi MySQL ke Neo4j

Sumber: `db_green_map_pnm` (MySQL 8.0). Tujuan: Neo4j Desktop 2.3.1, Neo4j 2026.10.2 (Graph Database).

## Pemetaan struktur

| Data di MySQL | Struktur di Neo4j | Aturan / transformasi |
| --- | --- | --- |
| `tanaman` (4 baris) | Node `:Tanaman` (4) | Satu baris menjadi satu node. `nama_tanaman` menjadi `nama`. `kondisi`, `latitude`, `longitude` dibawa. |
| `tanaman.jenis_tanaman` | Node `:Kategori` (3) dan relasi `TERMASUK_KATEGORI` (4) | Nilai berulang (Pohon, Tanaman Hias, Tanaman Obat) dijadikan node. |
| `pengguna` (4 baris) | Node `:Pengguna` (4) | Properti `nama` dan `peran`. |
| `perawatan` (4 baris) | Node `:Perawatan` (4), relasi `MELAKUKAN` dan `PADA` | `tindakan` menjadi `jenis`, `tanggal` menjadi tipe date. `id_pengguna` menjadi `MELAKUKAN`, `id_tanaman` menjadi `PADA`. |
| `laporan_kondisi` (3 baris) | Node `:Laporan` (3), relasi `MELAPORKAN` dan `TENTANG` | `deskripsi` menjadi `kondisi`, `tanggal_lapor` menjadi `tanggal`. Foreign key menjadi relasi. |
| `tanaman_objek` (3 baris) | Properti pada node `:Tanaman` | Kolom JSON dipecah: `tinggi_m`, `warna_bunga`, `khasiat` (list), `bagian_dipakai`. Mahoni tidak punya baris, jadi tidak punya properti khusus. |

## Model graf

```
(:Pengguna)-[:MELAKUKAN]->(:Perawatan)-[:PADA]->(:Tanaman)-[:TERMASUK_KATEGORI]->(:Kategori)
(:Pengguna)-[:MELAPORKAN]->(:Laporan)-[:TENTANG]->(:Tanaman)
```

## Konversi tipe data

| MySQL | Neo4j |
| --- | --- |
| `int` (id) | Tidak disimpan; identitas lewat properti `nama` yang dibuat unik |
| `varchar`, `text`, `enum` | String |
| `date` | `date('YYYY-MM-DD')` |
| `decimal(10,7)` (latitude, longitude) | Float |
| `json` (`atribut`) | Properti terpisah; array menjadi list |

## Tidak dimigrasikan

| Kolom | Alasan |
| --- | --- |
| `tanaman.total_laporan` | Data turunan. Di Neo4j dihitung dari relasi `TENTANG`. |
| `tanaman.foto`, `laporan_kondisi.foto_laporan` | Nilainya masih NULL. |
| `tanaman.manfaat`, `tanaman.cara_perawatan` | Isinya berulang (Trembesi dan Mahoni sama persis) dan tidak dipakai untuk penelusuran relasi. |
| `perawatan.catatan`, `laporan_kondisi.status` | Tidak dibutuhkan workload penelusuran relasi. |
| Semua kolom `id_*` | Identitas diganti properti `nama` yang unik. |
| `tanaman_objek.nama_tanaman`, `jenis_tanaman` | Salinan dari tabel `tanaman`. |

Seluruh tabel asli tetap berada di MySQL sebagai sumber utama dan arsip.

## Alur

1. Ekstraksi: `migration/extraction/01_ekstraksi_mysql.sql` (hasil disimpan sebagai CSV di `csv/`).
2. Transformasi: id diganti nama lewat JOIN, tipe data disesuaikan, JSON dipecah.
3. Pemuatan: `migration/loading/01_muat_data.sql`. Nilai hasil ekstraksi ditulis sebagai daftar `UNWIND` agar skrip berjalan tanpa mengatur folder import.
4. Validasi: `migration/loading/02_validasi.sql`.
