-- 1. Identifikasi versi DBMS
SELECT VERSION();
SELECT @@version_comment;
SHOW ENGINES;
SHOW DATABASES;

-- 2. Identifikasi storage engine pada tabel proyek
SHOW TABLE STATUS FROM db_green_map_pnm;
