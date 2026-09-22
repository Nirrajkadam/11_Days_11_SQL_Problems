# Day 9: Advanced Window Functions (ROW_NUMBER, RANK, DENSE_RANK, LEAD, LAG, NTILE, FIRST_VALUE, LAST_VALUE)

Welcome to Day 9 of the 11 Days 11 SQL Problems Challenge.
In Day 9, we focused on enterprise analytical SQL using Advanced Window Functions in PostgreSQL within database `day9_advanced_window_functions`. Window functions enable calculations across a set of table rows that are related to the current row without collapsing rows into a single summary output like standard `GROUP BY` aggregations.

We implemented ranking mechanics (`ROW_NUMBER`, `RANK`, `DENSE_RANK`), chronological navigation (`LEAD`, `LAG`), cumulative revenue tracking (Running Totals), boundary lookups (`FIRST_VALUE`, `LAST_VALUE` with explicit window framing), bucket distribution (`NTILE`), and partitioned Top-N group filtering.

---

## Project Structure

```text
Day9_Advanced_Window_Functions
|
|-- README.md
|-- queries.sql
|-- screenshots/
|   |-- 01_create_db_table_and_insert.png
|   |-- 02_row_number_and_rank.png
|   |-- 03_dense_rank_and_running_total.png
|   |-- 04_lead_and_lag.png
|   `-- 05_first_value_and_last_value.png
`-- dataset/
    `-- schema_and_data.sql
```

---

## Database and Table Setup

Database: `day9_advanced_window_functions`

```sql
CREATE DATABASE day9_advanced_window_functions;
\c day9_advanced_window_functions;

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    salesperson VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL,
    sale_amount NUMERIC(10,2) NOT NULL,
    sale_date DATE NOT NULL
);

INSERT INTO sales (salesperson, region, sale_amount, sale_date)
VALUES
('Rahul', 'West', 5000.00, '2025-01-01'),
('Priya', 'West', 7000.00, '2025-01-02'),
('Amit', 'North', 3000.00, '2025-01-03'),
('Sneha', 'North', 9000.00, '2025-01-04'),
('Rohit', 'South', 6000.00, '2025-01-05'),
('Rahul', 'West', 8000.00, '2025-01-06'),
('Priya', 'West', 7500.00, '2025-01-07'),
('Amit', 'North', 4000.00, '2025-01-08');
```

Initial Sales Records:

| sale_id | salesperson | region | sale_amount (Rs) | sale_date |
|---|---|---|---|---|
| 1 | Rahul | West | 5,000.00 | 2025-01-01 |
| 2 | Priya | West | 7,000.00 | 2025-01-02 |
| 3 | Amit | North | 3,000.00 | 2025-01-03 |
| 4 | Sneha | North | 9,000.00 | 2025-01-04 |
| 5 | Rohit | South | 6,000.00 | 2025-01-05 |
| 6 | Rahul | West | 8,000.00 | 2025-01-06 |
| 7 | Priya | West | 7,500.00 | 2025-01-07 |
| 8 | Amit | North | 4,000.00 | 2025-01-08 |

---

## Part 1: Ranking Functions

Ranking functions assign an ordered sequence based on specified criteria.

### 1. ROW_NUMBER(): Strict Unique Integer Ordering
Assigns a unique row number regardless of ties.
```sql
SELECT salesperson,
       sale_amount,
       ROW_NUMBER() OVER(
            ORDER BY sale_amount DESC
       ) AS row_num
FROM sales;
```
| salesperson | sale_amount (Rs) | row_num |
|---|---|---|
| Sneha | 9,000.00 | 1 |
| Rahul | 8,000.00 | 2 |
| Priya | 7,500.00 | 3 |
| Priya | 7,000.00 | 4 |
| Rohit | 6,000.00 | 5 |
| Rahul | 5,000.00 | 6 |
| Amit | 4,000.00 | 7 |
| Amit | 3,000.00 | 8 |

---

### 2. RANK(): Ranking With Gaps
Assigns identical rank to ties and skips ranks subsequently.
```sql
SELECT salesperson,
       sale_amount,
       RANK() OVER(
            ORDER BY sale_amount DESC
       ) AS rank_no
FROM sales;
```
| salesperson | sale_amount (Rs) | rank_no |
|---|---|---|
| Sneha | 9,000.00 | 1 |
| Rahul | 8,000.00 | 2 |
| Priya | 7,500.00 | 3 |
| Priya | 7,000.00 | 4 |
| Rohit | 6,000.00 | 5 |
| Rahul | 5,000.00 | 6 |
| Amit | 4,000.00 | 7 |
| Amit | 3,000.00 | 8 |

---

### 3. DENSE_RANK(): Ranking Without Gaps
Assigns identical rank to ties without skipping subsequent rank numbers.
```sql
SELECT salesperson,
       sale_amount,
       DENSE_RANK() OVER(
            ORDER BY sale_amount DESC
       ) AS dense_rank_no
