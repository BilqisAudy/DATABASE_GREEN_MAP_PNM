# Praktikum Modul 13: Migrasi Sebagian Data MySQL ke Neo4j

Kelompok 15, Proyek **Green Map PNM** (SDG 15 Ekosistem Daratan), 1C D4 TRPL.

| Nama | NIM |
| --- | --- |
| Bilqis Audynova Prasanty | 264311063 |
| Cindika Zahira Thitania Putri | 264311064 |
| Yaya Winda Salma | 264311087 |

Konsep: **Polyglot Persistence**. MySQL tetap menjadi sumber utama, sebagian data dipindahkan ke Neo4j (Graph Database)
untuk pengolahan hubungan antardata.

## Struktur repository

```
praktikum_modul13/
├── mysql/source-schema-and-data/db_green_map_pnm.sql     Dump MySQL (skema dan data)
├── migration/
│   ├── extraction/      01_ekstraksi_mysql.sql, csv/       Query ekstraksi dan hasil CSV
│   ├── transformation/  pemetaan_dan_transformasi.md       Pemetaan struktur dan aturan transformasi
│   └── loading/         01_muat_data.sql, 02_validasi.sql  Pemuatan ke Neo4j dan validasi
├── target-dbms/
│   ├── structure/       01_constraint.sql, model_graf.md   Constraint dan model graf
│   ├── crud/            01_crud.sql                        Create, Read, Update, Delete
│   └── workload-query/  01_workload_graf.sql               Penelusuran relasi dan PROFILE
├── evidence/screenshots/                                    Bukti hasil menjalankan
└── README.md
```

## Urutan menjalankan (Neo4j Desktop, instance lokal `green_map`, tab Query)

1. `target-dbms/structure/01_constraint.sql`
2. `migration/loading/01_muat_data.sql` (satu blok per satu, urut nomor)
3. `migration/loading/02_validasi.sql`
4. `target-dbms/crud/01_crud.sql`
5. `target-dbms/workload-query/01_workload_graf.sql`

Skrip di folder ini berekstensi `.sql` agar mudah dibuka, tetapi isinya Cypher. Nilai hasil ekstraksi MySQL ditulis langsung sebagai daftar `UNWIND`
agar skrip berjalan di instance mana pun tanpa mengatur folder import. File CSV di `migration/extraction/csv/` adalah
hasil ekstraksi yang sama dan dapat dipakai dengan `LOAD CSV` dari folder import Neo4j Desktop atau alamat https.

## Lembar kerja

### A. Identitas kelompok

| Komponen | Keterangan |
| --- | --- |
| Nama proyek | Green Map PNM |
| DBMS sumber | MySQL 8.0 (`db_green_map_pnm`) |
| DBMS tujuan | Neo4j Desktop (instance lokal `green_map`) |
| Versi DBMS | Neo4j Desktop 2.3.1; Neo4j 2026.10.2; Cypher 25 |
| Kategori DBMS | Graph Database |
| Bagian proyek yang dipilih | Tanaman, kategori, pengguna, perawatan, laporan kondisi, atribut khusus tanaman |

### B. Analisis migrasi

| Komponen | Keterangan |
| --- | --- |
| Kebutuhan | Pertanyaan relasi (siapa merawat tanaman apa, riwayat laporan) butuh JOIN berantai di empat tabel. `total_laporan` harus diperbarui manual. |
| Workload | Penelusuran hubungan antarnode: pengguna, perawatan, tanaman, kategori, laporan |
| Data yang dimigrasikan | `tanaman`, `pengguna`, `perawatan`, `laporan_kondisi`, dan atribut JSON dari `tanaman_objek` |
| Alasan memilih Neo4j | Relasi disimpan langsung, penelusuran tanpa JOIN berantai, atribut berbeda tiap jenis tanaman tersimpan sebagai properti |
| Keunggulan | Query penelusuran singkat dan mudah dibaca, hubungan dapat divisualisasikan, skema fleksibel |
| Trade-off | Data di dua sistem perlu disinkronkan, kurang efisien untuk rekap besar, tanpa foreign key dan trigger bawaan, perlu belajar Cypher |
| Tetap di MySQL | Seluruh tabel asli (sumber dan arsip), `total_laporan`, `foto`, `foto_laporan`, `manfaat`, `cara_perawatan` |

### C. Pemetaan struktur data

Lihat `migration/transformation/pemetaan_dan_transformasi.md`.

| Struktur sumber di MySQL | Struktur tujuan | Transformasi |
| --- | --- | --- |
| `tanaman` | Node `:Tanaman` | Baris menjadi node, `nama_tanaman` menjadi `nama` |
| `tanaman.jenis_tanaman` | Node `:Kategori` | Nilai berulang menjadi node |
| `pengguna` | Node `:Pengguna` | Properti `nama`, `peran` |
| `perawatan` | Node `:Perawatan` | `tindakan` menjadi `jenis` |
| `laporan_kondisi` | Node `:Laporan` | `deskripsi` menjadi `kondisi` |
| `tanaman_objek` | Properti pada `:Tanaman` | JSON dipecah menjadi properti |
| Primary key | Properti `nama` unik | Constraint unik |
| Foreign key | Relasi | `MELAKUKAN`, `PADA`, `MELAPORKAN`, `TENTANG`, `TERMASUK_KATEGORI` |

