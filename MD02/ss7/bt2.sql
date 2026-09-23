USE session_7;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL
) 

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE VIEW v_order_info AS
SELECT 
o.order_id,
o.order_date,
c.customer_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

SELECT * FROM v_order_info;