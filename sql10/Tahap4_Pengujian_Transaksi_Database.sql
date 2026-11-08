-- 1. Pemeriksaan kondisi awal
SELECT id_tanaman, nama_tanaman, total_laporan
FROM tanaman
WHERE id_tanaman IN (2, 4);

SELECT * FROM laporan_kondisi
WHERE id_laporan IN (201, 202);

-- 2. Pengujian COMMIT (laporan 201 untuk Mahoni)
START TRANSACTION;

INSERT INTO laporan_kondisi
  (id_laporan, id_tanaman, id_pengguna, tanggal_lapor, deskripsi, status)
VALUES
  (201, 2, 1, '2026-11-08', 'Daun mahoni berulat', 'diterima');

UPDATE tanaman
SET total_laporan = total_laporan + 1
WHERE id_tanaman = 2;

COMMIT;

-- 3. Pembuktian COMMIT
SELECT * FROM laporan_kondisi WHERE id_laporan = 201;

SELECT id_tanaman, nama_tanaman, total_laporan
FROM tanaman
WHERE id_tanaman = 2;

-- 4. Pengujian ROLLBACK (laporan 202 untuk Jahe)
START TRANSACTION;

INSERT INTO laporan_kondisi
  (id_laporan, id_tanaman, id_pengguna, tanggal_lapor, deskripsi, status)
VALUES
  (202, 4, 2, '2026-11-08', 'Daun jahe kering', 'diterima');

UPDATE tanaman
SET total_laporan = total_laporan + 1
WHERE id_tanaman = 4;

ROLLBACK;

-- 5. Pembuktian ROLLBACK
SELECT * FROM laporan_kondisi WHERE id_laporan = 202;

SELECT id_tanaman, nama_tanaman, total_laporan
FROM tanaman
WHERE id_tanaman = 4;
