USE ddl_sql;

CREATE TABLE students_constraint (
student_id VARCHAR(10) PRIMARY KEY,
student_fullname VARCHAR(100) NOT NULL,
student_email VARCHAR(100) UNIQUE,
student_age INT CHECK(student_age >=18)
);
