USE session_8;

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50) NOT NULL
);


DELIMITER //
CREATE PROCEDURE sp_get_products_by_category (
    IN p_category VARCHAR(50)
)
BEGIN
    SELECT 
        product_id,
        product_name,
        price,
        category
    FROM products
    WHERE category = p_category;
END //
DELIMITER ;

CALL sp_get_products_by_category('Điện thoại');