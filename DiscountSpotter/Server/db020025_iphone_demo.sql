-- phpMyAdmin SQL Dump
-- version 3.1.3.2
-- http://www.phpmyadmin.net
--
-- Host: database15.c1
-- Generation Time: Aug 27, 2010 at 11:05 AM
-- Server version: 5.0.87
-- PHP Version: 5.2.12-1byte4

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `db020025_iphone_demo`
--

-- --------------------------------------------------------

--
-- Table structure for table `Category`
--

CREATE TABLE IF NOT EXISTS `Category` (
  `id` int(11) NOT NULL auto_increment,
  `category` varchar(100) NOT NULL,
  `image` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `Category`
--

INSERT INTO `Category` (`id`, `category`, `image`) VALUES
(1, 'Mobile', ''),
(2, 'Television', ''),
(3, 'Camera', ''),
(4, 'Camcorder', ''),
(5, 'Desktop', ''),
(6, 'Laptop', ''),
(7, 'Printer', ''),
(8, 'Usb', '');

-- --------------------------------------------------------

--
-- Table structure for table `Coupon`
--

CREATE TABLE IF NOT EXISTS `Coupon` (
  `couponID` int(11) NOT NULL auto_increment,
  `productName` varchar(100) NOT NULL,
  `productDescription` text NOT NULL,
  `productBrand` varchar(100) NOT NULL,
  `productCategory` varchar(100) NOT NULL,
  `productPrice` float NOT NULL,
  `productImage` text NOT NULL,
  `discountDescription` text NOT NULL,
  `discountType` enum('percentage','absolute value','absolute off') NOT NULL,
  `discountValue` float NOT NULL,
  `fromDate` datetime NOT NULL,
  `toDate` datetime NOT NULL,
  `shopID` int(11) NOT NULL,
  `barcode` text NOT NULL,
  PRIMARY KEY  (`couponID`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=42 ;

--
-- Dumping data for table `Coupon`
--

INSERT INTO `Coupon` (`couponID`, `productName`, `productDescription`, `productBrand`, `productCategory`, `productPrice`, `productImage`, `discountDescription`, `discountType`, `discountValue`, `fromDate`, `toDate`, `shopID`, `barcode`) VALUES
(1, 'iPhone 3Gs', 'The revolution phone, it is a faster iPhone with featuring a 3.0 megapixel camera with autofocus, video recording capabilities with editing, and increased (3X) processing speed.', 'Apple', 'Mobile', 600, 'http://phptest.isaac.nl/iphone/productImages/iphone3gs.png', '20% discount', 'percentage', 0.2, '2010-07-12 14:15:09', '2010-08-26 14:15:13', 1, 'http://phptest.isaac.nl/iphone/coupons/barcode01.png'),
(2, 'MacBook Pro 15-inch ', 'The 15.4" MacBook Pro Notebook Computer from Apple gives you all the power of a Macintosh computer in a portable and attractive form.', 'Apple', 'Laptop', 1119, 'http://phptest.isaac.nl/iphone/productImages/macbook_pro_15.png', '200 euro discount ', 'absolute off', 200, '2010-07-14 14:30:44', '2010-08-30 14:30:52', 4, 'http://phptest.isaac.nl/iphone/coupons/barcode01.png'),
(3, 'Sony Cyber-shot DSC-WX1', 'The 10-megapixel, 5X-optical-zoom (24mm to 120mm) Sony Cyber-shot DSC-WX1 is among the first pocket cameras to offer Sony''s redesigned, low-light-optimized Exmor R sensor. Those low-light chops are the marquee feature of this very compact camera, which excels in dark situations thanks to its unique shooting modes.\r\n\r\nRather than forcing the shooter to boost ISO equivalency in order to take a brightly exposed photo in low-light situations without a flash, the WX1''s Handheld Twilight mode snaps up to six shots at different exposure settings in rapid succession, then overlays the images to create a sharper photo than most point-and-shoots produce in low light. The Handheld Twilight option works best in pitch-black settings; the sensor is so sensitive to light that any exposure to a light source in an otherwise dark environment can make those well-lit areas look a bit blown out and murky.\r\n\r\nFor example, in the first shot below, the light coming from the fountain is muted enough to create a fairly sharp picture. But in the second shot, the neon lights and the moon are bright enough to create a blobby glow around them.\r\n\r\n\r\n\r\n\r\n\r\nBesides the Handheld Twilight mode, the WX1 has an "Advanced" setting in its Scene Recognition mode that lets you take two shots with one press of the shutter button: one with the flash on, and one with the flash off. It displays those two shots side-by-side, letting you pick the one you think looks better and eliminating some of the guesswork involved when taking photos in low light.\r\n\r\nThe WX1 also comes with the excellent Sweep Panorama mode found in other new Sony cameras. This mode allows you to press the shutter button once, pan the camera from side to side, and create an instant panoramic image with surprisingly little effort. It works best with static landscapes, as any moving objects in the frame can appear to stretch across a large portion of the panoramic scene.\r\n\r\nIn the PCWorld Labs'' imaging tests, the Cyber-shot DSC-WX1 significantly outshone earlier point-and-shoot cameras from Sony in image quality. Our panel of judges rated color accuracy and overall image quality excellent in test shots taken with the WX1, but images did show a bit of distortion and lack of sharpness. Despite that, the WX1 earned an overall image rating of Superior when compared with other pocketable digital cameras.\r\n\r\nBattery life is also strong, as the camera took 394 shots on a single charge of its lithium ion battery. That was good enough for a PCWorld Labs battery-life rating of Very Good.\r\n\r\nThis Cyber-shot is an extremely compact camera, a bit smaller than a deck of cards, and unassuming enough to fit in a shirt pocket without a problem. Although the wide shutter button is big and comfortable to use, those with bigger hands may have trouble with the smaller mode dial, back-camera buttons, and zoom bar.\r\n\r\nA small button next to the shutter release places the camera in burst mode, which is capable of taking up to 10 shots per second. The mode dial on the back of the camera provides quick access to such modes as Handheld Twilight, Sweep Panorama, Automatic Scene Recognition, program, scene selections, Easy, antiblur, and high-definition video (the WX1 records 720p video at 30 frames per second).\r\n\r\nThe 2.7-inch LCD screen, which serves as the camera''s only viewfinder, is bright, crisp, and sharp. In fact, it may be a little too sharp: Even though the camera''s image quality is very good, photos look better on the camera''s LCD than after you''ve uploaded them to your computer. This is especially evident in Handheld Twilight mode shots, where brightly-lit highlights look noticeably less sharp than they do in images played back on the camera itself.\r\n\r\nAs with many Sony products, the WX1 comes with a couple of proprietary issues to think about before buying: It is one of the last Sony cameras that supports only Memory Stick format storage, and the USB cable used to offload photos directly from the WX1 has a proprietary connector on the camera''s side of the equation.\r\n\r\nAt around $330, the WX1 does cost a bit much for a camera with no manual shutter or aperture controls. However, for the price, you get a very compact, very stylish camera that takes excellent photos in dark settings, and its unique in-camera modes make it a great all-purpose pocket camera.', 'Sony', 'Camera', 373.99, 'http://phptest.isaac.nl/iphone/productImages/Sony-Cyber-shot%20DSC-WX1.jpg', 'Cheaper more than 50euro', 'absolute value', 300, '2010-07-15 14:45:19', '2010-08-22 14:45:23', 1, 'http://phptest.isaac.nl/iphone/coupons/barcode01.png'),
(4, 'Samsung PN50B650 50-inch LCD', 'The Samsung PN50B650 isn''t just a capable HDTV; its ethernet connection turns it into a multimedia machine, with access to online video, news and weather reports, and the photos and music stored on your PC. And with an estimated street price of $1200 (as of 12/7/09), it''s a good bargain, too.\r\n', 'Samsung', 'Television', 999, 'http://phptest.isaac.nl/iphone/productImages/Samsung-PN50B650-50-inch-LCD.jpg', '20% discount', 'percentage', 0.2, '2010-07-16 15:05:42', '2010-08-24 15:05:47', 8, 'http://phptest.isaac.nl/iphone/coupons/barcode01.png'),
(22, 'Hewlett-Packard Photosmart Plus All-In-One Printer  ', 'The HP Photosmart Plus color inkjet multifunction printer  is well priced for student and home users ($150 as of December 9, 2009). It also pumps out great-looking output quickly--something that few other models in its price class can achieve.\r\n\r\nHP makes things easy from the get-go. The installation wizard includes a library of animated instructions for setup and basic operation. The control panel features a 2.3-inch color LCD, surrounded by touch-sensitive LED buttons that light only when needed. Menu items include how-to animations, as well as troubleshooting instructions for clearing paper jams, replacing cartridges, and other everyday tasks.\r\n\r\nThe Photosmart Plus printed quickly and well in our tests, generating 8.9 pages per minute for plain text and 4 ppm for graphics. On plain paper, text looked crisp; even photos looked sharp and smooth, improving even more when we printed on HP''s own glossy paper. The unit''s scanning speeds were slower than average, but images were realistic and detailed. Although a text scan was slightly fuzzy, the Photosmart Plus rendered fine lines better than any inkjet MFP we''ve seen to date.\r\n\r\nWhile the performance is impressive, the feature set is pretty basic. Wi-Fi connectivity is a bonus, as is the second, 20-sheet photo-paper tray. The 125-sheet input tray is more pedestrian, but adequate; its lid serves as the 50-sheet output area (and houses the photo tray). The output tray''s extension arm is sturdy, and you''ll need it: My printed pages slid off the edge otherwise. This model has no automatic duplexing; check out the Canon Pixma MP560 if you want that feature (and cheaper ink). Two media slots accommodate Memory Stick, SD Card, and XD-Picture Card media, and the machine has a PictBridge port. HP sells a Bluetooth adapter for $20.\r\n\r\nThe ink costs are better than you''d expect for a low-cost MFP. A 250-page black cartridge and 300-page cyan, magenta, and yellow cartridges ship in the box. The standard-size ink cartridges have nicely midrange pricing, but the high-yield versions are the best deal. An 800-page black cartridge costs $35 (4.4 cents per page for black text), and each 750-page color cartridge costs $18 (2.4 cents per color, per page). A four-color page would cost a very affordable 11.6 cents--a darn sight better than the pricey inks for the Epson Stylus NX515 can manage. Replacing cartridges is nearly idiot-proof, as an illustrated label guides you through the process, or you can view an animation on the touchscreen.\r\n\r\nThe HP Photosmart Plus packs a lot of performance into a low-cost MFP package, with well-priced inks to boot. Other models in this price range can''t boast quite as much.', 'HP', 'Printer', 90, 'http://images.pcworld.com/reviews/graphics/185406-293765_180_original.jpg', '10% discount', 'percentage', 0.1, '2010-07-13 14:32:50', '2010-08-30 14:32:54', 10, 'http://phptest.isaac.nl/iphone/coupons/barcode01.png'),
(23, 'Sprint U301 USB Modem', 'The dual-mode U301 can deliver fast speeds where a 4G signal is available, but it has trouble automatically switching from 3G to 4G.', 'Sprint', 'Usb', 300, 'http://images.pcworld.com/reviews/graphics/197164-sprintu301new_180_original.jpg', '50 euro off', 'absolute off', 50, '2010-07-14 14:35:51', '2010-08-31 14:35:58', 11, 'http://phptest.isaac.nl/iphone/coupons/barcode01.png'),
(41, 'HTC EVO 4G', 'The speedy HTC EVO 4G packs in some powerful specs and a variety of multimedia features into a stylish, minimalist design, but not everybody will get to enjoy one of its best features--4G connectivity.', '', 'Mobile', 199, 'http://images.pcworld.com/reviews/graphics/products/uploaded/526735_g1.jpg', '20 euro discount', 'absolute off', 20, '2010-08-26 14:45:44', '2010-09-25 14:45:44', 1, 'http://phptest.isaac.nl/iphone/coupons/barcode01.png'),
(40, 'Maingear F131', 'The Maingear F131 hits the upper limits of the mainstream PC category, in both performance and cost. But you get quite a lot of bang for your buck, as the F131 delivers much of the muscle and flexibility of beefier machines, at a respectable price of $1999 (as of August 12, 2010)', '', 'Desktop', 1200, 'http://images.pcworld.com/reviews/graphics/products/uploaded/569794_g1.jpg', '20% discount', 'percentage', 0.2, '2010-08-26 14:28:46', '2010-09-25 14:28:46', 10, 'http://phptest.isaac.nl/iphone/coupons/barcode01.png'),
(35, 'SanDisk Cruzer Titanium', 'The SanDisk Cruzer Titanium is stylish enough for business, yet rugged enough for outdoor adventures', '', 'Usb', 75, 'http://www.toptenreviews.com/i/rev/site/cms/category_headers/180-h_main.png', '10 euro kortin', 'absolute value', 10, '2010-08-05 14:46:30', '2010-09-04 14:46:30', 11, 'http://phptest.isaac.nl/iphone/coupons/barcode01.png'),
(21, 'Toshiba Camileo S20', 'It may be thin and light--even for a pocket camcorder--but the ultraslim Toshiba Camileo S20 ($180 as of 5/7/2010) packs more features into its frame than any high-definition pocket camcorder we''ve tested to date.\r\n\r\nAlong with 1080p high-definition video, digital stabilization, and a macro/landscape toggle switch--all of which we''ve seen in models such as the Kodak Zi8--the Camileo S20 has a handful of pocket-camcorder firsts, including an LED light for shooting in the dark, a time-lapse mode that lets you select between three preset intervals, four white-balance presets, and a slow-motion mode that helps you take (very grainy) footage of fast action. It shoots AVI files in 1080p or 720p at 30 frames per second, recording the video footage to a user-supplied SD or SDHC card.\r\n\r\nInstead of the candy-bar design employed by the vast majority of pocket camcorders, the Camileo S20 shoots in a pistol-grip style, thanks to a flip-out, swiveling 3-inch LCD screen; it''s a Sony Bloggie MHS-CM5 on a no-carb diet. The adjustable screen is great for composing odd-angle shots (filming over a crowd or taking self-portraits, for example), but it''s not the sharpest screen we''ve seen, and it looks a bit dull in direct sunlight. That said, it''s big and adjustable enough to get the job done as a viewfinder.\r\n\r\nWith all the normal settings in 1080p (30 fps) mode, the Toshiba Camileo S20 served up sharp, smooth, but slightly muted video when compared to similar pocket camcorders. Video quality didn''t look bad at all, but colors aren''t as vivid as they are in footage shot with the Sony Bloggie MHS-CM5 or the top-rated Creative Vado HD. (For the highest-quality footage, select "1080p" from the drop-down menu that will appear in the lower right corner of the embedded video player when it starts.)', 'Toshiba', 'Camcorder', 180, 'http://images.pcworld.com/reviews/graphics/195955-to_pa3792u_600_180.jpg', 'now only 140 euro', 'absolute value', 140, '2010-07-22 14:28:46', '2010-08-26 14:28:49', 9, 'http://phptest.isaac.nl/iphone/coupons/barcode01.png');

-- --------------------------------------------------------

--
-- Table structure for table `Location`
--

CREATE TABLE IF NOT EXISTS `Location` (
  `locationID` int(11) NOT NULL auto_increment,
  `type` enum('shop','bank','atm') NOT NULL,
  `name` varchar(50) NOT NULL,
  `addressHint` text NOT NULL,
  `description` text NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  `homepageURL` varchar(50) NOT NULL,
  `phone` varchar(30) NOT NULL,
  `email` varchar(50) NOT NULL,
  PRIMARY KEY  (`locationID`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=14 ;

--
-- Dumping data for table `Location`
--

INSERT INTO `Location` (`locationID`, `type`, `name`, `addressHint`, `description`, `latitude`, `longitude`, `homepageURL`, `phone`, `email`) VALUES
(1, 'shop', 'YouMac', 'Eindhoven', 'YouMac is a premium Mac shop', 51.439015, 5.480118, 'http://www.youmac.nl', '40-293 03 68', 'info@youmac.nl'),
(2, 'bank', 'ABN Amro', 'Eindhoven', 'ABNAmro is a famous bank in Netherlands\r\n', 51.444593, 5.502434, 'http://www.abnamroprivatebanking.com/', '0634963489', 'info@abnamro.nl'),
(3, 'atm', 'ATM Rabo', 'Eindhoven', 'Rabobank atm, charge you a lot of money\r\n', 51.443389, 5.454669, '', '', ''),
(4, 'shop', 'MediaMarkt', 'Eindhoven', 'The biggest electronic shop in Eindhoven\r\n', 51.442907, 5.475011, 'http://www.mediamarkt.nl', '0900-6334262758', 'info@mediamarkt.nl'),
(5, 'atm', 'ATM Rachelsmolen', 'Eindhoven', 'a nice service\r\n\r\n', 51.451172, 5.480332, '', '', ''),
(6, 'bank', 'Rabo bank', 'Eindhoven', 'small bank for big people\r\n\r\n', 51.438119, 5.477114, 'http://www.rabobank.nl/', '040-545443876', 'info@rabobank.nl'),
(7, 'atm', 'ATM Fellenoord', 'Eindhoven', 'Big ATM in central\r\n\r\n', 51.443977, 5.475783, '', '', ''),
(8, 'shop', 'MyCom ', 'Eindhoven', 'MyCom is a nice computer shop\r\n', 51.448926, 5.47677, 'http://www.mycom.nl/', '040-2962762', 'info@mycom.nl'),
(9, 'shop', 'ShopIT', 'Gestel', 'Asian TV shop', 51.426213, 5.462651, 'www.gestel.nl', '040-545443874', 'info@gestel.nl'),
(10, 'shop', 'LinuxGeek', 'Nuenen', 'Linux shop for geek', 51.475823, 5.547409, 'www.linuxgeek.vn', '0654565434', 'info@linuxgeek.com'),
(11, 'shop', 'Ubuntu', 'Geldrop', 'Nice shop', 51.425116, 5.556335, 'www.ubuntu.com', '0634963483', '@info@ubuntu.com'),
(12, 'atm', 'ATM Magere', 'Amsterdam', 'ATM in Amsterdam', 52.375075, 4.891233, '', '', ''),
(13, 'bank', 'Fortys', 'Utrecht', 'Fortys bank in Utrech', 52.097015, 5.122375, '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `Notification`
--

CREATE TABLE IF NOT EXISTS `Notification` (
  `id` int(11) NOT NULL auto_increment,
  `token` varchar(150) NOT NULL,
  `shopID` int(11) NOT NULL,
  `couponID` varchar(20) NOT NULL,
  `productCategory` varchar(100) NOT NULL,
  `signedoffDate` datetime default NULL,
  `pushedDate` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=56 ;

--
-- Dumping data for table `Notification`
--

INSERT INTO `Notification` (`id`, `token`, `shopID`, `couponID`, `productCategory`, `signedoffDate`, `pushedDate`) VALUES
(55, '1d02bbd578ae8b59000b00344546d491b3b53523deb796a41f2db91651056da9', 1, '41', 'Mobile', NULL, '2010-08-26 14:45:44'),
(54, '1d02bbd578ae8b59000b00344546d491b3b53523deb796a41f2db91651056da9', 10, '40', 'Desktop', NULL, '2010-08-26 14:39:48');

-- --------------------------------------------------------

--
-- Table structure for table `Subscription`
--

CREATE TABLE IF NOT EXISTS `Subscription` (
  `id` int(11) NOT NULL auto_increment,
  `token` varchar(200) NOT NULL,
  `shopID` int(1) NOT NULL,
  `productCategory` varchar(50) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=529 ;

--
-- Dumping data for table `Subscription`
--

INSERT INTO `Subscription` (`id`, `token`, `shopID`, `productCategory`) VALUES
(515, '1d02bbd578ae8b59000b00344546d491b3b53523deb796a41f2db91651056da9', 4, 'Laptop'),
(523, '1d02bbd578ae8b59000b00344546d491b3b53523deb796a41f2db91651056da9', 9, 'Camcorder'),
(520, '1d02bbd578ae8b59000b00344546d491b3b53523deb796a41f2db91651056da9', 10, 'Desktop');

-- --------------------------------------------------------

--
-- Table structure for table `User`
--

CREATE TABLE IF NOT EXISTS `User` (
  `token` varchar(150) NOT NULL,
  `email` varchar(50) default NULL,
  `id` int(11) NOT NULL auto_increment,
  `pushAlert` varchar(10) NOT NULL,
  `pushBadge` varchar(10) NOT NULL,
  `pushSound` varchar(10) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `token` (`token`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=24 ;

--
-- Dumping data for table `User`
--

INSERT INTO `User` (`token`, `email`, `id`, `pushAlert`, `pushBadge`, `pushSound`) VALUES
('5f04d68f281915b22f194de24955c34cc4737422bca0209684f6ce82bde3d3fe', '', 23, 'enabled', 'enabled', 'enabled'),
('4ec6aca70530bb2c85b9a8e330180514592a6cce372b630cf7c6f90a35adfc01', 'dai@yajoo.com', 22, 'enabled', 'enabled', 'enabled'),
('1d02bbd578ae8b59000b00344546d491b3b53523deb796a41f2db91651056da9', 'dai.tran.hoang@isaac.nl', 21, 'enabled', 'enabled', 'enabled');
