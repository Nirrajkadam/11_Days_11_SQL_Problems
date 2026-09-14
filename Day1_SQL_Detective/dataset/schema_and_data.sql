-- Day 1 SQL Detective Dataset Schema & Initial Data
CREATE DATABASE day1_sql_detective;

\c day1_sql_detective;

CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    transation_date DATE NOT NULL,
    category VARCHAR(50) NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    payment_mode VARCHAR(20) NOT NULL
);

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
