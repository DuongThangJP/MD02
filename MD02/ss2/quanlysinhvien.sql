CREATE SCHEMA ddl_sql;

USE ddl_sql;

CREATE TABLE students (
student_id VARCHAR(10) PRIMARY KEY,
full_name VARCHAR(100) NOT NULL,
date_of_birth DATE,
gender VARCHAR(10)
);

ALTER TABLE students
ADD address VARCHAR(100);