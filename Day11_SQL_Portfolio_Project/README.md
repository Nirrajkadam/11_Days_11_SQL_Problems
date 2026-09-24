# Day 11: SQL Portfolio Project - E-Commerce Business Intelligence System

Welcome to Day 11 of the 11 Days 11 SQL Problems Challenge.
Day 11 serves as the comprehensive capstone portfolio project synthesizing the full spectrum of relational database engineering and business analytics skills acquired across the 11-day challenge.

Using a real-world enterprise dataset of 1,590 orders across 35 Indian states and 305 cities, this project implements an end-to-end E-Commerce Business Intelligence and Analytics System in PostgreSQL within database `day11_sql_portfolio_project`.

---

## Project Structure

```text
Day11_SQL_Portfolio_Project
|
|-- README.md
|-- insights.md
|-- queries.sql
|-- screenshots/
|   |-- 01_create_db_table_and_copy_orders.png
|   |-- 02_dataset_profile_kpi_and_revenue_by_state.png
|   |-- 03_top_products_and_delivery_performance.png
|   |-- 04_customer_segmentation.png
|   `-- 05_monthly_revenue_trend_and_date_check.png
`-- dataset/
    |-- OrdersCleaned_UTF8.csv
    `-- schema_and_data.sql
```

---

## Database and Table Setup

Database: `day11_sql_portfolio_project`

```sql
CREATE DATABASE day11_sql_portfolio_project;
\c day11_sql_portfolio_project;

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

## Dataset Profile & Key Business Sections

### Section 0: Dataset Quick Profile
```sql
SELECT COUNT(*) AS total_orders,
       COUNT(DISTINCT state) AS states,
       COUNT(DISTINCT city) AS cities,
       COUNT(DISTINCT product_name) AS products,
       SUM(total) AS revenue
FROM orders;
```
Output:

| total_orders | states | cities | products | revenue (Rs) |
|---|---|---|---|---|
| 1,590 | 35 | 305 | 17 | 2,803,006.00 |

---

### Section 1: Executive KPI Dashboard
```sql
SELECT COUNT(*) AS total_orders,
       SUM(total) AS total_revenue,
       ROUND(AVG(total), 2) AS avg_order_value
FROM orders;
```
Output:

| total_orders | total_revenue (Rs) | avg_order_value (Rs) |
|---|---|---|
| 1,590 | 2,803,006.00 | 1,762.90 |

---

### Section 2: Geographic Revenue Distribution by State
```sql
SELECT state,
       SUM(total) AS revenue
FROM orders
GROUP BY state
ORDER BY revenue DESC;
```
Top 10 State Revenue Output:

| rank | state | revenue (Rs) | Revenue Share (%) |
|---|---|---|---|
| 1 | Maharashtra | 488,534.00 | 17.43% |
| 2 | Karnataka | 340,498.00 | 12.15% |
| 3 | Delhi | 222,527.00 | 7.94% |
| 4 | Tamil Nadu | 214,323.00 | 7.65% |
| 5 | Uttar Pradesh | 198,235.00 | 7.07% |
| 6 | Telangana | 168,613.00 | 6.02% |
| 7 | West Bengal | 153,083.00 | 5.46% |
| 8 | Gujarat | 135,277.00 | 4.83% |
| 9 | Andhra Pradesh | 114,064.00 | 4.07% |
| 10 | Haryana | 110,073.00 | 3.93% |

---

### Section 3: Product Portfolio Performance (17 SKUs)
```sql
SELECT product_name,
       COUNT(*) AS orders,
       SUM(total) AS revenue
FROM orders
GROUP BY product_name
ORDER BY revenue DESC;
```
Output:

