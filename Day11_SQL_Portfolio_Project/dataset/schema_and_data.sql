-- =============================================================================
-- Day 11: SQL Portfolio Project - E-Commerce Business Intelligence System
-- Database: day11_sql_portfolio_project
-- Author: Nirraj Kadam
-- 11 Days 11 SQL Problems Challenge
-- =============================================================================

-- Step 1: Database Creation
-- CREATE DATABASE day11_sql_portfolio_project;
-- \c day11_sql_portfolio_project;

-- Step 2: Orders Master Table DDL
DROP TABLE IF EXISTS orders CASCADE;

CREATE TABLE orders (
    row_index INT,
    id INT,
    name VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    address TEXT,
    iscod BOOLEAN,
    date_placed TIMESTAMP,
    status VARCHAR(50),
    ivr VARCHAR(50),
    remarks TEXT,
    total NUMERIC,
    date_delivered TIMESTAMP,
    date_returned TIMESTAMP,
    pid VARCHAR(20),
    category VARCHAR(20),
    quantity INT,
    product_name VARCHAR(255)
);

-- Step 3: Bulk Data Import
-- \copy orders FROM 'C:/Users/kadam/Downloads/11_day_11_problem/Dataset/OrdersCleaned_UTF8.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';

-- Step 4: Analytical Views
CREATE OR REPLACE VIEW top_customers AS
SELECT name,
       SUM(total) AS spending
FROM orders
GROUP BY name;

-- Step 5: B-Tree Performance Indexes
CREATE INDEX IF NOT EXISTS idx_state ON orders(state);
CREATE INDEX IF NOT EXISTS idx_status ON orders(status);
