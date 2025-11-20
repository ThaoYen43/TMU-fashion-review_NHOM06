-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th10 20, 2025 lúc 02:05 PM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `fashion_review`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `brands`
--

CREATE TABLE `brands` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `cover_image` varchar(255) DEFAULT NULL,
  `price_range_min` decimal(10,0) DEFAULT 0,
  `price_range_max` decimal(10,0) DEFAULT 0,
  `shopee_link` varchar(255) DEFAULT NULL,
  `facebook_link` varchar(255) DEFAULT NULL,
  `is_featured` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `brands`
--

INSERT INTO `brands` (`id`, `name`, `description`, `logo`, `cover_image`, `price_range_min`, `price_range_max`, `shopee_link`, `facebook_link`, `is_featured`, `created_at`, `updated_at`) VALUES
(12, 'xéo xọ', '&quot;Xéo Xọ&quot; là tên một thương hiệu hoặc cửa hàng thời trang, không phải là một phong cách thời trang. Mô tả thời trang của &quot;Xéo Xọ&quot; thường liên quan đến các sản phẩm cụ thể của họ, ví dụ như set áo dài lụa tổng hợp dáng suông, tay loe lửng, màu xanh navy viền hồng và in họa tiết theo phong cách riêng của thương hiệu này.', '690d93e1521d5.jpg', '690d93e152787.jpg', 1000000, 2000000, 'https://shopee.vn/xeoxo', 'https://www.facebook.com/xeoxo/?locale=vi_VN', 0, '2025-11-07 06:38:25', '2025-11-07 06:48:06'),
(13, 'Chanel', 'Chanel là thương hiệu thời trang cao cấp của Pháp, do Coco Chanel sáng lập, nổi tiếng với các thiết kế sang trọng, thanh lịch vượt thời gian và tinh thần độc lập, giải phóng phụ nữ khỏi những khuôn mẫu cứng nhắc của thế kỷ trước. Thương hiệu này sản xuất đa dạng các sản phẩm như thời trang may sẵn, đồ xa xỉ, phụ kiện, nước hoa (nổi bật là Chanel No. 5), và trang sức. Chanel được biết đến với phong cách cổ điển nhưng vẫn hiện đại, sang trọng mà vẫn tiện dụng, đồng thời tạo ra các sản phẩm mang tính biểu tượng và giá trị bền vững.', '691d906b509bb.jpg', '691d906b50c8a.png', 1000000, 50000000, 'https://s.shopee.vn/1gAuUC4K7d', 'https://www.facebook.com/share/1RFNwov5Ed/?mibextid=wwXIfr', 1, '2025-11-07 07:32:18', '2025-11-19 09:50:03'),
(14, 'DEAR JOSÉ', 'Dear José là một thương hiệu thời trang thiết kế được thành lập vào năm 2018, nổi tiếng với phong cách lãng mạn, bay bổng và nữ tính, lấy cảm hứng từ tình yêu, hồi ức và những cảm xúc tinh tế. Thương hiệu này khai thác sự pha trộn giữa phong cách lãng mạn Tây phương thập niên 70 và nét &quot;princesscore&quot;, tập trung vào các thiết kế tinh tế, bay bổng, với các chi tiết như cánh bướm, họa tiết hoa, và chất liệu xuyên thấu.', '691d977debb7d.jpg', '691d977debdcd.png', 300000, 2000000, 'https://s.shopee.vn/1gAuUC4K7d', 'https://www.facebook.com/share/1RFNwov5Ed/?mibextid=wwXIfr', 1, '2025-11-19 10:10:05', '2025-11-19 10:10:05'),
(15, 'JM Dress', 'JM Dress Design là một thương hiệu thời trang nữ của Việt Nam, nổi tiếng với phong cách thanh lịch, tinh tế và hiện đại. Thương hiệu này cung cấp các dòng sản phẩm đa dạng, chủ yếu là đầm, áo dài cách tân và thời trang công sở, sử dụng chất liệu cao cấp và tập trung vào chất lượng từ thiết kế đến sản xuất. JM đã phát triển một chuỗi hệ thống cửa hàng lớn mạnh trên toàn quốc với hơn 30 showroom và có mục tiêu mở rộng ra thị trường quốc tế.', '691d980e9d91c.jpg', '691d980e9daf8.jpg', 2000000, 10000000, 'https://s.shopee.vn/1gAuUC4K7d', 'https://www.facebook.com/share/1RFNwov5Ed/?mibextid=wwXIfr', 1, '2025-11-19 10:12:30', '2025-11-19 10:12:30'),
(16, 'Calie', 'Calie là một thương hiệu thời trang thiết kế dành cho phái nữ tại Việt Nam, tập trung vào phong cách thanh lịch, tinh giản và nữ tính. Thương hiệu này mang tên Công ty TNHH Thời trang Calie House, được thành lập với sứ mệnh giúp phụ nữ tự tin thể hiện bản thân.', '691d99f580ade.jpg', '691d99f580fe9.webp', 300000, 20000000, 'https://s.shopee.vn/1gAuUC4K7d', 'https://www.facebook.com/share/1RFNwov5Ed/?mibextid=wwXIfr', 0, '2025-11-19 10:20:37', '2025-11-19 10:20:37'),
(17, 'UniQlo', 'Uniqlo là một thương hiệu thời trang Nhật Bản chuyên về quần áo thường ngày, nổi tiếng với triết lý &amp;quot;LifeWear&amp;quot; - tập trung vào quần áo chất lượng cao, thiết thực, có tính ứng dụng và giá cả phải chăng. Thay vì chạy theo các xu hướng thời trang nhanh, Uniqlo tạo ra những trang phục cơ bản, giản dị, dễ dàng phối hợp, với nhiều lựa chọn màu sắc.', '691d9aa058a4a.jpg', '691d9aa058ce5.jpg', 1000000, 10000000, 'https://s.shopee.vn/1gAuUC4K7d', 'https://www.facebook.com/share/1RFNwov5Ed/?mibextid=wwXIfr', 0, '2025-11-19 10:21:14', '2025-11-19 10:23:28'),
(18, 'Elise', 'Elise là một thương hiệu thời trang cao cấp hàng đầu Việt Nam, nổi tiếng với phong cách hiện đại, sang trọng và thanh lịch. Thương hiệu này có hơn 100 cửa hàng trên toàn quốc và sở hữu hệ thống thiết kế, sản xuất, phân phối đồng bộ. Ngoài ra, Elise còn là tên của một bản nhạc nổi tiếng của nhà soạn nhạc Beethoven.', '691d9a4e993b3.jpg', '691d9a4e99697.png', 500000, 15000000, 'https://s.shopee.vn/1gAuUC4K7d', 'https://www.facebook.com/share/1RFNwov5Ed/?mibextid=wwXIfr', 1, '2025-11-19 10:22:06', '2025-11-19 10:22:06'),
(20, 'Tingoan', 'Tingoan là một local brand thời trang nữ nổi tiếng ở Hà Nội, chuyên cung cấp các sản phẩm mang phong cách nữ tính, hiện đại và đa dạng. Tingoan được biết đến với nhiều mẫu mã, từ váy, áo croptop, quần đến phụ kiện như giày dép, và được nhiều KOLs Việt ưa chuộng. Thương hiệu tập trung vào các sản phẩm có chất lượng tốt, giá cả phải chăng, với hệ thống cửa hàng ở cả Hà Nội và TP.HCM', '691e68c79850a.jpg', '691e68c798649.jpg', 100000, 498999, 'https://s.shopee.vn/1gAuUC4K7d', 'https://www.facebook.com/share/1RFNwov5Ed/?mibextid=wwXIfr', 0, '2025-11-20 01:03:03', '2025-11-20 01:03:43');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `brand_id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `content` text NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `is_hidden` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `rating` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `comments`
--

INSERT INTO `comments` (`id`, `user_id`, `brand_id`, `product_id`, `parent_id`, `content`, `image`, `is_hidden`, `created_at`, `updated_at`, `rating`) VALUES
(103, 7, 17, 7, NULL, 'tốt', NULL, 0, '2025-11-13 04:04:23', '2025-11-19 14:54:07', 1),
(104, 7, 17, 8, NULL, 'hàng đẹp', NULL, 0, '2025-11-13 04:04:31', '2025-11-19 14:54:09', 1),
(105, 7, 17, 9, NULL, 'tuyệt', NULL, 0, '2025-11-13 04:40:24', '2025-11-19 14:54:11', 1),
(106, 7, 13, 1, NULL, 'thủy tiên nè', NULL, 0, '2025-11-13 06:31:20', '2025-11-19 12:10:50', 1),
(107, 7, 13, 1, NULL, '100đ', NULL, 0, '2025-11-13 06:31:27', '2025-11-19 12:10:50', 1),
(108, 7, 13, 2, NULL, 'sản phẩm đẹp, size chuẩn', NULL, 0, '2025-11-19 09:35:49', '2025-11-19 12:55:05', 5),
(109, 7, 13, 2, NULL, 'đẹp', NULL, 0, '2025-11-19 09:58:41', '2025-11-19 12:55:00', 5),
(110, 7, 13, 1, NULL, 'k ok', NULL, 0, '2025-11-19 10:02:06', '2025-11-19 12:10:50', 1),
(111, 7, 13, 2, NULL, 'ok', NULL, 0, '2025-11-19 11:40:31', '2025-11-19 12:10:50', 1),
(112, 7, 13, 2, NULL, 'tuyet voi', NULL, 0, '2025-11-19 12:11:19', '2025-11-19 12:11:19', 4),
(113, 9, 17, 9, NULL, 'áo đẹp chất vải xịn', NULL, 0, '2025-11-20 00:49:30', '2025-11-20 00:49:30', 5),
(114, 9, 17, 8, NULL, 'áo cũng đẹp', NULL, 0, '2025-11-20 00:49:53', '2025-11-20 00:49:53', 4),
(115, 9, 17, 7, NULL, 'xấu', NULL, 0, '2025-11-20 00:50:08', '2025-11-20 00:50:08', 2),
(116, 9, 18, 6, NULL, 'đẹp lắm luôn', NULL, 0, '2025-11-20 00:50:26', '2025-11-20 00:50:26', 5),
(117, 9, 18, 5, NULL, 'giá cao', NULL, 0, '2025-11-20 00:50:39', '2025-11-20 00:50:39', 5),
(118, 9, 18, 4, NULL, 'xịn', NULL, 0, '2025-11-20 00:50:51', '2025-11-20 00:50:51', 5),
(119, 9, 18, 3, NULL, 'rẻ đẹp', NULL, 0, '2025-11-20 00:51:10', '2025-11-20 00:51:10', 5),
(120, 9, 18, 6, NULL, 'dịch vụ tốt', NULL, 0, '2025-11-20 00:51:27', '2025-11-20 00:51:27', 4),
(121, 9, 16, 13, NULL, 'xinh', NULL, 0, '2025-11-20 00:51:46', '2025-11-20 00:51:46', 4),
(122, 9, 16, 12, NULL, 'xinhh', NULL, 0, '2025-11-20 00:51:59', '2025-11-20 00:51:59', 5),
(123, 9, 16, 10, NULL, 'ngắn', NULL, 0, '2025-11-20 00:52:16', '2025-11-20 00:52:16', 3),
(124, 7, 20, 19, NULL, 'đẹp', '691e7782ae39f.jpg', 0, '2025-11-20 02:05:54', '2025-11-20 02:05:54', 5),
(125, 7, 16, 13, NULL, 'sd', NULL, 0, '2025-11-20 11:56:53', '2025-11-20 11:56:53', 4);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `brand_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `short_description` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(12,2) DEFAULT 0.00,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `products`
--

