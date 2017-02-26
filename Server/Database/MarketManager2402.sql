-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Feb 24, 2017 at 03:35 AM
-- Server version: 10.1.21-MariaDB
-- PHP Version: 7.1.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `MarketManager`
--
CREATE DATABASE IF NOT EXISTS `MarketManager` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `MarketManager`;

-- --------------------------------------------------------

--
-- Table structure for table `crateManager`
--

DROP TABLE IF EXISTS `crateManager`;
CREATE TABLE IF NOT EXISTS `crateManager` (
  `crate_deli_ID` int(10) NOT NULL,
  `date` date NOT NULL,
  `quantity_left_yesterday` int(11) NOT NULL,
  `in` int(11) NOT NULL,
  `out` int(11) NOT NULL,
  `balance` int(11) NOT NULL,
  `description` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `crate_sellers`
--

DROP TABLE IF EXISTS `crate_sellers`;
CREATE TABLE IF NOT EXISTS `crate_sellers` (
  `crate_deli_ID` int(10) NOT NULL AUTO_INCREMENT,
  `companyName` varchar(200) NOT NULL,
  `description` varchar(200) NOT NULL,
  PRIMARY KEY (`crate_deli_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
CREATE TABLE IF NOT EXISTS `order` (
  `order_ID` int(10) NOT NULL AUTO_INCREMENT,
  `shop_ID` int(10) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`order_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
CREATE TABLE IF NOT EXISTS `product` (
  `productID` int(11) NOT NULL AUTO_INCREMENT,
  `productName` varchar(200) NOT NULL,
  `price` float NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`productID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`productID`, `productName`, `price`, `description`) VALUES
(2, 'kakak', 134004, 'test description');

-- --------------------------------------------------------

--
-- Table structure for table `shop`
--

DROP TABLE IF EXISTS `shop`;
CREATE TABLE IF NOT EXISTS `shop` (
  `shopID` int(10) NOT NULL AUTO_INCREMENT,
  `shopName` varchar(100) NOT NULL,
  `productID` int(10) NOT NULL,
  `description` varchar(200) NOT NULL,
  PRIMARY KEY (`shopID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Bảng shop';

-- --------------------------------------------------------

--
-- Table structure for table `warehouse`
--

DROP TABLE IF EXISTS `warehouse`;
CREATE TABLE IF NOT EXISTS `warehouse` (
  `whID` int(11) NOT NULL AUTO_INCREMENT,
  `whName` varchar(100) NOT NULL,
  `productID` int(10) NOT NULL,
  `inputDate` date NOT NULL,
  `description` varchar(200) NOT NULL,
  PRIMARY KEY (`whID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Table kho hàng';

DROP TABLE IF EXISTS `user`;
CREATE TABLE  IF NOT EXISTS `user` (
  `userID` int(10) NOT NULL AUTO_INCREMENT,
  `userName` varchar(100) NOT NULL,
  `password` varchar(20) NOT NULL,
  PRIMARY KEY (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
