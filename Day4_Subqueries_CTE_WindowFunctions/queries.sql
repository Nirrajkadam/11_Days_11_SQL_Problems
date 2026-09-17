-- ============================================================
-- Day 4: Subqueries, HAVING, CTEs & Advanced Window Functions
-- Database: day4_ecommerce_analysis_sub_cte
-- Dataset: OrdersCleaned_UTF8.csv (1,590 rows)
-- ============================================================

-- Step 1: Database Setup
CREATE DATABASE day4_ecommerce_analysis_sub_cte;
\c day4_ecommerce_analysis_sub_cte;

-- Step 2: Table Creation
DROP TABLE IF EXISTS orders;

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

-- Copy data from CSV
\copy orders FROM 'C:/Users/kadam/Downloads/11_day_11_problem/Dataset/OrdersCleaned_UTF8.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';

-- ============================================================
-- SECTION 1: Subqueries & HAVING Clause
-- ============================================================

-- Query 1: Orders having amount greater than average order value
SELECT id,
       name,
       total
FROM orders
WHERE total >
(
    SELECT AVG(total)
    FROM orders
)
ORDER BY total DESC;

-- Query 2: States generating revenue more than Rs 100000 (HAVING)
SELECT state,
       SUM(total) AS revenue
FROM orders
GROUP BY state
HAVING SUM(total) > 100000
ORDER BY revenue DESC;

-- Query 3: Products sold more than 50 times (HAVING)
SELECT product_name,
       COUNT(*) AS total_orders
FROM orders
GROUP BY product_name
HAVING COUNT(*) > 50
ORDER BY total_orders DESC;

-- ============================================================
-- SECTION 2: Common Table Expressions (CTE - WITH Clause)
-- ============================================================

-- Query 4: Revenue by state using CTE
WITH state_revenue AS
(
    SELECT state,
           SUM(total) AS revenue
    FROM orders
    GROUP BY state
)
SELECT *
FROM state_revenue
ORDER BY revenue DESC;

-- Query 5: CTE + Filter (States generating revenue > Rs 200000)
WITH state_revenue AS
(
    SELECT state,
           SUM(total) AS revenue
    FROM orders
    GROUP BY state
)
SELECT *
FROM state_revenue
WHERE revenue > 200000
ORDER BY revenue DESC;

-- ============================================================
-- SECTION 3: Advanced Window Functions (RANK, DENSE_RANK, LAG)
-- ============================================================

-- Query 6: State wise revenue ranking using RANK()
SELECT state,
       SUM(total) AS revenue,
       RANK() OVER
       (
           ORDER BY SUM(total) DESC
       ) AS state_rank
FROM orders
GROUP BY state;

-- Query 7: Top 5 Revenue States using CTE + RANK()
WITH state_revenue AS
(
    SELECT state,
           SUM(total) AS revenue,
           RANK() OVER
           (
               ORDER BY SUM(total) DESC
           ) AS rank_no
    FROM orders
    GROUP BY state
)
SELECT *
FROM state_revenue
WHERE rank_no <= 5;

-- Query 8: Product Revenue Ranking using RANK()
SELECT product_name,
       SUM(total) AS revenue,
       RANK() OVER
       (
           ORDER BY SUM(total) DESC
       ) AS product_rank
FROM orders
GROUP BY product_name;

-- Query 9: Customer Spending Ranking using DENSE_RANK()
SELECT name,
       SUM(total) AS spending,
       DENSE_RANK() OVER
       (
           ORDER BY SUM(total) DESC
       ) AS customer_rank
FROM orders
GROUP BY name;

-- Query 10: Revenue Contribution Percentage by State
SELECT state,
       SUM(total) AS revenue,
       ROUND(
            SUM(total) * 100.0 /
            SUM(SUM(total)) OVER(),
            2
       ) AS contribution_percent
FROM orders
GROUP BY state
ORDER BY revenue DESC;

-- Query 11: Running Total Revenue Across States
SELECT state,
       SUM(total) AS revenue,
       SUM(SUM(total)) OVER
       (
           ORDER BY SUM(total) DESC
       ) AS running_revenue
FROM orders
GROUP BY state;

-- Query 12: Previous State Revenue Comparison (LAG Window Function)
SELECT state,
       SUM(total) AS revenue,
       LAG(SUM(total))
       OVER(
           ORDER BY SUM(total) DESC
       ) AS previous_revenue
FROM orders
GROUP BY state;
