-- Tahap 2: Denormalisasi (atribut turunan jumlah_laporan)
USE db_green_map_pnm;

ALTER TABLE tanaman ADD COLUMN jumlah_laporan INT DEFAULT 0;

UPDATE tanaman t
SET jumlah_laporan = (
  SELECT COUNT(*) FROM laporan_kondisi l WHERE l.id_tanaman = t.id_tanaman
);

SELECT * FROM tanaman;
