CREATE DATABASE quanlylophoc;
USE quanlylophoc;

CREATE TABLE classes (
class_id CHAR(10) PRIMARY KEY,
class_name CHAR(50) NOT NULL);

CREATE TABLE students (
student_id INT PRIMARY KEY auto_increment,
student_name CHAR(50) NOT NULL,
dob DATE,
email CHAR(50),
class_id CHAR(10) NOT NULL,
CONSTRAINT fk_students_classes
FOREIGN KEY (class_id) REFERENCES classes(class_id)
);