FROM sales;
```
| salesperson | sale_amount (Rs) | dense_rank_no |
|---|---|---|
| Sneha | 9,000.00 | 1 |
| Rahul | 8,000.00 | 2 |
| Priya | 7,500.00 | 3 |
| Priya | 7,000.00 | 4 |
| Rohit | 6,000.00 | 5 |
| Rahul | 5,000.00 | 6 |
| Amit | 4,000.00 | 7 |
| Amit | 3,000.00 | 8 |

---

## Part 2: Value and Navigation Functions

### 4. Running Total (Cumulative Revenue Over Time)
Aggregates sales dynamically across chronological dates.
```sql
SELECT sale_date,
       sale_amount,
       SUM(sale_amount) OVER(
            ORDER BY sale_date
       ) AS running_total
FROM sales;
```
| sale_date | sale_amount (Rs) | running_total (Rs) |
|---|---|---|
| 2025-01-01 | 5,000.00 | 5,000.00 |
| 2025-01-02 | 7,000.00 | 12,000.00 |
| 2025-01-03 | 3,000.00 | 15,000.00 |
| 2025-01-04 | 9,000.00 | 24,000.00 |
| 2025-01-05 | 6,000.00 | 30,000.00 |
| 2025-01-06 | 8,000.00 | 38,000.00 |
| 2025-01-07 | 7,500.00 | 45,500.00 |
| 2025-01-08 | 4,000.00 | 49,500.00 |

---

### 5. LEAD(): Accessing Future Row Values
Looks forward 1 row chronologically to extract the next transaction amount.
```sql
SELECT salesperson,
       sale_amount,
       LEAD(sale_amount) OVER(
            ORDER BY sale_date
       ) AS next_sale
FROM sales;
```
| salesperson | sale_amount (Rs) | next_sale (Rs) |
|---|---|---|
| Rahul | 5,000.00 | 7,000.00 |
| Priya | 7,000.00 | 3,000.00 |
| Amit | 3,000.00 | 9,000.00 |
| Sneha | 9,000.00 | 6,000.00 |
| Rohit | 6,000.00 | 8,000.00 |
| Rahul | 8,000.00 | 7,500.00 |
| Priya | 7,500.00 | 4,000.00 |
| Amit | 4,000.00 | NULL |

---

### 6. LAG(): Accessing Historical Row Values
Looks backward 1 row chronologically to extract the preceding transaction amount.
```sql
SELECT salesperson,
       sale_amount,
       LAG(sale_amount) OVER(
            ORDER BY sale_date
       ) AS previous_sale
FROM sales;
```
| salesperson | sale_amount (Rs) | previous_sale (Rs) |
|---|---|---|
| Rahul | 5,000.00 | NULL |
| Priya | 7,000.00 | 5,000.00 |
| Amit | 3,000.00 | 7,000.00 |
| Sneha | 9,000.00 | 3,000.00 |
| Rohit | 6,000.00 | 9,000.00 |
| Rahul | 8,000.00 | 6,000.00 |
| Priya | 7,500.00 | 8,000.00 |
| Amit | 4,000.00 | 7,500.00 |

---

### 7. FIRST_VALUE(): Highest Transaction in Partition
Retrieves the maximum transaction across the ordered partition.
```sql
SELECT salesperson,
       sale_amount,
       FIRST_VALUE(sale_amount) OVER(
            ORDER BY sale_amount DESC
       ) AS highest_sale
FROM sales;
```
| salesperson | sale_amount (Rs) | highest_sale (Rs) |
|---|---|---|
| Sneha | 9,000.00 | 9,000.00 |
| Rahul | 8,000.00 | 9,000.00 |
| Priya | 7,500.00 | 9,000.00 |
| Priya | 7,000.00 | 9,000.00 |
| Rohit | 6,000.00 | 9,000.00 |
| Rahul | 5,000.00 | 9,000.00 |
| Amit | 4,000.00 | 9,000.00 |
| Amit | 3,000.00 | 9,000.00 |

---

### 8. LAST_VALUE(): Lowest Transaction (Explicit Frame Required)
In SQL standard, the default window frame is `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`. To evaluate the true last value across the entire window, an explicit frame of `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING` must be declared.
```sql
SELECT salesperson,
       sale_amount,
       LAST_VALUE(sale_amount) OVER(
            ORDER BY sale_amount DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND UNBOUNDED FOLLOWING
       ) AS lowest_sale
