CREATE TABLE employees (
emp_id VARCHAR(20) PRIMARY KEY,
full_name VARCHAR(50) NOT NULL,
department VARCHAR(50),
salary DECIMAL(12, 2) 
);

INSERT INTO employees (emp_id, full_name, department, salary) VALUES
('NV01', 'Nguyễn Văn An', 'Công nghệ thông tin', 15000000),
('NV02', 'Trần Thị Bích', 'Công nghệ thông tin', 18000000),
('NV03', 'Lê Hoàng Cường', 'Công nghệ thông tin', 12000000),
('NV04', 'Phạm Minh Đức', 'Công nghệ thông tin', 20000000),
('NV05', 'Hoàng Thùy Dung', 'Kế toán', 10000000),
('NV06', 'Đỗ Văn Em', 'Kế toán', 11000000),
('NV07', 'Vũ Thị Giang', 'Nhân sự', 13000000),
('NV08', 'Bùi Hữu Hạnh', 'Nhân sự', 9000000);

SELECT * FROM employees;

SELECT department,
COUNT(emp_id) AS total_employees
FROM employees 
GROUP BY department;

SELECT department,
AVG(salary) AS avg_salary
FROM employees
GROUP BY department;

SELECT department,
COUNT(emp_id) AS total_employees
FROM employees 
GROUP BY department
HAVING COUNT(emp_id) >3;

SELECT department,
AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 12000000;