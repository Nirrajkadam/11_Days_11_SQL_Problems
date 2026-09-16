-- ============================================================
-- Day 3: E-Commerce Analytics (SQL JOINs & CASE WHEN Logic)
-- Database: day3_ecommerce_analysis
-- Dataset: OrdersCleaned_UTF8.csv (1,590 rows)
-- ============================================================

-- Step 1: Database Setup
CREATE DATABASE day3_ecommerce_analysis;
\c day3_ecommerce_analysis;

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
\copy orders FROM 'C:/Users/kadam/Downloads/11_day_11_problem/Dataset/OrdersCleaned_UTF8.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';

-- Step 3: Create Relational Customers Table
DROP TABLE IF EXISTS customers;

CREATE TABLE customers AS
SELECT DISTINCT
       id AS customer_id,
       name,
       city,
       state
FROM orders;

-- Query 1: Total Orders Count
SELECT COUNT(*) FROM orders;

-- Query 2: Total Revenue Generated
SELECT ROUND(SUM(total), 2) AS total_revenue
FROM orders;

-- Query 3: Order Breakdown by Status
SELECT status,
       COUNT(*) AS total_orders
FROM orders
GROUP BY status
ORDER BY total_orders DESC;

-- Query 4: Revenue & Orders by Payment Mode (isCOD)
SELECT iscod,
       COUNT(*) AS orders,
       ROUND(SUM(total), 2) AS revenue
FROM orders
GROUP BY iscod;

-- Query 5: Top 10 States by Order Volume
SELECT state,
       COUNT(*) AS total_orders
FROM orders
GROUP BY state
ORDER BY total_orders DESC
LIMIT 10;

-- Query 6: Top 10 Products by Sales Volume
SELECT product_name,
       COUNT(*) AS total_orders
FROM orders
GROUP BY product_name
ORDER BY total_orders DESC
LIMIT 10;

-- Query 7: Returned Orders Count
SELECT COUNT(*) AS returned_orders
FROM orders
WHERE date_returned IS NOT NULL;

-- Query 8: Delivered Orders Count
SELECT COUNT(*) AS delivered_orders
FROM orders
WHERE date_delivered IS NOT NULL;

-- Query 9: Verify Customers Table Count
SELECT COUNT(*) FROM customers;

-- Query 10: INNER JOIN - Matching Customers and Orders
SELECT c.customer_id,
       c.name,
       c.city,
       o.product_name,
       o.total
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.id
LIMIT 20;

-- Query 11: Top Customers by Revenue (JOIN + GROUP BY Name & State)
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

-- Query 12: LEFT JOIN Operation
SELECT c.customer_id,
       c.name,
       o.product_name
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.id
LIMIT 20;

-- Query 13: Order Delivery Status Breakdown by State (JOIN + GROUP BY)
SELECT c.state,
       o.status,
       COUNT(*) AS orders
FROM customers c
JOIN orders o
ON c.customer_id = o.id
GROUP BY c.state, o.status
ORDER BY orders DESC;

-- Query 14: Order Value Categorization (CASE WHEN)
SELECT id,
       total,
       CASE
           WHEN total >= 2000 THEN 'High Value'
           ELSE 'Normal Value'
       END AS order_type
FROM orders
LIMIT 20;

-- Query 15: High Value vs Normal Value Summary (CASE WHEN + Aggregations)
SELECT
    CASE
        WHEN total >= 2000 THEN 'High Value'
        ELSE 'Normal Value'
    END AS order_type,
    COUNT(*) AS orders,
    SUM(total) AS revenue
FROM orders
GROUP BY order_type;

-- Query 16: Order Delivery Result Segmentation (CASE WHEN)
SELECT
    CASE
        WHEN status = 'Delivered' THEN 'Successful'
        ELSE 'Failed/Returned'
    END AS order_result,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_result;

-- Query 17: Payment Channel Segmentation (CASE WHEN)
SELECT
    CASE
        WHEN iscod = TRUE THEN 'Cash on Delivery'
        ELSE 'Prepaid'
    END AS payment_type,
    COUNT(*) AS orders,
    SUM(total) AS revenue
FROM orders
GROUP BY payment_type;

-- Query 18: Advanced Order Category by State (CASE WHEN + JOIN)
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
ORDER BY orders DESC;

-- Query 19: Order Status Percentage Calculation (Subquery in SELECT)
SELECT status,
       COUNT(*) AS orders,
       ROUND(
         COUNT(*)*100.0/
         (SELECT COUNT(*) FROM orders),
         2
       ) AS percentage
FROM orders
GROUP BY status
ORDER BY orders DESC;
