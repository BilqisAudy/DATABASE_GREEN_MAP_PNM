// =====================================================================
// MODUL 12 - TAHAP 5: RANCANGAN MIGRASI QUERY DAN KONTROL AKSES (PjBL)
// Kelompok 15 : Bilqis Audynova Prasanty (264311063)
//               Cindika Zahira Thitania Putri (264311064)
//               Yaya Winda Salma (264311087)
// Proyek      : Green Map PNM (SDG 15 - Ekosistem Daratan)
// DBMS target : Neo4j (Aura Free) - Graph Database
// Migrasi: MySQL -> Neo4j
// Fitur utama: Peta digital (KF-07), yaitu detail tanaman, riwayat
// perawatan, dan laporan kondisi saat marker tanaman dipilih.
// Prasyarat: data Green Map PNM (Bagian B skrip 01) sudah dimuat.
// =====================================================================


// ===== 1. Query fitur utama (pengganti join 3 tabel) =====
// Pattern comprehension dipakai agar perawatan dan laporan tidak saling
// dikalikan menjadi baris ganda.
MATCH (t:Tanaman {nama: 'Bougainvillea'})-[:TERMASUK_KATEGORI]->(k:Kategori) RETURN t.nama AS tanaman, k.nama AS jenis, t.kondisi AS kondisi, t.latitude AS lat, t.longitude AS lng, [(pr:Perawatan)-[:PADA]->(t) | pr.jenis + ' (' + toString(pr.tanggal) + ')'] AS riwayat_perawatan, [(l:Laporan)-[:TENTANG]->(t) | l.catatan] AS laporan;


// ===== 2. Optimisasi saat data membesar =====
// 2a. Index pencarian: constraint unik Tanaman.nama otomatis membuat index
// (sudah dibuat pada skrip 01).

// 2b. Simpan lokasi sebagai point untuk pencarian di area peta
MATCH (t:Tanaman) SET t.lokasi = point({latitude: t.latitude, longitude: t.longitude});

CREATE POINT INDEX tanaman_lokasi IF NOT EXISTS FOR (t:Tanaman) ON (t.lokasi);

// 2c. Bandingkan db hits dengan PROFILE
PROFILE MATCH (t:Tanaman {nama: 'Bougainvillea'}) RETURN t.nama, t.lokasi;


// ===== 3. Rancangan DCL / RBAC (TIDAK dijalankan di Aura Free) =====
// Pengelola: baca dan tulis semua data.
// Civitas akademika: baca semua data dan membuat laporan kondisi baru.
// CREATE ROLE pengelola;
// GRANT ACCESS ON DATABASE neo4j TO pengelola;
// GRANT MATCH {*} ON GRAPH neo4j TO pengelola;
// GRANT WRITE ON GRAPH neo4j TO pengelola;
//
// CREATE ROLE civitas;
// GRANT ACCESS ON DATABASE neo4j TO civitas;
// GRANT MATCH {*} ON GRAPH neo4j TO civitas;
// GRANT CREATE ON GRAPH neo4j NODES Laporan TO civitas;
// GRANT CREATE ON GRAPH neo4j RELATIONSHIPS MELAPORKAN, TENTANG TO civitas;
// GRANT SET PROPERTY {*} ON GRAPH neo4j NODES Laporan TO civitas;
//
// CREATE USER pak_very SET PASSWORD '<password_placeholder>' CHANGE REQUIRED;
// GRANT ROLE pengelola TO pak_very;
