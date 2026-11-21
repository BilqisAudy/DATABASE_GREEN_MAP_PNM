// =====================================================================
// MODUL 12 - TAHAP 4: PENGUJIAN HAK AKSES (DCL)
// Kelompok 15 : Bilqis Audynova Prasanty (264311063)
//               Cindika Zahira Thitania Putri (264311064)
//               Yaya Winda Salma (264311087)
// Proyek      : Green Map PNM (SDG 15 - Ekosistem Daratan)
// DBMS target : Neo4j (Aura Free) - Graph Database
// Catatan: pada Neo4j Aura Free, role kustom tidak didukung (CREATE ROLE
// ditolak dengan error 42NFF). Akun pelapor dibuat lewat console Aura
// (undang akun kedua dengan role project Viewer). Perintah DCL asli
// (GRANT/REVOKE) di bagian C hanya rancangan untuk Neo4j Enterprise.
// Prasyarat: data Green Map PNM (Bagian B skrip 01) sudah dimuat.
// =====================================================================


// ===== A. Percobaan DCL oleh administrator (ditolak pada Aura Free) =====
CREATE ROLE reporter;


// ===== B. Pengujian oleh akun pelapor (role Viewer, jendela Incognito) =====

// B1. Baca data: diizinkan (4 baris: Trembesi, Mahoni, Bougainvillea, Jahe)
MATCH (t:Tanaman) RETURN t.nama, t.kondisi;

// B2. Siapkan node uji (dijalankan oleh ADMINISTRATOR, bukan pelapor)
CREATE (:Uji {id: 1});

// B3. Hapus data: harus ditolak (Access denied, error 42NFF)
MATCH (u:Uji) DETACH DELETE u;

// B4. Setelah pengujian, administrator membersihkan node uji
// MATCH (u:Uji) DETACH DELETE u;

// B5. REVOKE pada Aura Free = mengeluarkan akun pelapor dari project
// (lewat console Aura: Project users -> Remove). Setelah halaman di-refresh,
// akun pelapor mendapat 404 Page not found.


// ===== C. Rancangan DCL untuk Neo4j Enterprise (TIDAK dijalankan) =====
// Sintaks perlu diverifikasi pada versi yang dipakai.
// CREATE USER report_user SET PASSWORD '<password_placeholder>' CHANGE NOT REQUIRED;
// CREATE ROLE reporter;
// GRANT ROLE reporter TO report_user;
// GRANT ACCESS ON DATABASE neo4j TO reporter;
// GRANT MATCH {*} ON GRAPH neo4j NODES Tanaman, Kategori TO reporter;
// GRANT MATCH {*} ON GRAPH neo4j RELATIONSHIPS TERMASUK_KATEGORI TO reporter;
// SHOW ROLE reporter PRIVILEGES AS COMMANDS;
// REVOKE MATCH {*} ON GRAPH neo4j NODES Tanaman, Kategori FROM reporter;