INSERT INTO `products` (`id`, `brand_id`, `name`, `image`, `short_description`, `description`, `price`, `created_at`) VALUES
(1, 13, 'Áo dài lục phi', '69156c5958d92.jpg', '', '', 4.80, '2025-11-13 12:27:53'),
(2, 13, 'tweed trong BST Chanel Cruise', '691aedc651c45.jpg', '', 'Bouclé Jacket – chiếc áo khoác làm từ vải tweed của nhà mốt Chanel có thể được xem là một trong những biểu tượng của vẻ đẹp thanh lịch, vượt thời gian trong làng thời trang. Lấy cảm hứng từ trang phục menswear, thiết kế này được ra mắt vào năm 1954 khi Coco Chanel đã 71 tuổi. Bà sử dụng chất liệu mềm mại, tạo nên chiếc áo phom đứng với mong muốn phái đẹp có thể ăn diện thoải mái hơn so với những kiểu dáng chiết eo “ngạt thở” trong thập niên 50.', 1300000.00, '2025-11-17 16:41:26'),
(3, 18, 'Đầm đen cổ nơ', '691d9def385d7.jpg', 'Đầm tơ đen HT logo cổ đức đai eo', 'Trang phục linh hoạt, được thiết kế để mặc từ thắt lưng trở xuống, với vô số kiểu dáng, chiều dài, và chất liệu khác nhau, phục vụ cho nhiều mục đích và phong cách thời trang đa dạng', 300000.00, '2025-11-19 17:37:35'),
(4, 18, 'Đầm dáng dài đen kèm khăn đeo cổ', '691d9e35abac7.jpg', 'Đầm dáng dài đen thanh lịch phù hợp đi tiệc', 'Trang phục linh hoạt, được thiết kế để mặc từ thắt lưng trở xuống, với vô số kiểu dáng, chiều dài, và chất liệu khác nhau, phục vụ cho nhiều mục đích và phong cách thời trang đa dạng', 1000000.00, '2025-11-19 17:38:45'),
(5, 18, 'Đầm ghi đậm boom gấu đai eo', '691d9e752dda1.jpg', 'Đầm ghi đậm boom gấu đai eo sang chảnh', 'Trang phục linh hoạt, được thiết kế để mặc từ thắt lưng trở xuống, với vô số kiểu dáng, chiều dài, và chất liệu khác nhau, phục vụ cho nhiều mục đích và phong cách thời trang đa dạng', 7000000.00, '2025-11-19 17:39:49'),
(6, 18, 'Áo tiểu thư kết hợp chân váy dáng dài trắng sữa', '691d9ec4ed814.jpg', 'Áo tiểu thư kết hợp chân váy dài cách điệu', 'Trang phục linh hoạt, được thiết kế để mặc từ thắt lưng trở xuống, với vô số kiểu dáng, chiều dài, và chất liệu khác nhau, phục vụ cho nhiều mục đích và phong cách thời trang đa dạng', 5499000.00, '2025-11-19 17:41:08'),
(7, 17, 'Áo gió', '691d9ef1a633f.webp', 'Áo gió hợp thời trang', 'Trang phục linh hoạt, được thiết kế để mặc từ thắt lưng trở xuống, với vô số kiểu dáng, chiều dài, và chất liệu khác nhau, phục vụ cho nhiều mục đích và phong cách thời trang đa dạng', 500000.00, '2025-11-19 17:41:53'),
(8, 17, 'Áo Parka 2 mặt cho nữ', '691da247ed597.png', 'Áo parka 2 mặt xám tiêu siêu đẹp', 'Trang phục linh hoạt, được thiết kế để mặc từ thắt lưng trở xuống, với vô số kiểu dáng, chiều dài, và chất liệu khác nhau, phục vụ cho nhiều mục đích và phong cách thời trang đa dạng', 1500000.00, '2025-11-19 17:43:04'),
(9, 17, 'Áo thun Uni', '691da236f33ad.jpg', 'Các màu áo thun trendy', 'Trang phục linh hoạt, được thiết kế để mặc từ thắt lưng trở xuống, với vô số kiểu dáng, chiều dài, và chất liệu khác nhau, phục vụ cho nhiều mục đích và phong cách thời trang đa dạng', 400000.00, '2025-11-19 17:43:43'),
(10, 16, 'Váy xanh than dáng lửng', '691d9fbc1eae3.jpeg', 'Váy lửng', 'Trang phục linh hoạt, được thiết kế để mặc từ thắt lưng trở xuống, với vô số kiểu dáng, chiều dài, và chất liệu khác nhau, phục vụ cho nhiều mục đích và phong cách thời trang đa dạng', 5000000.00, '2025-11-19 17:45:16'),
(11, 16, 'Váy hồng be có cổ tiểu thư', '691d9fe997b3c.jpg', 'Váy lửng', 'Trang phục linh hoạt, được thiết kế để mặc từ thắt lưng trở xuống, với vô số kiểu dáng, chiều dài, và chất liệu khác nhau, phục vụ cho nhiều mục đích và phong cách thời trang đa dạng', 3000000.00, '2025-11-19 17:46:01'),
(12, 16, 'Váy dáng A phổi cổ xếp ly', '691da012b7c88.jpeg', 'Váy dáng A', 'Trang phục linh hoạt, được thiết kế để mặc từ thắt lưng trở xuống, với vô số kiểu dáng, chiều dài, và chất liệu khác nhau, phục vụ cho nhiều mục đích và phong cách thời trang đa dạng', 4000000.00, '2025-11-19 17:46:42'),
(13, 16, 'Áo dáng lửng phối cổ thêu hoa trà', '691da050836dc.jpg', 'Áo dáng lửng phối cổ thêu hoa trà cùng chân váy xếp li ngắn', 'Trang phục linh hoạt, được thiết kế để mặc từ thắt lưng trở xuống, với vô số kiểu dáng, chiều dài, và chất liệu khác nhau, phục vụ cho nhiều mục đích và phong cách thời trang đa dạng', 4500000.00, '2025-11-19 17:47:44'),
(14, 15, 'Đầm be dáng ngắn', '691da089cb43b.jpg', 'Đầm be', 'Trang phục linh hoạt, được thiết kế để mặc từ thắt lưng trở xuống, với vô số kiểu dáng, chiều dài, và chất liệu khác nhau, phục vụ cho nhiều mục đích và phong cách thời trang đa dạng', 2500000.00, '2025-11-19 17:48:41'),
(15, 15, 'Đầm thiết kế có lớp voan bên dưới', '691da0bdecc21.jpeg', 'Đầm thiết kế chất liệu sang trọng', 'Trang phục linh hoạt, được thiết kế để mặc từ thắt lưng trở xuống, với vô số kiểu dáng, chiều dài, và chất liệu khác nhau, phục vụ cho nhiều mục đích và phong cách thời trang đa dạng', 7000000.00, '2025-11-19 17:49:33'),
(16, 15, 'Đầm chân nhún bèo nơ', '691da0f85b1ea.jpg', 'Đầm chân nhún bèo nơ', 'Trang phục linh hoạt, được thiết kế để mặc từ thắt lưng trở xuống, với vô số kiểu dáng, chiều dài, và chất liệu khác nhau, phục vụ cho nhiều mục đích và phong cách thời trang đa dạng', 10000000.00, '2025-11-19 17:50:32'),
(17, 15, 'Đầm cổ dức phối kèm chân váy xếp ly', '691da126273b2.jpg', 'Đầm cổ đức phối chân váy', 'Trang phục linh hoạt, được thiết kế để mặc từ thắt lưng trở xuống, với vô số kiểu dáng, chiều dài, và chất liệu khác nhau, phục vụ cho nhiều mục đích và phong cách thời trang đa dạng', 9500000.00, '2025-11-19 17:51:18'),
(18, 15, 'Đầm đính nơ cổ yếm', '691da1570eed4.jpg', 'Đần đính nơ cổ yếm', 'Trang phục linh hoạt, được thiết kế để mặc từ thắt lưng trở xuống, với vô số kiểu dáng, chiều dài, và chất liệu khác nhau, phục vụ cho nhiều mục đích và phong cách thời trang đa dạng', 8999000.00, '2025-11-19 17:52:07'),
(19, 20, 'Chân váy xếp ly phồng', '691e69b8d0427.jpg', 'Chân váy xếp ly đen phồng phong cách', 'Vẻ đẹp nhẹ nhàng, duyên dáng, với các chi tiết như nơ nhung, cúc đá lấp lánh, viền ren hoặc bèo nhún.', 300000.00, '2025-11-20 08:07:04');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_sizes`
--

CREATE TABLE `product_sizes` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `size_label` varchar(16) NOT NULL,
  `bust_min` int(11) DEFAULT 0,
  `bust_max` int(11) DEFAULT 0,
  `waist_min` int(11) DEFAULT 0,
  `waist_max` int(11) DEFAULT 0,
  `hip_min` int(11) DEFAULT 0,
  `hip_max` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `product_sizes`
--

INSERT INTO `product_sizes` (`id`, `product_id`, `size_label`, `bust_min`, `bust_max`, `waist_min`, `waist_max`, `hip_min`, `hip_max`, `created_at`) VALUES
(5, 1, 'S', 80, 86, 60, 66, 86, 92, '2025-11-20 19:02:01'),
(6, 1, 'M', 86, 92, 66, 72, 92, 98, '2025-11-20 19:02:01'),
(7, 1, 'L', 92, 98, 72, 78, 98, 104, '2025-11-20 19:02:01'),
(8, 2, 'S', 80, 86, 60, 66, 86, 92, '2025-11-20 19:03:01'),
(9, 2, 'M', 86, 92, 66, 72, 92, 98, '2025-11-20 19:03:01'),
(10, 2, 'L', 92, 98, 72, 78, 98, 104, '2025-11-20 19:03:01'),
(11, 3, 'S', 80, 86, 60, 66, 86, 92, '2025-11-20 19:04:17'),
(12, 3, 'M', 86, 92, 66, 72, 92, 98, '2025-11-20 19:04:17'),
(13, 3, 'L', 92, 98, 72, 84, 98, 104, '2025-11-20 19:04:17'),
(14, 4, 'S', 80, 86, 60, 66, 86, 92, '2025-11-20 19:08:25'),
(15, 4, 'M', 86, 92, 66, 72, 92, 98, '2025-11-20 19:08:25'),
(16, 4, 'L', 92, 98, 72, 84, 98, 104, '2025-11-20 19:08:25'),
(17, 5, 'S', 80, 86, 60, 66, 86, 92, '2025-11-20 19:09:32'),
(18, 5, 'M', 86, 92, 66, 72, 92, 98, '2025-11-20 19:09:32'),
(19, 5, 'L', 92, 98, 72, 78, 98, 104, '2025-11-20 19:09:32'),
(20, 6, 'S', 80, 86, 60, 66, 86, 92, '2025-11-20 19:10:13'),
(21, 6, 'M', 86, 92, 66, 72, 92, 98, '2025-11-20 19:10:13'),
(22, 6, 'L', 92, 98, 72, 78, 98, 104, '2025-11-20 19:10:13'),
(23, 7, 'S', 80, 86, 60, 66, 86, 92, '2025-11-20 19:10:55'),
(24, 7, 'M', 86, 92, 66, 72, 92, 98, '2025-11-20 19:10:55'),
(25, 7, 'L', 92, 98, 72, 78, 98, 104, '2025-11-20 19:10:55'),
(26, 8, 'S', 80, 86, 60, 66, 86, 92, '2025-11-20 19:11:31'),
(27, 8, 'M', 86, 92, 66, 72, 92, 98, '2025-11-20 19:11:31'),
(28, 8, 'L', 92, 98, 72, 78, 98, 104, '2025-11-20 19:11:31'),
(29, 9, 'S', 80, 86, 60, 66, 86, 92, '2025-11-20 19:12:22'),
(30, 9, 'M', 86, 92, 66, 72, 92, 98, '2025-11-20 19:12:22'),
(31, 9, 'L', 92, 98, 72, 78, 98, 104, '2025-11-20 19:12:22'),
(32, 10, 'S', 80, 86, 60, 66, 86, 92, '2025-11-20 19:13:05'),
(33, 10, 'M', 86, 92, 66, 72, 92, 98, '2025-11-20 19:13:05'),
(34, 10, 'L', 92, 98, 72, 78, 98, 104, '2025-11-20 19:13:05'),
(35, 11, 'S', 80, 86, 60, 66, 86, 92, '2025-11-20 19:13:48'),
(36, 11, 'M', 86, 92, 66, 72, 92, 98, '2025-11-20 19:13:48'),
(37, 11, 'L', 92, 98, 72, 78, 98, 104, '2025-11-20 19:13:48'),
(38, 12, 'S', 80, 86, 60, 66, 86, 92, '2025-11-20 19:14:30'),
(39, 12, 'M', 86, 92, 66, 72, 92, 98, '2025-11-20 19:14:30'),
(40, 12, 'L', 92, 98, 72, 78, 98, 104, '2025-11-20 19:14:30'),
(41, 13, 'S', 80, 86, 60, 66, 86, 92, '2025-11-20 19:15:10'),
(42, 13, 'M', 86, 92, 66, 72, 92, 98, '2025-11-20 19:15:10'),
(43, 13, 'L', 92, 98, 72, 78, 98, 104, '2025-11-20 19:15:10'),
(44, 14, 'S', 80, 86, 60, 66, 86, 92, '2025-11-20 19:16:02'),
(45, 14, 'M', 86, 92, 66, 72, 92, 98, '2025-11-20 19:16:02'),
(46, 14, 'L', 92, 98, 72, 78, 98, 104, '2025-11-20 19:16:02'),
(47, 14, 'XL', 98, 104, 78, 84, 104, 110, '2025-11-20 19:16:02'),
(48, 15, 'S', 80, 89, 60, 69, 86, 95, '2025-11-20 19:17:02'),
(49, 15, 'L', 89, 98, 69, 78, 95, 104, '2025-11-20 19:17:02'),
(50, 16, 'S', 80, 89, 60, 69, 86, 95, '2025-11-20 19:17:33'),
(51, 16, 'L', 89, 98, 69, 78, 95, 104, '2025-11-20 19:17:33'),
(52, 17, 'XS', 76, 90, 57, 70, 80, 88, '2025-11-20 19:18:28'),
(53, 17, 'M', 90, 100, 70, 86, 88, 98, '2025-11-20 19:18:28'),
(54, 18, 'S', 80, 86, 60, 66, 86, 92, '2025-11-20 19:18:58'),
(55, 18, 'M', 86, 92, 66, 72, 92, 98, '2025-11-20 19:18:58'),
(56, 19, 'XS', 80, 86, 60, 66, 86, 92, '2025-11-20 19:20:01'),
(57, 19, 'S', 86, 92, 66, 72, 92, 98, '2025-11-20 19:20:01'),
(58, 19, 'M', 92, 98, 72, 78, 98, 104, '2025-11-20 19:20:01'),
(59, 19, 'L', 98, 104, 78, 84, 104, 110, '2025-11-20 19:20:01'),
(60, 19, 'XL', 104, 110, 84, 90, 110, 116, '2025-11-20 19:20:01');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT 'default-avatar.jpg',
  `role` enum('user','admin') DEFAULT 'user',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `full_name`, `avatar`, `role`, `created_at`, `updated_at`) VALUES
(7, 'admin', 'admin@example.com', '$2y$10$DSNSM1YBnvD/VF710yr7Fes5oXeKxRSSmj0W1dsKCMCL5cx4/4ZHG', 'Administrator', '691e77a438e5c.jpg', 'admin', '2025-10-24 04:23:10', '2025-11-20 02:06:28'),
(8, 'thuytien', 'vihoangthuytien@gmail.com', '$2y$10$Gdk9veFMvpvno1XgrZ4kEucOh7FCZ9KqEISXIOUzxvc6Jihoypxme', 'Tiên Vi', '690d97a4159bc.jpg', 'user', '2025-11-07 06:39:38', '2025-11-07 06:54:28'),
(9, 'thaoyen', 'thaoyen0001@gmail.com', '$2y$10$YKJHfAxOiWTvdRE1lyX8e.GnqhoFW7kwWAK8hZIDqG5QcCziBTusq', 'Nguyễn Thị Thảo Yến', '691e65574bc39.jpg', 'user', '2025-11-20 00:48:23', '2025-11-20 00:48:23');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_measurements`
--

