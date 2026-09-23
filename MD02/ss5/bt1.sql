CREATE TABLE students (
student_id VARCHAR(10) PRIMARY KEY,
full_name VARCHAR(100) NOT NULL,
birth_year YEAR,
gender ENUM("male", "female", "other") NOT NULL,
score DECIMAL(4, 2)
);

SELECT * FROM students;

INSERT INTO students (student_id, full_name, birth_year, gender, score)
VALUES 
('SV001', 'Nguyễn Văn A', '2000', 'male', '10'),
('SV002', 'Nguyễn Thị B','2003', 'female', '8.7'),
('SV003', 'Nguyễn Văn C','1998', 'other', '9.5'),
('SV004', 'Lê Hoàng D','1994', 'male', '6.8'),
('SV005', 'Võ Thị E','1984', 'male', '7.2');

SELECT student_id, 
UPPER(full_name) AS full_name_upper
FROM students;

SELECT full_name,
(YEAR(CURRENT_DATE)- birth_year) AS age
FROM students;

SELECT full_name, 
ROUND(score, 1) AS rounded_score
FROM students;

SELECT COUNT(student_id) AS total_students,
MAX(score) AS highest_score,
MIN(score) AS lowest_score
FROM students;