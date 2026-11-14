-- 03 Mengisi data awal
-- Proyek: Green Map PNM (Tahap 3: Implementasi Basis Data dengan Fitur JSON)

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