CREATE TABLE `user_measurements` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `preset` varchar(64) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `bust` int(11) DEFAULT NULL,
  `waist` int(11) DEFAULT NULL,
  `hip` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `user_measurements`
--

INSERT INTO `user_measurements` (`id`, `user_id`, `brand_id`, `preset`, `height`, `bust`, `waist`, `hip`, `created_at`) VALUES
(1, 7, NULL, 'mesomorph', 150, 79, 65, 85, '2025-11-13 14:31:50'),
(2, 7, NULL, 'mesomorph', 150, 79, 65, 85, '2025-11-13 14:31:52'),
(3, 7, NULL, 'mesomorph', 150, 80, 65, 85, '2025-11-13 14:34:00');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `brand_id` (`brand_id`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Chỉ mục cho bảng `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `brand_id` (`brand_id`);

--
-- Chỉ mục cho bảng `product_sizes`
--
ALTER TABLE `product_sizes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ux_product_size` (`product_id`,`size_label`),
  ADD KEY `product_id` (`product_id`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Chỉ mục cho bảng `user_measurements`
--
ALTER TABLE `user_measurements`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `brands`
--
ALTER TABLE `brands`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT cho bảng `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=126;

--
-- AUTO_INCREMENT cho bảng `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT cho bảng `product_sizes`
--
ALTER TABLE `product_sizes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT cho bảng `user_measurements`
--
ALTER TABLE `user_measurements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comments_ibfk_3` FOREIGN KEY (`parent_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
