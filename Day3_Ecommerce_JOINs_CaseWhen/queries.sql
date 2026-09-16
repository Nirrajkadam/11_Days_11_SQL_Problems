-- ============================================================
-- Day 3: E-Commerce Analytics (SQL JOINs & CASE WHEN Logic)
-- Database: day3_ecommerce_db
-- Dataset: OrdersCleaned_UTF8.csv (1,590 rows)
-- ============================================================

-- Step 1: Database Setup
CREATE DATABASE day3_ecommerce_db;
\c day3_ecommerce_db;

-- Step 2: Create Primary Orders Table
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_index INT,
    id INT,
    name VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    address TEXT,
    iscod BOOLEAN,
    date_placed TIMESTAMP,
    status VARCHAR(50),
    ivr VARCHAR(50),
    remarks TEXT,
    total NUMERIC(10, 2),
    date_delivered TIMESTAMP,
    date_returned TIMESTAMP,
    pid VARCHAR(50),
    category VARCHAR(50),
    quantity INT,
    product_name VARCHAR(255)
);

-- Copy data from CSV
\copy orders FROM 'C:/Users/kadam/Downloads/11_day_11_problem/Dataset/OrdersCleaned_UTF8.csv' DELIMITER ',' CSV HEADER;

-- Step 3: Create Relational Customers Table
DROP TABLE IF EXISTS customers;

CREATE TABLE customers AS
SELECT DISTINCT
       id AS customer_id,
       name,
       city,
       state
FROM orders;

-- Query 1: Verify Customers Table Count
SELECT COUNT(*) AS total_customers FROM customers;

-- Query 2: Verify Orders Table Count
SELECT COUNT(*) AS total_orders FROM orders;

-- ============================================================
-- SECTION 1: SQL JOINs Operations
-- ============================================================

-- Query 3: INNER JOIN - Retrieve Matching Customer and Order Data
SELECT c.customer_id,
       c.name,
       c.state,
       o.product_name,
       o.total
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.id
LIMIT 10;

-- Query 4: Customer Revenue Analysis using INNER JOIN
SELECT c.name,
       c.state,
       COUNT(*) AS total_orders,
       SUM(o.total) AS revenue
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.id
GROUP BY c.name, c.state
ORDER BY revenue DESC
LIMIT 10;

-- Query 5: LEFT JOIN - All Customers with Order Info
SELECT c.customer_id,
       c.name,
       o.product_name
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.id
LIMIT 20;

-- ============================================================
-- SECTION 2: CASE WHEN Business Logic & Segmentation
-- ============================================================

-- Query 6: High Value vs Normal Value Orders (CASE WHEN)
SELECT id,
       total,
       CASE
           WHEN total >= 2000 THEN 'High Value'
           ELSE 'Normal Value'
       END AS order_type
FROM orders
LIMIT 20;

-- Query 7: Order Delivery Status Analysis (Successful vs Failed/Returned)
SELECT
    CASE
        WHEN status = 'Delivered' THEN 'Successful'
        ELSE 'Failed/Returned'
    END AS result,
    COUNT(*) AS orders
FROM orders
GROUP BY result;

-- Query 8: Payment Channel Analysis (COD vs Prepaid Revenue)
SELECT
    CASE
        WHEN iscod = TRUE THEN 'COD'
        ELSE 'Prepaid'
    END AS payment_type,
    COUNT(*) AS total_orders,
    SUM(total) AS revenue
FROM orders
GROUP BY payment_type;

-- Query 9: Advanced CASE WHEN + JOIN (Order Value Category by State)
SELECT c.state,
       CASE
           WHEN o.total >= 2000 THEN 'High Value'
           ELSE 'Normal Value'
       END AS order_category,
       COUNT(*) AS orders
FROM customers c
JOIN orders o
ON c.customer_id = o.id
GROUP BY c.state, order_category
ORDER BY orders DESC
LIMIT 10;
