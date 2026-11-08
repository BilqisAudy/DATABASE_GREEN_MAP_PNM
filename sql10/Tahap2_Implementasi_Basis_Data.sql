-- Modul 10 - Tahap 2: Implementasi Basis Data
-- Proyek: Green Map PNM

-- 1. Membuat Basis Data
CREATE DATABASE IF NOT EXISTS db_green_map_pnm
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;
 
USE db_green_map_pnm;

-- 2. Membuat Tabel Pengguna
CREATE TABLE pengguna (
  id_pengguna INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  peran ENUM('Mahasiswa','Dosen','Staf','Pengelola') NOT NULL
);

-- 3. Membuat Tabel Tanaman
CREATE TABLE tanaman (
  id_tanaman INT AUTO_INCREMENT PRIMARY KEY,
  nama_tanaman VARCHAR(100) NOT NULL,
  jenis_tanaman VARCHAR(50) NOT NULL,
  manfaat TEXT,
  cara_perawatan TEXT,
  kondisi VARCHAR(50),
  foto VARCHAR(255),
  latitude DECIMAL(10,7),
  longitude DECIMAL(10,7)
);

-- 4. Membuat Tabel Perawatan
CREATE TABLE perawatan (
  id_perawatan INT AUTO_INCREMENT PRIMARY KEY,
  id_tanaman INT NOT NULL,
  id_pengguna INT NOT NULL,
  tanggal DATE,
  tindakan VARCHAR(100),
  catatan TEXT,
  FOREIGN KEY (id_tanaman) REFERENCES tanaman(id_tanaman),
  FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna)
);

-- 5. Membuat Tabel Laporan Kondisi
CREATE TABLE laporan_kondisi (
  id_laporan INT AUTO_INCREMENT PRIMARY KEY,
  id_tanaman INT NOT NULL,
  id_pengguna INT NOT NULL,
  tanggal_lapor DATE,
  deskripsi TEXT,
  foto_laporan VARCHAR(255),
  status ENUM('diterima','diproses','selesai') DEFAULT 'diterima',
  FOREIGN KEY (id_tanaman) REFERENCES tanaman(id_tanaman),
  FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna)
);

-- 6. Memeriksa Relasi Tabel
SELECT TABLE_NAME AS tabel_anak,
       COLUMN_NAME AS foreign_key,
       REFERENCED_TABLE_NAME AS tabel_induk,
       REFERENCED_COLUMN_NAME AS primary_key
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'db_green_map_pnm'
  AND REFERENCED_TABLE_NAME IS NOT NULL;
 
SHOW CREATE TABLE perawatan;

-- 7. Mengisi Data Awal
