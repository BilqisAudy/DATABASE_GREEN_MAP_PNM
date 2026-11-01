-- Post-test no. 1 (2): DDL tabel denormalisasi + query panggilan

-- DDL: tabel denormalisasi
CREATE TABLE tanaman_denorm (
  id_tanaman         INT PRIMARY KEY,
  nama_tanaman       VARCHAR(100),
  nama_jenis         VARCHAR(100),
  manfaat            TEXT,
  kondisi            VARCHAR(50),
  latitude           DECIMAL(10,7),
  longitude          DECIMAL(10,7),
  jumlah_perawatan   INT DEFAULT 0,
  jumlah_laporan     INT DEFAULT 0,
  perawatan_terakhir DATE
);

-- Isi dari tabel normal
INSERT INTO tanaman_denorm
SELECT
  t.id_tanaman, t.nama_tanaman, jt.nama_jenis, jt.manfaat,
  t.kondisi, t.latitude, t.longitude,
  COUNT(DISTINCT p.id_perawatan),
  COUNT(DISTINCT lk.id_laporan),
  MAX(p.tanggal)
FROM tanaman t
JOIN jenis_tanaman jt        ON t.id_jenis = jt.id_jenis
LEFT JOIN perawatan p        ON t.id_tanaman = p.id_tanaman
LEFT JOIN laporan_kondisi lk ON t.id_tanaman = lk.id_tanaman
GROUP BY t.id_tanaman, t.nama_tanaman, jt.nama_jenis, jt.manfaat,
         t.kondisi, t.latitude, t.longitude;

-- Query panggilan (tanpa JOIN)
SELECT nama_tanaman, nama_jenis, jumlah_perawatan, jumlah_laporan, perawatan_terakhir
FROM tanaman_denorm
WHERE jumlah_laporan > 0
ORDER BY jumlah_laporan DESC;
