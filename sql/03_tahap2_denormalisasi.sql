-- Tahap 2: Denormalisasi (atribut turunan total_perawatan)
-- Database: db_green_map_pnm
ALTER TABLE tanaman ADD COLUMN total_perawatan INT DEFAULT 0;

UPDATE tanaman t
SET total_perawatan = (
  SELECT COUNT(*) FROM perawatan p WHERE p.id_tanaman = t.id_tanaman
);

SELECT * FROM tanaman;
