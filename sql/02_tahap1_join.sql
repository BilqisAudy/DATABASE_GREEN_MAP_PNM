-- Tahap 1: Eksplorasi JOIN + agregasi
-- Database: db_green_map_pnm
SELECT t.id_tanaman, t.nama_tanaman, COUNT(p.id_perawatan) AS total_perawatan
FROM tanaman t
JOIN perawatan p ON t.id_tanaman = p.id_tanaman
GROUP BY t.id_tanaman, t.nama_tanaman;
