// ============================================================
// Pemuatan data hasil ekstraksi MySQL ke Neo4j (Neo4j Desktop, Query)
// Prasyarat: jalankan target-dbms/structure/01_constraint.sql lebih dulu.
// Jalankan satu blok per satu, sesuai urutan nomor.
// Nilai di bawah berasal dari hasil ekstraksi (migration/extraction/csv).
// ============================================================

// 0. Bersihkan data Green Map lama (label lain, misalnya Route dan Trip, tidak disentuh)
MATCH (n:Tanaman|Kategori|Pengguna|Perawatan|Laporan) DETACH DELETE n;

// 1. Tanaman + Kategori + relasi TERMASUK_KATEGORI + atribut khusus (dari tanaman_objek)
UNWIND [
  {nama: 'Trembesi', jenis: 'Pohon', kondisi: 'Terawat', latitude: -7.6298, longitude: 111.5239, atribut: {tinggi_m: 13}},
  {nama: 'Mahoni', jenis: 'Pohon', kondisi: 'Terawat', latitude: -7.6299, longitude: 111.5240, atribut: {}},
  {nama: 'Bougainvillea', jenis: 'Tanaman Hias', kondisi: 'Perlu perawatan', latitude: -7.6300, longitude: 111.5241, atribut: {warna_bunga: 'magenta'}},
  {nama: 'Jahe', jenis: 'Tanaman Obat', kondisi: 'Terawat', latitude: -7.6301, longitude: 111.5242, atribut: {khasiat: ['anti-mual', 'hangat'], bagian_dipakai: 'rimpang'}}
] AS r
CREATE (t:Tanaman {nama: r.nama, kondisi: r.kondisi, latitude: r.latitude, longitude: r.longitude})
SET t += r.atribut
MERGE (k:Kategori {nama: r.jenis})
CREATE (t)-[:TERMASUK_KATEGORI]->(k);

// 2. Pengguna
UNWIND [
  {nama: 'Bilqis', peran: 'Mahasiswa'},
  {nama: 'Cindika', peran: 'Mahasiswa'},
  {nama: 'Yaya', peran: 'Mahasiswa'},
  {nama: 'Pak Very', peran: 'Pengelola'}
] AS r
CREATE (:Pengguna {nama: r.nama, peran: r.peran});

// 3. Perawatan + relasi MELAKUKAN dan PADA
UNWIND [
  {tanaman: 'Trembesi', pengguna: 'Pak Very', tanggal: '2026-10-01', jenis: 'Penyiraman'},
  {tanaman: 'Trembesi', pengguna: 'Pak Very', tanggal: '2026-10-15', jenis: 'Pemangkasan'},
  {tanaman: 'Bougainvillea', pengguna: 'Pak Very', tanggal: '2026-10-20', jenis: 'Pemupukan'},
  {tanaman: 'Mahoni', pengguna: 'Pak Very', tanggal: '2026-10-22', jenis: 'Penyiraman'}
] AS r
MATCH (p:Pengguna {nama: r.pengguna}), (t:Tanaman {nama: r.tanaman})
CREATE (p)-[:MELAKUKAN]->(:Perawatan {jenis: r.jenis, tanggal: date(r.tanggal)})-[:PADA]->(t);

// 4. Laporan + relasi MELAPORKAN dan TENTANG
UNWIND [
  {tanaman: 'Bougainvillea', pengguna: 'Bilqis', tanggal: '2026-10-18', kondisi: 'Daun layu'},
  {tanaman: 'Bougainvillea', pengguna: 'Cindika', tanggal: '2026-10-19', kondisi: 'Daun menguning'},
  {tanaman: 'Trembesi', pengguna: 'Yaya', tanggal: '2026-10-25', kondisi: 'Cabang patah'}
] AS r
MATCH (p:Pengguna {nama: r.pengguna}), (t:Tanaman {nama: r.tanaman})
CREATE (p)-[:MELAPORKAN]->(:Laporan {tanggal: date(r.tanggal), kondisi: r.kondisi})-[:TENTANG]->(t);
