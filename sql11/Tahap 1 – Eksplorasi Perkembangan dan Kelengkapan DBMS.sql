-- Modul 11 - Tahap 1: Eksplorasi Perkembangan dan Kelengkapan DBMS
-- Proyek: Green Map PNM
-- Prasyarat: database db_green_map_pnm sudah dibuat (sql/01_schema_data.sql)
 
USE db_green_map_pnm;
 
-- 1. Identifikasi DBMS
-- Mengetahui versi DBMS
SELECT VERSION();
 
-- Mengetahui informasi DBMS
SELECT @@version_comment;
 
-- Mengetahui database yang tersedia
SHOW DATABASES;
 
-- Melihat storage engine
SHOW ENGINES;
 
-- Melihat karakteristik server
SHOW VARIABLES LIKE 'character_set_server';
 
-- Melihat collation
SHOW VARIABLES LIKE 'collation_server';
 
-- Memeriksa informasi waktu server
SELECT NOW();
 
-- Memeriksa database aktif
SELECT DATABASE();

-- 2. Fitur JSON
-- Memeriksa dukungan fungsi JSON
SELECT
    JSON_VALID('{"nama":"Budi"}') AS json_valid,
    JSON_EXTRACT(
        '{"nama":"Budi"}',
        '$.nama'
    ) AS nama;
 
-- Membuat tabel percobaan dengan kolom JSON
CREATE TABLE tanaman_json (
  id_tanaman INT PRIMARY KEY,
  atribut JSON
);
 
-- Mengisi data atribut tanaman dalam format JSON
INSERT INTO tanaman_json VALUES
(1, '{"nama":"Trembesi","jenis":"Pohon","lokasi":{"lat":-7.6298,"lng":111.5239}}');
 
-- Mengambil nilai nama dan latitude dari JSON
SELECT JSON_EXTRACT(atribut,'$.nama') AS nama,
       JSON_EXTRACT(atribut,'$.lokasi.lat') AS latitude
FROM tanaman_json;

-- 3. Fasilitas transaksi (data dibatalkan dengan ROLLBACK)
-- Memulai transaksi
START TRANSACTION;
-- Mengubah kondisi tanaman sementara
UPDATE tanaman SET kondisi = 'Sehat' WHERE id_tanaman = 3;
SELECT id_tanaman, nama_tanaman, kondisi FROM tanaman WHERE id_tanaman = 3;
-- Membatalkan perubahan
ROLLBACK;
SELECT id_tanaman, nama_tanaman, kondisi FROM tanaman WHERE id_tanaman = 3;

-- 4. Hak akses pengguna
-- Membuat pengguna baru
CREATE USER 'pengguna_baca'@'localhost' IDENTIFIED BY 'Baca#2026';
-- Memberi hak baca saja
GRANT SELECT ON db_green_map_pnm.* TO 'pengguna_baca'@'localhost';
-- Melihat hak akses pengguna
SHOW GRANTS FOR 'pengguna_baca'@'localhost';

-- 5. Stored function dan log biner
-- Membuat fungsi penghitung laporan per tanaman
CREATE FUNCTION fn_jumlah_laporan(p_id INT) RETURNS INT
READS SQL DATA
RETURN (SELECT COUNT(*) FROM laporan_kondisi WHERE id_tanaman = p_id);
 
-- Memanggil fungsi untuk tanaman dengan id 3 (Bougainvillea)
SELECT fn_jumlah_laporan(3) AS jumlah_laporan;
-- Memeriksa log biner
SHOW VARIABLES LIKE 'log_bin';
