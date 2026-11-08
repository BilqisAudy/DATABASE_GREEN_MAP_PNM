-- 1. Pemeriksaan kondisi awal (sebelum backup)

USE db_green_map_pnm;
SHOW TABLES;
SELECT COUNT(*) AS jml_laporan_kondisi FROM laporan_kondisi;
SELECT COUNT(*) AS jml_pengguna FROM pengguna;
SELECT COUNT(*) AS jml_perawatan FROM perawatan;
SELECT COUNT(*) AS jml_tanaman FROM tanaman;

-- 2. Backup dan restore lewat phpMyAdmin
-- Backup : Export > format SQL > metode Quick > simpan backup_modul10.sql
-- Restore: buat database db_green_map_restore > menu Import > pilih backup_modul10.sql

-- 3. Backup dan restore lewat command line (dijalankan di Command Prompt, bukan di SQL)
-- Backup : mysqldump -u <user> -p --no-tablespaces --databases db_green_map_pnm > backup_modul10_cli.sql
-- Restore: mysql -u <user> -p < backup_modul10_cli.sql

-- 4. Validasi hasil restore (database hasil restore phpMyAdmin)
USE db_green_map_restore;
SHOW TABLES;
SELECT COUNT(*) AS jml_laporan_kondisi FROM laporan_kondisi;
SELECT COUNT(*) AS jml_pengguna FROM pengguna;
SELECT COUNT(*) AS jml_perawatan FROM perawatan;
SELECT COUNT(*) AS jml_tanaman FROM tanaman;

-- 5. Pembuktian jumlah data sama (asal vs hasil restore)
SELECT 'laporan_kondisi' AS tabel,
       (SELECT COUNT(*) FROM db_green_map_pnm.laporan_kondisi) AS asal,
       (SELECT COUNT(*) FROM db_green_map_restore.laporan_kondisi) AS restore_
UNION ALL
SELECT 'pengguna',
       (SELECT COUNT(*) FROM db_green_map_pnm.pengguna),
       (SELECT COUNT(*) FROM db_green_map_restore.pengguna)
UNION ALL
SELECT 'perawatan',
       (SELECT COUNT(*) FROM db_green_map_pnm.perawatan),
       (SELECT COUNT(*) FROM db_green_map_restore.perawatan)
UNION ALL
SELECT 'tanaman',
       (SELECT COUNT(*) FROM db_green_map_pnm.tanaman),
       (SELECT COUNT(*) FROM db_green_map_restore.tanaman);
