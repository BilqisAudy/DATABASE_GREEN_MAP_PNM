-- ============================================================
-- Modul 11 - Eksplorasi DBMS Lanjutan
-- Proyek : Green Map PNM (SDG 15 Ekosistem Daratan)
-- Kelas  : 1C D4 TRPL - Politeknik Negeri Madiun
-- Anggota: Bilqis Audynova Prasanty (264311063)
--          Cindika Zahira Thitania Putri (264311064)
--          Yaya Winda Salma (264311087)
-- DBMS   : MySQL/MariaDB (Laragon), phpMyAdmin
--
-- Isi script (jalankan berurutan):
--   Bagian A : Tahap 3 dan 4 pada database praktikum_modul11
--   Bagian B : Lembar kerja post-test pada database db_green_map_pnm
-- ============================================================

-- ------------------------------------------------------------
-- BAGIAN A - Database praktikum_modul11
-- Database praktikum dibuat ulang agar script dapat dijalankan berulang.
-- ------------------------------------------------------------
DROP DATABASE IF EXISTS praktikum_modul11;

-- ===== A1. Membuat database =====
CREATE DATABASE IF NOT EXISTS praktikum_modul11
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

USE praktikum_modul11;

-- ===== A2. Membuat tabel =====
USE praktikum_modul11;

-- Tabel kategori
CREATE TABLE kategori (
    id_kategori INT AUTO_INCREMENT PRIMARY KEY,
    nama_kategori VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Tabel tanaman (atribut tambahan disimpan sebagai JSON)
CREATE TABLE tanaman (
    id_tanaman INT AUTO_INCREMENT PRIMARY KEY,
    id_kategori INT NOT NULL,
    nama_tanaman VARCHAR(150) NOT NULL,
    kondisi VARCHAR(50) NOT NULL,
    atribut JSON NOT NULL,

    CONSTRAINT fk_tanaman_kategori
        FOREIGN KEY (id_kategori)
        REFERENCES kategori(id_kategori)
) ENGINE=InnoDB;

-- ===== A3. Mengisi data awal =====
USE praktikum_modul11;

-- Mengisi data kategori
INSERT INTO kategori (nama_kategori)
VALUES
    ('Pohon'),
    ('Tanaman Hias'),
    ('Tanaman Obat');

-- Memeriksa data
SELECT * FROM kategori;

-- Tanaman kategori Pohon
INSERT INTO tanaman (id_kategori, nama_tanaman, kondisi, atribut)
VALUES (
    1,
    'Trembesi',
    'Sehat',
    '{
        "tinggi_m": 12,
        "diameter_cm": 45,
        "tajuk": "lebar"
    }'
);

-- Tanaman kategori Tanaman Hias
INSERT INTO tanaman (id_kategori, nama_tanaman, kondisi, atribut)
VALUES (
    2,
    'Bougainvillea',
    'Perlu perawatan',
    '{
        "warna_bunga": "magenta",
        "musim_berbunga": "kemarau",
        "penyiraman": "setiap hari"
    }'
);

-- Tanaman kategori Tanaman Obat
INSERT INTO tanaman (id_kategori, nama_tanaman, kondisi, atribut)
VALUES (
    3,
    'Jahe',
    'Sehat',
    '{
        "bagian_dipakai": "rimpang",
        "warna_rimpang": "kuning",
        "khasiat": [
            "anti-mual",
            "hangat"
        ]
    }'
);

-- Memeriksa seluruh data
SELECT * FROM tanaman;

-- ===== A4. Pengujian fitur JSON =====
USE praktikum_modul11;

-- 6. Membaca atribut JSON
-- Mengambil atribut tinggi pohon
SELECT
    nama_tanaman,
    JSON_EXTRACT(
        atribut,
        '$.tinggi_m'
    ) AS tinggi_m
FROM tanaman;

-- Mengambil atribut warna bunga
SELECT
    nama_tanaman,
    JSON_EXTRACT(
        atribut,
        '$.warna_bunga'
    ) AS warna_bunga
FROM tanaman;

-- Mengambil atribut khasiat
SELECT
    nama_tanaman,
    JSON_EXTRACT(
        atribut,
        '$.khasiat'
    ) AS khasiat
FROM tanaman;

-- 7. Mengubah atribut JSON
-- Tinggi Trembesi berubah menjadi 13 meter
UPDATE tanaman
SET atribut = JSON_SET(
    atribut,
    '$.tinggi_m',
    13
)
WHERE nama_tanaman = 'Trembesi';

-- Memeriksa hasil
SELECT
    nama_tanaman,
    JSON_EXTRACT(
        atribut,
        '$.tinggi_m'
    ) AS tinggi_m
FROM tanaman
WHERE nama_tanaman = 'Trembesi';

-- 8. Menambahkan atribut JSON
-- Trembesi mendapatkan atribut baru berupa fungsi
UPDATE tanaman
SET atribut = JSON_SET(
    atribut,
    '$.fungsi',
    'Peneduh'
)
WHERE nama_tanaman = 'Trembesi';

-- Memeriksa hasil
SELECT
    nama_tanaman,
    atribut
FROM tanaman
WHERE nama_tanaman = 'Trembesi';

