-- ============================================================
-- Day 2: Banking & Fraud Detection Analytics
-- Database: day2_bank_analysis
-- Dataset: bank_transactions_data_2.csv (2,512 rows)
-- ============================================================

-- Step 1: Database Setup
CREATE DATABASE day2_bank_analysis;
\c day2_bank_analysis;

-- Step 2: Table Creation (Matching exact psql schema)
CREATE TABLE bank_transactions(
    TransactionID VARCHAR(20),
    AccountID VARCHAR(20),
    TransactionAmount NUMERIC,
    TransactionDate TIMESTAMP,
    TransactionType VARCHAR(50),
    Loction VARCHAR(100),
    DeviceID VARCHAR(50),
    IP_Address VARCHAR(50),
    MerchantID VARCHAR(50),
    Channel VARCHAR(50),
    CustomerAge INT,
    CustomerOccupation VARCHAR(100),
    TransactionDuration INT,
    LoginAttempts INT,
    AccountBalance NUMERIC,
    PreviousTransationDate TIMESTAMP
);

-- Step 3: Copy Data from CSV
\copy bank_transactions FROM 'C:/Users/kadam/Downloads/11_day_11_problem/Dataset/bank_transactions_data_2.csv' DELIMITER ',' CSV HEADER;

-- ============================================================
-- SECTION 1: Core Banking Overview & Aggregations
-- ============================================================

-- Query 1: Total Transactions Count (Target: 2,512)
SELECT COUNT(*) FROM bank_transactions;

SELECT COUNT(*) AS total_transactions
FROM bank_transactions;

-- Query 2: Total Volume Transacted
SELECT ROUND(SUM(TransactionAmount), 2) AS total_amount
FROM bank_transactions;

-- Query 3: Average Transaction Amount
SELECT ROUND(AVG(TransactionAmount), 2) AS average_amount
FROM bank_transactions;

-- Query 4: Transaction Type Breakdown (Debit vs Credit)
SELECT TransactionType,
       COUNT(*) AS total_transactions,
       ROUND(SUM(TransactionAmount), 2) AS total_amount
FROM bank_transactions
GROUP BY TransactionType
ORDER BY total_amount DESC;

-- Query 5: Channel Preference Breakdown (Branch vs ATM vs Online)
SELECT Channel,
       COUNT(*) AS total_transactions
FROM bank_transactions
GROUP BY Channel
ORDER BY total_transactions DESC;

-- Query 6: Top 10 Highest Value Transactions
SELECT TransactionID,
       TransactionAmount,
       TransactionType,
       Channel
FROM bank_transactions
ORDER BY TransactionAmount DESC
LIMIT 10;

-- Query 7: Customer Occupation Spending Breakdown
SELECT CustomerOccupation,
       ROUND(SUM(TransactionAmount), 2) AS total_amount
FROM bank_transactions
GROUP BY CustomerOccupation
ORDER BY total_amount DESC;

-- ============================================================
-- SECTION 2: Fraud Risk & Security Analytics 🚨
-- ============================================================

-- Query 8: Login Attempts Distribution (Detecting Authentication Anomalies)
SELECT LoginAttempts,
       COUNT(*) AS total_transactions
FROM bank_transactions
GROUP BY LoginAttempts
ORDER BY LoginAttempts;

-- Query 9: High Risk Fraud Audit (Login Attempts > 3)
SELECT *
FROM bank_transactions
WHERE LoginAttempts > 3;

-- Query 10: Average Login Attempts per Channel
SELECT Channel,
       AVG(LoginAttempts)
FROM bank_transactions
GROUP BY Channel;
