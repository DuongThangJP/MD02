USE ddl_sql;

CREATE TABLE products (
product_id VARCHAR(10) PRIMARY KEY,
product_name VARCHAR(150) NOT NULL,
price INT NOT NULL,
stock INT NOT NULL
);