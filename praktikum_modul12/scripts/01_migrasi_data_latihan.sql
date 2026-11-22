// =====================================================================
// MODUL 12 - TAHAP 2: MIGRASI DATA LATIHAN KE DBMS TARGET
// Kelompok 15 : Bilqis Audynova Prasanty (264311063)
//               Cindika Zahira Thitania Putri (264311064)
//               Yaya Winda Salma (264311087)
// Proyek      : Green Map PNM (SDG 15 - Ekosistem Daratan)
// DBMS target : Neo4j (Aura Free) - Graph Database
// Cara pakai: jalankan Bagian A atau Bagian B SATU PER SATU (masing-masing
// diawali reset, sehingga menjalankan yang kedua menghapus data yang pertama).
// =====================================================================


// #####################################################################
// BAGIAN A - KASUS LATIHAN TRANSPORTASI (ROUTES dan TRIPS)
// Catatan: skrip ini disusun dari deskripsi dan hasil di laporan Tahap 2
// (3 Route, 4 Trip, 4 relasi ON_ROUTE). Kolom status pada TRIPS tidak
// tercantum di laporan sehingga tidak dimuat di sini. Jika ada skrip asli,
// ganti isi bagian ini dengan skrip asli.
// #####################################################################

// ===== A1. Reset =====
MATCH (n) DETACH DELETE n;

// ===== A2. Batasan: id unik =====
CREATE CONSTRAINT route_id_unik IF NOT EXISTS FOR (r:Route) REQUIRE r.route_id IS UNIQUE;

CREATE CONSTRAINT trip_id_unik IF NOT EXISTS FOR (t:Trip) REQUIRE t.trip_id IS UNIQUE;

// ===== A3. Node Route (tabel ROUTES) =====
CREATE (:Route {route_id: 12, route_name: 'Koridor Pusat–Terminal'}), (:Route {route_id: 15, route_name: 'Koridor Kampus–Stasiun'}), (:Route {route_id: 18, route_name: 'Koridor Pasar–Kota'});

// ===== A4. Node Trip (tabel TRIPS) =====
CREATE (:Trip {trip_id: 'T001', started_at: datetime('2026-11-02')}), (:Trip {trip_id: 'T003', started_at: datetime('2026-11-03')}), (:Trip {trip_id: 'T004', started_at: datetime('2026-10-29')}), (:Trip {trip_id: 'T005', started_at: datetime('2026-11-05')});

// ===== A5. Relasi ON_ROUTE (pengganti foreign key route_id) =====
MATCH (t:Trip), (r:Route) WHERE (t.trip_id IN ['T001', 'T003', 'T005'] AND r.route_id = 12) OR (t.trip_id = 'T004' AND r.route_id = 18) CREATE (t)-[:ON_ROUTE]->(r);

// ===== A6. Verifikasi (7 node: 3 Route + 4 Trip; 4 relasi ON_ROUTE) =====
MATCH (n) RETURN labels(n)[0] AS jenis_node, count(*) AS jumlah ORDER BY jenis_node;

MATCH ()-[r]->() RETURN type(r) AS relasi, count(*) AS jumlah;


// #####################################################################
// BAGIAN B - KASUS DATABASE KELOMPOK (GREEN MAP PNM)
// Hasil: 18 node dan 18 relasi
// (3 Kategori, 4 Pengguna, 4 Tanaman, 4 Perawatan, 3 Laporan)
// #####################################################################

// ===== B1. Reset =====
MATCH (n) DETACH DELETE n;


// ===== B2. BATASAN: NAMA TIDAK BOLEH GANDA =====
CREATE CONSTRAINT kategori_nama IF NOT EXISTS FOR (k:Kategori) REQUIRE k.nama IS UNIQUE;

CREATE CONSTRAINT tanaman_nama IF NOT EXISTS FOR (t:Tanaman) REQUIRE t.nama IS UNIQUE;

CREATE CONSTRAINT pengguna_nama IF NOT EXISTS FOR (p:Pengguna) REQUIRE p.nama IS UNIQUE;


// ===== B3. NODE KATEGORI =====
CREATE (:Kategori {nama: 'Pohon'}), (:Kategori {nama: 'Tanaman Hias'}), (:Kategori {nama: 'Tanaman Obat'});


// ===== B4. NODE PENGGUNA =====
CREATE (:Pengguna {nama: 'Bilqis Audynova Prasanty', peran: 'Mahasiswa'}), (:Pengguna {nama: 'Cindika Zahira Thitania Putri', peran: 'Mahasiswa'}), (:Pengguna {nama: 'Yaya Winda Salma', peran: 'Mahasiswa'}), (:Pengguna {nama: 'Pak Very', peran: 'Pengelola'});


