# Praktikum Modul 12: Pemrosesan Query, Aljabar Relasional, dan Kontrol Akses

Proyek **Green Map PNM**, sistem pemetaan dan identifikasi tanaman Kampus 2 Politeknik Negeri Madiun (SDG 15: Ekosistem Daratan).

DBMS target migrasi: **Neo4j** (Neo4j Aura Free), kategori Graph Database.

## Anggota Kelompok 15

| Nama | NIM |
|---|---|
| Bilqis Audynova Prasanty | 264311063 |
| Cindika Zahira Thitania Putri | 264311064 |
| Yaya Winda Salma | 264311087 |

Kelas 1C, D4 Teknologi Rekayasa Perangkat Lunak (TRPL).

## Struktur Folder

```
praktikum_modul12/
├── scripts/
│   ├── 01_migrasi_data_latihan.sql
│   ├── 02_query_transportasi.sql
│   ├── 03_pengujian_dcl.sql
│   └── 04_rancangan_migrasi_pjbl.sql
├── dokumentasi/
│   ├── analisis_query_cost.pdf
│   └── laporan_modul12.pdf
├── diagram/
│   └── query_tree.png
└── README.md
```

## Isi Berkas

| Berkas | Tahap | Keterangan |
|---|---|---|
| `scripts/01_migrasi_data_latihan.sql` | 2 | Migrasi data ke Neo4j. Bagian A: kasus latihan transportasi (ROUTES dan TRIPS). Bagian B: kasus Green Map PNM (18 node, 18 relasi). |
| `scripts/02_query_transportasi.sql` | 2 dan 3 | Query pengujian, `EXPLAIN`, dan `PROFILE` untuk kasus transportasi dan Green Map PNM. |
| `scripts/03_pengujian_dcl.sql` | 4 | Pengujian hak akses akun pelapor (baca diizinkan, hapus ditolak) dan rancangan DCL untuk Neo4j Enterprise. |
| `scripts/04_rancangan_migrasi_pjbl.sql` | 5 | Rancangan query fitur peta digital, optimisasi (index, point index), dan rancangan RBAC. |
| `dokumentasi/analisis_query_cost.pdf` | 3 | Perbandingan rencana eksekusi, estimasi query cost, dan inspeksi `EXPLAIN`/`PROFILE`. |
| `dokumentasi/laporan_modul12.pdf` | 1 sampai 5 | Laporan praktikum lengkap. |
| `diagram/query_tree.png` | 2 dan 3 | Query tree Rencana 1 (join dahulu) dan Rencana 2 (seleksi dahulu). |

## Ringkasan Tahap

| Tahap | Kegiatan | Hasil utama | Letak |
|---|---|---|---|
| 1 | Konsep dasar pemrosesan query, aljabar relasional, dan query tree | Instance Neo4j Aura (versi dan data Green Map), pemetaan σ, π, dan ⋈ ke Cypher, query tree dan `EXPLAIN`, serta pengujian parsing dan validasi | `dokumentasi/laporan_modul12.pdf` |
| 2 | Migrasi data latihan ke DBMS target dan pemodelan query | Kasus transportasi (3 Route, 4 Trip) dan Green Map PNM (18 node, 18 relasi) berhasil dimigrasikan | `scripts/01`, `scripts/02`, `dokumentasi/laporan_modul12.pdf` |
| 3 | Analisis query cost dan rencana eksekusi | Perbandingan join dahulu vs seleksi dahulu, estimasi page read, `EXPLAIN` dan `PROFILE` | `scripts/02`, `dokumentasi/analisis_query_cost.pdf`, `diagram/query_tree.png` |
| 4 | Kontrol akses (DCL) dan prinsip least privilege | Akun pelapor (Viewer): baca berhasil, hapus ditolak, akses dicabut | `scripts/03`, `dokumentasi/laporan_modul12.pdf` |
| 5 | Rancangan migrasi query dan kontrol akses proyek PjBL | Query fitur peta digital, optimisasi (index dan point index), dan rancangan RBAC | `scripts/04`, `dokumentasi/laporan_modul12.pdf` |
| 6 | Dokumentasi di Git | Struktur folder `praktikum_modul12` pada repositori ini | Seluruh folder |

## Cara Menjalankan

1. Buat instance **Neo4j Aura Free** di `console.neo4j.io`, lalu buka **Query**.
2. Jalankan `01_migrasi_data_latihan.sql` **per bagian**. Bagian A dan B masing-masing diawali reset, jadi menjalankan salah satunya menghapus data bagian lain.
3. Jalankan `02` sampai `04` **satu perintah per kali**, lalu bandingkan hasilnya dengan laporan.

## Catatan

- Pada Neo4j Aura Free, role kustom tidak didukung. Perintah `GRANT` dan `REVOKE` di `03` dan `04` ditulis sebagai rancangan (dikomentari) untuk Neo4j Enterprise.
- Password database tidak disimpan di repositori. Nilai `<password_placeholder>` harus diganti sendiri saat dipakai.
