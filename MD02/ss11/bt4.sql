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


CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    log_message VARCHAR(255) NOT NULL,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);


INSERT INTO accounts (id, customer_name, balance)
VALUES (3, 'Nguyen Van A', 500000.00)
ON DUPLICATE KEY UPDATE customer_name = VALUES(customer_name);


DELIMITER //

CREATE PROCEDURE deposit_with_logging (
    IN p_account_id INT,
    IN p_amount DECIMAL(15,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Giao dịch thất bại! Đã hoàn tất ROLLBACK.' AS message;
    END;

    START TRANSACTION;
    UPDATE accounts 
    SET balance = balance + p_amount 
    WHERE id = p_account_id;

    INSERT INTO transactions (account_id, amount, log_message) 
    VALUES (p_account_id, p_amount, 'Nạp tiền vào tài khoản');

    COMMIT;
    SELECT 'Nạp tiền thành công!' AS message;

END //

DELIMITER ;


CALL withdraw_money(2, 100000.00);
CALL withdraw_money(2, 500000.00);

CALL deposit_with_logging(3, 1000000.00);

SELECT * FROM accounts WHERE id = 3;
SELECT * FROM transactions WHERE account_id = 3;

DROP TABLE transactions;

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    log_message VARCHAR(255) NOT NULL,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

UPDATE accounts SET balance = 2000000.00 WHERE account_id = 4;
UPDATE accounts SET balance = 0.00 WHERE account_id = 5;


SELECT account_id, account_name, balance AS balance_before 
FROM accounts 
WHERE account_id IN (4, 5);


DROP PROCEDURE transfer_money;

DELIMITER //

CREATE PROCEDURE transfer_money (
    IN p_sender_id INT,
    IN p_receiver_id INT,
    IN p_amount DECIMAL(15,2)
)
BEGIN
    DECLARE v_sender_balance DECIMAL(15,2);
    DECLARE v_sender_exists INT DEFAULT 0;
    DECLARE v_receiver_exists INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Giao dịch thất bại do lỗi hệ thống! Đã hoàn tất ROLLBACK.' AS message;
    END;

    -- Bắt đầu Transaction
    START TRANSACTION;

    SELECT COUNT(*), COALESCE(SUM(balance), 0) 
    INTO v_sender_exists, v_sender_balance
    FROM accounts WHERE account_id = p_sender_id;

    SELECT COUNT(*) INTO v_receiver_exists 
    FROM accounts WHERE account_id = p_receiver_id;

    IF v_sender_exists = 0 OR v_receiver_exists = 0 THEN
        ROLLBACK;
        SELECT 'Thất bại: Tai khoan nguoi gui hoac nguoi nhan khong ton tai!' AS message;

    ELSEIF p_amount <= 0 THEN
        ROLLBACK;
        SELECT 'Thất bại: So tien chuyen phai lon hon 0!' AS message;

    ELSEIF v_sender_balance < p_amount THEN
        ROLLBACK;
        SELECT 'Thất bại: So du nguoi gui khong du de thuc hien giao dich!' AS message;

    ELSE

        UPDATE accounts 
        SET balance = balance - p_amount 
        WHERE account_id = p_sender_id;

        UPDATE accounts 
        SET balance = balance + p_amount 
        WHERE account_id = p_receiver_id;

        INSERT INTO transactions (account_id, amount, log_message)
        VALUES (p_sender_id, -p_amount, CONCAT('Chuyen tien den tai khoan ID: ', p_receiver_id));

        INSERT INTO transactions (account_id, amount, log_message)
        VALUES (p_receiver_id, p_amount, CONCAT('Nhan tien tu tai khoan ID: ', p_sender_id));

        COMMIT;
        SELECT 'Chuyển tiền thành công!' AS message;
    END IF;

END //

DELIMITER ;

CALL transfer_money(4, 5, 300000.00);

SELECT account_id, account_name, balance AS balance_after 
FROM accounts 
WHERE account_id IN (4, 5);

SELECT * FROM transactions WHERE account_id IN (4, 5);