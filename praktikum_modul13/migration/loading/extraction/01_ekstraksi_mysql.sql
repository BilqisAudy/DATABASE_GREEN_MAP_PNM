-- ============================================================
-- Ekstraksi data dari MySQL (db_green_map_pnm) untuk dimigrasikan ke Neo4j
-- Jalankan di phpMyAdmin (tab SQL). Hasil tiap query diekspor sebagai CSV
-- (tombol Export > CSV) dan disimpan di folder csv/.
-- ============================================================

-- 0. Jumlah data sumber (baseline untuk validasi)
SELECT 'tanaman' AS tabel, COUNT(*) AS jumlah FROM tanaman
UNION ALL SELECT 'pengguna', COUNT(*) FROM pengguna
UNION ALL SELECT 'perawatan', COUNT(*) FROM perawatan
UNION ALL SELECT 'laporan_kondisi', COUNT(*) FROM laporan_kondisi
UNION ALL SELECT 'tanaman_objek', COUNT(*) FROM tanaman_objek;

-- 1. Tanaman (-> node :Tanaman dan :Kategori)
--    Kolom yang tidak dibawa: id_tanaman, manfaat, cara_perawatan, foto, total_laporan
SELECT nama_tanaman, jenis_tanaman, kondisi, latitude, longitude
FROM tanaman;

-- 2. Pengguna (-> node :Pengguna)
SELECT nama, peran
FROM pengguna;

-- 3. Perawatan (-> node :Perawatan + relasi MELAKUKAN dan PADA)
--    id diganti nama lewat JOIN supaya relasi dapat dibuat dengan MATCH berdasarkan nama
SELECT t.nama_tanaman AS tanaman, p.nama AS pengguna, r.tanggal, r.tindakan
FROM perawatan r
JOIN tanaman t ON t.id_tanaman = r.id_tanaman
JOIN pengguna p ON p.id_pengguna = r.id_pengguna
ORDER BY r.id_perawatan;

-- 4. Laporan kondisi (-> node :Laporan + relasi MELAPORKAN dan TENTANG)
--    Kolom yang tidak dibawa: id_laporan, foto_laporan, status
SELECT t.nama_tanaman AS tanaman, p.nama AS pengguna, l.tanggal_lapor, l.deskripsi
FROM laporan_kondisi l
JOIN tanaman t ON t.id_tanaman = l.id_tanaman
JOIN pengguna p ON p.id_pengguna = l.id_pengguna
ORDER BY l.id_laporan;

-- 5. Atribut khusus (-> properti pada node :Tanaman)
SELECT nama_tanaman, atribut
FROM tanaman_objek;

-- 6. Pembanding total_laporan (dipakai saat validasi, dibandingkan dengan hitungan relasi TENTANG)
SELECT nama_tanaman, total_laporan
FROM tanaman
ORDER BY nama_tanaman;