FROM sales;
```
| salesperson | sale_amount (Rs) | lowest_sale (Rs) |
|---|---|---|
| Sneha | 9,000.00 | 3,000.00 |
| Rahul | 8,000.00 | 3,000.00 |
| Priya | 7,500.00 | 3,000.00 |
| Priya | 7,000.00 | 3,000.00 |
| Rohit | 6,000.00 | 3,000.00 |
| Rahul | 5,000.00 | 3,000.00 |
| Amit | 4,000.00 | 3,000.00 |
| Amit | 3,000.00 | 3,000.00 |

---

## Part 3: Distribution and Partitioned Windowing

### 9. NTILE(4): Quartile Distribution
Divides rows into 4 equally-sized performance quartiles.
```sql
SELECT salesperson,
       sale_amount,
       NTILE(4) OVER(
            ORDER BY sale_amount DESC
       ) AS quartile
FROM sales;
```
| salesperson | sale_amount (Rs) | quartile | Segment |
|---|---|---|---|
| Sneha | 9,000.00 | 1 | Top 25% (Q1) |
| Rahul | 8,000.00 | 1 | Top 25% (Q1) |
| Priya | 7,500.00 | 2 | Upper Mid (Q2) |
| Priya | 7,000.00 | 2 | Upper Mid (Q2) |
| Rohit | 6,000.00 | 3 | Lower Mid (Q3) |
| Rahul | 5,000.00 | 3 | Lower Mid (Q3) |
| Amit | 4,000.00 | 4 | Bottom 25% (Q4) |
| Amit | 3,000.00 | 4 | Bottom 25% (Q4) |

---

### 10. Top Performer Per Region (PARTITION BY + Filter)
```sql
SELECT *
FROM
(
    SELECT salesperson,
           region,
           sale_amount,
           ROW_NUMBER() OVER(
               PARTITION BY region
               ORDER BY sale_amount DESC
           ) AS rn
    FROM sales
) x
WHERE rn = 1;
```
| salesperson | region | sale_amount (Rs) | rn |
|---|---|---|---|
| Sneha | North | 9,000.00 | 1 |
| Rohit | South | 6,000.00 | 1 |
| Rahul | West | 8,000.00 | 1 |

---

## Part 4: Bonus Interview Challenges

### Bonus 1: Region-wise Ranking
```sql
SELECT salesperson,
       region,
       sale_amount,
       RANK() OVER(
            PARTITION BY region
            ORDER BY sale_amount DESC
       ) AS region_rank
FROM sales;
```
| salesperson | region | sale_amount (Rs) | region_rank |
|---|---|---|---|
| Sneha | North | 9,000.00 | 1 |
| Amit | North | 4,000.00 | 2 |
| Amit | North | 3,000.00 | 3 |
| Rohit | South | 6,000.00 | 1 |
| Rahul | West | 8,000.00 | 1 |
| Priya | West | 7,500.00 | 2 |
| Priya | West | 7,000.00 | 3 |
| Rahul | West | 5,000.00 | 4 |

---

### Bonus 2: Percentage Contribution to Total Revenue
Total revenue is Rs 49,500.00.
```sql
SELECT salesperson,
       sale_amount,
       ROUND(
           sale_amount * 100.0 /
           SUM(sale_amount) OVER(),
           2
       ) AS contribution_percent
FROM sales;
```
| salesperson | sale_amount (Rs) | contribution_percent (%) |
|---|---|---|
| Rahul | 5,000.00 | 10.10 |
| Priya | 7,000.00 | 14.14 |
| Amit | 3,000.00 | 6.06 |
| Sneha | 9,000.00 | 18.18 |
| Rohit | 6,000.00 | 12.12 |
| Rahul | 8,000.00 | 16.16 |
| Priya | 7,500.00 | 15.15 |
| Amit | 4,000.00 | 8.08 |

---

### Bonus 3: Difference From Previous Sale (Velocity / Growth)
```sql
SELECT salesperson,
       sale_amount,
       sale_amount -
       LAG(sale_amount) OVER(
            ORDER BY sale_date
       ) AS difference
