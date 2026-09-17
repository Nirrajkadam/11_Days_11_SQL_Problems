# Day 4: Subqueries, HAVING Clause, CTEs and Advanced Window Functions

Welcome to Day 4 of the 11 Days 11 SQL Problems Challenge.
In Day 4, we scaled up our SQL capabilities by analyzing an E-Commerce dataset of 1,590 orders in PostgreSQL database day4_ecommerce_analysis_sub_cte using Subqueries, HAVING clauses, Common Table Expressions (WITH clause CTEs), and Advanced Window Functions (RANK, DENSE_RANK, LAG, and Running Totals).

---

## Project Structure

```text
Day4_Subqueries_CTE_WindowFunctions
│
├── README.md
├── queries.sql
├── screenshots/
│   ├── 01_create_table_and_copy.png
│   ├── 02_orders_above_avg_subquery.png
│   ├── 03_having_revenue_and_products.png
│   ├── 04_cte_state_revenue.png
│   └── 05_cte_filter_and_rank.png
└── dataset/
    ├── OrdersCleaned_UTF8.csv
    └── schema_and_data.sql
```

---

## Database and Table Setup

Database: day4_ecommerce_analysis_sub_cte

```sql
CREATE DATABASE day4_ecommerce_analysis_sub_cte;
\c day4_ecommerce_analysis_sub_cte;

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

\copy orders FROM 'C:/Users/kadam/Downloads/11_day_11_problem/Dataset/OrdersCleaned_UTF8.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';
```

---

## Executed SQL Queries and Output

### 1. Subquery: Orders Greater than Average Order Value
```sql
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
```
| id | name | total (Rs) |
|---|---|---|
| 28022 | Jei | 7,992.00 |
| 28143 | Sha | 7,593.00 |
| 28196 | Ree | 7,593.00 |
| 27907 | Nad | 6,833.00 |
| 29165 | Poo | 6,833.00 |

---

### 2. HAVING Clause: States Generating Revenue > Rs 100,000
```sql
SELECT state,
       SUM(total) AS revenue
FROM orders
GROUP BY state
HAVING SUM(total) > 100000
ORDER BY revenue DESC;
```
| state | revenue (Rs) |
|---|---|
| Maharashtra | Rs 488,534.00 |
| Karnataka | Rs 340,498.00 |
| Delhi | Rs 222,527.00 |
| Tamil Nadu | Rs 214,323.00 |
| Uttar Pradesh | Rs 198,235.00 |
| Telangana | Rs 168,613.00 |
| West Bengal | Rs 153,083.00 |
| Gujarat | Rs 135,277.00 |
| Andhra Pradesh | Rs 114,064.00 |
| Haryana | Rs 110,073.00 |

---

### 3. HAVING Clause: Products Sold More Than 50 Times
```sql
SELECT product_name,
       COUNT(*) AS total_orders
FROM orders
GROUP BY product_name
HAVING COUNT(*) > 50
ORDER BY total_orders DESC;
```
| product_name | total_orders |
|---|---|
| One Week Weight-Loss (Peach) | 277 |
| One Week Detox Trial | 262 |
| One Week Weight-Loss (Mint) | 261 |
| One Month Weight-Loss (Peach) | 252 |
| One Month Weight-Loss (Mint) | 182 |
| One Month Detox | 125 |
| One Week Keto Booster | 101 |

---

### 4. CTE (WITH Clause): Revenue by State
```sql
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
```
Result: Successfully encapsulated state aggregations inside modular CTE expression.

---

### 5. CTE + Filter: States Generating Revenue > Rs 200,000
```sql
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
```
| state | revenue (Rs) |
|---|---|
| Maharashtra | Rs 488,534.00 |
| Karnataka | Rs 340,498.00 |
| Delhi | Rs 222,527.00 |
| Tamil Nadu | Rs 214,323.00 |

---

### 6. State Wise Revenue Ranking using RANK()
```sql
SELECT state,
       SUM(total) AS revenue,
       RANK() OVER (ORDER BY SUM(total) DESC) AS state_rank
FROM orders
GROUP BY state;
```
| state | revenue (Rs) | state_rank |
|---|---|---|
| Maharashtra | Rs 488,534.00 | 1 |
| Karnataka | Rs 340,498.00 | 2 |
| Delhi | Rs 222,527.00 | 3 |
| Tamil Nadu | Rs 214,323.00 | 4 |
| Uttar Pradesh | Rs 198,235.00 | 5 |

---

### 7. Product Revenue Ranking using RANK()
```sql
SELECT product_name,
       SUM(total) AS revenue,
       RANK() OVER (ORDER BY SUM(total) DESC) AS product_rank
FROM orders
GROUP BY product_name;
```
| product_name | revenue (Rs) | product_rank |
|---|---|---|
| One Month Weight-Loss (Peach) | Rs 862,760.00 | 1 |
| One Month Weight-Loss (Mint) | Rs 613,415.00 | 2 |
| One Week Weight-Loss (Peach) | Rs 299,814.00 | 3 |
| One Week Weight-Loss (Mint) | Rs 284,575.00 | 4 |
| One Month Detox | Rs 270,364.00 | 5 |

