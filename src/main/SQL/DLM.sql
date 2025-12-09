USE watch_store;
SET SQL_SAFE_UPDATES = 0;

-- 0) XÓA SẠCH DỮ LIỆU CŨ (giữ lại 2 tài khoản staff/admin)
DELETE FROM khieu_nai;
DELETE FROM danh_gia;
DELETE FROM san_pham_trong_don;
DELETE FROM don_hang;
DELETE FROM san_pham_trong_gio;
DELETE FROM gio_hang;
DELETE FROM nguoi_dung WHERE vai_tro = 'customer';

-- Reset AUTO_INCREMENT để customer mới bắt đầu từ id=3
ALTER TABLE nguoi_dung    AUTO_INCREMENT = 3;
ALTER TABLE gio_hang      AUTO_INCREMENT = 1;
ALTER TABLE don_hang      AUTO_INCREMENT = 1;
ALTER TABLE khieu_nai     AUTO_INCREMENT = 1;
ALTER TABLE danh_gia      AUTO_INCREMENT = 1;

-- 1) Sinh 50 khách hàng (id 3–52)
DROP PROCEDURE IF EXISTS gen_customers;
DELIMITER $$
CREATE PROCEDURE gen_customers()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 50 DO
    INSERT INTO nguoi_dung (ten_day_du,email,mat_khau,sdt,vai_tro,trang_thai)
    VALUES (
      CONCAT('KH ', LPAD(i,2,'0')),
      CONCAT('kh',i,'@example.com'),
      'password',
      CONCAT('09', LPAD(FLOOR(RAND()*100000000),8,'0')),
      'customer',
      1
    );
    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;
CALL gen_customers();
DROP PROCEDURE gen_customers;

-- 2) Sinh 500 đơn hàng trải đều ngẫu nhiên mỗi tháng
DROP PROCEDURE IF EXISTS gen_orders;
DELIMITER $$
CREATE PROCEDURE gen_orders()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE cust_id INT;
  DECLARE ord_date DATETIME;
  DECLARE stt VARCHAR(20);
  DECLARE total DECIMAL(12,2);
  WHILE i <= 500 DO
    -- random existing customer
    SELECT id_nguoi_dung
    INTO cust_id
    FROM nguoi_dung
    WHERE vai_tro='customer'
    ORDER BY RAND()
    LIMIT 1;

    -- random timestamp between 2024-01-01 and now
    SET ord_date = CONCAT(
      DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND()*DATEDIFF(CURDATE(),'2024-01-01')) DAY),
      ' ',
      SEC_TO_TIME(FLOOR(RAND()*86400))
    );

    SET stt = ELT(FLOOR(RAND()*3)+1,'Hoàn thành','Đang xử lý','Đã hủy');

    INSERT INTO don_hang (id_nguoi_dung,ngay_dat,trang_thai,tong_tien,dia_chi,sdt_nguoi_nhan)
    VALUES (
      cust_id,
      ord_date,
      stt,
      0,
      CONCAT('DC ',cust_id),
      CONCAT('09',LPAD(FLOOR(RAND()*100000000),8,'0'))
    );
    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;
CALL gen_orders();
DROP PROCEDURE gen_orders;

