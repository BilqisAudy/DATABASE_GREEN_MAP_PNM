-- 04 Pengujian fitur JSON
-- Proyek: Green Map PNM (Tahap 3: Implementasi Basis Data dengan Fitur JSON)

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


