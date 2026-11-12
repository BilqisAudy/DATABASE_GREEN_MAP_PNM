-- Modul 11 - Tahap 2: Implementasi Fitur DBMS (Tipe Data JSON)

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

-- 2. Penyimpanan data JSON
INSERT INTO katalog_tanaman (id_tanaman, nama_tanaman, jenis_tanaman, detail) VALUES
(1, 'Trembesi', 'Pohon',
 '{"kondisi": "Terawat", "manfaat": ["Memberi keteduhan", "Menyerap CO2"], "cara_perawatan": "Siram 2x seminggu, pangkas cabang kering", "lokasi": {"lat": -7.6298, "lng": 111.5239}, "tinggi_m": 15}'),
(2, 'Mahoni', 'Pohon',
 '{"kondisi": "Terawat", "manfaat": ["Memberi keteduhan", "Menyerap CO2"], "cara_perawatan": "Siram 2x seminggu, pangkas cabang kering", "lokasi": {"lat": -7.6299, "lng": 111.5240}, "tinggi_m": 20}'),
(3, 'Bougainvillea', 'Tanaman Hias',
 '{"kondisi": "Perlu perawatan", "manfaat": ["Estetika taman"], "cara_perawatan": "Siram tiap hari, beri pupuk sebulan sekali", "lokasi": {"lat": -7.6300, "lng": 111.5241}, "warna_bunga": ["Ungu", "Merah muda"]}'),
(4, 'Jahe', 'Tanaman Obat',
 '{"kondisi": "Terawat", "manfaat": ["Bahan obat tradisional"], "cara_perawatan": "Siram 1x sehari, tanah gembur", "lokasi": {"lat": -7.6301, "lng": 111.5242}, "bagian_dipakai": "Rimpang"}');

SELECT * FROM db_katalog_tanaman.katalog_tanaman;

-- 3. Pembacaan data JSON
SELECT
  nama_tanaman,
  JSON_EXTRACT(detail, '$.kondisi') AS kondisi_extract,
  detail->>'$.kondisi'              AS kondisi_teks,
  detail->>'$.lokasi.lat'           AS latitude,
  detail->>'$.manfaat[0]'           AS manfaat_pertama
FROM db_katalog_tanaman.katalog_tanaman;

-- 4. Pencarian data JSON
-- 4a. Berdasarkan nilai atribut
SELECT id_tanaman, nama_tanaman, detail->>'$.kondisi' AS kondisi
FROM db_katalog_tanaman.katalog_tanaman
WHERE detail->>'$.kondisi' = 'Perlu perawatan';

-- 4b. Berdasarkan isi array
SELECT id_tanaman, nama_tanaman
FROM db_katalog_tanaman.katalog_tanaman
WHERE JSON_CONTAINS(detail->'$.manfaat', '"Menyerap CO2"');

-- 4c. Berdasarkan keberadaan atribut
SELECT id_tanaman, nama_tanaman, detail->>'$.tinggi_m' AS tinggi_m
FROM db_katalog_tanaman.katalog_tanaman
WHERE JSON_CONTAINS_PATH(detail, 'one', '$.tinggi_m');

-- 5. Perubahan atribut JSON: mengubah dan menambah atribut (JSON_SET)
UPDATE db_katalog_tanaman.katalog_tanaman
SET detail = JSON_SET(detail,
      '$.kondisi', 'Terawat',
      '$.terakhir_disiram', '2026-11-11')
WHERE id_tanaman = 3;

SELECT id_tanaman, nama_tanaman,
       detail->>'$.kondisi'          AS kondisi,
       detail->>'$.terakhir_disiram' AS terakhir_disiram
FROM db_katalog_tanaman.katalog_tanaman
WHERE id_tanaman = 3;

-- 6. Perubahan atribut JSON: menghapus atribut (JSON_REMOVE)
UPDATE db_katalog_tanaman.katalog_tanaman
SET detail = JSON_REMOVE(detail, '$.terakhir_disiram')
WHERE id_tanaman = 3;

SELECT id_tanaman, nama_tanaman,
       detail->>'$.kondisi'          AS kondisi,
       detail->>'$.terakhir_disiram' AS terakhir_disiram,
       JSON_CONTAINS_PATH(detail, 'one', '$.terakhir_disiram') AS ada_atribut
FROM db_katalog_tanaman.katalog_tanaman
WHERE id_tanaman = 3;
