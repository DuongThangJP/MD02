CREATE DATABASE session_10;
USE session_10;

CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    salary DECIMAL(10, 2),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(15)
);


CREATE TABLE salary_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    old_salary DECIMAL(10, 2),
    new_salary DECIMAL(10, 2),
    change_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);

INSERT INTO employees (first_name, last_name, salary, email, phone_number) VALUES
('Van A', 'Nguyen', 15000000.00, 'nguyenvana@gmail.com', '0901234567'),
('Thi B', 'Tran', 12000000.00, 'tranthib@gmail.com', '0912345678'),
('Van C', 'Le', 18000000.00, 'levanc@gmail.com', '0923456789'),
('Thi D', 'Pham', 9500000.00, 'phamthid@gmail.com', '0934567890'),
('Hoang E', 'Hoang', 22000000.00, 'hoanghoange@gmail.com', '0945678901'),
('Thanh F', 'Vu', 11000000.00, 'vuthanhf@gmail.com', '0956789012'),
('Minh G', 'Dang', 13500000.00, 'dangminhg@gmail.com', '0967890123'),
('Thuy H', 'Bui', 16000000.00, 'buithuyh@gmail.com', '0978901234'),
('Quang I', 'Dinh', 20000000.00, 'dinhquangi@gmail.com', '0989012345'),
('Duc K', 'Do', 8500000.00, 'doduck@gmail.com', '0990123456');

DELIMITER //
CREATE TRIGGER trg_after_update_salary
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
	IF OLD.salary <> NEW.salary THEN
	INSERT INTO salary_log (employee_id, old_salary, new_salary, change_date)
	VALUES (NEW.id, OLD.salary, NEW.salary, NOW());
END IF;
END //
DELIMITER ;

UPDATE employees 
SET salary = 17500000.00 
WHERE id = 1;


SELECT * FROM salary_log;
SELECT * FROM employees;