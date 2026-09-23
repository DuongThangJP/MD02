CREATE DATABASE session_7;

USE session_7;

CREATE TABLE students (
    student_id VARCHAR(20) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    birth_year INT,
    class_name VARCHAR(50) NOT NULL,
    address VARCHAR(255)
)

CREATE VIEW v_student_basic AS
SELECT 
    student_id,
    full_name,
    class_name
FROM students;

SELECT * FROM v_student_basic;