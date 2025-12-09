USE watch_store;

####################################################
# 1) Doanh thu theo tháng
#    - Tổng tong_tien của các đơn “Hoàn thành” (trang_thai = 'Hoàn thành') nhóm theo YYYY-MM
####################################################
CREATE OR REPLACE VIEW `DoanhThuTheoThang` AS
SELECT
  DATE_FORMAT(ngay_dat, '%Y-%m') AS Thang,       -- Ví dụ '2024-05'
  SUM(tong_tien)                     AS TongDoanhThu
FROM don_hang
WHERE trang_thai = 'Hoàn thành'
GROUP BY DATE_FORMAT(ngay_dat, '%Y-%m');

####################################################
# 2) Số lượng đơn hàng theo tháng
#    - Đếm số đơn có trang_thai = 'Hoàn thành' theo tháng
####################################################
CREATE OR REPLACE VIEW `SoDonTheoThang` AS
SELECT
  DATE_FORMAT(ngay_dat, '%Y-%m') AS Thang,
  COUNT(*)                        AS SoDonHang
FROM don_hang
WHERE trang_thai = 'Hoàn thành'
GROUP BY DATE_FORMAT(ngay_dat, '%Y-%m');

####################################################
# 3) Số lượng sản phẩm đã bán theo sản phẩm/tháng
#    - Tổng so_luong từ san_pham_trong_don JOIN don_hang (chỉ đơn hoàn thành), nhóm theo tháng + id_san_pham
####################################################
CREATE OR REPLACE VIEW `SanPhamBanTheoThang` AS
SELECT
  DATE_FORMAT(dh.ngay_dat, '%Y-%m')   AS Thang,
  sp.id_san_pham,
  sp.ten_san_pham,
  SUM(ct.so_luong)                     AS TongSoLuongBan
FROM san_pham_trong_don ct
JOIN don_hang dh ON ct.id_don_hang = dh.id_don_hang
JOIN san_pham sp ON ct.id_san_pham = sp.id_san_pham
WHERE dh.trang_thai = 'Hoàn thành'
GROUP BY
  DATE_FORMAT(dh.ngay_dat, '%Y-%m'),
  sp.id_san_pham, sp.ten_san_pham;

####################################################
# 4) Số lượng sản phẩm đã bán theo hãng/tháng
#    - Tổng so_luong nhóm theo tháng + nha_san_xuat
####################################################
CREATE OR REPLACE VIEW `HangBanTheoThang` AS
SELECT
  DATE_FORMAT(dh.ngay_dat, '%Y-%m') AS Thang,
  sp.nha_san_xuat                  AS Hang,
  SUM(ct.so_luong)                 AS TongSoLuongBan
FROM san_pham_trong_don ct
JOIN don_hang dh ON ct.id_don_hang = dh.id_don_hang
JOIN san_pham sp ON ct.id_san_pham = sp.id_san_pham
WHERE dh.trang_thai = 'Hoàn thành'
GROUP BY
  DATE_FORMAT(dh.ngay_dat, '%Y-%m'),
  sp.nha_san_xuat;

####################################################
# 5) Giá trị trung bình đơn hàng (AOV) theo tháng
#    - AOV = Tổng doanh thu / Số đơn hoàn thành trong tháng
####################################################
CREATE OR REPLACE VIEW `AOVTheoThang` AS
SELECT
  dt.Thang,
  ROUND(dt.TongDoanhThu / sd.SoDonHang, 2) AS AOV
FROM DoanhThuTheoThang dt
JOIN SoDonTheoThang sd USING(Thang);

####################################################
# 6) Tỷ lệ hủy đơn theo tháng
#    - Hủy = số đơn trang_thai='Đã hủy' / tổng đơn đặt trong tháng *100
####################################################
CREATE OR REPLACE VIEW `TyLeHuyDonTheoThang` AS
SELECT
  Thang,
  ROUND(100 * SoHuy / TongDat, 2) AS TyLeHuy
