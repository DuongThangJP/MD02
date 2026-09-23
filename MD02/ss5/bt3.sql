CREATE TABLE products (
product_id VARCHAR(20) PRIMARY KEY,
product_name VARCHAR(100) NOT NULL,
category VARCHAR(50),
price DECIMAL(15,2)
);

INSERT INTO products (product_id, product_name, category, price) VALUES
('P01', 'iPhone 15 Pro', 'Điện thoại', 28000000),
('P02', 'Samsung Galaxy A54', 'Điện thoại', 8000000),
('P03', 'MacBook Air M2', 'Laptop', 26000000),
('P04', 'Dell Inspiron 15', 'Laptop', 15000000),
('P05', 'Chuột Logitech G102', 'Phụ kiện', 400000),
('P06', 'Bàn phím Akko', 'Phụ kiện', 1500000);

SELECT * FROM products;

SELECT product_id,
product_name,
category,
price
FROM products
WHERE price > (SELECT AVG(price) FROM products);

SELECT product_id,
product_name,
category,
price
FROM products AS p
WHERE price = (
SELECT MAX(price) 
FROM products
WHERE category = p.category
);

SELECT product_id,
product_name,
category,
price
FROM products
WHERE category IN (
SELECT DISTINCT category
FROM products
WHERE price > 20000000);