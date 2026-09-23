CREATE DATABASE session_11;
USE session_11;

CREATE TABLE accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    account_name CHAR(100) NOT NULL,
    balance DECIMAL(15, 2) NOT NULL DEFAULT 0.00
);

INSERT INTO accounts (account_name, balance) VALUES
('Nguyen Van A', 5000000.00),
('Tran Thi B', 12000000.00),
('Le Van C', 8500000.00),
('Pham Thi D', 20000000.00),
('Hoang Van E', 300000.00),
('Vu Thi F', 1500000.00),
('Dang Van G', 9000000.00),
('Bui Thi H', 4500000.00),
('Do Van I', 11000000.00),
('Ngo Thi K', 6200000.00);

SELECT account_id, account_name, balance AS balance_before 
FROM accounts 
WHERE account_id = 1;


START TRANSACTION;

UPDATE accounts 
SET balance = balance + 1000000.00 
WHERE account_id = 1;

COMMIT;

SELECT account_id, account_name, balance AS balance_after 
FROM accounts 
WHERE account_id = 1;

SELECT * FROM accounts;
UPDATE accounts SET balance = 300000 WHERE account_id = 2;

DELIMITER //
CREATE PROCEDURE withdraw_money ( IN p_account_id INT, p_amount DECIMAL(15,2))
BEGIN
	DECLARE v_current_balance DECIMAL(15,2);
    START TRANSACTION;
	UPDATE accounts SET balance = balance - p_amount
    WHERE account_id = p_account_id;
    
    SELECT balance INTO v_current_balance
    FROM accounts
    WHERE account_id = p_account_id;
    
    IF v_current_balance < 0 THEN
    ROLLBACK;
    SELECT 'Số dư không đủ' AS message;
    ELSE
	COMMIT;
	SELECT 'Rút tiền thành công' AS message;
    END IF;
    
END //
DELIMITER ;

CALL withdraw_money(2, 100000);
CALL withdraw_money(2, 500000);