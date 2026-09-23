USE ddl_sql;

CREATE TABLE users (
user_id VARCHAR(10) PRIMARY KEY,
user_loginname VARCHAR(50) UNIQUE NOT NULL,
user_password VARCHAR(255) NOT NULL,
user_status VARCHAR(10) DEFAULT 'ACTIVE' CHECK (user_status IN ('ACTIVE','INACTIVE'))
);