-- =============================================================================
-- Day 11: SQL Portfolio Project - E-Commerce Business Intelligence System
-- Database: day11_sql_portfolio_project
-- Author: Nirraj Kadam
-- 11 Days 11 SQL Problems Challenge (Final Portfolio Capstone)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- SECTION 0: DATASET VERIFICATION & QUICK PROFILE
-- -----------------------------------------------------------------------------

-- Verify Total Row Count
SELECT COUNT(*) AS total_orders FROM orders;

-- Comprehensive Dataset Profile
SELECT COUNT(*) AS total_orders,
       COUNT(DISTINCT state) AS states,
       COUNT(DISTINCT city) AS cities,
       COUNT(DISTINCT product_name) AS products,
       SUM(total) AS revenue
FROM orders;


-- -----------------------------------------------------------------------------
-- SECTION 1: EXECUTIVE KPI DASHBOARD
-- -----------------------------------------------------------------------------

SELECT COUNT(*) AS total_orders,
       SUM(total) AS total_revenue,
       ROUND(AVG(total), 2) AS avg_order_value
FROM orders;


-- -----------------------------------------------------------------------------
-- SECTION 2: GEOGRAPHIC REVENUE DISTRIBUTION
-- -----------------------------------------------------------------------------

SELECT state,
       SUM(total) AS revenue
FROM orders
GROUP BY state
ORDER BY revenue DESC;


-- -----------------------------------------------------------------------------
-- SECTION 3: PRODUCT PORTFOLIO PERFORMANCE
-- -----------------------------------------------------------------------------

SELECT product_name,
       COUNT(*) AS orders,
       SUM(total) AS revenue
FROM orders
GROUP BY product_name
ORDER BY revenue DESC;


-- -----------------------------------------------------------------------------
-- SECTION 4: DELIVERY & FULFILLMENT PERFORMANCE
-- -----------------------------------------------------------------------------

SELECT status,
       COUNT(*) AS orders,
       ROUND(
           COUNT(*) * 100.0 /
           (SELECT COUNT(*) FROM orders), 2
       ) AS percentage
FROM orders
GROUP BY status
ORDER BY orders DESC;


-- -----------------------------------------------------------------------------
-- SECTION 5: CUSTOMER LIFETIME VALUE & VALUE TIER SEGMENTATION
-- -----------------------------------------------------------------------------

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


-- -----------------------------------------------------------------------------
-- SECTION 6: MONTHLY REVENUE & RUN RATE TREND
-- -----------------------------------------------------------------------------

SELECT DATE_TRUNC('month', date_placed) AS revenue_month,
       SUM(total) AS revenue
FROM orders
GROUP BY DATE_TRUNC('month', date_placed)
ORDER BY DATE_TRUNC('month', date_placed);


-- -----------------------------------------------------------------------------
-- SECTION 7: ADVANCED WINDOW FUNCTION RANKING
-- -----------------------------------------------------------------------------

SELECT name,
       SUM(total) AS spending,
       RANK() OVER(
           ORDER BY SUM(total) DESC
       ) AS customer_rank
FROM orders
GROUP BY name;


-- -----------------------------------------------------------------------------
-- SECTION 8: REUSABLE DATABASE VIEW CREATION
-- -----------------------------------------------------------------------------

CREATE OR REPLACE VIEW top_customers AS
SELECT name,
       SUM(total) AS spending
FROM orders
GROUP BY name;

-- Query the Created View
SELECT * FROM top_customers ORDER BY spending DESC LIMIT 10;


-- -----------------------------------------------------------------------------
-- SECTION 9: DATABASE INDEXING FOR PERFORMANCE OPTIMIZATION
-- -----------------------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_state ON orders(state);
CREATE INDEX IF NOT EXISTS idx_status ON orders(status);


-- -----------------------------------------------------------------------------
-- SECTION 10: QUERY OPTIMIZATION & EXECUTION PLAN EVALUATION
-- -----------------------------------------------------------------------------

EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE state = 'Maharashtra';