-- 3) Sinh chi tiết đơn và cập nhật tổng tiền
DROP PROCEDURE IF EXISTS gen_order_items;
DELIMITER $$
CREATE PROCEDURE gen_order_items()
BEGIN
  DECLARE max_o INT;
  DECLARE oid INT DEFAULT 1;
  DECLARE n_items INT;
  -- xác định max order
  SELECT MAX(id_don_hang) INTO max_o FROM don_hang;
  WHILE oid <= max_o DO
    -- chèn 1–4 sản phẩm cho mỗi đơn
    SET n_items = FLOOR(1+RAND()*4);
    REPEAT
      INSERT INTO san_pham_trong_don (id_don_hang,id_san_pham,so_luong,don_gia)
      SELECT
        oid,
        sp.id_san_pham,
        FLOOR(1+RAND()*5),
        sp.gia
      FROM san_pham AS sp
      ORDER BY RAND()
      LIMIT 1
      ON DUPLICATE KEY UPDATE
        so_luong = so_luong + VALUES(so_luong);
      SET n_items = n_items - 1;
    UNTIL n_items = 0 END REPEAT;

    -- cập nhật tổng tiền
    UPDATE don_hang dh
    JOIN (
      SELECT id_don_hang, SUM(so_luong*don_gia) AS total
      FROM san_pham_trong_don
      WHERE id_don_hang = oid
      GROUP BY id_don_hang
    ) t ON t.id_don_hang = dh.id_don_hang
    SET dh.tong_tien = t.total;

    SET oid = oid + 1;
  END WHILE;
END$$
DELIMITER ;
CALL gen_order_items();
DROP PROCEDURE gen_order_items;

-- 4) Sinh 100 đánh giá ngẫu nhiên, kèm ngày giờ
DROP PROCEDURE IF EXISTS gen_reviews;
DELIMITER $$
CREATE PROCEDURE gen_reviews()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE cust_id INT;
  DECLARE prod_id INT;
  DECLARE stars INT;
  DECLARE comment TEXT;
  DECLARE dt DATETIME;
  WHILE i <= 100 DO
    -- Lấy ngẫu nhiên 1 customer
    SELECT id_nguoi_dung 
    INTO cust_id
    FROM nguoi_dung
    WHERE vai_tro='customer'
    ORDER BY RAND()
    LIMIT 1;
    -- Lấy ngẫu nhiên 1 product
    SELECT id_san_pham 
    INTO prod_id
    FROM san_pham
    ORDER BY RAND()
    LIMIT 1;
    SET stars = FLOOR(1 + RAND()*5);
    SET comment = CONCAT('Bình luận mẫu #', LPAD(i,3,'0'));
    SET dt = CONCAT(
      DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND()*DATEDIFF(CURDATE(),'2024-01-01')) DAY),
      ' ', SEC_TO_TIME(FLOOR(RAND()*86400))
    );
    INSERT INTO danh_gia (id_san_pham, id_nguoi_dung, so_sao, noi_dung, ngay_danh_gia)
    VALUES (prod_id, cust_id, stars, comment, dt);
    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;
CALL gen_reviews();
DROP PROCEDURE gen_reviews;

-- 5) Procedure sinh 20 khiếu nại ngẫu nhiên an toàn
DROP PROCEDURE IF EXISTS gen_complaints;
DELIMITER $$
CREATE PROCEDURE gen_complaints()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE cust_id INT;
  DECLARE order_id INT;
  DECLARE text TEXT;
  DECLARE refund TINYINT;
  DECLARE dt DATETIME;
  WHILE i <= 20 DO
    SELECT id_nguoi_dung 
    INTO cust_id
    FROM nguoi_dung
    WHERE vai_tro='customer'
    ORDER BY RAND()
    LIMIT 1;
    SELECT id_don_hang 
    INTO order_id
    FROM don_hang
    ORDER BY RAND()
    LIMIT 1;
    SET text = CONCAT('Khiếu nại mẫu #', LPAD(i,2,'0'));
    SET refund = IF(RAND()<0.3,1,0);
    SET dt = CONCAT(
      DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND()*DATEDIFF(CURDATE(),'2024-01-01')) DAY),
      ' ', SEC_TO_TIME(FLOOR(RAND()*86400))
    );
    INSERT INTO khieu_nai (id_nguoi_dung, id_don_hang, noi_dung, yeu_cau_tra_hang, ngay_gui)
    VALUES (cust_id, order_id, text, refund, dt);
    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;
CALL gen_complaints();
DROP PROCEDURE gen_complaints;

SET SQL_SAFE_UPDATES = 1;
