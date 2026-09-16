# Day 3: E-Commerce Data Analytics (SQL JOINs and CASE WHEN Logic)

Welcome to Day 3 of the 11 Days 11 SQL Problems Challenge.
In Day 3, we analyzed an E-Commerce dataset of 1,590 orders in PostgreSQL database day3_ecommerce_analysis. We built a relational customer table, performed SQL JOIN operations (INNER JOIN, LEFT JOIN), and implemented business conditional logic using CASE WHEN statements.

---

## Project Structure

```text
Day3_Ecommerce_JOINs_CaseWhen
│
├── README.md
├── queries.sql
├── screenshots/
│   ├── 01_copy_dataset_and_totals.png
│   ├── 02_status_iscod_state_breakdown.png
│   ├── 03_product_name_and_returned.png
│   ├── 04_create_customers_inner_join.png
│   ├── 05_customer_revenue_city_state_join.png
│   ├── 06_state_status_join.png
│   ├── 07_customer_revenue_state_join.png
│   ├── 08_high_value_case_summary.png
│   ├── 09_id_order_type_case_limit20.png
│   └── 10_advanced_case_join_full.png
└── dataset/
    ├── OrdersCleaned_UTF8.csv
    └── schema_and_data.sql
```

---

## Database and Relational Schema Setup

Database: day3_ecommerce_analysis

```sql
CREATE DATABASE day3_ecommerce_analysis;
\c day3_ecommerce_analysis;

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

\copy orders FROM 'C:/Users/kadam/Downloads/11_day_11_problem/Dataset/OrdersCleaned_UTF8.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';

-- Create relational Customers table from Orders dataset
CREATE TABLE customers AS
SELECT DISTINCT
       id AS customer_id,
       name,
       city,
       state
FROM orders;
```

---

## Executed SQL Queries and Output

### 1. Dataset Overview and Total Revenue
```sql
SELECT COUNT(*) FROM orders;
SELECT ROUND(SUM(total), 2) AS total_revenue FROM orders;
```
- Total Orders: 1,590
- Total Revenue: Rs 2,803,006.00

---

### 2. Relational Table Verification and INNER JOIN
```sql
SELECT COUNT(*) FROM customers;

SELECT c.customer_id,
       c.name,
       c.city,
       o.product_name,
       o.total
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.id
LIMIT 5;
```
| customer_id | name | city | product_name | total |
|---|---|---|---|---|
| 30145 | Man | Nayagarh | One Week Weight-Loss (Peach) | 999.00 |
| 30144 | Dik | Thane | One Week Detox Trial | 599.00 |
| 30143 | Shi | Bangalore | One Week Detox Trial | 599.00 |
| 30142 | Pre | Mumbai | One Month Weight-Loss (Peach) | 3596.00 |
| 30138 | Dr. | Pauri Garhwal | One Week Weight-Loss (Mint) | 999.00 |

---

### 3. Customer Revenue Analysis (INNER JOIN + GROUP BY)
```sql
SELECT c.name,
       c.state,
       COUNT(*) AS total_orders,
       SUM(o.total) AS revenue
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.id
GROUP BY c.name, c.state
ORDER BY revenue DESC
LIMIT 5;
```
| name | state | total_orders | revenue (Rs) |
|---|---|---|---|
| Poo | Maharashtra | 13 | 27,161.00 |
| Pri | Maharashtra | 5 | 13,403.00 |
| San | Karnataka | 8 | 12,630.00 |
| Sri | Andhra Pradesh | 6 | 12,008.00 |
| Sne | Maharashtra | 4 | 11,559.00 |

---

### 4. Order Delivery Status Breakdown by State (JOIN + GROUP BY)
```sql
SELECT c.state,
       o.status,
       COUNT(*) AS orders
FROM customers c
JOIN orders o
ON c.customer_id = o.id
GROUP BY c.state, o.status
ORDER BY orders DESC
LIMIT 5;
```
| state | status | orders |
|---|---|---|
| Maharashtra | Delivered | 259 |
| Karnataka | Delivered | 162 |
| Delhi | Delivered | 125 |
| Tamil Nadu | Delivered | 104 |
| Uttar Pradesh | Delivered | 91 |

---

