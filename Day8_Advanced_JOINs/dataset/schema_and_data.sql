-- =============================================================================
-- Day 8: Advanced SQL JOINs (INNER, LEFT, RIGHT, FULL, SELF, CROSS & Anti-Joins)
-- Database: day8_advanced_joins
-- Author: Nirraj Kadam
-- 11 Days 11 SQL Problems Challenge
-- =============================================================================

-- Step 1: Database Creation
-- Note: Execute inside psql
-- CREATE DATABASE day8_advanced_joins;
-- \c day8_advanced_joins;

-- Step 2: Customer Master Table DDL
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS employees CASCADE;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL
);

-- Step 3: Insert Customer Data
INSERT INTO customers (customer_id, customer_name, city)
VALUES
(1, 'Rahul', 'Mumbai'),
(2, 'Priya', 'Pune'),
(3, 'Amit', 'Hyderabad'),
(4, 'Sneha', 'Delhi'),
(5, 'Rohit', 'Bangalore');

-- Step 4: Orders Table DDL
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_amount NUMERIC NOT NULL
);

-- Step 5: Insert Orders Data
-- Note: Customers 4 and 5 have placed no orders.
-- Order 105 has customer_id = 7 which does not exist in customers table.
INSERT INTO orders (order_id, customer_id, order_amount)
VALUES
(101, 1, 5000),
(102, 1, 2500),
(103, 2, 7000),
(104, 3, 3000),
(105, 7, 9000);

-- Step 6: Employee Hierarchy Table DDL (For SELF JOIN)
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    manager_id INT
);

-- Step 7: Insert Employee Hierarchy Data
INSERT INTO employees (emp_id, emp_name, manager_id)
VALUES
(1, 'CEO', NULL),
(2, 'Manager A', 1),
(3, 'Manager B', 1),
(4, 'Developer 1', 2),
(5, 'Developer 2', 2);
