USE session_8;

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    total_amount DECIMAL(12, 2) NOT NULL
);


DELIMITER //
CREATE PROCEDURE sp_check_order_value(
    IN p_total_amount DECIMAL(12, 2)
)
BEGIN
    IF p_total_amount >= 5000000 THEN
        SELECT 'Đơn hàng giá trị cao' AS order_status;
    ELSE
        SELECT 'Đơn hàng bình thường' AS order_status;
    END IF;
END //
DELIMITER ;


CALL sp_check_order_value(6500000);
CALL sp_check_order_value(3200000);