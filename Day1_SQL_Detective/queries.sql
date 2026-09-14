-- ============================================================
-- Day 1: SQL Detective - Personal Finance Analysis
-- Database: day1_sql_detective
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

-- Step 3: Insert Dataset Records
INSERT INTO transactions VALUES
(1, '2025-09-01', 'Food', 250.00, 'UPI'),
(2, '2025-09-01', 'Fuel', 500.00, 'UPI'),
(3, '2025-09-02', 'Shopping', 1200.00, 'Card'),
(4, '2025-09-03', 'Travel', 2500.00, 'Card'),
(5, '2025-09-04', 'Medical', 800.00, 'UPI');

-- ============================================================
-- Analysis Queries
-- ============================================================

-- Query 1: View all transaction records
SELECT * FROM transactions;

-- Query 2: Count total number of transactions
SELECT COUNT(*) FROM transactions;

-- Query 3: Calculate Average Transaction Amount
SELECT AVG(amount) AS avg_amount FROM transactions;

-- Query 4: Highest Value Transaction
SELECT * FROM transactions
ORDER BY amount DESC
LIMIT 1;

-- Query 5: Lowest Value Transaction
SELECT * FROM transactions
ORDER BY amount ASC
LIMIT 1;

-- Query 6: Payment Mode Breakdown (Count of transactions per method)
SELECT payment_mode,
       COUNT(*) AS total_transactions
FROM transactions
GROUP BY payment_mode;

-- Query 7: Top 3 Highest Transactions
SELECT * FROM transactions
ORDER BY amount DESC
LIMIT 3;

-- Query 8: Category Ranking using Window Function (RANK)
SELECT category,
       SUM(amount) AS total,
       RANK() OVER (ORDER BY SUM(amount) DESC) AS rank_no
FROM transactions
GROUP BY category;
