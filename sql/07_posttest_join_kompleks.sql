-- Post-test no. 1 (1): Query JOIN kompleks
-- 3 JOIN + COUNT(DISTINCT) + MAX + GROUP BY
SELECT
  t.id_tanaman,
  t.nama_tanaman,
  jt.nama_jenis,
  COUNT(DISTINCT p.id_perawatan) AS jumlah_perawatan,
  COUNT(DISTINCT lk.id_laporan)  AS jumlah_laporan,
  MAX(p.tanggal)                 AS perawatan_terakhir
FROM tanaman t
JOIN jenis_tanaman jt        ON t.id_jenis = jt.id_jenis
LEFT JOIN perawatan p        ON t.id_tanaman = p.id_tanaman
LEFT JOIN laporan_kondisi lk ON t.id_tanaman = lk.id_tanaman
GROUP BY t.id_tanaman, t.nama_tanaman, jt.nama_jenis
ORDER BY jumlah_laporan DESC;
