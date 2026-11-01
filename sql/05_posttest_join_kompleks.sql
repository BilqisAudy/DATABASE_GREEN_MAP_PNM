-- Post-test no. 1 (1): Query JOIN kompleks
-- 4 JOIN + COUNT(DISTINCT) + MAX + GROUP_CONCAT + GROUP BY
SELECT
  t.id_tanaman,
  t.nama_tanaman,
  jt.nama_jenis,
  t.kondisi,
  COUNT(DISTINCT p.id_perawatan)  AS jumlah_perawatan,
  COUNT(DISTINCT lk.id_laporan)   AS jumlah_laporan,
  MAX(p.tanggal)                  AS perawatan_terakhir,
  GROUP_CONCAT(DISTINCT pg.nama ORDER BY pg.nama SEPARATOR ', ') AS perawat_terlibat
FROM tanaman t
JOIN jenis_tanaman jt        ON t.id_jenis = jt.id_jenis
LEFT JOIN perawatan p        ON t.id_tanaman = p.id_tanaman
LEFT JOIN pengguna pg        ON p.id_pengguna = pg.id_pengguna
LEFT JOIN laporan_kondisi lk ON t.id_tanaman = lk.id_tanaman
GROUP BY t.id_tanaman, t.nama_tanaman, jt.nama_jenis, t.kondisi
ORDER BY jumlah_laporan DESC;
