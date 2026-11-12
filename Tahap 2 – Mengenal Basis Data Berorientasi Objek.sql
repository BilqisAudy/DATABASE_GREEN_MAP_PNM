-- 1. Membuat database dan tabel katalog dengan kolom JSON
CREATE DATABASE IF NOT EXISTS db_katalog_tanaman;
USE db_katalog_tanaman;
 
CREATE TABLE katalog_tanaman (
  id_tanaman INT PRIMARY KEY,
  nama_tanaman VARCHAR(100) NOT NULL,
  jenis_tanaman VARCHAR(50) NOT NULL,
  detail JSON
) ENGINE=InnoDB;
 
DESCRIBE db_katalog_tanaman.katalog_tanaman;
