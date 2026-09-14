# 🔍 Day 1: SQL Detective (Personal Finance Analysis)

Welcome to **Day 1** of the **11 Days 11 SQL Problems** Challenge! 🚀  
In this project, we analyze personal transaction data in PostgreSQL to uncover spending habits, identify highest & lowest expenditures, analyze payment methods, and rank categories using SQL window functions (`RANK() OVER`).

---

## 📁 Project Structure

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

## 🗄️ Database & Schema Setup

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

## 💻 SQL Queries & Execution Results

### 1️⃣ Full Table View
```sql
SELECT * FROM transactions;
```
| transaction_id | transation_date | category | amount | payment_mode |
|---|---|---|---|---|
| 1 | 2025-09-01 | Food | ₹250.00 | UPI |
| 2 | 2025-09-01 | Fuel | ₹500.00 | UPI |
| 3 | 2025-09-02 | Shopping | ₹1,200.00 | Card |
| 4 | 2025-09-03 | Travel | ₹2,500.00 | Card |
| 5 | 2025-09-04 | Medical | ₹800.00 | UPI |

---

### 2️⃣ Average Transaction Amount
```sql
SELECT AVG(amount) AS avg_amount FROM transactions;
```
**Result:** `1050.00`

---

### 3️⃣ Maximum & Minimum Expense
```sql
-- Highest Expense (Travel)
SELECT * FROM transactions ORDER BY amount DESC LIMIT 1;
-- Result: Travel (₹2,500.00, Card)

-- Lowest Expense (Food)
SELECT * FROM transactions ORDER BY amount ASC LIMIT 1;
-- Result: Food (₹250.00, UPI)
```

---

### 4️⃣ Payment Mode Breakdown
```sql
SELECT payment_mode,
       COUNT(*) AS total_transactions
FROM transactions
GROUP BY payment_mode;
```
| payment_mode | total_transactions |
|---|---|
| **UPI** | 3 |
| **Card** | 2 |

---

### 5️⃣ Category Spending & Ranking (Window Function `RANK()`)
```sql
SELECT category,
       SUM(amount) AS total,
       RANK() OVER (ORDER BY SUM(amount) DESC) AS rank_no
FROM transactions
GROUP BY category;
```
| category | total | rank_no |
|---|---|---|
| **Travel** | ₹2,500.00 | 1 |
| **Shopping** | ₹1,200.00 | 2 |
| **Medical** | ₹800.00 | 3 |
| **Fuel** | ₹500.00 | 4 |
| **Food** | ₹250.00 | 5 |

---

## 📊 Key Insights & Findings

1. 💳 **Payment Preference:** **UPI** is the most preferred payment mode (3 out of 5 transactions).
2. ✈️ **Highest Expenditure:** **Travel** is the top expense category at **₹2,500** (Rank 1).
3. 🍔 **Lowest Expenditure:** **Food** is the lowest recorded expense at **₹250** (Rank 5).
4. 📈 **Average Transaction:** The average order size across transactions is **₹1,050**.

---

## 📱 LinkedIn Post Draft (Ready to Share 🚀)

```text
🚀 Day 1 of #11Days11SQLProblems: SQL Detective Challenge Completed! 🕵️‍♂️💻

Today I kicked off Day 1 of my SQL challenge by building a personal transaction database in PostgreSQL and running key analytical queries! 📊

Key Concepts Covered:
✅ Database Setup & DDL (CREATE DATABASE, CREATE TABLE)
✅ Data Insertion & Selection (INSERT INTO, SELECT)
✅ Aggregations (AVG, COUNT, SUM)
✅ Sorting & Filtering (ORDER BY DESC/ASC, LIMIT)
✅ Grouping (GROUP BY payment_mode)
✅ Advanced Window Functions (RANK() OVER)

💡 Insights Discovered:
• 📱 UPI led payment volume with 60% of total transactions.
• ✈️ Travel ranked #1 in category spend at ₹2,500.
• 📊 Average transaction amount was ₹1,050.

GitHub Repository: [Your GitHub Repo Link Here]

#SQL #DataAnalytics #PostgreSQL #DataDetective #11DaysOfSQL #DataScience #DataEngineering
```

---

## ✅ Day 1 Status
- [x] Database Created (`day1_sql_detective`)
- [x] Table Created (`transactions`)
- [x] Data Inserted & Verified
- [x] Queries Run & Analyzed
- [x] psql Terminal Screenshots Saved in `screenshots/`
- [x] Git Commit Done (`git commit -m "Day 1 SQL Detective completed"`)
