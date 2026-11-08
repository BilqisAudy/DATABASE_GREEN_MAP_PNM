--1.	Pengujian Query Sebelum Index
   EXPLAIN
   SELECT
       id_perawatan,
       id_pengguna,
       tanggal,
       tindakan
   FROM perawatan
   WHERE tanggal >= '2026-01-01'
     AND tanggal < '2026-12-01';

--2.	Membuat Index
USE db_green_map_pnm;

CREATE INDEX idx_perawatan_tanggal
ON perawatan(tanggal);

SHOW INDEX FROM perawatan;

--3.	Pengujian Query Setelah Index
EXPLAIN
SELECT
    id_perawatan,
    id_pengguna,
    tanggal,
    tindakan
FROM perawatan
WHERE tanggal >= '2026-01-01'
  AND tanggal < '2026-12-01';



