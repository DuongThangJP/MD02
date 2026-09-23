CREATE TABLE Customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL
);

CREATE TABLE Orders (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(20),
    customer_id VARCHAR(20),
    product_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Customers (customer_id, customer_name) VALUES
('C01', 'Nguyễn Văn An'),
('C02', 'Trần Thị Bích'),
('C03', 'Lê Hoàng Cường');

INSERT INTO Orders (order_id, order_date, customer_id) VALUES
('ORD01', '2024-03-01', 'C01'),
('ORD02', '2024-03-02', 'C02'),
('ORD03', '2024-03-03', 'C01');

INSERT INTO Order_items (order_id, customer_id, product_name, quantity, price) VALUES
('ORD01', 'C01', 'iPhone 15 Pro', 1, 28000000),
('ORD01', 'C01', 'Ốp lưng iPhone', 2, 250000),
('ORD02', 'C02', 'Tai nghe Bluetooth', 1, 1500000),
('ORD02', 'C02', 'Sạc dự phòng', 1, 800000),
('ORD03', 'C03', 'Laptop Dell Inspiron', 1, 15000000);

SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM Order_items;

SELECT 
o.order_id, 
o.order_date, 
c.customer_name
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;

SELECT 
oi.order_id,
o.order_date,
oi.product_name,
oi.quantity,
oi.price
FROM Order_items oi
JOIN Orders o ON oi.order_id = o.order_id;

SELECT 
    o.order_id,
    o.order_date,
    c.customer_name,
    SUM(oi.quantity * oi.price) AS total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_date, c.customer_name;

SELECT 
    o.order_id,
    o.order_date,
    c.customer_name,
    SUM(oi.quantity * oi.price) AS total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_date, c.customer_name
HAVING SUM(oi.quantity * oi.price) > 10000000;