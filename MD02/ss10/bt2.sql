CREATE DATABASE InventoryManagement;
USE InventoryManagement;

CREATE TABLE Products (
productID INT PRIMARY KEY AUTO_INCREMENT, 
productName varchar(100), 
quantity int);

CREATE TABLE inventoryChanges (
changeID int PRIMARY KEY AUTO_INCREMENT, 
productID int NOT NULL, 
oldQuantity int, 
newQuantity int, 
changeDate datetime,
CONSTRAINT fk_products_inventoryChanges
FOREIGN KEY (productID) REFERENCES Products(productID)
) ;


DELIMITER $$
CREATE TRIGGER AfterProductUpdate
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
	IF OLD.quantity <> NEW.quantity THEN
    INSERT INTO inventoryChanges (ProductID, oldQuantity, newQuantity, changeDate)
    VALUES (NEW.productID, OLD.quantity, NEW.quantity,NOW());
END IF;
END $$
DELIMITER ;

DELIMITER //
CREATE TRIGGER BeforeProductDelete
BEFORE DELETE ON Products
FOR EACH ROW
BEGIN
	IF OLD.quantity > 10 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Lỗi: Không thể xóa sản phẩm có số lượng lớn hơn 10';
END IF;
END //
DELIMITER ;

INSERT INTO Products (productID, productName, quantity) 
VALUES 
(1, 'Sản phẩm A', 15),
(2, 'Sản phẩm B', 5);

DELETE FROM Products WHERE productID = 1;
DELETE FROM Products WHERE productID = 2;