-- 1. CREATE – Menambahkan Data
--- a. Tambah Data
INSERT INTO pengguna
    (id_pengguna, nama, peran)
VALUES
    ('5', 'Tita', 'Dosen');

--- b. Cek Hasil
SELECT * FROM `pengguna`

	
-- 2. READ – Membaca Data
SELECT id_pengguna, nama, peran FROM pengguna;


-- 3. UPDATE – Memperbarui Data
--- a. Update Data
	UPDATE tanaman 
SET kondisi = 'Terawat' 
WHERE id_tanaman = 3;

--- b. Cek Hasil
SELECT id_tanaman, nama_tanaman, kondisi 
FROM tanaman 
WHERE id_tanaman = 3;


-- 4. DELETE – Menghapus Data
--- a. Hapus Data
	DELETE FROM laporan_kondisi WHERE id_pengguna = 2;

--- b. Cek Hasil
SELECT * FROM `laporan_kondisi` WHERE 1

	
-- 5. Menguji Integritas Referensial
INSERT INTO perawatan
    (id_tanaman, id_pengguna, tanggal, tindakan, catatan)
VALUES
    (1, 4, '2026-11-08', 'Penyiraman', 'Uji data valid');

DELETE FROM pengguna
WHERE id_pengguna = 4;

