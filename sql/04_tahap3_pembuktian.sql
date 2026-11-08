-- Tahap 3: Pembuktian (tanpa JOIN dan tanpa agregasi)
USE db_green_map_pnm;

SELECT id_tanaman, nama_tanaman, jumlah_laporan
FROM tanaman
ORDER BY jumlah_laporan DESC;
