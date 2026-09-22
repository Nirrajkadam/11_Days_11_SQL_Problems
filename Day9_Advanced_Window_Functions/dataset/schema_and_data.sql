-- =============================================================================
-- Day 9: Advanced Window Functions (ROW_NUMBER, RANK, DENSE_RANK, LEAD, LAG, NTILE, etc.)
-- Database: day9_advanced_window_functions
-- Author: Nirraj Kadam
-- 11 Days 11 SQL Problems Challenge
-- =============================================================================

-- Step 1: Database Creation
-- Note: Execute inside psql
-- CREATE DATABASE day9_advanced_window_functions;
-- \c day9_advanced_window_functions;

-- Step 2: Sales Table DDL
DROP TABLE IF EXISTS sales CASCADE;

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    salesperson VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL,
    sale_amount NUMERIC(10,2) NOT NULL,
    sale_date DATE NOT NULL
);

-- Step 3: Insert Sample Sales Records
INSERT INTO sales (salesperson, region, sale_amount, sale_date)
VALUES
('Rahul', 'West', 5000.00, '2025-01-01'),
('Priya', 'West', 7000.00, '2025-01-02'),
('Amit', 'North', 3000.00, '2025-01-03'),
('Sneha', 'North', 9000.00, '2025-01-04'),
('Rohit', 'South', 6000.00, '2025-01-05'),
('Rahul', 'West', 8000.00, '2025-01-06'),
('Priya', 'West', 7500.00, '2025-01-07'),
('Amit', 'North', 4000.00, '2025-01-08');
