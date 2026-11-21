// =====================================================================
// MODUL 12 - TAHAP 2 DAN 3: QUERY PENGUJIAN DAN RENCANA EKSEKUSI
// Kelompok 15 : Bilqis Audynova Prasanty (264311063)
//               Cindika Zahira Thitania Putri (264311064)
//               Yaya Winda Salma (264311087)
// Proyek      : Green Map PNM (SDG 15 - Ekosistem Daratan)
// DBMS target : Neo4j (Aura Free) - Graph Database
// Prasyarat: Bagian A (transportasi) atau Bagian B (Green Map) dari
// 01_migrasi_data_latihan.sql sudah dijalankan.
// Cara pakai: jalankan SATU perintah per kali, lalu screenshot hasilnya.
// =====================================================================


// #####################################################################
// BAGIAN A - KASUS TRANSPORTASI (data Bagian A skrip 01)
// #####################################################################

// ===== A1. Query pengujian =====
// σ: route_id = 12 dan started_at >= 2026-11-01 | ⋈: relasi ON_ROUTE
// π: trip_id, started_at, route_name | Hasil: T001, T003, T005
MATCH (t:Trip)-[:ON_ROUTE]->(r:Route {route_id: 12}) WHERE t.started_at >= datetime('2026-11-01') RETURN t.trip_id, t.started_at, r.route_name;

// ===== A2. Rencana eksekusi tanpa menjalankan query =====
EXPLAIN MATCH (t:Trip)-[:ON_ROUTE]->(r:Route {route_id: 12}) WHERE t.started_at >= datetime('2026-11-01') RETURN t.trip_id, t.started_at, r.route_name;

// ===== A3. Rencana eksekusi dengan menjalankan query (Rows dan DB Hits) =====
PROFILE MATCH (t:Trip)-[:ON_ROUTE]->(r:Route {route_id: 12}) WHERE t.started_at >= datetime('2026-11-01') RETURN t.trip_id, t.started_at, r.route_name;


// #####################################################################
// BAGIAN B - KASUS GREEN MAP PNM (data Bagian B skrip 01)
// #####################################################################

// ===== B1. Query pengujian =====
// Laporan tanaman Bougainvillea sejak 7 November 2026. Hasil: 1 baris (Yaya Winda Salma)
MATCH (p:Pengguna)-[:MELAPORKAN]->(l:Laporan)-[:TENTANG]->(t:Tanaman {nama: 'Bougainvillea'}) WHERE l.tanggal >= date('2026-11-07') RETURN p.nama AS pelapor, l.tanggal AS tanggal, l.kondisi AS kondisi, l.catatan AS catatan, t.nama AS tanaman;

// ===== B2. Rencana eksekusi =====
EXPLAIN MATCH (p:Pengguna)-[:MELAPORKAN]->(l:Laporan)-[:TENTANG]->(t:Tanaman {nama: 'Bougainvillea'}) WHERE l.tanggal >= date('2026-11-07') RETURN p.nama AS pelapor, l.tanggal AS tanggal, l.kondisi AS kondisi, l.catatan AS catatan, t.nama AS tanaman;

// ===== B3. Rencana eksekusi dengan Rows dan DB Hits =====
PROFILE MATCH (p:Pengguna)-[:MELAPORKAN]->(l:Laporan)-[:TENTANG]->(t:Tanaman {nama: 'Bougainvillea'}) WHERE l.tanggal >= date('2026-11-07') RETURN p.nama AS pelapor, l.tanggal AS tanggal, l.kondisi AS kondisi, l.catatan AS catatan, t.nama AS tanaman;
