-- Post-Test No. 2: Script pembuatan tabel, Primary Key, Foreign Key, dan pengujian CRUD


-- 1. Script pembuatan tabel (struktur sama dengan db_green_map_pnm)
CREATE TABLE IF NOT EXISTS pengguna (
  id_pengguna INT NOT NULL AUTO_INCREMENT,
  nama VARCHAR(100) NOT NULL,
  peran ENUM('Mahasiswa','Dosen','Staf','Pengelola') NOT NULL,
  PRIMARY KEY (id_pengguna)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tanaman (
  id_tanaman INT NOT NULL AUTO_INCREMENT,
  nama_tanaman VARCHAR(100) NOT NULL,
  jenis_tanaman VARCHAR(50) NOT NULL,
  manfaat TEXT,
  cara_perawatan TEXT,
  kondisi VARCHAR(50) DEFAULT NULL,
  foto VARCHAR(255) DEFAULT NULL,
  latitude DECIMAL(10,7) DEFAULT NULL,
  longitude DECIMAL(10,7) DEFAULT NULL,
  total_laporan INT DEFAULT 0,
  PRIMARY KEY (id_tanaman)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS laporan_kondisi (
  id_laporan INT NOT NULL AUTO_INCREMENT,
  id_tanaman INT NOT NULL,
  id_pengguna INT NOT NULL,
  tanggal_lapor DATE DEFAULT NULL,
  deskripsi TEXT,
  foto_laporan VARCHAR(255) DEFAULT NULL,
  status ENUM('diterima','diproses','selesai') DEFAULT 'diterima',
  PRIMARY KEY (id_laporan),
  CONSTRAINT laporan_kondisi_ibfk_1 FOREIGN KEY (id_tanaman) REFERENCES tanaman (id_tanaman),
  CONSTRAINT laporan_kondisi_ibfk_2 FOREIGN KEY (id_pengguna) REFERENCES pengguna (id_pengguna)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS perawatan (
  id_perawatan INT NOT NULL AUTO_INCREMENT,
  id_tanaman INT NOT NULL,
  id_pengguna INT NOT NULL,
  tanggal DATE DEFAULT NULL,
  tindakan VARCHAR(100) DEFAULT NULL,
  catatan TEXT,
  PRIMARY KEY (id_perawatan),
  CONSTRAINT perawatan_ibfk_1 FOREIGN KEY (id_tanaman) REFERENCES tanaman (id_tanaman),
  CONSTRAINT perawatan_ibfk_2 FOREIGN KEY (id_pengguna) REFERENCES pengguna (id_pengguna)
) ENGINE=InnoDB;

-- Bukti struktur PK dan FK
SHOW CREATE TABLE laporan_kondisi;
SHOW CREATE TABLE perawatan;

-- 2. CREATE: menambah data uji (tabel induk dulu, baru tabel anak)
START TRANSACTION;

INSERT INTO pengguna (id_pengguna, nama, peran)
VALUES (901, 'Pengguna Uji', 'Mahasiswa');

INSERT INTO tanaman (id_tanaman, nama_tanaman, jenis_tanaman, manfaat, cara_perawatan, kondisi, latitude, longitude, total_laporan)
VALUES (901, 'Tanaman Uji', 'Tanaman Hias', 'Data uji CRUD', 'Siram 1x sehari', 'Terawat', -7.6302000, 111.5243000, 0);

INSERT INTO laporan_kondisi (id_laporan, id_tanaman, id_pengguna, tanggal_lapor, deskripsi, status)
VALUES (901, 901, 901, '2026-11-08', 'Daun layu (data uji)', 'diterima');

UPDATE tanaman
SET total_laporan = total_laporan + 1
WHERE id_tanaman = 901;

INSERT INTO perawatan (id_perawatan, id_tanaman, id_pengguna, tanggal, tindakan, catatan)
VALUES (901, 901, 901, '2026-11-08', 'Penyiraman', 'Data uji');

COMMIT;

-- 3. READ: membuktikan data tersimpan dan relasi antar tabel
SELECT * FROM tanaman WHERE id_tanaman = 901;

SELECT l.id_laporan, t.nama_tanaman, p.nama AS pelapor, l.tanggal_lapor, l.deskripsi, l.status
FROM laporan_kondisi l
JOIN tanaman t ON l.id_tanaman = t.id_tanaman
JOIN pengguna p ON l.id_pengguna = p.id_pengguna
WHERE l.id_laporan = 901;

-- 4. UPDATE: mengubah data uji
UPDATE laporan_kondisi SET status = 'diproses' WHERE id_laporan = 901;
UPDATE tanaman SET kondisi = 'Perlu perawatan' WHERE id_tanaman = 901;

SELECT id_laporan, status FROM laporan_kondisi WHERE id_laporan = 901;
SELECT id_tanaman, kondisi, total_laporan FROM tanaman WHERE id_tanaman = 901;

-- 5. Pengujian constraint
-- Jalankan SATU PER SATU. Setiap perintah di bawah HARUS ditolak MySQL (muncul error).

-- 5a. Foreign key: laporan untuk tanaman yang tidak ada
-- Hasil yang diharapkan: Error 1452 (Cannot add or update a child row)
INSERT INTO laporan_kondisi (id_laporan, id_tanaman, id_pengguna, tanggal_lapor, deskripsi)
VALUES (902, 999, 901, '2026-11-08', 'Tanaman tidak ada');

-- 5b. Foreign key: menghapus tanaman yang masih punya laporan dan perawatan
-- Hasil yang diharapkan: Error 1451 (Cannot delete or update a parent row)
DELETE FROM tanaman WHERE id_tanaman = 901;

-- 5c. Primary key: id_pengguna duplikat
-- Hasil yang diharapkan: Error 1062 (Duplicate entry '901' for key 'PRIMARY')
INSERT INTO pengguna (id_pengguna, nama, peran)
VALUES (901, 'Duplikat', 'Dosen');

-- 5d. NOT NULL: nama pengguna kosong
-- Hasil yang diharapkan: Error 1048 (Column 'nama' cannot be null)
INSERT INTO pengguna (id_pengguna, nama, peran)
VALUES (902, NULL, 'Dosen');

-- 5e. ENUM: peran di luar daftar yang diizinkan
-- Hasil yang diharapkan: Error 1265 (Data truncated for column 'peran')
INSERT INTO pengguna (id_pengguna, nama, peran)
VALUES (902, 'Peran Salah', 'Alien');

-- 6. DELETE: menghapus data uji (tabel anak dulu, baru tabel induk)
START TRANSACTION;

DELETE FROM perawatan WHERE id_perawatan = 901;
DELETE FROM laporan_kondisi WHERE id_laporan = 901;

UPDATE tanaman
SET total_laporan = total_laporan - 1
WHERE id_tanaman = 901;

DELETE FROM tanaman WHERE id_tanaman = 901;
DELETE FROM pengguna WHERE id_pengguna = 901;

COMMIT;

-- 7. Verifikasi: jumlah data kembali seperti semula (3, 4, 4, 4)
SELECT COUNT(*) AS jml_laporan_kondisi FROM laporan_kondisi;
SELECT COUNT(*) AS jml_pengguna FROM pengguna;
SELECT COUNT(*) AS jml_perawatan FROM perawatan;
SELECT COUNT(*) AS jml_tanaman FROM tanaman;