FROM (
  SELECT
    DATE_FORMAT(ngay_dat, '%Y-%m')      AS Thang,
    SUM(trang_thai = 'Đã hủy')           AS SoHuy,    -- MySQL treats boolean as 1/0
    COUNT(*)                             AS TongDat
  FROM don_hang
  GROUP BY DATE_FORMAT(ngay_dat, '%Y-%m')
) AS t;

####################################################
# 7) Xếp hạng sản phẩm bán chạy nhất/kém nhất mỗi tháng
#    - Dùng window‐function ROW_NUMBER() để rank DESC/ASC trên tổng so_luong
####################################################
CREATE OR REPLACE VIEW `XepHangSPTheoThang` AS
WITH Sales AS (
  SELECT
    DATE_FORMAT(dh.ngay_dat, '%Y-%m') AS Thang,
    sp.id_san_pham,
    sp.ten_san_pham,
    SUM(ct.so_luong)                 AS TongSoLuong
  FROM san_pham_trong_don ct
  JOIN don_hang dh ON ct.id_don_hang = dh.id_don_hang
  JOIN san_pham sp ON ct.id_san_pham = sp.id_san_pham
  WHERE dh.trang_thai = 'Hoàn thành'
  GROUP BY DATE_FORMAT(dh.ngay_dat, '%Y-%m'), sp.id_san_pham, sp.ten_san_pham
)
SELECT
  Thang,
  id_san_pham,
  ten_san_pham,
  TongSoLuong,
  ROW_NUMBER() OVER (PARTITION BY Thang ORDER BY TongSoLuong DESC) AS Rank_CaoNhat,
  ROW_NUMBER() OVER (PARTITION BY Thang ORDER BY TongSoLuong ASC ) AS Rank_ThapNhat
FROM Sales;

####################################################
# 8) Tỷ lệ khách quay lại theo tháng
#    - Khách có >=2 đơn trong tháng / tổng khách mua hàng tháng đó *100
####################################################
CREATE OR REPLACE VIEW `TyLeKhachQuayLaiTheoThang` AS
WITH CustMonthly AS (
  SELECT
    DATE_FORMAT(ngay_dat, '%Y-%m') AS Thang,
    id_nguoi_dung,
    COUNT(*)                     AS SoDon
  FROM don_hang
  GROUP BY DATE_FORMAT(ngay_dat, '%Y-%m'), id_nguoi_dung
),
Stats AS (
  SELECT
    Thang,
    COUNT(*)                 AS TongKhach,
    SUM(SoDon >= 2)          AS KhachQuayLai
  FROM CustMonthly
  GROUP BY Thang
)
SELECT
  Thang,
  ROUND(100 * KhachQuayLai / TongKhach, 2) AS TyLeQuayLai
FROM Stats;

####################################################
# 9) Doanh thu trung bình theo khách hàng (CLV) theo tháng
#    - CLV = Tổng doanh thu / số khách hàng có đơn trong tháng
####################################################
CREATE OR REPLACE VIEW `CLVTheoThang` AS
WITH Rev AS (
  SELECT
    DATE_FORMAT(ngay_dat, '%Y-%m') AS Thang,
    SUM(tong_tien)               AS TongDoanhThu
  FROM don_hang
  WHERE trang_thai = 'Hoàn thành'
  GROUP BY DATE_FORMAT(ngay_dat, '%Y-%m')
),
Cust AS (
  SELECT
    DATE_FORMAT(ngay_dat, '%Y-%m') AS Thang,
    COUNT(DISTINCT id_nguoi_dung) AS SoKhach
  FROM don_hang
  GROUP BY DATE_FORMAT(ngay_dat, '%Y-%m')
)
SELECT
  r.Thang,
  ROUND(r.TongDoanhThu / c.SoKhach, 2) AS CLV
FROM Rev r
JOIN Cust c USING(Thang);