### 5. Order Value Categorization (CASE WHEN Summary)
```sql
SELECT
    CASE
        WHEN total >= 2000 THEN 'High Value'
        ELSE 'Normal Value'
    END AS order_type,
    COUNT(*) AS orders,
    SUM(total) AS revenue
FROM orders
GROUP BY order_type;
```
| order_type | orders | revenue (Rs) | Share (%) |
|---|---|---|---|
| High Value (>= Rs 2,000) | 583 | Rs 1,861,969.00 | 66.4% |
| Normal Value (< Rs 2,000) | 1,007 | Rs 941,037.00 | 33.6% |

---

### 6. Order Result Segmentation (CASE WHEN)
```sql
SELECT
    CASE
        WHEN status = 'Delivered' THEN 'Successful'
        ELSE 'Failed/Returned'
    END AS order_result,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_result;
```
| order_result | total_orders | Percentage |
|---|---|---|
| Successful | 1,401 | 88.1% |
| Failed/Returned | 189 | 11.9% |

---

### 7. Payment Channel Segmentation (CASE WHEN)
```sql
SELECT
    CASE
        WHEN iscod = TRUE THEN 'Cash on Delivery'
        ELSE 'Prepaid'
    END AS payment_type,
    COUNT(*) AS orders,
    SUM(total) AS revenue
FROM orders
GROUP BY payment_type;
```
| payment_type | orders | revenue (Rs) | Share (%) |
|---|---|---|---|
| Cash on Delivery | 1,012 | Rs 1,674,054.00 | 59.7% |
| Prepaid | 578 | Rs 1,128,952.00 | 40.3% |

---

### 8. Advanced CASE WHEN + JOIN (Order Category Distribution by State)
```sql
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
LIMIT 5;
```
| state | order_category | orders |
|---|---|---|
| Maharashtra | Normal Value | 182 |
| Karnataka | Normal Value | 112 |
| Maharashtra | High Value | 102 |
| Delhi | Normal Value | 87 |
| Karnataka | High Value | 74 |

---

## Key Business Insights

1. Revenue Concentration: High Value orders (>= Rs 2,000) represent only 36.7% of order volume (583 orders) but account for 66.4% of total revenue (Rs 1.86M out of Rs 2.80M).
2. Delivery Success Rate: 88.1% of orders (1,401 out of 1,590) were successfully delivered, while 11.9% (189 orders) resulted in returns/RTO.
3. Payment Method Dependency: Cash on Delivery (COD) generated Rs 1,674,054.00 (59.7% of revenue) across 1,012 orders, compared to Rs 1,128,952.00 (40.3%) from 578 Prepaid orders.
4. Top Customer Revenue: Customer Poo in Maharashtra led individual customer revenue with Rs 27,161.00 across 13 orders.

---

## LinkedIn Post Draft

```text
Day 3 of #11Days11SQLProblems: E-Commerce Analytics using SQL JOINs & CASE WHEN Logic

Today I completed Day 3 of my 11 Days SQL Challenge by performing relational table modeling, JOIN operations, and conditional segmentation on an E-Commerce dataset of 1,590 orders in PostgreSQL.

Key Technical Skills Applied:
- Relational Modeling (CREATE TABLE AS SELECT DISTINCT)
- SQL JOIN Operations (INNER JOIN, LEFT JOIN)
- Multi-column Aggregations (SUM, COUNT, GROUP BY)
- Conditional Business Logic (CASE WHEN ... THEN ... ELSE ... END)

Key Analytical Findings:
- Total Revenue Generated: Rs 2.80M across 1,590 transactions.
- High Value Revenue Dominance: High Value orders (>= Rs 2,000) account for 66.4% of total revenue (Rs 1.86M).
- Delivery Success Rate: 88.1% of orders (1,401) delivered, while 11.9% (189) resulted in returns/RTO.
- Revenue by Payment Type: Cash on Delivery (COD) accounts for 59.7% of total revenue (Rs 1.67M out of Rs 2.80M).

GitHub Repository:
https://github.com/Nirrajkadam/11_Days_11_SQL_Problems/tree/main/Day3_Ecommerce_JOINs_CaseWhen

#SQL #DataAnalytics #EcommerceAnalytics #PostgreSQL #DataScience #DataEngineering #11DaysOfSQL
```

---

## Day 3 Completion Check
- Database Created (day3_ecommerce_analysis)
- Relational Tables Created (orders, customers)
- 1,590 Orders Imported via \copy
- All JOIN and CASE WHEN Queries Executed
- All 10 Terminal Screenshots Saved
- Git Commit Completed
