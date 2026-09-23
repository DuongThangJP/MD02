CREATE DATABASE student_manage_database;

USE student_manage_database;

CREATE TABLE students (
student_id VARCHAR(10) PRIMARY KEY,
full_name VARCHAR(100) NOT NULL,
birth_date DATE,
gender ENUM("male", "female", "other") NOT NULL,
email VARCHAR(100)
);

SELECT * FROM student_manage_database.students;

INSERT INTO students (student_id, full_name, birth_date, gender, email)
VALUES 
('SV001', 'Nguyễn Văn A', '2000-01-20', 'male', 'nguyenvana@gmail.com'),
('SV002', 'Nguyễn Thị B','2003-02-01', 'female', 'nguyenthib@gmail.com'),
('SV003', 'Nguyễn Văn C','1998-08-15', 'other', NULL),
('SV004', 'Lê Hoàng D','2002-06-25', 'male', 'lehoangd@gmail.com'),
('SV005', 'Võ Thị E','2005-08-18', 'male', 'vothie@gmail.com');

SELECT * FROM student_manage_database.students;

SELECT student_id, full_name, email 
FROM students;