// ===== B5. NODE TANAMAN (atribut khusus langsung jadi properti) =====
CREATE (:Tanaman {nama: 'Trembesi', kondisi: 'Terawat', latitude: -7.6298, longitude: 111.5239, tinggi_m: 12, diameter_cm: 45, tajuk: 'lebar'}), (:Tanaman {nama: 'Mahoni', kondisi: 'Terawat', latitude: -7.6299, longitude: 111.5241, tinggi_m: 9, diameter_cm: 30}), (:Tanaman {nama: 'Bougainvillea', kondisi: 'Perlu perawatan', latitude: -7.6297, longitude: 111.5238, warna_bunga: 'magenta', musim_berbunga: 'kemarau', penyiraman: 'setiap hari'}), (:Tanaman {nama: 'Jahe', kondisi: 'Terawat', latitude: -7.6300, longitude: 111.5240, bagian_dipakai: 'rimpang', warna_rimpang: 'kuning', khasiat: ['anti-mual', 'hangat']});


// ===== B6. RELASI TANAMAN -> KATEGORI =====
MATCH (t:Tanaman), (k:Kategori) WHERE (t.nama IN ['Trembesi', 'Mahoni'] AND k.nama = 'Pohon') OR (t.nama = 'Bougainvillea' AND k.nama = 'Tanaman Hias') OR (t.nama = 'Jahe' AND k.nama = 'Tanaman Obat') CREATE (t)-[:TERMASUK_KATEGORI]->(k);


// ===== B7. PERAWATAN: (Pengguna)-[:MELAKUKAN]->(Perawatan)-[:PADA]->(Tanaman) =====
MATCH (p:Pengguna {nama: 'Bilqis Audynova Prasanty'}), (t:Tanaman {nama: 'Trembesi'}) CREATE (p)-[:MELAKUKAN]->(:Perawatan {jenis: 'Penyiraman', tanggal: date('2026-11-02')})-[:PADA]->(t);

MATCH (p:Pengguna {nama: 'Cindika Zahira Thitania Putri'}), (t:Tanaman {nama: 'Mahoni'}) CREATE (p)-[:MELAKUKAN]->(:Perawatan {jenis: 'Pemangkasan', tanggal: date('2026-11-03')})-[:PADA]->(t);

MATCH (p:Pengguna {nama: 'Yaya Winda Salma'}), (t:Tanaman {nama: 'Bougainvillea'}) CREATE (p)-[:MELAKUKAN]->(:Perawatan {jenis: 'Penyiraman', tanggal: date('2026-11-04')})-[:PADA]->(t);

MATCH (p:Pengguna {nama: 'Pak Very'}), (t:Tanaman {nama: 'Jahe'}) CREATE (p)-[:MELAKUKAN]->(:Perawatan {jenis: 'Pemupukan', tanggal: date('2026-11-05')})-[:PADA]->(t);


// ===== B8. LAPORAN KONDISI: (Pengguna)-[:MELAPORKAN]->(Laporan)-[:TENTANG]->(Tanaman) =====
MATCH (p:Pengguna {nama: 'Bilqis Audynova Prasanty'}), (t:Tanaman {nama: 'Bougainvillea'}) CREATE (p)-[:MELAPORKAN]->(:Laporan {kondisi: 'Perlu perawatan', catatan: 'Daun mulai menguning', tanggal: date('2026-11-06')})-[:TENTANG]->(t);

MATCH (p:Pengguna {nama: 'Cindika Zahira Thitania Putri'}), (t:Tanaman {nama: 'Trembesi'}) CREATE (p)-[:MELAPORKAN]->(:Laporan {kondisi: 'Terawat', catatan: 'Kondisi baik', tanggal: date('2026-11-06')})-[:TENTANG]->(t);

MATCH (p:Pengguna {nama: 'Yaya Winda Salma'}), (t:Tanaman {nama: 'Bougainvillea'}) CREATE (p)-[:MELAPORKAN]->(:Laporan {kondisi: 'Perlu perawatan', catatan: 'Perlu dipangkas', tanggal: date('2026-11-07')})-[:TENTANG]->(t);


// ===== B9. VERIFIKASI (harus: Kategori 3, Laporan 3, Pengguna 4, Perawatan 4, Tanaman 4) =====
MATCH (n) RETURN labels(n)[0] AS jenis_node, count(*) AS jumlah ORDER BY jenis_node;
