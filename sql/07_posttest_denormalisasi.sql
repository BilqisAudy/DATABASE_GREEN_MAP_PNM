-- Post-test no. 1 (2): DDL atribut turunan + query panggilan
-- (kolom total_perawatan sudah dibuat pada Tahap 2)

-- DDL: tambah dua atribut turunan
ALTER TABLE tanaman
  ADD COLUMN total_laporan INT DEFAULT 0,
  ADD COLUMN perawatan_terakhir DATE;

-- Isi dari tabel asal
UPDATE tanaman t
SET t.total_laporan = (
      SELECT COUNT(*) FROM laporan_kondisi lk WHERE lk.id_tanaman = t.id_tanaman),
    t.perawatan_terakhir = (
      SELECT MAX(p.tanggal) FROM perawatan p WHERE p.id_tanaman = t.id_tanaman);

-- Query panggilan (tanpa JOIN dan tanpa agregasi)
SELECT nama_tanaman, total_perawatan, total_laporan, perawatan_terakhir
FROM tanaman
WHERE total_laporan > 0
ORDER BY total_laporan DESC;
