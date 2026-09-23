CREATE DATABASE BRSE_PTON_NI260527_THANG;
USE BRSE_PTON_NI260527_THANG;

CREATE TABLE BenhNhan (
 benhnhan_id VARCHAR(10) PRIMARY KEY NOT NULL,
 ho_ten VARCHAR(100) NOT NULL,
 email VARCHAR(100) NOT NULL UNIQUE,
 so_dien_thoai VARCHAR(15) NOT NULL,
 dia_chi VARCHAR(200)
);

CREATE TABLE DichVu (
 dichvu_id VARCHAR(10) PRIMARY KEY NOT NULL,
 ten_dich_vu VARCHAR(150) NOT NULL UNIQUE,
 gia_dich_vu DECIMAL(12,2) NOT NULL CHECK (gia_dich_vu > 0),
 trang_thai VARCHAR(50) DEFAULT 'Hoạt động',
 thoi_gian_uoc_tinh INT NOT NULL COMMENT 'phut'
);

CREATE TABLE PhieuKham (
 phieukham_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
 benhnhan_id VARCHAR(10) NOT NULL,
 dichvu_id VARCHAR(10) NOT NULL,
 ngay_kham DATE NOT NULL,
 ngay_tai_kham DATE,
 tong_tien DECIMAL(12,2) DEFAULT 0,
    
CONSTRAINT ｆｋ_refs_BenhNhan
FOREIGN KEY (benhnhan_id) REFERENCES BenhNhan(benhnhan_id),
CONSTRAINT fk_refs_DichVu
FOREIGN KEY (dichvu_id) REFERENCES DichVu(dichvu_id)
);

CREATE TABLE HoaDon (
 hoadon_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
 phieukham_id INT NOT NULL,
 phuong_thuc_tt VARCHAR(50) NOT NULL,
 ngay_tt DATE NOT NULL,
 so_tien_tt DECIMAL(12,2) NOT NULL CHECK (so_tien_tt > 0),    
CONSTRAINT refs_PhieuKham
FOREIGN KEY (phieukham_id) REFERENCES PhieuKham(phieukham_id)
);
INSERT INTO BenhNhan (benhnhan_id, ho_ten, email, so_dien_thoai, dia_chi) VALUES
('BN001', 'Nguyen Anh Tu', 'tu.nguyen@example.com', '0912345678', 'Hanoi, Vietnam'),
('BN002', 'Tran Thi Mai', 'mai.tran@example.com', '0923456789', 'Ho Chi Minh, Vietnam'),
('BN003', 'Le Minh Hoang', 'hoang.le@example.com', '0934567890', 'Danang, Vietnam'),
('BN004', 'Pham Hoàng Nam', 'nam.pham@example.com', '0945678901', 'Hue, Vietnam'),
('BN005', 'Vu Minh Thu', 'thu.vu@example.com', '0956789012', 'Hai Phong, Vietnam'),
('BN006', 'Nguyen Thi Lan', 'lan.nguyen@example.com', '0967890123', 'Quang Ninh, Vietnam'),
('BN007', 'Bui Minh Tuan', 'tuan.bui@example.com', '0978901234', 'Bac Giang, Vietnam'),
('BN008', 'Pham Quang Hieu', 'hieu.pham@example.com', '0989012345', 'Quang Nam, Vietnam');

INSERT INTO DichVu (dichvu_id, ten_dich_vu, gia_dich_vu, trang_thai, thoi_gian_uoc_tinh) VALUES
('DV001', 'Khám tổng quát', 200.0, 'Hoạt động', 30),
('DV002', 'Chụp X-Quang', 150.0, 'Tạm ngưng', 15),
('DV003', 'Xét nghiệm máu', 300.0, 'Hoạt động', 20),
('DV004', 'Siêu âm 4D', 400.0, 'Hoạt động', 45),
('DV005', 'Khám chuyên khoa', 250.0, 'Hoạt động', 30),
('DV006', 'Nội soi dạ dày', 500.0, 'Hoạt động', 60),
('DV007', 'Khám mắt', 150.0, 'Hoạt động', 20),
('DV008', 'Khám tai mũi họng', 200.0, 'Tạm ngưng', 25);