| product_name | orders | revenue (Rs) | Unit Price Bracket |
|---|---|---|---|
| One Month Weight-Loss (Peach) | 252 | 862,760.00 | Premium (Rs 3,423 AOV) |
| One Month Weight-Loss (Mint) | 182 | 613,415.00 | Premium (Rs 3,370 AOV) |
| One Week Weight-Loss (Peach) | 277 | 299,814.00 | Entry Hook (Rs 1,082 AOV) |
| One Week Weight-Loss (Mint) | 261 | 284,575.00 | Entry Hook (Rs 1,090 AOV) |
| One Month Detox | 125 | 270,364.00 | Mid Tier (Rs 2,162 AOV) |
| One Week Detox Trial | 262 | 180,412.00 | Entry Hook (Rs 688 AOV) |
| One Month Keto Booster | 28 | 83,827.00 | Specialist Tier (Rs 2,993 AOV) |
| One Week Keto Booster | 101 | 70,389.00 | Entry Hook (Rs 696 AOV) |
| category | 35 | 62,846.00 | Mid Tier (Rs 1,795 AOV) |
| Lean Bar Week | 33 | 41,860.00 | Low Velocity (Rs 1,268 AOV) |
| pname | 18 | 11,700.00 | Low Velocity |
| One Month Immuni-Tea Booster | 2 | 6,678.00 | Specialist Tier |
| One Week Immuni-Tea Booster | 8 | 4,138.00 | Low Velocity |
| SKIN x SLEEP : 1 Week Plan | 1 | 3,719.00 | Niche Tier |
| GLOW: 14-Day Skincare Plan | 3 | 3,515.00 | Niche Tier |
| GLOW: 1 Month Skincare Plan | 1 | 1,996.00 | Niche Tier |
| One Month Glow regime - Week | 1 | 998.00 | Niche Tier |

---

### Section 4: Delivery & Fulfillment Performance
```sql
SELECT status,
       COUNT(*) AS orders,
       ROUND(
           COUNT(*) * 100.0 /
           (SELECT COUNT(*) FROM orders), 2
       ) AS percentage
FROM orders
GROUP BY status;
```
Output:

| status | orders | percentage (%) | Supply Chain Evaluation |
|---|---|---|---|
| Delivered | 1,401 | 88.11% | Successful Fulfillment |
| Returned | 187 | 11.76% | Reverse Logistics Cost Leakage |
| RTO | 2 | 0.13% | In-Transit Undelivered |

---

### Section 5: Customer Value Tier Segmentation
```sql
SELECT name,
       SUM(total) AS spending,
       CASE
           WHEN SUM(total) >= 10000 THEN 'Premium'
           WHEN SUM(total) >= 5000 THEN 'Gold'
           ELSE 'Regular'
       END AS customer_segment
FROM orders
GROUP BY name;
```
Sample Captured Output:

| name | spending (Rs) | customer_segment |
|---|---|---|
| Rid | 9,104.00 | Gold |
| Nak | 2,156.00 | Regular |
| Tir | 950.00 | Regular |
| Stu | 999.00 | Regular |
| Say | 4,595.00 | Regular |
| Nas | 7,013.00 | Gold |
| Han | 722.00 | Regular |
| Cha | 11,745.00 | Premium |
| Neh | 38,692.00 | Premium |
| Hem | 14,190.00 | Premium |

---

### Section 6: Monthly Revenue Trend & Run Rate
```sql
SELECT DATE_TRUNC('month', date_placed) AS revenue_month,
       SUM(total) AS revenue
FROM orders
GROUP BY DATE_TRUNC('month', date_placed)
ORDER BY DATE_TRUNC('month', date_placed);
```
Output:

| revenue_month | revenue (Rs) | Strategic Commentary |
|---|---|---|
| 2020-12-01 00:00:00 | 2,517.00 | Soft Launch & Infrastructure Testing |
| 2021-01-01 00:00:00 | 2,800,489.00 | Full Commercial Scale-up |

---

### Section 7: Window Function Ranking
```sql
SELECT name,
       SUM(total) AS spending,
       RANK() OVER(
           ORDER BY SUM(total) DESC
       ) AS customer_rank
FROM orders
GROUP BY name;
```

---

### Section 8: Virtual Database View
```sql
CREATE OR REPLACE VIEW top_customers AS
SELECT name,
       SUM(total) AS spending
FROM orders
GROUP BY name;

SELECT * FROM top_customers ORDER BY spending DESC LIMIT 10;
```

---

### Section 9 & 10: Performance Indexing and Execution Diagnostics
```sql
CREATE INDEX IF NOT EXISTS idx_state ON orders(state);
CREATE INDEX IF NOT EXISTS idx_status ON orders(status);

EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE state = 'Maharashtra';
```

