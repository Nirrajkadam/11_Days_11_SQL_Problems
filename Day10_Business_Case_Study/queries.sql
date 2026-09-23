-- =============================================================================
-- Day 10: E-Commerce Business Intelligence Case Study
-- Database: day10_business_case_study
-- Author: Nirraj Kadam
-- 11 Days 11 SQL Problems Challenge
-- =============================================================================

-- -----------------------------------------------------------------------------
-- SECTION 1: VERIFY DATASET
-- -----------------------------------------------------------------------------

SELECT COUNT(*) AS total_records FROM orders;


-- -----------------------------------------------------------------------------
-- PART 1: EXECUTIVE KPI DASHBOARD
-- -----------------------------------------------------------------------------

-- Query 1: Total Business Summary (Executive KPI Dashboard)
SELECT COUNT(*) AS total_orders,
       SUM(total) AS total_revenue,
       ROUND(AVG(total), 2) AS avg_order_value
FROM orders;


-- -----------------------------------------------------------------------------
-- PART 2: FULFILLMENT & LOGISTICS ANALYTICS
-- -----------------------------------------------------------------------------

-- Query 2: Order Fulfillment Status Distribution
SELECT status,
       COUNT(*) AS orders,
       ROUND(
           COUNT(*) * 100.0 /
           (SELECT COUNT(*) FROM orders), 2
       ) AS percentage
FROM orders
GROUP BY status
ORDER BY orders DESC;

-- Query 6: Return Rate Analysis (Data Integrity & Quality Check)
SELECT COUNT(*) FILTER(WHERE status = 'Returned') AS returned_orders,
       COUNT(*) AS total_orders,
       ROUND(
           COUNT(*) FILTER(WHERE status = 'Returned') * 100.0 /
           COUNT(*),
           2
       ) AS return_rate
FROM orders;


-- -----------------------------------------------------------------------------
-- PART 3: GEOGRAPHIC & REGIONAL REVENUE
-- -----------------------------------------------------------------------------

-- Query 3: Top 10 Highest Revenue Generating States
SELECT state,
       SUM(total) AS revenue
FROM orders
GROUP BY state
ORDER BY revenue DESC
LIMIT 10;

-- Query 10: State Revenue Contribution Percentage
SELECT state,
       SUM(total) AS revenue,
       ROUND(
           SUM(total) * 100.0 /
           (SELECT SUM(total) FROM orders), 2
       ) AS contribution_percent
FROM orders
GROUP BY state
ORDER BY revenue DESC;


-- -----------------------------------------------------------------------------
-- PART 4: PRODUCT & CATEGORY PERFORMANCE
-- -----------------------------------------------------------------------------

-- Query 4: Top 10 Best-Selling Products by Revenue
SELECT product_name,
       COUNT(*) AS orders,
       SUM(total) AS revenue
FROM orders
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 10;

-- Query 8: Category-wise Revenue Breakdown
SELECT category,
       COUNT(*) AS orders,
       SUM(total) AS revenue
FROM orders
GROUP BY category
ORDER BY revenue DESC;

-- Bonus Query 11: Top Product in Each Category (CTE + Partitioned Ranking)
WITH product_rank AS (
    SELECT category,
           product_name,
           SUM(total) AS revenue,
           ROW_NUMBER() OVER(
               PARTITION BY category
               ORDER BY SUM(total) DESC
           ) AS rn
    FROM orders
    GROUP BY category, product_name
)
SELECT category,
       product_name,
       revenue
FROM product_rank
WHERE rn = 1
ORDER BY revenue DESC;


-- -----------------------------------------------------------------------------
-- PART 5: PAYMENT CHANNEL & CUSTOMER SEGMENTATION
-- -----------------------------------------------------------------------------

-- Query 5: Cash on Delivery (COD) vs Prepaid Financial Performance
SELECT CASE
           WHEN iscod = TRUE THEN 'COD'
           ELSE 'Prepaid'
       END AS payment_type,
       COUNT(*) AS orders,
       SUM(total) AS revenue
FROM orders
GROUP BY payment_type;

-- Query 7: Monthly Revenue Trend
SELECT DATE_TRUNC('month', date_placed) AS month,
       SUM(total) AS revenue
FROM orders
GROUP BY month
ORDER BY month;

-- Query 9: Top 10 Highest Spending Customers
SELECT name,
       SUM(total) AS spending
FROM orders
GROUP BY name
ORDER BY spending DESC
LIMIT 10;

-- Bonus Query 12: Customer Value Tier Segmentation
SELECT name,
       SUM(total) AS spending,
       CASE
           WHEN SUM(total) >= 10000 THEN 'Premium'
           WHEN SUM(total) >= 5000 THEN 'Gold'
           ELSE 'Regular'
       END AS customer_segment
FROM orders
GROUP BY name
ORDER BY spending DESC;
