-- =============================================================================
-- Day 7: String Functions, Date Functions, NULL Handling, and Data Cleaning
-- Database: day7_string_date_functions
-- Author: Nirraj Kadam
-- 11 Days 11 SQL Problems Challenge
-- =============================================================================

-- Step 1: Database Creation
-- CREATE DATABASE day7_string_date_functions;
-- \c day7_string_date_functions;

-- Step 2: Employees Table DDL
DROP TABLE IF EXISTS employees CASCADE;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100),
    department VARCHAR(50),
    salary NUMERIC(10,2),
    email VARCHAR(100),
    joining_date DATE
);

-- Step 3: Insert Sample Employee Data
INSERT INTO employees (emp_name, department, salary, email, joining_date)
VALUES
('rahul sharma', 'IT', 50000.00, 'rahul@gmail.com', '2023-01-15'),
('PRIYA PATIL', 'HR', 45000.00, 'priya@gmail.com', '2022-05-10'),
('Amit Kumar', 'IT', 70000.00, NULL, '2021-03-20'),
('Sneha Joshi', 'Finance', 60000.00, 'sneha@gmail.com', '2020-07-01'),
('Rohit Verma', 'IT', 80000.00, NULL, '2019-08-25');
