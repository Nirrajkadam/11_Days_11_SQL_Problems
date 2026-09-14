-- ============================================================
-- Day 1: SQL Detective - Query Script
-- Database: day1_sql_detective
-- Description: Personal Finance & Transaction Analysis SQL Queries
-- ============================================================

-- Step 1: Database Creation
-- CREATE DATABASE day1_sql_detective;
-- \c day1_sql_detective;

-- Step 2: Table Creation
DROP TABLE IF EXISTS transactions;

CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    transation_date DATE NOT NULL, -- Note: Column named transation_date as created in Day 1 schema
    category VARCHAR(50) NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    payment_mode VARCHAR(20) NOT NULL
);

-- Alternative view / column alias fix if needed:
-- ALTER TABLE transactions RENAME COLUMN transation_date TO transaction_date;

-- Step 3: Insert 12 Sample Records
INSERT INTO transactions (transation_date, category, amount, payment_mode) VALUES
('2025-09-01', 'Food', 450.00, 'Cash'),
('2025-09-01', 'Fuel', 1200.00, 'Card'),
('2025-09-02', 'Food', 400.00, 'UPI'),
('2025-09-03', 'Travel', 2500.00, 'Card'),
('2025-09-04', 'Entertainment', 1500.00, 'Card'),
('2025-09-05', 'Medical', 800.00, 'UPI'),
('2025-09-06', 'Shopping', 3200.00, 'Card'),
('2025-09-07', 'Travel', 4500.00, 'UPI'),
('2025-09-08', 'Shopping', 1200.00, 'UPI'),
('2025-09-09', 'Food', 300.00, 'UPI'),
('2025-09-10', 'Medical', 2500.00, 'UPI'),
('2025-09-11', 'Food', 200.00, 'UPI');

-- ============================================================
-- Day 1 Queries & Analysis
-- ============================================================

-- Query 1: View all transactions
SELECT * FROM transactions;

-- Query 2: Category-wise Total Spending (Ordered by highest spending)
SELECT category,
       SUM(amount) AS total_spending
FROM transactions
GROUP BY category
ORDER BY SUM(amount) DESC;

-- Query 3: Payment Mode Analysis (Count & Total Amount per Payment Method)
SELECT payment_mode,
       COUNT(*) AS transactions,
       SUM(amount) AS total_amount
FROM transactions
GROUP BY payment_mode
ORDER BY total_amount DESC;

-- Query 4: Average Transaction Amount
SELECT ROUND(AVG(amount), 2) AS avg_transaction_amount
FROM transactions;

-- Query 5: High Value Transactions (> ₹2000)
SELECT *
FROM transactions
WHERE amount > 2000
ORDER BY amount DESC;

-- Query 6: Category Ranking using Window Function (RANK)
SELECT category,
       SUM(amount) AS total,
       RANK() OVER(ORDER BY SUM(amount) DESC) AS rank_no
FROM transactions
GROUP BY category;

-- Query 7: Running Total over Time using Window Function (SUM OVER)
SELECT transation_date,
       amount,
       SUM(amount) OVER(
         ORDER BY transation_date, transaction_id
       ) AS running_total
FROM transactions;

-- Bonus Query: Top Spending Category (Limit 1)
SELECT category,
       SUM(amount) AS total_spend
FROM transactions
GROUP BY category
ORDER BY total_spend DESC
LIMIT 1;