FROM sales;
```
| salesperson | sale_amount (Rs) | difference (Rs) | Trend |
|---|---|---|---|
| Rahul | 5,000.00 | NULL | Baseline |
| Priya | 7,000.00 | +2,000.00 | Increase |
| Amit | 3,000.00 | -4,000.00 | Decrease |
| Sneha | 9,000.00 | +6,000.00 | Increase |
| Rohit | 6,000.00 | -3,000.00 | Decrease |
| Rahul | 8,000.00 | +2,000.00 | Increase |
| Priya | 7,500.00 | -500.00 | Decrease |
| Amit | 4,000.00 | -3,500.00 | Decrease |

---

## Technical Summary of Window Function Behaviors

| Function | Primary Purpose | Frame Dependency | Typical Use Case |
|---|---|---|---|
| `ROW_NUMBER()` | Assigns unique sequence numbers | None | Pagination, Top-N filtering, deduplication |
| `RANK()` | Ranks with gaps on ties | None | Competition rank, leaderboard placement |
| `DENSE_RANK()` | Ranks without gaps on ties | None | Dense salary tiers, executive compensation bands |
| `LEAD()` | Fetches subsequent row value | None | Churn analysis, time-to-next-order |
| `LAG()` | Fetches preceding row value | None | MoM growth, day-over-day transaction variance |
| `FIRST_VALUE()` | Fetches first value in window | Default frame | Benchmark vs top performer |
| `LAST_VALUE()` | Fetches last value in window | Requires `UNBOUNDED FOLLOWING` | Comparison against minimum baseline |
| `NTILE(n)` | Bins records into $n$ balanced buckets | None | Quartile, decile, customer RFM segmentation |

---

## Terminal Verification Screenshots

All queries were verified directly in the PostgreSQL terminal:

1. `01_create_db_table_and_insert.png`: Database creation, table definition, and 8 sales records inserted
2. `02_row_number_and_rank.png`: ROW_NUMBER() strict ordering and RANK() evaluation
3. `03_dense_rank_and_running_total.png`: DENSE_RANK() evaluation and cumulative revenue running total
4. `04_lead_and_lag.png`: LEAD() subsequent lookahead and LAG() previous transaction lookup
5. `05_first_value_and_last_value.png`: FIRST_VALUE() benchmark lookup and LAST_VALUE() with explicit window framing

---

## Key Business & Engineering Insights

1. Running Total Velocity: Cumulative revenue reached Rs 49,500.00 across 8 days, enabling leadership to track burn rate and trajectory without costly subqueries.
2. Regional Performance Disparity: Sneha (North) led the overall organization with Rs 9,000.00 (18.18% of total revenue), while Rahul topped the West region with Rs 8,000.00.
3. Transaction Variance Analysis: Combining `LAG()` with delta arithmetic directly pinpoints transaction deceleration (e.g., Amit's dip by Rs 4,000.00 on Jan 3).
4. Window Framing Precision: `LAST_VALUE()` must always declare `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING` to prevent the default frame from restricting evaluation to the current row.

---

## LinkedIn Post Draft

```text
Day 9 of #11Days11SQLProblems: Advanced Window Functions in PostgreSQL

Today I completed Day 9 of my 11 Days SQL Challenge by diving deep into advanced analytical window functions for cohort and trend analysis.

Key Technical Skills Applied:
- Ranking Algorithms: ROW_NUMBER(), RANK(), and DENSE_RANK() comparison
- Value Navigation: LEAD() and LAG() for period-over-period delta calculation
- Window Framing: Explicit framing (ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) for accurate LAST_VALUE() lookups
- Segmentation & Partitions: NTILE(4) quartile distribution and PARTITION BY Top-N extraction per region
- Cumulative Tracking: Running revenue aggregation over chronological timestamps

Key Business Findings:
- Sneha dominated overall revenue with Rs 9,000 (18.18% share).
- Regional leaders: Sneha (North - Rs 9,000), Rahul (West - Rs 8,000), Rohit (South - Rs 6,000).
- Total cumulative revenue scaled smoothly from Rs 5,000 to Rs 49,500 across 8 transactions.

GitHub Repository:
https://github.com/Nirrajkadam/11_Days_11_SQL_Problems/tree/main/Day9_Advanced_Window_Functions

#SQL #PostgreSQL #WindowFunctions #DataAnalytics #DataEngineering #BusinessIntelligence #AnalyticsEngineering #11DaysOfSQL
```

---

## Day 9 Completion Checklist
- Database Created (`day9_advanced_window_functions`)
- Sales Table Created & 8 Transactions Seeded
- Ranking Functions Executed (ROW_NUMBER, RANK, DENSE_RANK)
- Running Total Cumulative Revenue Verified
- Temporal Navigation Executed (LEAD, LAG)
- Boundary Value Lookups Executed (FIRST_VALUE, LAST_VALUE with explicit framing)
- Distribution Functions Executed (NTILE)
- Regional Partitioning Executed (Top Performer per Region)
- Bonus Interview Problems Implemented (Region Rank, % Contribution, Day-over-Day Delta)
- All 5 Terminal Screenshots Verified and Linked
- Git Repository Synchronized and Pushed
