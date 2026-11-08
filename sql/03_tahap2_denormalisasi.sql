-- 1. Tambah kolom turunan
ALTER TABLE tanaman
ADD COLUMN total_laporan INT DEFAULT 0;

-- 2. Isi kolom dari hasil perhitungan Tahap 1
UPDATE tanaman t
SET t.total_laporan = (
  SELECT COUNT(*)
  FROM laporan_kondisi l
  WHERE l.id_tanaman = t.id_tanaman
);

-- 3. Verifikasi
SELECT id_tanaman, nama_tanaman, total_laporan FROM tanaman;
