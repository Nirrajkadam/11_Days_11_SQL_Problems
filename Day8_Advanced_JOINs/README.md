# Day 8: Advanced SQL JOINs (INNER, LEFT, RIGHT, FULL, SELF, CROSS & Anti-Joins)

Welcome to Day 8 of the 11 Days 11 SQL Problems Challenge.
In Day 8, we explored Advanced Relational Joins in PostgreSQL within database `day8_advanced_joins`. We covered all foundational and enterprise join variations: INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN, Anti-Join patterns (identifying orphaned data), SELF JOIN (hierarchical employee-manager structures), CROSS JOIN (Cartesian product), and multi-table business aggregations combining JOINs with Window Functions and HAVING clauses.

---

## Project Structure

```text
Day8_Advanced_JOINs
|
|-- README.md
|-- queries.sql
|-- screenshots/
|   |-- 01_inner_join_and_left_join.png
|   |-- 02_right_join_and_full_join.png
|   |-- 03_anti_joins_unmatched_records.png
|   |-- 04_self_join_employee_hierarchy.png
|   |-- 05_cross_join_cartesian_product.png
|   |-- 06_customer_spending_and_top_spender.png
|   |-- 07_second_highest_spender_and_order_count.png
|   `-- 08_repeat_customers_city_revenue_highest_order.png
`-- dataset/
    `-- schema_and_data.sql
```

---

## Database and Table Setup

Database: `day8_advanced_joins`

```sql
CREATE DATABASE day8_advanced_joins;
\c day8_advanced_joins;

-- Customers Table
CREATE TABLE customers(
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(100)
);

INSERT INTO customers VALUES
(1, 'Rahul', 'Mumbai'),
(2, 'Priya', 'Pune'),
(3, 'Amit', 'Hyderabad'),
(4, 'Sneha', 'Delhi'),
(5, 'Rohit', 'Bangalore');

-- Orders Table
CREATE TABLE orders(
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_amount NUMERIC
);

INSERT INTO orders VALUES
(101, 1, 5000),
(102, 1, 2500),
(103, 2, 7000),
(104, 3, 3000),
(105, 7, 9000);

-- Employee Hierarchy Table (For SELF JOIN)
CREATE TABLE employees(
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    manager_id INT
);

INSERT INTO employees VALUES
(1, 'CEO', NULL),
(2, 'Manager A', 1),
(3, 'Manager B', 1),
(4, 'Developer 1', 2),
(5, 'Developer 2', 2);
```

Dataset Anomaly Notes:
- Customers 4 (Sneha) and 5 (Rohit) exist in `customers` but have never placed an order in `orders`.
- Order 105 references `customer_id = 7`, which does not exist in `customers` (orphaned order).
- In `employees`, the CEO has `manager_id = NULL` (top of corporate hierarchy).

---

## Part 1: Core Relational JOINs

### 1. INNER JOIN: Matching Records Across Both Tables
Returns only customers who have placed at least one order.
```sql
SELECT c.customer_id,
       c.customer_name,
       o.order_id,
       o.order_amount
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id;
```
Output (4 rows):

| customer_id | customer_name | order_id | order_amount (Rs) |
|---|---|---|---|
| 1 | Rahul | 101 | 5,000 |
| 1 | Rahul | 102 | 2,500 |
| 2 | Priya | 103 | 7,000 |
| 3 | Amit | 104 | 3,000 |

---

### 2. LEFT JOIN: Preserving All Left Table Records
Returns all customers, including those with zero orders (fields populated with NULL).
```sql
SELECT c.customer_name,
       o.order_id,
       o.order_amount
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;
```
Output (6 rows):

| customer_name | order_id | order_amount (Rs) |
|---|---|---|
| Rahul | 101 | 5,000 |
| Rahul | 102 | 2,500 |
| Priya | 103 | 7,000 |
| Amit | 104 | 3,000 |
| Rohit | NULL | NULL |
| Sneha | NULL | NULL |

---

### 3. RIGHT JOIN: Preserving All Right Table Records
Returns all orders, including order 105 which has an unmapped customer.
```sql
SELECT c.customer_name,
       o.order_id,
       o.order_amount
FROM customers c
RIGHT JOIN orders o
ON c.customer_id = o.customer_id;
```
Output (5 rows):

| customer_name | order_id | order_amount (Rs) |
|---|---|---|
| Rahul | 101 | 5,000 |
| Rahul | 102 | 2,500 |
| Priya | 103 | 7,000 |
| Amit | 104 | 3,000 |
| NULL | 105 | 9,000 |

---

### 4. FULL OUTER JOIN: Complete Union of Matching and Non-Matching Records
Returns all customers and all orders regardless of match status.
```sql
SELECT c.customer_name,
       o.order_id,
       o.order_amount