### D. Hasil migrasi

| Indikator | Hasil |
| --- | --- |
| Data sumber yang dipilih | `tanaman`, `pengguna`, `perawatan`, `laporan_kondisi`, `tanaman_objek` |
| Jumlah data sumber | 4, 4, 4, 3, 3 baris (`evidence/screenshots/01_mysql_jumlah_data.png`) |
| Jumlah data berhasil dimigrasikan | Tanaman 4, Pengguna 4, Perawatan 4, Laporan 3, Kategori 3 (dari 3 jenis berbeda); relasi 18 |
| Atribut yang diubah | `nama_tanaman` menjadi `nama`, `tindakan` menjadi `jenis`, `deskripsi` menjadi `kondisi`, `tanggal` menjadi date, JSON menjadi properti |
| Informasi yang tidak dimigrasikan | Semua `id_*`, `total_laporan`, `foto`, `foto_laporan`, `manfaat`, `cara_perawatan`, `catatan`, `status` |
| Status migrasi | Berhasil. Jumlah node (Tanaman 4, Pengguna 4, Perawatan 4, Laporan 3, Kategori 3) dan relasi (18) sama dengan sumber, `total_laporan` cocok, tidak ada data menggantung (`evidence/screenshots/04` sampai `07`) |

### E. Pengujian operasi

| Operasi | Perintah | Hasil aktual | Status |
| --- | --- | --- | --- |
| Create | `crud/01_crud.sql` blok C1 sampai C3 | Tanaman Lidah Buaya (kategori Tanaman Obat), satu perawatan, dan satu laporan berhasil dibuat (`08_create.png`) | Berhasil |
| Read | `crud/01_crud.sql` blok R1 dan R2 | Daftar tanaman beserta kategori, serta perawatan dan laporan Lidah Buaya berhasil dibaca (`09_read.png`) | Berhasil |
| Update | `crud/01_crud.sql` blok U1 dan U2 | Kondisi Bougainvillea berubah menjadi "Terawat" (`10_update_u1.png`), lalu dikembalikan menjadi "Perlu perawatan" (`10_update_u2.png`) | Berhasil |
| Delete | `crud/01_crud.sql` blok D1 sampai D3 | Lidah Buaya beserta perawatan dan laporannya terhapus (`11_delete.png`). Hapus tanpa `DETACH` ditolak: G1001 Dependent object error, edges still exist (`11b_delete_ditolak.png`) | Berhasil sesuai harapan |
| Query sesuai workload | `workload-query/01_workload_graf.sql` W1, W4, dan W6 | W1 menampilkan 4 perawatan oleh Pak Very (`12_workload_w1.png`). W4 menampilkan 3 pasangan pelapor dan perawat (`13_workload_w4.png`). PROFILE W6: 4 baris, total database accesses 85 (`14_profile_w6.png`). Graf: 18 node dan 18 relasi (`15_graf.png`) | Berhasil |

Catatan:
- Blok D3 sengaja menghapus tanpa `DETACH` untuk menunjukkan Neo4j menolak penghapusan node yang masih punya relasi.
- Saat memuat perawatan dan laporan, Neo4j menampilkan peringatan informasi `03N90: Cartesian product`. Itu muncul karena dua pola `MATCH` dipisah koma, tetapi tiap pola hanya cocok dengan satu node (nama unik), sehingga aman dan biayanya kecil.

### F. Analisis trade-off

1. **Mengapa sebagian data dipilih?** Keempat tabel inti saling berelasi, dan pertanyaan seperti siapa merawat tanaman apa
   butuh JOIN berantai di MySQL. Atribut tanaman juga beragam menurut jenisnya.
2. **Keunggulan Neo4j?** Relasi disimpan langsung, sehingga satu pola `MATCH` menampilkan pengguna, perawatan, tanaman, dan
   kategorinya. Hubungan juga dapat divisualisasikan sebagai graf.
3. **Keterbatasan dibanding MySQL?** Tidak ada foreign key dan trigger bawaan, kurang efisien untuk agregasi dan rekap besar,
   serta perlu mempelajari Cypher.
4. **Mengapa tidak semua dimigrasikan?** Kolom turunan, kosong, dan berulang tidak memberi manfaat sebagai graf. Data asli
   tetap di MySQL sebagai sumber utama.
5. **Pembagian tanggung jawab?** MySQL: penyimpanan utama, perubahan data, rekap, arsip. Neo4j: penelusuran relasi,
   visualisasi graf, analisis keterhubungan. Perubahan dimulai dari MySQL lalu disalin ke Neo4j.
