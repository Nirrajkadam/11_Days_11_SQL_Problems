-- =============================================================================
-- Day 6: PostgreSQL Functions, Stored Procedures, and Triggers
-- Database: day6_functions_procedures_triggers
-- Author: Nirraj Kadam
-- 11 Days 11 SQL Problems Challenge
-- =============================================================================

-- Step 1: Database Creation
-- Note: Run in psql or PostgreSQL client
-- CREATE DATABASE day6_functions_procedures_triggers;
-- \c day6_functions_procedures_triggers;

-- Step 2: Employee Master Table DDL
DROP TABLE IF EXISTS salary_audit CASCADE;
DROP TABLE IF EXISTS employee_audit CASCADE;
DROP TABLE IF EXISTS employees CASCADE;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary NUMERIC(10,2) NOT NULL,
    joining_date DATE NOT NULL
);

-- Step 3: Insert Initial Employee Records
INSERT INTO employees (emp_name, department, salary, joining_date)
VALUES
('Rahul', 'IT', 50000.00, '2023-01-15'),
('Priya', 'HR', 45000.00, '2022-05-10'),
('Amit', 'IT', 70000.00, '2021-03-20'),
('Sneha', 'Finance', 60000.00, '2020-07-01'),
('Rohit', 'IT', 80000.00, '2019-08-25');

-- Step 4: Audit Logging Tables DDL
CREATE TABLE salary_audit (
    audit_id SERIAL PRIMARY KEY,
    emp_id INT NOT NULL,
    old_salary NUMERIC(10,2) NOT NULL,
    new_salary NUMERIC(10,2) NOT NULL,
    changed_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employee_audit (
    audit_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    inserted_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
