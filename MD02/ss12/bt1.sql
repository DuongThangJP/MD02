CREATE DATABASE ecommerce;
USE ecommerce;
-- 1. Bảng customers (Khách hàng)
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Bảng orders (Đơn hàng)
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) DEFAULT 0,
    status ENUM('Pending', 'Completed', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

-- 3. Bảng products (Sản phẩm)
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Bảng order_items (Chi tiết đơn hàng)
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 5. Bảng inventory (Kho hàng)
CREATE TABLE inventory (
    product_id INT PRIMARY KEY,
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- 6. Bảng payments (Thanh toán)
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('Credit Card', 'PayPal', 'Bank Transfer', 'Cash') NOT NULL,
    status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- Trigger BEFORE INSERT
DELIMITER //
CREATE TRIGGER trg_check_stockquantity
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
DECLARE current_stock INT;
SELECT stock_quantity INTO current_stock
FROM inventory
WHERE product_id = NEW.product_id;

 IF current_stock IS NULL OR current_stock < NEW.quantity THEN
 SIGNAL SQLSTATE '45000'
 SET message_text = 'Số lượng tồn kho không đúng';
END IF;
END //
DELIMITER ;

-- Trigger AFTER INSERT
DELIMITER //
CREATE TRIGGER trg_update_totalamount
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
UPDATE orders SET 
total_amount = total_amount + NEW.quantity * NEW.price
WHERE order_id = NEW.order_id;
END //
DELIMITER ;

-- Trigger BEFORE UPDATE
DELIMITER //
CREATE TRIGGER trg_beforeupdatequantity
BEFORE UPDATE ON order_items
FOR EACH ROW
BEGIN
DECLARE current_stock INT;
SELECT stock_quantity INTO current_stock
FROM inventory
WHERE product_id = NEW.product_id; 

IF current_stock iS NULL OR current_stock < (NEW.quantity - OLD.quantity) THEN
SIGNAL SQLSTATE '45000'
SET message_text = 'Số lượng tồn kho không đủ để cập nhật đơn hàng!';
END IF;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_after_update_order_items
AFTER UPDATE ON order_items
FOR EACH ROW
BEGIN
    IF (NEW.quantity <> OLD.quantity) OR (NEW.price <> OLD.price) THEN
        UPDATE orders
        SET total_amount = total_amount + (NEW.quantity * NEW.price) - (OLD.quantity * OLD.price)
        WHERE order_id = NEW.order_id;
    END IF;
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER trg_prevent_delete_completed_order
BEFORE DELETE ON orders
FOR EACH ROW
BEGIN
    IF OLD.status = 'Completed' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Không thể xóa đơn hàng đã hoàn thành (Completed)!';
    END IF;
END //
DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_restore_stock_after_delete
AFTER DELETE ON order_items
FOR EACH ROW
BEGIN
    UPDATE inventory
    SET stock_quantity = stock_quantity + OLD.quantity
    WHERE product_id = OLD.product_id;
END //

DELIMITER ;

DROP TRIGGER IF EXISTS trg_check_stockquantity;
DROP TRIGGER IF EXISTS trg_update_totalamount;
DROP TRIGGER IF EXISTS trg_beforeupdatequantity;
DROP TRIGGER IF EXISTS trg_after_update_order_items;
DROP TRIGGER IF EXISTS trg_restore_stock_after_delete;

DROP TRIGGER IF EXISTS trg_prevent_delete_completed_order;