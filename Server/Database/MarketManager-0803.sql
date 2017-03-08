-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Mar 08, 2017 at 11:14 AM
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

-- --------------------------------------------------------

--
-- Table structure for table `crateManager`
--

CREATE TABLE `crateManager` (
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

CREATE TABLE `crate_sellers` (
  `crate_deli_ID` int(10) NOT NULL,
  `companyName` varchar(200) NOT NULL,
  `description` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `order`
--

CREATE TABLE `order` (
  `order_ID` int(10) NOT NULL,
  `shop_ID` int(10) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `order`
--

INSERT INTO `order` (`order_ID`, `shop_ID`, `date`) VALUES
(1, 1, '2017-03-01'),
(2, 1, '2017-03-01');

-- --------------------------------------------------------

--
-- Table structure for table `order_each_day`
--

CREATE TABLE `order_each_day` (
  `oderID` int(10) NOT NULL,
  `productID` int(10) NOT NULL,
  `stockTake` int(10) NOT NULL COMMENT 'So du tu hom truoc',
  `deliverFrom` int(10) NOT NULL COMMENT 'Nhập từ wh1, wh2,...',
  `order_quantity` int(10) NOT NULL COMMENT 'So luong',
  `quantity_needed` int(10) NOT NULL,
  `crate_deli_ID` int(10) NOT NULL COMMENT 'Mã thùng',
  `crates_received` int(10) NOT NULL COMMENT 'Số lượng thùng'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `order_each_day`
--

INSERT INTO `order_each_day` (`oderID`, `productID`, `stockTake`, `deliverFrom`, `order_quantity`, `quantity_needed`, `crate_deli_ID`, `crates_received`) VALUES
(1, 1, 5, 1, 10, 0, 1, 3);

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `productID` int(11) NOT NULL,
  `productName` varchar(200) NOT NULL,
  `price` float NOT NULL,
  `description` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`productID`, `productName`, `price`, `description`) VALUES
(3, 'Asparagus', 4, 'Available'),
(4, 'butler melon', 2, 'Sold'),
(5, 'broccoli', 2.8, 'Available'),
(6, 'bean', 4, 'Bean'),
(7, 'silver beer', 15, ''),
(8, 'spring onion', 1, ''),
(10, 'celery', 4, ''),
(11, 'carrot baby', 54, ''),
(12, 'chili red', 21, 'Heh'),
(14, 'yellow chili', 1, ''),
(15, 'green chili', 42, ''),
(16, 'Choko', 2, ''),
(17, 'corn sweet', 0.546, ''),
(18, 'dill', 54, ''),
(19, 'egg fruit', 5, ''),
(20, 'Thai eggplant', 5, ''),
(21, 'luffa', 5, ''),
(22, 'lime', 54, ''),
(23, 'milk', 2, 'Available');

-- --------------------------------------------------------

--
-- Table structure for table `shop`
--

CREATE TABLE `shop` (
  `shopID` int(10) NOT NULL,
  `shopName` varchar(100) NOT NULL,
  `productID` int(10) NOT NULL,
  `description` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Bảng shop';

--
-- Dumping data for table `shop`
--

INSERT INTO `shop` (`shopID`, `shopName`, `productID`, `description`) VALUES
(1, 'Giraween', 4, ''),
(2, 'Altone', 4, ''),
(3, 'Carousel', 5, ''),
(4, 'Cash & carry', 7, ''),
(5, 'MCQ', 5, ''),
(6, 'Daily Fresh', 8, '');

-- --------------------------------------------------------

--
-- Table structure for table `shop_product`
--

CREATE TABLE `shop_product` (
  `shopID` int(10) NOT NULL,
  `productID` int(10) NOT NULL,
  `stockTake` int(10) NOT NULL COMMENT 'Hàng tồn từ hôm qua',
  `date` date NOT NULL,
  `description` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shop_product`
--

INSERT INTO `shop_product` (`shopID`, `productID`, `stockTake`, `date`, `description`) VALUES
(1, 4, 4, '2017-03-01', ''),
(1, 5, 5, '2017-03-03', 'ok');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `userID` int(10) NOT NULL,
  `userName` varchar(100) NOT NULL,
  `password` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`userID`, `userName`, `password`) VALUES
(1, 'admin', 'admin'),
(2, 'hanhnn', '11111'),
(3, 'peter', '11111');

-- --------------------------------------------------------

--
-- Table structure for table `warehouse`
--

CREATE TABLE `warehouse` (
  `whID` int(11) NOT NULL,
  `whName` varchar(100) NOT NULL,
  `productID` int(10) NOT NULL,
  `inputDate` date NOT NULL,
  `description` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Table kho hàng';

--
-- Dumping data for table `warehouse`
--

INSERT INTO `warehouse` (`whID`, `whName`, `productID`, `inputDate`, `description`) VALUES
(1, 'WH1', 0, '0000-00-00', ''),
(2, 'WH2', 0, '0000-00-00', ''),
(3, 'WH T&L', 0, '0000-00-00', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `crate_sellers`
--
ALTER TABLE `crate_sellers`
  ADD PRIMARY KEY (`crate_deli_ID`);

--
-- Indexes for table `order`
--
ALTER TABLE `order`
  ADD PRIMARY KEY (`order_ID`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`productID`);

--
-- Indexes for table `shop`
--
ALTER TABLE `shop`
  ADD PRIMARY KEY (`shopID`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`userID`);

--
-- Indexes for table `warehouse`
--
ALTER TABLE `warehouse`
  ADD PRIMARY KEY (`whID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `crate_sellers`
--
ALTER TABLE `crate_sellers`
  MODIFY `crate_deli_ID` int(10) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `order`
--
ALTER TABLE `order`
  MODIFY `order_ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `productID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;
--
-- AUTO_INCREMENT for table `shop`
--
ALTER TABLE `shop`
  MODIFY `shopID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `userID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `warehouse`
--
ALTER TABLE `warehouse`
  MODIFY `whID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