INSERT INTO PhieuKham (benhnhan_id, dichvu_id, ngay_kham, ngay_tai_kham, tong_tien) VALUES
('BN001', 'DV001', '2026-09-01', '2026-09-10', 200.0),
('BN002', 'DV002', '2026-09-02', '2026-09-11', 150.0),
('BN003', 'DV003', '2026-09-03', '2026-09-12', 300.0),
('BN004', 'DV004', '2026-09-04', '2026-09-13', 400.0),
('BN005', 'DV005', '2026-09-05', '2026-09-14', 250.0),
('BN006', 'DV006', '2026-09-06', '2026-09-15', 500.0),
('BN007', 'DV007', '2026-09-07', '2026-09-16', 150.0),
('BN008', 'DV008', '2026-09-08', '2026-09-17', 200.0);


INSERT INTO HoaDon (phieukham_id, phuong_thuc_tt, ngay_tt, so_tien_tt) VALUES
(1, 'Cash', '2026-09-01', 200.0),
(2, 'Credit Card', '2026-09-02', 150.0),
(3, 'Bank Transfer', '2026-09-03', 300.0),
(4, 'Cash', '2026-09-04', 400.0),
(5, 'Credit Card', '2026-09-05', 250.0),
(6, 'Bank Transfer', '2026-09-06', 500.0),
(7, 'Cash', '2026-09-07', 150.0),
(8, 'Credit Card', '2026-09-08', 200.0);

UPDATE PhieuKham
 JOIN DichVu ON PhieuKham.dichvu_id = DichVu.dichvu_id
 SET PhieuKham.tong_tien = DichVu.gia_dich_vu + 50.0
 WHERE DichVu.trang_thai = 'Hoạt động'
 AND PhieuKham.ngay_kham < CURDATE();
  
DELETE FROM HoaDon
 WHERE phuong_thuc_tt = 'Cash'
 AND so_tien_tt < 200.0;
  
SELECT benhnhan_id, ho_ten, email, so_dien_thoai, dia_chi
 FROM BenhNhan
 ORDER BY ho_ten ASC;

SELECT dichvu_id, ten_dich_vu, gia_dich_vu, thoi_gian_uoc_tinh
 FROM DichVu
 ORDER BY gia_dich_vu DESC;

SELECT bn.benhnhan_id, bn.ho_ten, pk.dichvu_id, pk.ngay_kham, pk.ngay_tai_kham
FROM BenhNhan bn, PhieuKham pk
WHERE bn.benhnhan_id = pk.benhnhan_id;

SELECT bn.benhnhan_id, bn.ho_ten, hd.phuong_thuc_tt, hd.so_tien_tt
FROM BenhNhan bn, PhieuKham pk, HoaDon hd
WHERE bn.benhnhan_id = pk.benhnhan_id
  AND pk.phieukham_id = hd.phieukham_id
ORDER BY hd.so_tien_tt DESC;

SELECT benhnhan_id, ho_ten, email, so_dien_thoai, dia_chi
 FROM BenhNhan
 ORDER BY ho_ten ASC
 LIMIT 3 OFFSET 1;

SELECT bn.benhnhan_id, bn.ho_ten, COUNT(pk.phieukham_id) AS so_luong_phieu
 FROM BenhNhan bn
 JOIN PhieuKham pk ON bn.benhnhan_id = pk.benhnhan_id
 JOIN HoaDon hd ON pk.phieukham_id = hd.phieukham_id
 GROUP BY bn.benhnhan_id, bn.ho_ten
 HAVING COUNT(pk.phieukham_id) >= 2 AND SUM(hd.so_tien_tt) > 500.0;

SELECT dv.dichvu_id, dv.ten_dich_vu, dv.gia_dich_vu, SUM(hd.so_tien_tt) AS tong_tien
 FROM DichVu dv
 JOIN PhieuKham pk ON dv.dichvu_id = pk.dichvu_id
 JOIN HoaDon hd ON pk.phieukham_id = hd.phieukham_id
 GROUP BY dv.dichvu_id, dv.ten_dich_vu, dv.gia_dich_vu
 HAVING SUM(hd.so_tien_tt) < 1000.0 AND COUNT(DISTINCT pk.benhnhan_id) >= 3;

