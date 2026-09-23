-- =============================================================================
-- Day 10: E-Commerce Business Intelligence Case Study
-- Database: day10_business_case_study
-- Author: Nirraj Kadam
-- 11 Days 11 SQL Problems Challenge
-- =============================================================================

-- Step 1: Database Creation
-- Note: Execute inside psql
-- CREATE DATABASE day10_business_case_study;
-- \c day10_business_case_study;

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

-- Step 3: Import Cleaned Dataset
-- \copy orders FROM 'C:/Users/kadam/Downloads/11_day_11_problem/Dataset/OrdersCleaned_UTF8.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';
