-- Praktikum Modul 11 - 05 Pemodelan data berorientasi objek
-- Proyek: Green Map PNM (Tahap 4: Pemodelan Data Berorientasi Objek)
-- Prasyarat: 01 sampai 04 sudah dijalankan (tabel kategori dan tanaman dari Tahap 3)

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
