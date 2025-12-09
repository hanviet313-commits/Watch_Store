-- Tạo database và chọn sử dụng
CREATE DATABASE IF NOT EXISTS watch_store
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE watch_store;

-- Cấu hình timezone cho database
SET time_zone = '+07:00';

-- Bảng người dùng chung, phân vai trò bằng cột vai_tro
CREATE TABLE nguoi_dung (
  id_nguoi_dung INT AUTO_INCREMENT PRIMARY KEY,
  ten_day_du    VARCHAR(100) NOT NULL,
  email         VARCHAR(100) NOT NULL UNIQUE,
  mat_khau      VARCHAR(64)  NOT NULL,
  sdt           VARCHAR(15)  NOT NULL,
  vai_tro       VARCHAR(20)  NOT NULL COMMENT 'customer|staff|admin',
  trang_thai    TINYINT      NOT NULL DEFAULT 1  COMMENT '1=hoat dong,0=vo hieu hoa',
  ngay_tao      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bảng sản phẩm
DROP TABLE IF EXISTS san_pham;
CREATE TABLE san_pham (
  id_san_pham    INT AUTO_INCREMENT PRIMARY KEY,
  ten_san_pham   VARCHAR(150) NOT NULL,
  mo_ta          TEXT         NOT NULL,
  gia            DECIMAL(10,2) NOT NULL,
  url_anh        VARCHAR(255) NOT NULL,
  so_luong_ton   INT          NOT NULL DEFAULT 0,
  nha_san_xuat   VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Thêm dữ liệu mẫu với url_anh chính xác
INSERT INTO san_pham (ten_san_pham, mo_ta, gia, url_anh, so_luong_ton, nha_san_xuat) VALUES
('Casio G-Shock GA-2100', 'Đồng hồ thể thao với khả năng chống sốc và chống nước tuyệt vời.', 2990000.00, 'GA-2100RW-1A.jpg', 50, 'Casio'),
('Casio Edifice EFR-S108D', 'Đồng hồ dây da thanh lịch với thiết kế tối giản.', 1890000.00, 'Casio Edifice EFR-S108D.jpg', 30, 'Casio'),
('Casio Baby-G BA-110', 'Đồng hồ nữ thiết kế nhỏ gọn, phù hợp cho giới trẻ.', 2490000.00, 'Casio Baby-G BA-110.jpg', 40, 'Casio'),
('Casio Pro Trek PRW-30', 'Đồng hồ đa chức năng với la bàn số, đo độ cao, đo áp suất.', 4990000.00, 'Casio Pro Trek PRW-30.jpg', 20, 'Casio'),
('Casio Vintage A168', 'Đồng hồ retro với thiết kế cổ điển thập niên 80.', 990000.00, 'Casio Vintage A168.jpg', 100, 'Casio'),
('Citizen Eco-Drive BM8180', 'Đồng hồ năng lượng ánh sáng với thiết kế quân đội.', 3990000.00, 'Citizen Eco-Drive BM8180.jpg', 35, 'Citizen'),
('Citizen Promaster NY0040', 'Đồng hồ lặn chuyên nghiệp với khả năng chống nước 200m.', 5990000.00, 'Citizen Promaster NY0040.jpg', 25, 'Citizen'),
('Citizen Chandler BM7420', 'Đồng hồ dây vải thể thao, phù hợp cho hoạt động ngoài trời.', 3490000.00, 'Citizen Chandler BM7420.jpg', 45, 'Citizen'),
('Citizen Eco-Drive AW1410', 'Đồng hồ nam với vỏ mặt số dạ quang, dây đeo thép không gỉ.', 3790000.00, 'Citizen Eco-Drive AW1410.jpg', 30, 'Citizen'),
('Citizen Promaster Navihawk', 'Đồng hồ đa chức năng với la bàn và tính năng định vị.', 7990000.00, 'Citizen Promaster Navihawk.jpg', 15, 'Citizen'),
('Seiko 5 Sports SRPD55', 'Đồng hồ thể thao với bộ máy tự động, thiết kế mạnh mẽ.', 4990000.00, 'Seiko 5 Sports SRPD55.jpg', 40, 'Seiko'),
('Seiko Presage SRPB41', 'Đồng hồ vỏ mặt số nam đá, thiết kế thanh lịch.', 6990000.00, 'Seiko Presage SRPB41.jpg', 25, 'Seiko'),
('Seiko Prospex SRP777', 'Đồng hồ lặn chuyên nghiệp với khả năng chống nước 200m.', 7990000.00, 'Seiko Prospex SRP777.jpg', 20, 'Seiko'),
('Seiko Lukia SSVX451', 'Đồng hồ nữ vỏ mỏng, mặt đá, dây kim loại.', 8900000.00, 'Seiko Lukia SSVX451.jpg', 15, 'Seiko'),
('Seiko Astron SSH063', 'Đồng hồ GPS Solar với khả năng tự điều chỉnh múi giờ.', 15990000.00, 'Seiko Astron SSH063.jpg', 10, 'Seiko'),
('Tissot T-Classic T063', 'Đồng hồ dây da với thiết kế cổ điển, phù hợp mọi dịp.', 5990000.00, 'Tissot T-Classic T063.jpg', 30, 'Tissot'),
('Tissot PRC 200 T014', 'Đồng hồ thể thao với mặt số lớn, mặt số phụ chronograph.', 12990000.00, 'Tissot PRC 200 T014.jpg', 20, 'Tissot'),
('Tissot Le Locle T006', 'Đồng hồ tự động với mặt số vân thép, mặt số guilloche.', 8990000.00, 'Tissot Le Locle T006.jpg', 35, 'Tissot'),
('Tissot T-Lady T033', 'Đồng hồ nữ với mặt số nam đá, dây đeo thép không gỉ.', 7990000.00, 'Tissot T-Lady T033.jpg', 30, 'Tissot'),
('Tissot T-Touch Expert', 'Đồng hồ đa chức năng với màn hình cảm ứng.', 19990000.00, 'Tissot T-Touch Expert.jpg', 15, 'Tissot');

-- Bảng giỏ hàng
CREATE TABLE gio_hang (
  id_gio_hang    INT AUTO_INCREMENT PRIMARY KEY,
  id_nguoi_dung  INT NOT NULL,
  ngay_tao       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_nguoi_dung) REFERENCES nguoi_dung(id_nguoi_dung)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Các mặt hàng trong giỏ
CREATE TABLE san_pham_trong_gio (
  id_gio_hang    INT NOT NULL,
  id_san_pham    INT NOT NULL,
  so_luong       INT NOT NULL,
  PRIMARY KEY (id_gio_hang, id_san_pham),
  FOREIGN KEY (id_gio_hang) REFERENCES gio_hang(id_gio_hang) ON DELETE CASCADE,
  FOREIGN KEY (id_san_pham) REFERENCES san_pham(id_san_pham)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bảng đơn hàng
CREATE TABLE don_hang (
  id_don_hang    INT AUTO_INCREMENT PRIMARY KEY,
  id_nguoi_dung  INT NOT NULL,
  ngay_dat       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  trang_thai     VARCHAR(20) NOT NULL,
  tong_tien      DECIMAL(12,2) NOT NULL,
  dia_chi        VARCHAR(255) NOT NULL,
  sdt_nguoi_nhan VARCHAR(15)  NOT NULL,
  FOREIGN KEY (id_nguoi_dung) REFERENCES nguoi_dung(id_nguoi_dung)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Chi tiết sản phẩm trong đơn hàng
CREATE TABLE san_pham_trong_don (
  id_don_hang    INT NOT NULL,
  id_san_pham    INT NOT NULL,
  so_luong       INT NOT NULL,
  don_gia        DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id_don_hang, id_san_pham),
  FOREIGN KEY (id_don_hang) REFERENCES don_hang(id_don_hang) ON DELETE CASCADE,
  FOREIGN KEY (id_san_pham) REFERENCES san_pham(id_san_pham)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bảng đánh giá
CREATE TABLE danh_gia (
  id_danh_gia    INT AUTO_INCREMENT PRIMARY KEY,
  id_san_pham    INT NOT NULL,
  id_nguoi_dung  INT NOT NULL,
  so_sao         INT NOT NULL CHECK (so_sao BETWEEN 1 AND 5),
  noi_dung       TEXT NOT NULL,
  tra_loi        TEXT,
  ngay_danh_gia  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  trang_thai     TINYINT NOT NULL DEFAULT 1 COMMENT '1=hien,0=an',
  FOREIGN KEY (id_san_pham)   REFERENCES san_pham(id_san_pham),
  FOREIGN KEY (id_nguoi_dung) REFERENCES nguoi_dung(id_nguoi_dung)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bảng khiếu nại
CREATE TABLE khieu_nai (
  id_khieu_nai   INT AUTO_INCREMENT PRIMARY KEY,
  id_nguoi_dung  INT NOT NULL,
  id_don_hang    INT,
  noi_dung       TEXT NOT NULL,
  phan_hoi       TEXT,
  trang_thai     VARCHAR(20) NOT NULL DEFAULT 'Dang cho',
  ngay_gui       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  yeu_cau_tra_hang BOOLEAN NOT NULL DEFAULT FALSE,
  FOREIGN KEY (id_nguoi_dung) REFERENCES nguoi_dung(id_nguoi_dung),
  FOREIGN KEY (id_don_hang)   REFERENCES don_hang(id_don_hang)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bảng thông báo
CREATE TABLE thong_bao (
  id_thong_bao   INT AUTO_INCREMENT PRIMARY KEY,
  tieu_de        VARCHAR(150) NOT NULL,
  noi_dung       TEXT NOT NULL,
  ngay_tao       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ngay_ket_thuc  TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bảng báo cáo (doanh số)
CREATE TABLE bao_cao (
  id_bao_cao     INT AUTO_INCREMENT PRIMARY KEY,
  thang          TINYINT NOT NULL,
  nam            SMALLINT NOT NULL,
  tong_doanh_thu DECIMAL(14,2) NOT NULL,
  tong_so_don    INT NOT NULL,
  ngay_tao       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tạo bảng báo cáo sản phẩm
CREATE TABLE bao_cao_san_pham (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_san_pham INT NOT NULL,
    thang TINYINT NOT NULL,
    nam SMALLINT NOT NULL,
    so_luong_da_ban INT DEFAULT 0,
    tong_doanh_thu DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (id_san_pham) REFERENCES san_pham(id_san_pham),
    UNIQUE KEY unique_san_pham_thang_nam (id_san_pham, thang, nam)
);
-- Thêm tài khoản staff và admin
INSERT INTO nguoi_dung (ten_day_du, email, mat_khau, sdt, vai_tro, trang_thai) VALUES
('Staff Account', 'staff@watchstore.com', 'staff123', '0123456789', 'staff', 1),
('Admin Account', 'admin@watchstore.com', 'admin123', '0987654321', 'admin', 1);
