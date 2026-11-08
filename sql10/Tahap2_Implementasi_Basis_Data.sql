-- Modul 10 - Tahap 2: Implementasi Basis Data
-- Proyek: Green Map PNM

-- Membuat Basis Data
CREATE DATABASE IF NOT EXISTS db_green_map_pnm
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;
 
USE db_green_map_pnm;

-- Membuat Tabel Pengguna
CREATE TABLE pengguna (
  id_pengguna INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  peran ENUM('Mahasiswa','Dosen','Staf','Pengelola') NOT NULL
);