FROM customers c
FULL JOIN orders o
ON c.customer_id = o.customer_id;
```
Output (7 rows):

| customer_name | order_id | order_amount (Rs) | Match Type |
|---|---|---|---|
| Rahul | 101 | 5,000 | Matched |
| Rahul | 102 | 2,500 | Matched |
| Priya | 103 | 7,000 | Matched |
| Amit | 104 | 3,000 | Matched |
| NULL | 105 | 9,000 | Right-only (Orphaned order) |
| Rohit | NULL | NULL | Left-only (Zero-order customer) |
| Sneha | NULL | NULL | Left-only (Zero-order customer) |

---

## Part 2: Anti-Join Patterns (Finding Data Discrepancies)

Anti-joins identify rows in one table that do not have a corresponding match in another table.

### 5. Customers Without Orders (Inactive Customers)
```sql
SELECT c.*
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;
```
Output (2 rows):

| customer_id | customer_name | city |
|---|---|---|
| 5 | Rohit | Bangalore |
| 4 | Sneha | Delhi |

---

### 6. Orders Without Customers (Referential Integrity Violations)
```sql
SELECT o.*
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
```
Output (1 row):

| order_id | customer_id | order_amount (Rs) |
|---|---|---|
| 105 | 7 | 9,000 |

---

## Part 3: Advanced Structural JOINs

### 7. SELF JOIN: Organizational Hierarchy
Joins `employees` table to itself using `manager_id` referencing `emp_id`.
```sql
SELECT e.emp_name AS employee,
       m.emp_name AS manager
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.emp_id;
```
Output (5 rows):

| employee | manager | Hierarchy Level |
|---|---|---|
| CEO | NULL | Top Level |
| Manager A | CEO | Mid Level |
| Manager B | CEO | Mid Level |
| Developer 1 | Manager A | Base Level |
| Developer 2 | Manager A | Base Level |

---

### 8. CROSS JOIN: Cartesian Product
Produces all possible pairings between customers (5) and orders (5), generating 25 rows.
```sql
SELECT c.customer_name,
       o.order_id
FROM customers c
CROSS JOIN orders o;
```

---

## Part 4: Aggregation and Spending Analysis

### 9. Total Spending per Customer
```sql
SELECT c.customer_name,
       COALESCE(SUM(o.order_amount), 0) AS total_spent
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;
```
| customer_name | total_spent (Rs) |
|---|---|
| Rahul | 7,500 |
| Priya | 7,000 |
| Amit | 3,000 |
| Rohit | 0 |
| Sneha | 0 |

---

### 10. Highest Spending Customer
```sql
SELECT c.customer_name,
       SUM(o.order_amount) AS total_spent
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 1;
```
| customer_name | total_spent (Rs) |
|---|---|
| Rahul | 7,500 |

---

## Part 5: Bonus Interview Challenges

### Bonus 1: Second Highest Spending Customer (JOIN + Window Function)
```sql
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
```
| customer_name | total_spent (Rs) |
|---|---|
| Priya | 7,000 |

---

### Bonus 2: Customer Order Count (Including Zero-Order Customers)
```sql
SELECT c.customer_name,
       COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC;
```
| customer_name | total_orders |
|---|---|
| Rahul | 2 |
| Priya | 1 |
| Amit | 1 |
| Rohit | 0 |
| Sneha | 0 |

---

### Bonus 3: Customers with More Than One Order (Repeat Customers via HAVING)
```sql
SELECT c.customer_name,
       COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) > 1;
```
| customer_name | total_orders |
|---|---|
| Rahul | 2 |

---

### Bonus 4: City-wise Revenue Generation
```sql
SELECT c.city,
       SUM(o.order_amount) AS revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY revenue DESC;
