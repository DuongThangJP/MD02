CREATE DATABASE session_8;
USE session_8;

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    class_name VARCHAR(50) NOT NULL
);

DELIMITER //
CREATE PROCEDURE sp_get_all_students()
BEGIN
    SELECT * FROM students;
END //
DELIMITER ;

CALL sp_get_all_students();