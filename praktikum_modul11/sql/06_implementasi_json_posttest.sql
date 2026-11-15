-- Praktikum Modul 11 | 06 Implementasi JSON (Lembar Kerja Post-Test no. 2)
-- Proyek: Green Map PNM
-- Prasyarat: database db_green_map_pnm, tabel kategori_tanaman dan tanaman_objek sudah ada
-- (struktur tabel tanaman_objek ada pada laporan bagian 2.1, hasil SHOW CREATE TABLE)

USE db_green_map_pnm;

-- 2.1 Melihat struktur tabel
SHOW CREATE TABLE tanaman_objek;

-- 2.2 Mengisi tabel kategori
INSERT INTO kategori_tanaman (id_kategori, nama_kategori) VALUES
(1, 'Pohon'),
(2, 'Tanaman Obat'),
(3, 'Tanaman Hias');
SELECT * FROM kategori_tanaman;

-- 2.3 INSERT (menambah data)
INSERT INTO tanaman_objek (nama_tanaman, jenis_tanaman, id_kategori, kondisi, spesifikasi)
VALUES
('Mangga', 'Pohon', 1, 'Baik',
    JSON_OBJECT('tinggi_m', 8, 'diameter_cm', 30)),
('Lidah Buaya', 'Tanaman Obat', 2, 'Baik',
    JSON_OBJECT('bagian_dipakai', 'daun',
                'khasiat', JSON_ARRAY('melembapkan kulit', 'menyejukkan'))),
('Kembang Sepatu', 'Tanaman Hias', 3, 'Baik',
    JSON_OBJECT('warna_bunga', 'merah', 'musim_berbunga', 'sepanjang tahun'));

-- 2.4 SELECT (membaca data)
SELECT * FROM tanaman_objek;

-- 2.5 UPDATE (mengubah data JSON)
-- Mengubah nilai atribut yang sudah ada
UPDATE tanaman_objek
SET spesifikasi = JSON_SET(spesifikasi, '$.tinggi_m', 9)
WHERE nama_tanaman = 'Mangga';

-- Menambah atribut baru
UPDATE tanaman_objek
SET spesifikasi = JSON_SET(spesifikasi, '$.catatan', 'perlu disiram rutin')
WHERE nama_tanaman = 'Kembang Sepatu';

-- Memeriksa hasil
SELECT nama_tanaman, spesifikasi FROM tanaman_objek
WHERE nama_tanaman IN ('Mangga', 'Kembang Sepatu');

-- 2.6 DELETE (menghapus data)
-- Menghapus satu atribut di dalam JSON
UPDATE tanaman_objek
SET spesifikasi = JSON_REMOVE(spesifikasi, '$.diameter_cm')
WHERE nama_tanaman = 'Mangga';

SELECT nama_tanaman, spesifikasi FROM tanaman_objek
WHERE nama_tanaman = 'Mangga';

-- Menghapus satu baris data
DELETE FROM tanaman_objek WHERE nama_tanaman = 'Kembang Sepatu';

SELECT * FROM tanaman_objek;
