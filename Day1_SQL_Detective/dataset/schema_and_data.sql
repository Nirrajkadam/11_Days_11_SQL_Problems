-- Day 1 SQL Detective Dataset & Table Creation
CREATE DATABASE day1_sql_detective;

\c day1_sql_detective;

CREATE TABLE transactions(
    transaction_id INT,
    transation_date DATE,
    category VARCHAR(50),
    amount DECIMAL(10,2),
    payment_mode VARCHAR(20)
);

-- Batch 1: Initial 5 Records
INSERT INTO transactions VALUES
(1, '2025-09-01', 'Food', 250, 'UPI'),
(2, '2025-09-01', 'Fuel', 500, 'UPI'),
(3, '2025-09-02', 'Shopping', 1200, 'Card'),
(4, '2025-09-03', 'Travel', 2500, 'Card'),
(5, '2025-09-04', 'Medical', 800, 'UPI');

-- Batch 2: Remaining 7 Records
INSERT INTO transactions VALUES
(6, '2025-09-05', 'Food', 450, 'Cash'),
(7, '2025-09-06', 'Shopping', 3200, 'Card'),
(8, '2025-09-07', 'Travel', 4500, 'UPI'),
(9, '2025-09-08', 'Fuel', 700, 'UPI'),
(10, '2025-09-09', 'Entertainment', 1500, 'Card'),
(11, '2025-09-10', 'Medical', 2500, 'UPI'),
(12, '2025-09-11', 'Food', 650, 'UPI');
