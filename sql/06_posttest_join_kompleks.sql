-- Script 1: JOIN 4 tabel + agregasi (jumlah laporan, jumlah perawatan, laporan belum selesai)
SELECT
  t.id_tanaman,
  t.nama_tanaman,
  t.jenis_tanaman,
  COUNT(DISTINCT l.id_laporan)  AS jumlah_laporan,
  COUNT(DISTINCT p.id_perawatan) AS jumlah_perawatan,
  COUNT(DISTINCT CASE WHEN l.status <> 'selesai' THEN l.id_laporan END) AS laporan_belum_selesai,
  MAX(p.tanggal) AS perawatan_terakhir
FROM tanaman t
LEFT JOIN laporan_kondisi l ON t.id_tanaman = l.id_tanaman
LEFT JOIN perawatan p       ON t.id_tanaman = p.id_tanaman
GROUP BY t.id_tanaman, t.nama_tanaman, t.jenis_tanaman
ORDER BY jumlah_laporan DESC;
