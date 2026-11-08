-- Modul 10 - Tahap 1: Eksplorasi DBMS dan Arsitektur Sistem
-- Proyek: Green Map PNM

-- 1. Identifikasi versi, vendor, storage engine, dan daftar database
SELECT VERSION();
SELECT @@version_comment;
SHOW ENGINES;
SHOW DATABASES;

-- 2. Identifikasi storage engine pada tabel proyek
SHOW TABLE STATUS FROM db_green_map_pnm;

-- 3. Verifikasi jumlah data tabel perawatan
SELECT COUNT(*) FROM db_green_map_pnm.perawatan;
