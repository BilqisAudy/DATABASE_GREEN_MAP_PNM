-- 02 Membuat tabel 
-- Proyek: Green Map PNM (Tahap 3: Implementasi Basis Data dengan Fitur JSON)

USE praktikum_modul11;

-- Tabel kategori
CREATE TABLE kategori (
    id_kategori INT AUTO_INCREMENT PRIMARY KEY,
    nama_kategori VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Tabel tanaman (atribut tambahan disimpan sebagai JSON)
CREATE TABLE tanaman (
    id_tanaman INT AUTO_INCREMENT PRIMARY KEY,
    id_kategori INT NOT NULL,
    nama_tanaman VARCHAR(150) NOT NULL,
    kondisi VARCHAR(50) NOT NULL,
    atribut JSON NOT NULL,

    CONSTRAINT fk_tanaman_kategori
        FOREIGN KEY (id_kategori)
        REFERENCES kategori(id_kategori)
) ENGINE=InnoDB;