SELECT bn.benhnhan_id, bn.ho_ten, pk.dichvu_id, SUM(hd.so_tien_tt) AS tong_tien
 FROM BenhNhan bn
 JOIN PhieuKham pk ON bn.benhnhan_id = pk.benhnhan_id
 JOIN HoaDon hd ON pk.phieukham_id = hd.phieukham_id
 GROUP BY bn.benhnhan_id, bn.ho_ten, pk.dichvu_id
 HAVING SUM(hd.so_tien_tt) > 500.0;

SELECT benhnhan_id, ho_ten, email, so_dien_thoai
 FROM BenhNhan
 WHERE ho_ten LIKE '%Minh%'
 OR dia_chi LIKE '%Hanoi%'
 ORDER BY ho_ten ASC;

SELECT dichvu_id, ten_dich_vu, gia_dich_vu
 FROM DichVu
 ORDER BY gia_dich_vu DESC
 LIMIT 2 OFFSET 2;

CREATE VIEW View_DichVu_BenhNhan AS
SELECT DichVu.dichvu_id, DichVu.ten_dich_vu, BenhNhan.benhnhan_id, BenhNhan.ho_ten
FROM PhieuKham
JOIN DichVu ON PhieuKham.dichvu_id = DichVu.dichvu_id
JOIN BenhNhan ON PhieuKham.benhnhan_id = BenhNhan.benhnhan_id
WHERE PhieuKham.ngay_kham < '2026-09-08';

CREATE VIEW View_BenhNhan_PhieuKham AS
SELECT BenhNhan.benhnhan_id, BenhNhan.ho_ten, DichVu.dichvu_id, DichVu.gia_dich_vu
FROM PhieuKham
JOIN BenhNhan ON PhieuKham.benhnhan_id = BenhNhan.benhnhan_id
JOIN DichVu ON PhieuKham.dichvu_id = DichVu.dichvu_id
WHERE DichVu.gia_dich_vu > 200.0;

DELIMITER $$

CREATE TRIGGER check_insert_phieukham
BEFORE INSERT ON PhieuKham
FOR EACH ROW
BEGIN
 IF NEW.ngay_tai_kham IS NOT NULL AND NEW.ngay_tai_kham < NEW.ngay_kham THEN
 SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'Ngày tái khám không thể trước ngày khám bệnh được !';
 END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER update_dichvu_status_on_booking
AFTER INSERT ON PhieuKham
FOR EACH ROW
BEGIN
    DECLARE so_luong INT;
    SELECT COUNT(*) INTO so_luong
    FROM PhieuKham
    WHERE dichvu_id = NEW.dichvu_id
    AND ngay_kham = NEW.ngay_kham;
    IF so_luong > 50 THEN
    UPDATE DichVu
    SET trang_thai = 'Tạm ngưng'
    WHERE dichvu_id = NEW.dichvu_id;
  END IF;
END $$
DELIMITER ;

DELIMITER $$

CREATE PROCEDURE add_benhnhan(
    IN p_benhnhan_id VARCHAR(10),
    IN p_ho_ten VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_so_dien_thoai VARCHAR(15),
    IN p_dia_chi VARCHAR(200)
)
BEGIN
    INSERT INTO BenhNhan (benhnhan_id, ho_ten, email, so_dien_thoai, dia_chi)
    VALUES (p_benhnhan_id, p_ho_ten, p_email, p_so_dien_thoai, p_dia_chi);
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE add_hoadon(
    IN p_phieukham_id INT,
    IN p_phuong_thuc_tt VARCHAR(50),
    IN p_so_tien_tt DECIMAL(12,2),
    IN p_ngay_tt DATE
)
BEGIN
    INSERT INTO HoaDon (phieukham_id, phuong_thuc_tt, so_tien_tt, ngay_tt)
    VALUES (p_phieukham_id, p_phuong_thuc_tt, p_so_tien_tt, p_ngay_tt);
END $$

DELIMITER ;