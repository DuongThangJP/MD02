CREATE DATABASE session_9;
USE session_9;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    address VARCHAR(255) NOT NULL
);

CREATE UNIQUE INDEX index_unique_email ON customers(email);

CREATE INDEX index_phone ON customers(phone);