---

### 8. Customer Spending Ranking using DENSE_RANK()
```sql
SELECT name,
       SUM(total) AS spending,
       DENSE_RANK() OVER (ORDER BY SUM(total) DESC) AS customer_rank
FROM orders
GROUP BY name;
```
| name | spending (Rs) | customer_rank |
|---|---|---|
| Sha | Rs 71,249.00 | 1 |
| Pra | Rs 61,985.00 | 2 |
| San | Rs 61,911.00 | 3 |
| Man | Rs 60,009.00 | 4 |
| Poo | Rs 48,848.00 | 5 |

---

### 9. Revenue Contribution Percentage by State
```sql
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
```
| state | revenue (Rs) | contribution_percent (%) |
|---|---|---|
| Maharashtra | Rs 488,534.00 | 17.43% |
| Karnataka | Rs 340,498.00 | 12.15% |
| Delhi | Rs 222,527.00 | 7.94% |
| Tamil Nadu | Rs 214,323.00 | 7.65% |
| Uttar Pradesh | Rs 198,235.00 | 7.07% |

---

### 10. Running Revenue Total Across States
```sql
SELECT state,
       SUM(total) AS revenue,
       SUM(SUM(total)) OVER (ORDER BY SUM(total) DESC) AS running_revenue
FROM orders
GROUP BY state;
```
| state | revenue (Rs) | running_revenue (Rs) |
|---|---|---|
| Maharashtra | Rs 488,534.00 | Rs 488,534.00 |
| Karnataka | Rs 340,498.00 | Rs 829,032.00 |
| Delhi | Rs 222,527.00 | Rs 1,051,559.00 |
| Tamil Nadu | Rs 214,323.00 | Rs 1,265,882.00 |
| Uttar Pradesh | Rs 198,235.00 | Rs 1,464,117.00 |

---

### 11. Previous State Revenue Comparison using LAG()
```sql
SELECT state,
       SUM(total) AS revenue,
       LAG(SUM(total)) OVER(ORDER BY SUM(total) DESC) AS previous_revenue
FROM orders
GROUP BY state;
```
| state | revenue (Rs) | previous_revenue (Rs) |
|---|---|---|
| Maharashtra | Rs 488,534.00 | NULL |
| Karnataka | Rs 340,498.00 | Rs 488,534.00 |
| Delhi | Rs 222,527.00 | Rs 340,498.00 |
| Tamil Nadu | Rs 214,323.00 | Rs 222,527.00 |
| Uttar Pradesh | Rs 198,235.00 | Rs 214,323.00 |

---

## Key Business Insights

1. Geographic Contribution: Maharashtra generates 17.43% of total revenue (Rs 488,534.00), followed by Karnataka (12.15% / Rs 340,498.00) and Delhi (7.94% / Rs 222,527.00). Top 5 states combined generate nearly 52.2% of overall revenue.
2. Product Revenue Performance: While One Week Weight-Loss (Peach) leads in unit sales volume (277 orders), One Month Weight-Loss (Peach) ranks #1 in revenue (Rs 862,760.00) due to higher per-unit pricing.
3. Top Customer Spending: Customer Sha leads overall customer spending with Rs 71,249.00 (Rank 1 via DENSE_RANK).
4. High Revenue Tier States: Only 4 states (Maharashtra, Karnataka, Delhi, Tamil Nadu) generate revenue exceeding Rs 200,000.

---

## LinkedIn Post Draft

```text
Day 4 of #11Days11SQLProblems: Advanced Subqueries, CTEs & Window Functions Analytics

Today I completed Day 4 of my 11 Days SQL Challenge by performing advanced query techniques including CTEs, Subqueries, HAVING filters, and Window Functions (RANK, DENSE_RANK, LAG, Running Totals) on 1,590 E-Commerce orders in PostgreSQL.

Key Technical Skills Applied:
- Subqueries & HAVING Clause (Filtering aggregated states & products)
- Common Table Expressions (WITH clause for modular query structures)
- Advanced Window Functions (RANK, DENSE_RANK for customer/state rankings)
- Comparative Analytics (LAG function & Cumulative Running Revenue)

Key Analytical Findings:
- Revenue Contribution Leaders: Maharashtra (17.43% / Rs 488k) and Karnataka (12.15% / Rs 340k) drive top revenue shares.
- Product Performance Split: One Month Weight-Loss (Peach) generated highest revenue (Rs 862k), while One Week Weight-Loss (Peach) led in transaction volume (277 orders).
- Customer Segmentation: Top spender Sha generated Rs 71,249 across orders.

GitHub Repository:
https://github.com/Nirrajkadam/11_Days_11_SQL_Problems/tree/main/Day4_Subqueries_CTE_WindowFunctions

#SQL #DataAnalytics #PostgreSQL #Subqueries #CTE #WindowFunctions #DataScience #DataEngineering #11DaysOfSQL
```

---

## Day 4 Completion Check
- Database Created (day4_ecommerce_analysis_sub_cte)
- 1,590 Orders Imported via \copy
- All 12 Subquery, HAVING, CTE, and Window Function Queries Executed
- Terminal Screenshots Saved
- Git Commit Completed
