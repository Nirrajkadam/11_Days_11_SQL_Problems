-- ============================================================
-- Day 1: SQL Detective - Personal Finance Analysis
-- Database: day1_sql_detective
-- Description: Complete 12-Record Analysis Script
-- ============================================================

-- Step 1: Database Setup
CREATE DATABASE day1_sql_detective;
\c day1_sql_detective;

-- Step 2: Table Creation
CREATE TABLE transactions(
    transaction_id INT,
    transation_date DATE,
    category VARCHAR(50),
    amount DECIMAL(10,2),
    payment_mode VARCHAR(20)
);

-- Step 3: Data Insertion (12 Records)
INSERT INTO transactions VALUES
(1, '2025-09-01', 'Food', 250, 'UPI'),
(2, '2025-09-01', 'Fuel', 500, 'UPI'),
(3, '2025-09-02', 'Shopping', 1200, 'Card'),
(4, '2025-09-03', 'Travel', 2500, 'Card'),
(5, '2025-09-04', 'Medical', 800, 'UPI'),
(6, '2025-09-05', 'Food', 450, 'Cash'),
(7, '2025-09-06', 'Shopping', 3200, 'Card'),
(8, '2025-09-07', 'Travel', 4500, 'UPI'),
(9, '2025-09-08', 'Fuel', 700, 'UPI'),
(10, '2025-09-09', 'Entertainment', 1500, 'Card'),
(11, '2025-09-10', 'Medical', 2500, 'UPI'),
(12, '2025-09-11', 'Food', 650, 'UPI');

-- ============================================================
-- Analysis Queries
-- ============================================================

-- Query 1: Total Spending by Category
SELECT category,
       SUM(amount) AS total_spend
FROM transactions
GROUP BY category
ORDER BY total_spend DESC;

-- Query 2: Top 5 Highest Transactions
SELECT *
FROM transactions
ORDER BY amount DESC
LIMIT 5;

-- Query 3: Payment Mode Summary (Count & Total Amount)
SELECT payment_mode,
       COUNT(*) AS transactions,
       SUM(amount) AS total_amount
FROM transactions
GROUP BY payment_mode;

-- Query 4: Average Transaction Amount
SELECT ROUND(AVG(amount), 2)
FROM transactions;

-- Query 5: High Value Transactions (> ₹2000)
SELECT *
FROM transactions
WHERE amount > 2000;

-- Query 6: Category Ranking using Window Function (RANK)
SELECT category,
       SUM(amount) AS total,
       RANK() OVER(ORDER BY SUM(amount) DESC) AS rank_no
FROM transactions
GROUP BY category;

-- Query 7: Cumulative / Running Total using Window Function (SUM OVER)
SELECT transation_date,
       amount,
       SUM(amount) OVER(
         ORDER BY transation_date
       ) AS running_total
FROM transactions;

-- Query 8: Top Single Spending Category (Bonus)
SELECT category,
       SUM(amount) AS total_spend
FROM transactions
GROUP BY category
ORDER BY total_spend DESC
LIMIT 1;
