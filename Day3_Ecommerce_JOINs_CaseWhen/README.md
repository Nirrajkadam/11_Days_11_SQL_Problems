# Day 3: E-Commerce Data Analytics (SQL JOINs and CASE WHEN Logic)

Welcome to Day 3 of the 11 Days 11 SQL Problems Challenge.
In Day 3, we advanced beyond single-table aggregations by introducing relational table design (creating customers table from orders), executing SQL JOIN operations (INNER JOIN, LEFT JOIN), and implementing business conditional logic using CASE WHEN statements on an E-Commerce dataset of 1,590 transactions.

---

## Project Structure

```text
Day3_Ecommerce_JOINs_CaseWhen
│
├── README.md
├── queries.sql
├── screenshots/
│   ├── 01_customers_table_creation.png
│   ├── 02_inner_join_query.png
│   ├── 03_customer_revenue_join.png
│   ├── 04_left_join_query.png
│   ├── 05_delivered_vs_returned_case.png
│   ├── 06_cod_vs_prepaid_case.png
│   └── 07_advanced_case_join.png
└── dataset/
    ├── OrdersCleaned_UTF8.csv
    └── schema_and_data.sql
```

---

## Database and Relational Schema Setup

Database: day3_ecommerce_db

```sql
CREATE DATABASE day3_ecommerce_db;
\c day3_ecommerce_db;

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

\copy orders FROM 'dataset/OrdersCleaned_UTF8.csv' DELIMITER ',' CSV HEADER;

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

### 1. Relational Table Verification
```sql
SELECT COUNT(*) AS total_customers FROM customers;
SELECT COUNT(*) AS total_orders FROM orders;
```
- Total Customers: 1,590
- Total Orders: 1,590

---

### 2. INNER JOIN (Matching Customer and Order Records)
```sql
SELECT c.customer_id,
       c.name,
       c.state,
       o.product_name,
       o.total
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.id
LIMIT 5;
```
| customer_id | name | state | product_name | total |
|---|---|---|---|---|
| 30145 | Man | Odisha | One Week Weight-Loss (Peach) | 999.00 |
| 30144 | Dik | Maharashtra | One Week Detox Trial | 599.00 |
| 30143 | Shi | Karnataka | One Week Detox Trial | 599.00 |
| 30142 | Pre | Maharashtra | One Month Weight-Loss (Peach) | 3596.00 |
| 30138 | Dr. | Uttarakhand | One Week Weight-Loss (Mint) | 999.00 |

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

### 4. LEFT JOIN Operation
```sql
SELECT c.customer_id,
       c.name,
       o.product_name
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.id
LIMIT 5;
```
Result: Successfully retains all customer entities while mapping corresponding order items.

---

### 5. Order Status Analysis (CASE WHEN: Successful vs Failed/Returned)
```sql
SELECT
    CASE
        WHEN status = 'Delivered' THEN 'Successful'
        ELSE 'Failed/Returned'
    END AS result,
    COUNT(*) AS orders
FROM orders
GROUP BY result;
```
| result | orders | Percentage |
|---|---|---|
| Successful | 1,401 | 88.1% |
| Failed/Returned | 189 | 11.9% |

---

### 6. Payment Segmentation Analysis (CASE WHEN: COD vs Prepaid)
```sql
SELECT
    CASE
        WHEN iscod = TRUE THEN 'COD'
        ELSE 'Prepaid'
    END AS payment_type,
    COUNT(*) AS total_orders,
    SUM(total) AS revenue
FROM orders
GROUP BY payment_type;
```
| payment_type | total_orders | revenue (Rs) | Share (%) |
|---|---|---|---|
| COD | 1,012 | Rs 1,674,054.00 | 59.7% |
| Prepaid | 578 | Rs 1,128,952.00 | 40.3% |

---

### 7. Advanced CASE WHEN + JOIN (Order Category Distribution by State)
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

1. Order Delivery Performance: 88.1% of orders (1,401 out of 1,590) were successfully delivered, while 11.9% (189 orders) resulted in returns or failed delivery.
2. Payment Channel Preference: Cash on Delivery (COD) represents 59.7% of total revenue (Rs 1.67M out of Rs 2.80M total), indicating high dependency on post-delivery collections.
3. Customer Concentration: Top customer Poo in Maharashtra generated Rs 27,161 across 13 orders.
4. Geographic Segmentation: Maharashtra and Karnataka emerge as top states for both normal value (< Rs 2,000) and high value (>= Rs 2,000) order volume.

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
- Delivery Success Rate: 88.1% of orders (1,401) were successfully delivered, while 11.9% (189) resulted in returns.
- Revenue by Payment Type: Cash on Delivery (COD) accounts for 59.7% of total revenue (Rs 1.67M out of Rs 2.80M).
- Geographic Revenue Leaders: Maharashtra and Karnataka generated highest order volumes across both High Value (>= Rs 2,000) and Normal Value segments.

GitHub Repository:
https://github.com/Nirrajkadam/11_Days_11_SQL_Problems/tree/main/Day3_Ecommerce_JOINs_CaseWhen

#SQL #DataAnalytics #EcommerceAnalytics #PostgreSQL #DataScience #DataEngineering #11DaysOfSQL
```

---

## Day 3 Completion Check
- Database Created (day3_ecommerce_db)
- Relational Tables Created (orders, customers)
- 1,590 Orders Imported and Verified
- INNER JOIN and LEFT JOIN Queries Executed
- CASE WHEN Conditional Logic Executed
- Terminal Screenshots Saved in screenshots/
- Git Commit Completed
