-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jul 20, 2023 at 08:52 AM
-- Server version: 5.7.33
-- PHP Version: 7.4.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pabrik_semen_gilang_perkasa`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `pembelian_status_report` ()   BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE pembelian_id INT;
  DECLARE pembelian_uuid VARCHAR(5);
  DECLARE pembelian_status VARCHAR(255);
  
  DECLARE pembelian_cursor CURSOR FOR SELECT id, uuid, status FROM pembelian;
  
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  CREATE TEMPORARY TABLE IF NOT EXISTS pembelian_report (
    pembelian_id INT,
    pembelian_uuid VARCHAR(5),
    pembelian_status VARCHAR(255)
  );
  
  OPEN pembelian_cursor;
  
  read_loop: LOOP
    IF done THEN
      LEAVE read_loop;
    END IF;
    
    IF pembelian_status = 'ready' THEN
      INSERT INTO pembelian_report (pembelian_id, pembelian_uuid, pembelian_status)
      VALUES (pembelian_id, pembelian_uuid, pembelian_status);
    ELSEIF pembelian_status = 'sold' THEN
      UPDATE pembelian SET status = 'completed' WHERE id = pembelian_id;
INSERT INTO pembelian_report (pembelian_id, pembelian_uuid, pembelian_status)
      VALUES (pembelian_id, pembelian_uuid, 'completed');
    ELSE
      INSERT INTO pembelian_report (pembelian_id, pembelian_uuid, pembelian_status)
      VALUES (pembelian_id, pembelian_uuid, pembelian_status);
    END IF;
  END LOOP;
  
  CLOSE pembelian_cursor;
  
  SELECT * FROM pembelian_report;
  DROP TABLE IF EXISTS pembelian_report;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `hitung_total_harga` (`jumlah` INT, `harga` DECIMAL(10,2)) RETURNS DECIMAL(10,2)  BEGIN
  DECLARE total DECIMAL(10, 2);
  SET total = jumlah * harga;
  RETURN total;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `karyawan`
--

CREATE TABLE `karyawan` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) DEFAULT NULL,
  `posisi` varchar(255) DEFAULT NULL,
  `pabrik_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `karyawan`
--

INSERT INTO `karyawan` (`id`, `nama`, `posisi`, `pabrik_id`) VALUES
(1, 'John Doe', 'Manager', 1),
(2, 'Jane Smith', 'Supervisor', 1),
(3, 'Michael Johnson', 'Operator', 2),
(4, 'Emily Davis', 'Technician', 3),
(5, 'David Wilson', 'Engineer', 4);

-- --------------------------------------------------------

--
-- Table structure for table `pabrik`
--

CREATE TABLE `pabrik` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) DEFAULT NULL,
  `alamat` varchar(255) DEFAULT NULL,
  `tahun_berdiri` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pabrik`
--

INSERT INTO `pabrik` (`id`, `nama`, `alamat`, `tahun_berdiri`) VALUES
(1, 'Pabrik Semen A', 'Jl. Pabrik No. 1', 2000),
(2, 'Pabrik Semen B', 'Jl. Pabrik No. 2', 1995),
(3, 'Pabrik Semen C', 'Jl. Pabrik No. 3', 2010),
(4, 'Pabrik Semen D', 'Jl. Pabrik No. 4', 2005),
(5, 'Pabrik Semen E', 'Jl. Pabrik No. 5', 1990);

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) DEFAULT NULL,
  `alamat` varchar(255) DEFAULT NULL,
  `telepon` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`id`, `nama`, `alamat`, `telepon`) VALUES
(1, 'Adam Smith', 'Jl. Pelanggan No. 1', '081234567890'),
(2, 'Lisa Johnson', 'Jl. Pelanggan No. 2', '082345678901'),
(3, 'Robert Brown', 'Jl. Pelanggan No. 3', '083456789012'),
(4, 'Olivia Davis', 'Jl. Pelanggan No. 4', '084567890123'),
(5, 'Sophia Wilson', 'Jl. Pelanggan No. 5', '085678901234');

-- --------------------------------------------------------

--
-- Table structure for table `pembelian`
--

CREATE TABLE `pembelian` (
  `id` int(11) NOT NULL,
  `tanggal_pembelian` date DEFAULT NULL,
  `jumlah_produk` int(11) DEFAULT NULL,
  `produk_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pembelian`
--

INSERT INTO `pembelian` (`id`, `tanggal_pembelian`, `jumlah_produk`, `produk_id`) VALUES
(1, '2023-01-01', 10, 1),
(2, '2023-02-05', 5, 2),
(3, '2023-03-10', 8, 3),
(4, '2023-04-15', 12, 4),
(5, '2023-05-20', 7, 5);

-- --------------------------------------------------------

--
-- Table structure for table `produk`
--

CREATE TABLE `produk` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) DEFAULT NULL,
  `harga` decimal(10,2) DEFAULT NULL,
  `pabrik_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `produk`
--

INSERT INTO `produk` (`id`, `nama`, `harga`, `pabrik_id`) VALUES
(1, 'Semen Putih', '50000.00', 1),
(2, 'Semen Merah', '45000.00', 2),
(3, 'Semen Hijau', '48000.00', 2),
(4, 'Semen Biru', '52000.00', 3),
(5, 'Semen Kuning', '49000.00', 4);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `karyawan`
--
ALTER TABLE `karyawan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pabrik_id` (`pabrik_id`);

--
-- Indexes for table `pabrik`
--
ALTER TABLE `pabrik`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pembelian`
--
ALTER TABLE `pembelian`
  ADD PRIMARY KEY (`id`),
  ADD KEY `produk_id` (`produk_id`);

--
-- Indexes for table `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pabrik_id` (`pabrik_id`),
  ADD KEY `idx_harga_produk` (`harga`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `karyawan`
--
ALTER TABLE `karyawan`
  ADD CONSTRAINT `karyawan_ibfk_1` FOREIGN KEY (`pabrik_id`) REFERENCES `pabrik` (`id`);

--
-- Constraints for table `pembelian`
--
ALTER TABLE `pembelian`
  ADD CONSTRAINT `pembelian_ibfk_1` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`id`);

--
-- Constraints for table `produk`
--
ALTER TABLE `produk`
  ADD CONSTRAINT `produk_ibfk_1` FOREIGN KEY (`pabrik_id`) REFERENCES `pabrik` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
