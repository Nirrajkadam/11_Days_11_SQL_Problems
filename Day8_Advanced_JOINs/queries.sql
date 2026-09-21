-- =============================================================================
-- Day 8: Advanced SQL JOINs (INNER, LEFT, RIGHT, FULL, SELF, CROSS & Anti-Joins)
-- Database: day8_advanced_joins
-- Author: Nirraj Kadam
-- 11 Days 11 SQL Problems Challenge
-- =============================================================================

-- -----------------------------------------------------------------------------
-- SECTION 1: VERIFY INITIAL DATA
-- -----------------------------------------------------------------------------

SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM employees;


-- -----------------------------------------------------------------------------
-- PART 1: CORE JOIN OPERATIONS
-- -----------------------------------------------------------------------------

-- Query 1: INNER JOIN
-- Returns records that have matching values in both tables.
SELECT c.customer_id,
       c.customer_name,
       o.order_id,
       o.order_amount
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id;

-- Query 2: LEFT JOIN
-- Returns all records from the left table (customers), and matched records from the right table (orders).
SELECT c.customer_name,
       o.order_id,
       o.order_amount
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

-- Query 3: RIGHT JOIN
-- Returns all records from the right table (orders), and matched records from the left table (customers).
SELECT c.customer_name,
       o.order_id,
       o.order_amount
FROM customers c
RIGHT JOIN orders o
ON c.customer_id = o.customer_id;

-- Query 4: FULL OUTER JOIN
-- Returns all records when there is a match in either left or right table.
SELECT c.customer_name,
       o.order_id,
       o.order_amount
FROM customers c
FULL JOIN orders o
ON c.customer_id = o.customer_id;


-- -----------------------------------------------------------------------------
-- PART 2: ANTI-JOIN PATTERNS (FINDING ORPHANS & UNMATCHED RECORDS)
-- -----------------------------------------------------------------------------

-- Query 5: Customers Without Orders (Customers who never placed an order)
SELECT c.*
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

-- Query 6: Orders Without Customers (Orders referencing non-existent customers)
SELECT o.*
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- -----------------------------------------------------------------------------
-- PART 3: ADVANCED STRUCTURAL JOINS (SELF & CROSS JOINS)
-- -----------------------------------------------------------------------------

-- Query 7: SELF JOIN
-- Joining a table to itself to evaluate hierarchical employee-manager relationships.
SELECT e.emp_name AS employee,
       m.emp_name AS manager
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.emp_id;

-- Query 8: CROSS JOIN
-- Generates the Cartesian product (every customer paired with every order).
SELECT c.customer_name,
       o.order_id
FROM customers c
CROSS JOIN orders o;


-- -----------------------------------------------------------------------------
-- PART 4: AGGREGATION & SPENDING ANALYSIS WITH JOINS
-- -----------------------------------------------------------------------------

-- Query 9: Customer Total Spending
SELECT c.customer_name,
       COALESCE(SUM(o.order_amount), 0) AS total_spent
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- Query 10: Highest Spending Customer
SELECT c.customer_name,
       SUM(o.order_amount) AS total_spent
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 1;


-- -----------------------------------------------------------------------------
-- PART 5: BONUS INTERVIEW CHALLENGES
-- -----------------------------------------------------------------------------

-- Bonus 1: Second Highest Spending Customer (JOIN + DENSE_RANK Window Function)
SELECT customer_name,
       total_spent
FROM
(
    SELECT c.customer_name,
           SUM(o.order_amount) AS total_spent,
           DENSE_RANK() OVER(
               ORDER BY SUM(o.order_amount) DESC
           ) AS rnk
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    GROUP BY c.customer_name
) x
WHERE rnk = 2;

-- Bonus 2: Customer Order Count (Including Customers with 0 Orders)
SELECT c.customer_name,
       COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC;

-- Bonus 3: Customers with More Than One Order (Repeat Customers via HAVING)
SELECT c.customer_name,
       COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) > 1;

-- Bonus 4: City-wise Revenue Generation
SELECT c.city,
       SUM(o.order_amount) AS revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY revenue DESC;

-- Bonus 5: Highest Single Order Per Customer
SELECT c.customer_name,
       MAX(o.order_amount) AS highest_order
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY highest_order DESC;
