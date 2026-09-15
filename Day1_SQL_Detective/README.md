# Day 1: SQL Detective (Personal Finance Analysis)

Welcome to Day 1 of the 11 Days 11 SQL Problems Challenge.
In this project, we analyze personal transaction data in PostgreSQL to uncover spending habits, identify high-value expenditures, rank categories, and calculate cumulative spending using SQL window functions.

---

## Project Structure

```text
Day1_SQL_Detective
│
├── README.md
├── queries.sql
├── screenshots/
│   ├── 01_create_database.png
│   ├── 02_create_table_and_insert.png
│   ├── 03_avg_max_min.png
│   ├── 04_group_by_payment_top3.png
│   └── 05_category_ranking_window_fn.png
└── dataset/
    ├── schema_and_data.sql
    └── transactions.csv
```

---

## Database Schema Setup

```sql
CREATE DATABASE day1_sql_detective;
\c day1_sql_detective

CREATE TABLE transactions(
    transaction_id INT,
    transation_date DATE,
    category VARCHAR(50),
    amount DECIMAL(10,2),
    payment_mode VARCHAR(20)
);

INSERT INTO transactions VALUES
(1, '2025-09-01', 'Food', 250.00, 'UPI'),
(2, '2025-09-01', 'Fuel', 500.00, 'UPI'),
(3, '2025-09-02', 'Shopping', 1200.00, 'Card'),
(4, '2025-09-03', 'Travel', 2500.00, 'Card'),
(5, '2025-09-04', 'Medical', 800.00, 'UPI');
```

---

## SQL Queries and Results

### 1. Full Table View
```sql
SELECT * FROM transactions;
```
| transaction_id | transation_date | category | amount | payment_mode |
|---|---|---|---|---|
| 1 | 2025-09-01 | Food | Rs 250.00 | UPI |
| 2 | 2025-09-01 | Fuel | Rs 500.00 | UPI |
| 3 | 2025-09-02 | Shopping | Rs 1,200.00 | Card |
| 4 | 2025-09-03 | Travel | Rs 2,500.00 | Card |
| 5 | 2025-09-04 | Medical | Rs 800.00 | UPI |

---

### 2. Average Transaction Amount
```sql
SELECT AVG(amount) AS avg_amount FROM transactions;
```
Result: 1050.00

---

### 3. Maximum and Minimum Expense
```sql
-- Highest Expense
SELECT * FROM transactions ORDER BY amount DESC LIMIT 1;
-- Result: Travel (Rs 2,500.00, Card)

-- Lowest Expense
SELECT * FROM transactions ORDER BY amount ASC LIMIT 1;
-- Result: Food (Rs 250.00, UPI)
```

---

### 4. Payment Mode Breakdown
```sql
SELECT payment_mode,
       COUNT(*) AS total_transactions
FROM transactions
GROUP BY payment_mode;
```
| payment_mode | total_transactions |
|---|---|
| UPI | 3 |
| Card | 2 |

---

### 5. Category Spending and Ranking (Window Function: RANK)
```sql
SELECT category,
       SUM(amount) AS total,
       RANK() OVER (ORDER BY SUM(amount) DESC) AS rank_no
FROM transactions
GROUP BY category;
```
| category | total | rank_no |
|---|---|---|
| Travel | Rs 2,500.00 | 1 |
| Shopping | Rs 1,200.00 | 2 |
| Medical | Rs 800.00 | 3 |
| Fuel | Rs 500.00 | 4 |
| Food | Rs 250.00 | 5 |

---

## Key Business Insights

1. Payment Preference: UPI is the most preferred payment mode (3 out of 5 transactions).
2. Highest Expenditure: Travel is the top expense category at Rs 2,500 (Rank 1).
3. Lowest Expenditure: Food is the lowest recorded expense at Rs 250 (Rank 5).
4. Average Transaction: The average order size across transactions is Rs 1,050.

---

## LinkedIn Post Draft

```text
Day 1 of #11Days11SQLProblems: SQL Detective Challenge Completed

Today I kicked off Day 1 of my SQL challenge by building a personal transaction database in PostgreSQL and running key analytical queries.

Key Concepts Covered:
- Database Setup and DDL (CREATE DATABASE, CREATE TABLE)
- Data Insertion and Selection (INSERT INTO, SELECT)
- Aggregations (AVG, COUNT, SUM)
- Sorting and Filtering (ORDER BY DESC/ASC, LIMIT)
- Grouping (GROUP BY payment_mode)
- Advanced Window Functions (RANK() OVER)

Key Insights:
- UPI led payment volume with 60% of total transactions.
- Travel ranked #1 in category spend at Rs 2,500.
- Average transaction amount was Rs 1,050.

GitHub Repository:
https://github.com/Nirrajkadam/11_Days_11_SQL_Problems/tree/main/Day1_SQL_Detective

#SQL #DataAnalytics #PostgreSQL #DataDetective #11DaysOfSQL #DataScience #DataEngineering
```

---

## Day 1 Completion Checklist
- Database Created (day1_sql_detective)
- Table Created (transactions)
- Data Inserted and Verified
- Queries Run and Analyzed
- Terminal Screenshots Saved
- Git Commit Completed