---

## Terminal Verification Screenshots

All case study implementations were validated in PostgreSQL:

1. `01_create_db_table_and_copy_orders.png`: Database creation, DDL execution, and CSV bulk import (1,590 rows)
2. `02_dataset_profile_kpi_and_revenue_by_state.png`: Quick profile diagnostics, KPI summary, and state-wise revenue table
3. `03_top_products_and_delivery_performance.png`: Complete 17-product ranking and fulfillment status breakdown
4. `04_customer_segmentation.png`: Dynamic customer value tier grouping (Premium, Gold, Regular)
5. `05_monthly_revenue_trend_and_date_check.png`: Monthly revenue trend evaluation and timestamp verification

---

## Strategic Executive Insights Summary

Detailed findings and operational recommendations are fully articulated in [insights.md](insights.md):

1. Hero Product Reliance: 52.66% of gross revenue depends on two SKUs (One Month Weight-Loss Peach and Mint).
2. Trial Funnel Optimization: Over 800 trial orders indicate strong acquisition interest but require systematic CRM nurturing to convert users into monthly subscribers.
3. Supply Chain Vulnerability: 11.76% return rate ties up Rs 304,000+ in reverse logistics costs, driven largely by uncommitted Cash on Delivery transactions.
4. Logistics Hubs: Maharashtra and Karnataka represent 29.58% of national demand, making them ideal locations for regional fulfillment nodes.

---

## Final LinkedIn Challenge Post Draft

```text
Day 11 of #11Days11SQLProblems: Challenge Completed

Over the past 11 days, I completed an intensive, hands-on SQL and PostgreSQL engineering challenge, solving real-world analytical problems across banking, personal finance, fraud analytics, e-commerce, and enterprise operational datasets.

Core Skills Mastered Across 11 Days:
- SQL Fundamentals & Data Modeling (DDL, DML, Constraints, System Catalogs)
- Multi-Table Relational Architectures (INNER, LEFT, RIGHT, FULL OUTER, SELF, CROSS, Anti-Joins)
- Advanced Query Logic (Subqueries, Correlated Subqueries, CTEs, CASE WHEN)
- Analytical Window Functions (ROW_NUMBER, RANK, DENSE_RANK, LEAD, LAG, NTILE, FIRST_VALUE, LAST_VALUE)
- Performance Engineering & Optimization (Virtual Views, B-Tree Indexes, EXPLAIN ANALYZE execution plans)
- Procedural SQL Development (User-Defined Functions, Stored Procedures, Event Triggers, Audit Logging)
- Data Wrangling & Quality Assurance (String standardization, Date manipulation, NULL handling with COALESCE/NULLIF)
- Executive Business Intelligence (End-to-end case studies, RFM customer segmentation, KPI dashboards)

Capstone Portfolio Project:
Built an E-Commerce Business Intelligence & Analytics System analyzing 1,590 orders across 35 states and 305 cities, uncovering revenue drivers, product portfolio economics, delivery return rates, and customer lifetime value tiers.

GitHub Repository:
https://github.com/Nirrajkadam/11_Days_11_SQL_Problems

This challenge strengthened my database design, query optimization, and data analytics problem-solving abilities. Looking forward to applying these skills to production data engineering and analytics engineering pipelines.

#SQL #PostgreSQL #DataAnalytics #DataEngineering #BusinessIntelligence #DatabaseDesign #AnalyticsEngineering #LearningInPublic #11Days11SQLProblems
```

---

## Day 11 Completion Checklist
- Database Created (`day11_sql_portfolio_project`)
- 1,590 Orders Imported via `\copy`
- Dataset Profile Analyzed (35 states, 305 cities, 17 products, Rs 2.80M revenue)
- Executive KPI Dashboard Implemented
- State-wise Revenue Distribution Computed
- Complete 17-Product Portfolio Ranked by Revenue
- Delivery & Fulfillment Status Evaluated
- Customer Value Tier Segmentation Configured
- Monthly Revenue Trend Evaluated
- Database View and Performance Indexes Created
- 8 Deep Strategic Insights Documented in `insights.md`
- All 5 Terminal Screenshots Verified and Linked
- Git Repository Synchronized and Pushed
