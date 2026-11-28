-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 27, 2026 at 05:09 AM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_green_map_pnm`
--

-- --------------------------------------------------------

--
-- Table structure for table `laporan_kondisi`
--

CREATE TABLE `laporan_kondisi` (
  `id_laporan` int NOT NULL,
  `id_tanaman` int NOT NULL,
  `id_pengguna` int NOT NULL,
  `tanggal_lapor` date DEFAULT NULL,
  `deskripsi` text,
  `foto_laporan` varchar(255) DEFAULT NULL,
  `status` enum('diterima','diproses','selesai') DEFAULT 'diterima'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `laporan_kondisi`
--

INSERT INTO `laporan_kondisi` (`id_laporan`, `id_tanaman`, `id_pengguna`, `tanggal_lapor`, `deskripsi`, `foto_laporan`, `status`) VALUES
(1, 3, 1, '2026-10-18', 'Daun layu', NULL, 'diproses'),
(2, 3, 2, '2026-10-19', 'Daun menguning', NULL, 'diterima'),
(3, 1, 3, '2026-10-25', 'Cabang patah', NULL, 'selesai');

-- --------------------------------------------------------

--
-- Table structure for table `pengguna`
--

CREATE TABLE `pengguna` (
  `id_pengguna` int NOT NULL,
  `nama` varchar(100) NOT NULL,
  `peran` enum('Mahasiswa','Dosen','Staf','Pengelola') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `pengguna`
--

INSERT INTO `pengguna` (`id_pengguna`, `nama`, `peran`) VALUES
(1, 'Bilqis', 'Mahasiswa'),
(2, 'Cindika', 'Mahasiswa'),
(3, 'Yaya', 'Mahasiswa'),
(4, 'Pak Very', 'Pengelola');

-- --------------------------------------------------------

--
-- Table structure for table `perawatan`
--

CREATE TABLE `perawatan` (
  `id_perawatan` int NOT NULL,
  `id_tanaman` int NOT NULL,
  `id_pengguna` int NOT NULL,
  `tanggal` date DEFAULT NULL,
  `tindakan` varchar(100) DEFAULT NULL,
  `catatan` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `perawatan`
--

INSERT INTO `perawatan` (`id_perawatan`, `id_tanaman`, `id_pengguna`, `tanggal`, `tindakan`, `catatan`) VALUES
(1, 1, 4, '2026-10-01', 'Penyiraman', 'Rutin'),
(2, 1, 4, '2026-10-15', 'Pemangkasan', 'Cabang kering'),
(3, 3, 4, '2026-10-20', 'Pemupukan', 'Pupuk NPK'),
(4, 2, 4, '2026-10-22', 'Penyiraman', 'Rutin');

-- --------------------------------------------------------

--
-- Table structure for table `tanaman`
--

CREATE TABLE `tanaman` (
  `id_tanaman` int NOT NULL,
  `nama_tanaman` varchar(100) NOT NULL,
  `jenis_tanaman` varchar(50) NOT NULL,
  `manfaat` text,
  `cara_perawatan` text,
  `kondisi` varchar(50) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `total_laporan` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `tanaman`
--

INSERT INTO `tanaman` (`id_tanaman`, `nama_tanaman`, `jenis_tanaman`, `manfaat`, `cara_perawatan`, `kondisi`, `foto`, `latitude`, `longitude`, `total_laporan`) VALUES
(1, 'Trembesi', 'Pohon', 'Memberi keteduhan dan menyerap CO2', 'Siram 2x seminggu, pangkas cabang kering', 'Terawat', NULL, '-7.6298000', '111.5239000', 1),
(2, 'Mahoni', 'Pohon', 'Memberi keteduhan dan menyerap CO2', 'Siram 2x seminggu, pangkas cabang kering', 'Terawat', NULL, '-7.6299000', '111.5240000', 0),
(3, 'Bougainvillea', 'Tanaman Hias', 'Estetika taman', 'Siram tiap hari, beri pupuk sebulan sekali', 'Perlu perawatan', NULL, '-7.6300000', '111.5241000', 2),
(4, 'Jahe', 'Tanaman Obat', 'Bahan obat tradisional', 'Siram 1x sehari, tanah gembur', 'Terawat', NULL, '-7.6301000', '111.5242000', 0);

-- --------------------------------------------------------

--
-- Table structure for table `tanaman_objek`
--

CREATE TABLE `tanaman_objek` (
  `id_tanaman` int NOT NULL,
  `nama_tanaman` varchar(100) DEFAULT NULL,
  `jenis_tanaman` varchar(50) DEFAULT NULL,
  `atribut` json DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `tanaman_objek`
--

INSERT INTO `tanaman_objek` (`id_tanaman`, `nama_tanaman`, `jenis_tanaman`, `atribut`) VALUES
(1, 'Trembesi', 'Pohon', '{\"tinggi_m\": 13}'),
(3, 'Bougainvillea', 'Tanaman Hias', '{\"warna_bunga\": \"magenta\"}'),
(4, 'Jahe', 'Tanaman Obat', '{\"khasiat\": [\"anti-mual\", \"hangat\"], \"bagian_dipakai\": \"rimpang\"}');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `laporan_kondisi`
--
ALTER TABLE `laporan_kondisi`
  ADD PRIMARY KEY (`id_laporan`),
  ADD KEY `id_tanaman` (`id_tanaman`),
  ADD KEY `id_pengguna` (`id_pengguna`);

--
-- Indexes for table `pengguna`
--
ALTER TABLE `pengguna`
  ADD PRIMARY KEY (`id_pengguna`);

--
-- Indexes for table `perawatan`
--
ALTER TABLE `perawatan`
  ADD PRIMARY KEY (`id_perawatan`),
  ADD KEY `id_tanaman` (`id_tanaman`),
  ADD KEY `id_pengguna` (`id_pengguna`);

--
-- Indexes for table `tanaman`
--
ALTER TABLE `tanaman`
  ADD PRIMARY KEY (`id_tanaman`);

--
-- Indexes for table `tanaman_objek`
--
ALTER TABLE `tanaman_objek`
  ADD PRIMARY KEY (`id_tanaman`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `laporan_kondisi`
--
ALTER TABLE `laporan_kondisi`
  MODIFY `id_laporan` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `id_pengguna` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `perawatan`
--
ALTER TABLE `perawatan`
  MODIFY `id_perawatan` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tanaman`
--
ALTER TABLE `tanaman`
  MODIFY `id_tanaman` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `laporan_kondisi`
--
ALTER TABLE `laporan_kondisi`
  ADD CONSTRAINT `laporan_kondisi_ibfk_1` FOREIGN KEY (`id_tanaman`) REFERENCES `tanaman` (`id_tanaman`),
  ADD CONSTRAINT `laporan_kondisi_ibfk_2` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`);

--
-- Constraints for table `perawatan`
--
ALTER TABLE `perawatan`
  ADD CONSTRAINT `perawatan_ibfk_1` FOREIGN KEY (`id_tanaman`) REFERENCES `tanaman` (`id_tanaman`),
  ADD CONSTRAINT `perawatan_ibfk_2` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
