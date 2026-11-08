SELECT
  t.id_tanaman,
  t.nama_tanaman,
  COUNT(l.id_laporan) AS total_laporan
FROM tanaman t
LEFT JOIN laporan_kondisi l
  ON t.id_tanaman = l.id_tanaman
GROUP BY t.id_tanaman, t.nama_tanaman
ORDER BY total_laporan DESC;
