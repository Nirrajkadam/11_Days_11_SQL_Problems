-- Day 2: Banking Database & Schema Setup
CREATE DATABASE day2_banking_db;

\c day2_banking_db;

CREATE TABLE bank_transactions (
    TransactionID VARCHAR(20) PRIMARY KEY,
    AccountID VARCHAR(20) NOT NULL,
    TransactionAmount NUMERIC(10, 2) NOT NULL,
    TransactionDate TIMESTAMP NOT NULL,
    TransactionType VARCHAR(20) NOT NULL,
    Location VARCHAR(100),
    DeviceID VARCHAR(50),
    IPAddress VARCHAR(50),
    MerchantID VARCHAR(50),
    Channel VARCHAR(20) NOT NULL,
    CustomerAge INT,
    CustomerOccupation VARCHAR(50),
    TransactionDuration INT,
    LoginAttempts INT,
    AccountBalance NUMERIC(12, 2),
    PreviousTransactionDate TIMESTAMP
);

-- Copy command for PostgreSQL:
-- \copy bank_transactions FROM 'dataset/bank_transactions_data_2.csv' WITH (FORMAT csv, HEADER true);
