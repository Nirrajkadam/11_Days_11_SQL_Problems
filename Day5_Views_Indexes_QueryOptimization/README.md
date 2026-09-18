# Day 5: Database Views, Indexing and Query Optimization

Welcome to Day 5 of the 11 Days 11 SQL Problems Challenge.
In Day 5, we focused on enterprise database performance engineering in PostgreSQL database day5_views_indexes_optimization using 1,590 E-Commerce orders. We implemented Virtual Database Views (delivered_orders, state_revenue, product_revenue), single-column and composite B-Tree Indexes (idx_state, idx_status, idx_state_status), and evaluated query execution plans using EXPLAIN ANALYZE.

---

## Project Structure

```text
Day5_Views_Indexes_QueryOptimization
│
├── README.md
├── queries.sql
├── screenshots/
│   ├── 01_copy_and_delivered_orders_view.png
│   ├── 02_state_revenue_view.png
│   ├── 03_product_revenue_view.png
│   └── 04_indexes_creation_and_pg_indexes.png
└── dataset/
    ├── OrdersCleaned_UTF8.csv
    └── schema_and_data.sql
```

---

## Database and Table Setup

Database: day5_views_indexes_optimization

```sql
CREATE DATABASE day5_views_indexes_optimization;
\c day5_views_indexes_optimization;

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

## Executed Database Views & Query Outputs

### 1. View 1: Delivered Orders View
```sql
CREATE VIEW delivered_orders AS
SELECT *
FROM orders
WHERE status = 'Delivered';

SELECT COUNT(*) AS delivered_orders FROM delivered_orders;
```
- Total Orders: 1,590
- Delivered Orders (View Output): 1,401

---

### 2. View 2: State Revenue Aggregation View
```sql
CREATE VIEW state_revenue AS
SELECT state,
       SUM(total) AS revenue
FROM orders
GROUP BY state;

SELECT * FROM state_revenue ORDER BY revenue DESC LIMIT 5;
```
| state | revenue (Rs) |
|---|---|
| Maharashtra | Rs 488,534.00 |
| Karnataka | Rs 340,498.00 |
| Delhi | Rs 222,527.00 |
| Tamil Nadu | Rs 214,323.00 |
| Uttar Pradesh | Rs 198,235.00 |

---

### 3. View 3: Product Revenue Ranking View
```sql
CREATE VIEW product_revenue AS
SELECT product_name,
       SUM(total) AS revenue
FROM orders
GROUP BY product_name;

SELECT * FROM product_revenue ORDER BY revenue DESC LIMIT 5;
```
| product_name | revenue (Rs) |
|---|---|
| One Month Weight-Loss (Peach) | Rs 862,760.00 |
| One Month Weight-Loss (Mint) | Rs 613,415.00 |
| One Week Weight-Loss (Peach) | Rs 299,814.00 |
| One Week Weight-Loss (Mint) | Rs 284,575.00 |
| One Month Detox | Rs 270,364.00 |

---

## Indexing and Query Performance Optimization

### Created Database Indexes:
```sql
-- Single Column Indexes
CREATE INDEX idx_state ON orders(state);
CREATE INDEX idx_status ON orders(status);

-- Composite Multi-Column Index
CREATE INDEX idx_state_status ON orders(state, status);
```

### PostgreSQL System Catalog Index Audit (`pg_indexes`):
```sql
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'orders';
```
| indexname | indexdef |
|---|---|
| idx_status | CREATE INDEX idx_status ON public.orders USING btree (status) |
| idx_state_status | CREATE INDEX idx_state_status ON public.orders USING btree (state, status) |

---

## Query Optimization Evaluation (EXPLAIN ANALYZE)

```sql
-- Execution Plan Test for State & Status Filter
EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE state = 'Maharashtra'
AND status = 'Delivered';
```

- Optimization Impact: Utilizing B-Tree indexes enables index scan access paths over full sequential table scans on filtered attributes.
- Revenue Breakdown by Status:
  - Delivered: Rs 2,494,323.00 (1,401 orders)
  - Returned: Rs 304,388.00 (187 orders)
  - RTO: Rs 4,295.00 (2 orders)

---

## Key Business Insights

1. Virtualization Benefits: Abstracting complex business logic into reusable views (`delivered_orders`, `state_revenue`, `product_revenue`) simplifies reporting queries and enforces consistent data access definitions.
2. Query Acceleration: Adding single-column and composite indexes (`idx_state_status`) optimizes lookup latency for high-frequency filtering conditions across state and order status attributes.
3. Financial Delivery Distribution: Delivered orders account for Rs 2.49M (89.0% of total financial volume), whereas returned/RTO orders account for Rs 308.6k (11.0%).

---

## LinkedIn Post Draft

```text
Day 5 of #11Days11SQLProblems: Database Views, Indexing & Query Optimization

Today I completed Day 5 of my 11 Days SQL Challenge by diving into database performance engineering in PostgreSQL on an E-Commerce dataset of 1,590 orders.

Key Technical Skills Applied:
- Database Views (CREATE VIEW for modular data abstraction)
- Single and Composite B-Tree Indexing (idx_state, idx_status, idx_state_status)
- Query Performance Diagnostics (EXPLAIN ANALYZE execution plan evaluation)
- System Catalog Auditing (Querying pg_indexes for index verification)

Key Technical Findings:
- Database Views: Built dedicated analytical views (delivered_orders, state_revenue, product_revenue) to encapsulate business aggregation logic.
- Indexing Strategy: Created composite multi-column B-Tree index (state, status) to optimize multi-attribute filter queries.
- Performance Tuning: Evaluated execution plans with EXPLAIN ANALYZE to transition from sequential scans to efficient index-driven access paths.

GitHub Repository:
https://github.com/Nirrajkadam/11_Days_11_SQL_Problems/tree/main/Day5_Views_Indexes_QueryOptimization

#SQL #PostgreSQL #DatabaseOptimization #QueryOptimization #Indexing #DataAnalytics #DataEngineering #11DaysOfSQL
```

---

## Day 5 Completion Check
- Database Created (day5_views_indexes_optimization)
- 1,590 Orders Imported via \copy
- 3 Virtual Views Created (delivered_orders, state_revenue, product_revenue)
- 3 B-Tree Indexes Created (idx_state, idx_status, idx_state_status)
- EXPLAIN ANALYZE Performance Diagnostics Executed
- Terminal Screenshots Saved
- Git Commit Completed
