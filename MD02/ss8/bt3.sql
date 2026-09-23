USE session_8;

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL
);


DELIMITER //
CREATE PROCEDURE sp_get_avg_salary()
BEGIN
    DECLARE v_avg_salary DECIMAL(10, 2);

    SELECT AVG(salary) INTO v_avg_salary FROM employees;

    SELECT v_avg_salary AS average_salary;
END //
DELIMITER ;

CALL sp_get_avg_salary();