-- 9. Menghapus atribut JSON
-- Atribut diameter_cm Trembesi dihapus
UPDATE tanaman
SET atribut = JSON_REMOVE(
    atribut,
    '$.diameter_cm'
)
WHERE nama_tanaman = 'Trembesi';

-- Memeriksa hasil
SELECT
    nama_tanaman,
    atribut
FROM tanaman;

-- 10. Pencarian berdasarkan atribut JSON
-- Mencari tanaman berbunga magenta
SELECT
    nama_tanaman,
    kondisi,
    atribut
FROM tanaman
WHERE JSON_UNQUOTE(
    JSON_EXTRACT(
        atribut,
        '$.warna_bunga'
    )
) = 'magenta';

-- Mencari tanaman berkhasiat anti-mual
SELECT
    nama_tanaman,
    kondisi
FROM tanaman
WHERE JSON_CONTAINS(
    JSON_EXTRACT(
        atribut,
        '$.khasiat'
    ),
    '"anti-mual"'
);

-- Gabungan dengan tabel kategori
-- Menampilkan nama kategori bersama atribut tanaman
SELECT
    k.nama_kategori,
    t.nama_tanaman,
    t.atribut
FROM tanaman t
JOIN kategori k
    ON t.id_kategori = k.id_kategori;

-- 11. Fungsi JSON lainnya
-- Membuat objek JSON
SELECT JSON_OBJECT(
    'nama', 'Trembesi',
    'tinggi_m', 12,
    'kondisi', 'Sehat'
) AS data_tanaman;

-- Membuat array JSON
SELECT JSON_ARRAY(
    'Pohon',
    'Tanaman Hias',
    'Tanaman Obat'
) AS daftar_kategori;

-- Memeriksa validitas JSON
SELECT
    JSON_VALID(
        '{"nama":"Trembesi","tinggi_m":12}'
    ) AS json_valid;

-- Menghitung jumlah elemen JSON
SELECT
    nama_tanaman,
    JSON_LENGTH(atribut) AS jumlah_atribut
FROM tanaman;

-- ===== A5. Pemodelan data berorientasi objek =====
USE praktikum_modul11;

-- 3. Memetakan objek ke struktur relasional
CREATE TABLE tanaman_objek (
    id_tanaman INT AUTO_INCREMENT PRIMARY KEY,
    nama_tanaman VARCHAR(150) NOT NULL,
    jenis_tanaman VARCHAR(50) NOT NULL,
    kondisi VARCHAR(50) NOT NULL,
    atribut_khusus JSON
) ENGINE=InnoDB;

-- Mengisi data
INSERT INTO tanaman_objek (
    nama_tanaman,
    jenis_tanaman,
    kondisi,
    atribut_khusus
)
VALUES
(
    'Trembesi',
    'Pohon',
    'Sehat',
    '{
        "tinggi_m": 12,
        "diameter_cm": 45
    }'
),
(
    'Bougainvillea',
    'Tanaman Hias',
    'Perlu perawatan',
    '{
        "warna_bunga": "magenta",
        "musim_berbunga": "kemarau"
    }'
),
(
    'Jahe',
    'Tanaman Obat',
    'Sehat',
    '{
        "bagian_dipakai": "rimpang",
        "khasiat": ["anti-mual", "hangat"]
    }'
);

-- Memeriksa data
SELECT * FROM tanaman_objek;

-- 4. Mengambil data berdasarkan jenis objek
-- Menampilkan seluruh pohon
SELECT
    id_tanaman,
    nama_tanaman,
    kondisi,
    atribut_khusus
FROM tanaman_objek
WHERE jenis_tanaman = 'Pohon';

-- Menampilkan seluruh tanaman hias
SELECT
    id_tanaman,
    nama_tanaman,
    kondisi,
    atribut_khusus
FROM tanaman_objek
WHERE jenis_tanaman = 'Tanaman Hias';

-- 5. Menggabungkan data objek dan relasional
SELECT
    t.id_tanaman,
    t.nama_tanaman,
    k.nama_kategori,
    t.kondisi,
    JSON_EXTRACT(
        t.atribut,
        '$.warna_bunga'
    ) AS warna_bunga
FROM tanaman t
JOIN kategori k
    ON t.id_kategori = k.id_kategori;

-- ------------------------------------------------------------
-- BAGIAN B - Lembar kerja post-test (database db_green_map_pnm)
-- Tabel dibuat bila belum ada. Jika tabel sudah berisi data dari praktikum
-- sebelumnya, kosongkan dahulu agar INSERT tidak menghasilkan data ganda.
-- ------------------------------------------------------------
USE db_green_map_pnm;

CREATE TABLE IF NOT EXISTS kategori_tanaman (
  id_kategori INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nama_kategori VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tanaman_objek (
  id_tanaman INT NOT NULL AUTO_INCREMENT,
  nama_tanaman VARCHAR(100) NOT NULL,
  jenis_tanaman VARCHAR(50) NOT NULL,
  id_kategori INT NOT NULL,
  kondisi VARCHAR(50) DEFAULT NULL,
  spesifikasi JSON DEFAULT NULL,
  PRIMARY KEY (id_tanaman),
  KEY fk_tanaman_kategori (id_kategori),
  CONSTRAINT fk_tanaman_kategori FOREIGN KEY (id_kategori)
    REFERENCES kategori_tanaman (id_kategori)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

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
