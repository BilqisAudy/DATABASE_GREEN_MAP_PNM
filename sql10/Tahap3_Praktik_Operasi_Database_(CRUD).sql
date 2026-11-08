-- 1. CREATE – Menambahkan Data
---- a. Tambah Data
        INSERT INTO pengguna
            (id_pengguna, nama, peran)
        VALUES
            ('5', 'Tita', 'Dosen');

---- b. Cek Hasil
        SELECT * FROM `pengguna`

-- 2. READ – Membaca Data
      	SELECT id_pengguna, nama, peran FROM pengguna;

-- 3. UPDATE – Memperbarui Data
	UPDATE tanaman 
SET kondisi = 'Terawat' 
WHERE id_tanaman = 3;


