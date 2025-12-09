USE watch_store;

-- Tắt chế độ safe update mode
SET SQL_SAFE_UPDATES = 0;


-- Xóa trigger cũ nếu tồn tại
DROP TRIGGER IF EXISTS after_order_completed;
DROP TRIGGER IF EXISTS after_order_detail_completed;

-- Trigger cập nhật báo cáo khi đơn hàng hoàn thành
DELIMITER //
CREATE TRIGGER after_order_completed
AFTER UPDATE ON don_hang
FOR EACH ROW
BEGIN
    DECLARE current_month TINYINT;
    DECLARE current_year SMALLINT;
    
    IF (NEW.trang_thai = 'Hoan thanh' OR NEW.trang_thai = 'HoÃ n thÃ nh') 
       AND (OLD.trang_thai != 'Hoan thanh' AND OLD.trang_thai != 'HoÃ n thÃ nh' OR OLD.trang_thai IS NULL) THEN
        -- Lấy tháng và năm hiện tại
        SET current_month = MONTH(NEW.ngay_dat);
        SET current_year = YEAR(NEW.ngay_dat);
        
        -- Kiểm tra xem đã có báo cáo cho tháng này chưa
        IF EXISTS (SELECT 1 FROM bao_cao WHERE thang = current_month AND nam = current_year) THEN
            -- Cập nhật báo cáo hiện có
            UPDATE bao_cao 
            SET tong_doanh_thu = tong_doanh_thu + NEW.tong_tien,
                tong_so_don = tong_so_don + 1
            WHERE thang = current_month AND nam = current_year;
        ELSE
            -- Tạo báo cáo mới
            INSERT INTO bao_cao (thang, nam, tong_doanh_thu, tong_so_don)
            VALUES (current_month, current_year, NEW.tong_tien, 1);
        END IF;
    END IF;
END //
DELIMITER ;

-- Trigger cập nhật báo cáo sản phẩm khi đơn hàng hoàn thành
DELIMITER //
CREATE TRIGGER after_order_detail_completed
AFTER UPDATE ON don_hang
FOR EACH ROW
BEGIN
    DECLARE current_month TINYINT;
    DECLARE current_year SMALLINT;
    
    IF (NEW.trang_thai = 'Hoan thanh' OR NEW.trang_thai = 'HoÃ n thÃ nh') 
       AND (OLD.trang_thai != 'Hoan thanh' AND OLD.trang_thai != 'HoÃ n thÃ nh' OR OLD.trang_thai IS NULL) THEN
        -- Lấy tháng và năm hiện tại
        SET current_month = MONTH(NEW.ngay_dat);
        SET current_year = YEAR(NEW.ngay_dat);
        
        -- Cập nhật báo cáo cho từng sản phẩm trong đơn hàng
        INSERT INTO bao_cao_san_pham (id_san_pham, thang, nam, so_luong_da_ban, tong_doanh_thu)
        SELECT 
            spd.id_san_pham,
            current_month,
            current_year,
            spd.so_luong,
            spd.so_luong * spd.don_gia
        FROM san_pham_trong_don spd
        WHERE spd.id_don_hang = NEW.id_don_hang
        ON DUPLICATE KEY UPDATE
            so_luong_da_ban = so_luong_da_ban + VALUES(so_luong_da_ban),
            tong_doanh_thu = tong_doanh_thu + VALUES(tong_doanh_thu);
    END IF;
END //
DELIMITER ;

-- Thêm dữ liệu mẫu cho báo cáo nếu chưa có
INSERT INTO bao_cao (thang, nam, tong_doanh_thu, tong_so_don)
SELECT MONTH(CURRENT_DATE), YEAR(CURRENT_DATE), 0, 0
WHERE NOT EXISTS (
    SELECT 1 FROM bao_cao 
    WHERE thang = MONTH(CURRENT_DATE) 
    AND nam = YEAR(CURRENT_DATE)
);

-- Xóa dữ liệu cũ theo thứ tự để tránh vi phạm ràng buộc khóa ngoại
DELETE FROM bao_cao_san_pham;
DELETE FROM san_pham_trong_don;
DELETE FROM san_pham_trong_gio;
DELETE FROM danh_gia;
DELETE FROM san_pham;

-- Bật lại chế độ safe update mode
SET SQL_SAFE_UPDATES = 1;