-- ============================================================
-- Day 2: Banking & Fraud Detection Analytics
-- Database: day2_banking_db
-- Dataset: bank_transactions_data_2.csv (2,512 rows)
-- ============================================================

-- Step 1: Database Setup
-- CREATE DATABASE day2_banking_db;
-- \c day2_banking_db;

-- Step 2: Table Creation
DROP TABLE IF EXISTS bank_transactions;

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

-- Note: Import data via \copy command in psql:
-- \copy bank_transactions FROM 'dataset/bank_transactions_data_2.csv' WITH (FORMAT csv, HEADER true);

-- ============================================================
-- SECTION 1: Core Banking Overview & Aggregations
-- ============================================================

-- Query 1: Total Transactions Verification (Target: 2,512)
SELECT COUNT(*) AS total_transactions
FROM bank_transactions;

-- Query 2: Total Volume / Financial Amount Transacted
SELECT ROUND(SUM(TransactionAmount), 2) AS total_amount
FROM bank_transactions;

-- Query 3: Average Transaction Amount
SELECT ROUND(AVG(TransactionAmount), 2) AS average_amount
FROM bank_transactions;

-- Query 4: Transaction Type Breakdown (Debit vs Credit Analysis)
SELECT TransactionType,
       COUNT(*) AS total_transactions,
       ROUND(SUM(TransactionAmount), 2) AS total_amount,
       ROUND(AVG(TransactionAmount), 2) AS avg_amount
FROM bank_transactions
GROUP BY TransactionType
ORDER BY total_amount DESC;

-- Query 5: Channel Preference Breakdown (Branch vs ATM vs Online)
SELECT Channel,
       COUNT(*) AS total_transactions,
       ROUND(SUM(TransactionAmount), 2) AS total_amount
FROM bank_transactions
GROUP BY Channel
ORDER BY total_transactions DESC;

-- Query 6: Top 10 Highest Value Transactions
SELECT TransactionID,
       AccountID,
       TransactionAmount,
       TransactionType,
       Channel,
       CustomerOccupation
FROM bank_transactions
ORDER BY TransactionAmount DESC
LIMIT 10;

-- Query 7: Customer Occupation-wise Expenditure & Activity
SELECT CustomerOccupation,
       COUNT(*) AS transaction_count,
       ROUND(SUM(TransactionAmount), 2) AS total_amount,
       ROUND(AVG(TransactionAmount), 2) AS avg_amount
FROM bank_transactions
GROUP BY CustomerOccupation
ORDER BY total_amount DESC;


-- ============================================================
-- SECTION 2: Fraud Detection & Risk Analytics 🚨
-- ============================================================

-- Query 8: Login Attempts Distribution (Detecting Brute-Force / Unflagged Logins)
SELECT LoginAttempts,
       COUNT(*) AS total_transactions
FROM bank_transactions
GROUP BY LoginAttempts
ORDER BY LoginAttempts DESC;

-- Query 9: High-Risk Login Flagging (> 3 Login Attempts)
SELECT TransactionID,
       AccountID,
       TransactionAmount,
       Channel,
       CustomerOccupation,
       LoginAttempts,
       AccountBalance
FROM bank_transactions
WHERE LoginAttempts > 3
ORDER BY TransactionAmount DESC;

-- Query 10: Channel Risk Profile (Average Login Attempts per Channel)
SELECT Channel,
       ROUND(AVG(LoginAttempts), 2) AS avg_login_attempts,
       COUNT(CASE WHEN LoginAttempts > 3 THEN 1 END) AS high_risk_logins
FROM bank_transactions
GROUP BY Channel
ORDER BY avg_login_attempts DESC;

-- Query 11: Suspicious Low-Balance / Overdraft Transactions (Balance < Amount)
SELECT TransactionID,
       AccountID,
       TransactionAmount,
       AccountBalance,
       (TransactionAmount - AccountBalance) AS deficit_amount,
       Channel,
       LoginAttempts
FROM bank_transactions
WHERE TransactionType = 'Debit' AND TransactionAmount > AccountBalance
ORDER BY deficit_amount DESC
LIMIT 10;

-- Query 12: High-Risk Fraud Audit Matrix (High Amount + High Login Attempts)
SELECT TransactionID,
       AccountID,
       TransactionAmount,
       Channel,
       CustomerOccupation,
       LoginAttempts,
       TransactionDuration,
       Location
FROM bank_transactions
WHERE LoginAttempts >= 4 AND TransactionAmount > 500
ORDER BY LoginAttempts DESC, TransactionAmount DESC;
