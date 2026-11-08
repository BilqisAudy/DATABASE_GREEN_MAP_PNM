-- 01: Pembuatan database, tabel, dan data contoh
-- Proyek: Green Map PNM

CREATE DATABASE IF NOT EXISTS db_green_map_pnm;
USE db_green_map_pnm;

CREATE TABLE pengguna (
  id_pengguna INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  peran ENUM('Mahasiswa','Dosen','Staf','Pengelola') NOT NULL
);

CREATE TABLE tanaman (
  id_tanaman INT AUTO_INCREMENT PRIMARY KEY,
  jenis_tanaman VARCHAR(50) NOT NULL,
  nama_tanaman VARCHAR(100) NOT NULL,
  kondisi VARCHAR(50),
  foto VARCHAR(255),
  latitude DECIMAL(10,7),
  longitude DECIMAL(10,7)
);

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

INSERT INTO pengguna (nama, peran) VALUES
('Bilqis','Mahasiswa'),
('Cindika','Mahasiswa'),
('Yaya','Mahasiswa'),
('Pak Very','Pengelola');

INSERT INTO tanaman (jenis_tanaman, nama_tanaman, kondisi, latitude, longitude) VALUES
('Pohon','Trembesi','Terawat',-7.6298,111.5239),
('Pohon','Mahoni','Terawat',-7.6299,111.5240),
('Tanaman Hias','Bougainvillea','Perlu perawatan',-7.6300,111.5241),
('Tanaman Obat','Jahe','Terawat',-7.6301,111.5242);

INSERT INTO perawatan (id_tanaman, id_pengguna, tanggal, tindakan, catatan) VALUES
(1,4,'2026-10-01','Penyiraman','Rutin'),
(1,4,'2026-10-15','Pemangkasan','Cabang kering'),
(3,4,'2026-10-20','Pemupukan','Pupuk NPK'),
(2,4,'2026-10-22','Penyiraman','Rutin');

INSERT INTO laporan_kondisi (id_tanaman, id_pengguna, tanggal_lapor, deskripsi, status) VALUES
(3,1,'2026-10-18','Daun layu','diproses'),
(3,2,'2026-10-19','Daun menguning','diterima'),
(1,3,'2026-10-25','Cabang patah','selesai');