```
| city | revenue (Rs) |
|---|---|
| Mumbai | 7,500 |
| Pune | 7,000 |
| Hyderabad | 3,000 |

---

### Bonus 5: Highest Single Order per Customer
```sql
SELECT c.customer_name,
       MAX(o.order_amount) AS highest_order
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY highest_order DESC;
```
| customer_name | highest_order (Rs) |
|---|---|
| Priya | 7,000 |
| Rahul | 5,000 |
| Amit | 3,000 |

---

## Technical Summary of SQL Join Types

| Join Type | Description | Handling of Unmatched Rows |
|---|---|---|
| INNER JOIN | Returns only matched rows from both tables | Excluded entirely |
| LEFT JOIN | Returns all rows from left table, matches from right | Right columns populated with NULL |
| RIGHT JOIN | Returns all rows from right table, matches from left | Left columns populated with NULL |
| FULL OUTER JOIN | Returns all rows from both tables | Missing side populated with NULL |
| ANTI-JOIN | `LEFT JOIN ... WHERE right.key IS NULL` | Filters exclusively for unmatched rows |
| SELF JOIN | Table joined to itself via primary-foreign key relationship | Unmatched levels resolved via `LEFT JOIN` |
| CROSS JOIN | Generates all permutations (Cartesian product: $M \times N$) | No join condition required |

---

## Terminal Verification Screenshots

All queries were verified directly in the PostgreSQL terminal:

1. `01_inner_join_and_left_join.png`: INNER JOIN (matching customers) and LEFT JOIN (all customers with null padding)
2. `02_right_join_and_full_join.png`: RIGHT JOIN (orphaned orders) and FULL OUTER JOIN (complete union of matches and discrepancies)
3. `03_anti_joins_unmatched_records.png`: Anti-Join patterns identifying inactive customers and invalid foreign keys
4. `04_self_join_employee_hierarchy.png`: SELF JOIN modeling hierarchical employee-to-manager relationships
5. `05_cross_join_cartesian_product.png`: CROSS JOIN generating full Cartesian product (25 rows)
6. `06_customer_spending_and_top_spender.png`: Total spending per customer and top customer identification
7. `07_second_highest_spender_and_order_count.png`: Second highest spending customer via DENSE_RANK() and order counts
8. `08_repeat_customers_city_revenue_highest_order.png`: Repeat customers via HAVING, revenue by city, and highest single order per customer

---

## Key Business & Engineering Insights

1. Data Quality Assurance: Anti-join queries (`WHERE right_key IS NULL`) serve as critical automated data hygiene checks to spot orphaned orders that lack valid customer master records.
2. Inactive Customer Re-engagement: Left joins allow marketing teams to segment registered customers who have never placed an order (`Rohit`, `Sneha`) for targeted re-engagement campaigns.
3. Hierarchical Modeling: Self joins provide an efficient mechanism to flatten recursive organizational structures into human-readable reporting tables.
4. Retention Analysis: Combining `JOIN` with `HAVING COUNT(order_id) > 1` isolates repeat buyers (`Rahul`) to calculate customer retention metrics.

---

## LinkedIn Post Draft

```text
Day 8 of #11Days11SQLProblems: Advanced Relational JOINs in PostgreSQL

Today I completed Day 8 of my 11 Days SQL Challenge by diving into advanced relational joins, data discrepancy detection, and hierarchical modeling.

Key Technical Skills Applied:
- Core Relational Joins: INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN
- Anti-Join Patterns: Filtering on IS NULL to detect orphaned records and inactive users
- Advanced Join Architectures: SELF JOIN for employee-manager organizational hierarchies, CROSS JOIN for Cartesian analysis
- Revenue & Cohort Aggregation: Grouping multi-table joins with HAVING filters and DENSE_RANK() window functions

Key Technical Findings:
- Anti-Join Diagnostics: Isolated 2 zero-order customers and 1 orphaned order violating referential integrity.
- Self Join Hierarchy: Successfully mapped a 3-tier corporate hierarchy from individual contributors to executive leadership.
- Financial Synthesis: Rahul emerged as top customer (Rs 7,500 across 2 orders), with Priya ranking second (Rs 7,000 single order).

GitHub Repository:
https://github.com/Nirrajkadam/11_Days_11_SQL_Problems/tree/main/Day8_Advanced_JOINs

#SQL #PostgreSQL #SQLJoins #DataModeling #DataAnalytics #DataEngineering #DatabaseDesign #11DaysOfSQL
```

---

## Day 8 Completion Checklist
- Database Created (`day8_advanced_joins`)
- Tables Created (`customers`, `orders`, `employees`)
- Sample Data Populated with Deliberate Discrepancies
- Core Joins Executed (INNER, LEFT, RIGHT, FULL)
- Anti-Join Queries Executed (Inactive Customers, Orphaned Orders)
- Structural Joins Executed (SELF JOIN, CROSS JOIN)
- Aggregation Queries Executed (Spending, Top Spender)
- Bonus Interview Queries Implemented (DENSE_RANK, HAVING, Max Order, City Revenue)
- All 8 Terminal Screenshots Verified and Linked
- Git Repository Synchronized and Pushed
