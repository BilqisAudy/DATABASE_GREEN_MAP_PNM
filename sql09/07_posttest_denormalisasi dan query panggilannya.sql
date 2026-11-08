-- Script 2: DDL denormalisasi
ALTER TABLE tanaman
ADD COLUMN total_laporan INT DEFAULT 0;

-- Mengisi atribut turunan dari hasil perhitungan Tahap 1
UPDATE tanaman t
SET t.total_laporan = (
  SELECT COUNT(*)
  FROM laporan_kondisi l
  WHERE l.id_tanaman = t.id_tanaman
);

-- Query pemanggil (tanpa JOIN dan agregasi)
SELECT id_tanaman, nama_tanaman, total_laporan
FROM tanaman
ORDER BY total_laporan DESC;
