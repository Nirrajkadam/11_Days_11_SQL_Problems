# 🔍 Day 1: SQL Detective (Personal Finance Analysis)

Welcome to **Day 1** of the **11 Days 11 SQL Problems** Challenge! 🚀  
In this project, we analyze a dataset of **12 personal transactions** in PostgreSQL to uncover spending patterns, evaluate payment modes, rank spending categories, and calculate cumulative spending using SQL window functions (`RANK() OVER` & `SUM() OVER`).

---

## 📁 Project Structure

```text
Day1_SQL_Detective
│
├── README.md                 <-- Comprehensive Documentation & Insights
├── queries.sql               <-- All Executed SQL Queries
├── screenshots/
│   ├── 01_create_database.png
│   ├── 02_create_table_and_insert.png
│   ├── 03_avg_max_min.png
│   ├── 04_group_by_payment_top3.png
│   ├── 05_category_ranking_window_fn.png
│   ├── 06_insert_records_6_to_12.png
│   ├── 07_payment_mode_and_avg.png
│   ├── 08_category_ranking_window_fn.png
│   └── 09_running_total_result.png
└── dataset/
    ├── schema_and_data.sql   <-- DB Schema & Insert Statements
    └── transactions.csv      <-- Clean 12-Record Dataset
```

---

## 🗄️ Database & Table Schema

**Database:** `day1_sql_detective`  
**Table:** `transactions`

| Column | Data Type | Description |
|---|---|---|
| `transaction_id` | `INT` | Unique Transaction ID |
| `transation_date` | `DATE` | Transaction Date |
| `category` | `VARCHAR(50)` | Expenditure Category |
| `amount` | `DECIMAL(10,2)` | Amount in ₹ |
| `payment_mode` | `VARCHAR(20)` | Payment Mode (UPI, Card, Cash) |

---

## 💻 Executed SQL Queries & Terminal Outputs

### 1️⃣ Total Spend by Category
```sql
SELECT category,
       SUM(amount) AS total_spend
FROM transactions
GROUP BY category
ORDER BY total_spend DESC;
```
**Output:**
| category | total_spend |
|---|---|
| **Travel** | ₹7,000.00 |
| **Shopping** | ₹4,400.00 |
| **Medical** | ₹3,300.00 |
| **Entertainment** | ₹1,500.00 |
| **Food** | ₹1,350.00 |
| **Fuel** | ₹1,200.00 |

---

### 2️⃣ Payment Mode Analysis
```sql
SELECT payment_mode,
       COUNT(*) AS transactions,
       SUM(amount) AS total_amount
FROM transactions
GROUP BY payment_mode;
```
**Output:**
| payment_mode | transactions | total_amount |
|---|---|---|
| **UPI** | 7 | ₹9,900.00 |
| **Card** | 4 | ₹8,400.00 |
| **Cash** | 1 | ₹450.00 |

---

### 3️⃣ Average Transaction Amount
```sql
SELECT ROUND(AVG(amount), 2)
FROM transactions;
```
**Output:** `1562.50`

---

### 4️⃣ High Value Transactions (> ₹2000)
```sql
SELECT *
FROM transactions
WHERE amount > 2000;
```
**Output:**
| transaction_id | transation_date | category | amount | payment_mode |
|---|---|---|---|---|
| 4 | 2025-09-03 | Travel | ₹2,500.00 | Card |
| 7 | 2025-09-06 | Shopping | ₹3,200.00 | Card |
| 8 | 2025-09-07 | Travel | ₹4,500.00 | UPI |
| 11 | 2025-09-10 | Medical | ₹2,500.00 | UPI |

---

### 5️⃣ Category Ranking using Window Function (`RANK()`)
```sql
SELECT category,
       SUM(amount) AS total,
       RANK() OVER(ORDER BY SUM(amount) DESC) AS rank_no
FROM transactions
GROUP BY category;
```
**Output:**
| category | total | rank_no |
|---|---|---|
| **Travel** | ₹7,000.00 | 1 |
| **Shopping** | ₹4,400.00 | 2 |
| **Medical** | ₹3,300.00 | 3 |
| **Entertainment** | ₹1,500.00 | 4 |
| **Food** | ₹1,350.00 | 5 |
| **Fuel** | ₹1,200.00 | 6 |

---

### 6️⃣ Cumulative Spend / Running Total (`SUM() OVER()`)
```sql
SELECT transation_date,
       amount,
       SUM(amount) OVER(
         ORDER BY transation_date
       ) AS running_total
FROM transactions;
```
**Output:**
| transation_date | amount | running_total |
|---|---|---|
| 2025-09-01 | ₹250.00 | ₹750.00 |
| 2025-09-01 | ₹500.00 | ₹750.00 |
| 2025-09-02 | ₹1,200.00 | ₹1,950.00 |
| 2025-09-03 | ₹2,500.00 | ₹4,450.00 |
| 2025-09-04 | ₹800.00 | ₹5,250.00 |
| 2025-09-05 | ₹450.00 | ₹5,700.00 |
| 2025-09-06 | ₹3,200.00 | ₹8,900.00 |
| 2025-09-07 | ₹4,500.00 | ₹13,400.00 |
| 2025-09-08 | ₹700.00 | ₹14,100.00 |
| 2025-09-09 | ₹1,500.00 | ₹15,600.00 |
| 2025-09-10 | ₹2,500.00 | ₹18,100.00 |
| 2025-09-11 | ₹650.00 | ₹18,750.00 |

---

## 📊 Business Insights

1. 💳 **UPI is the Dominant Payment Mode:** Out of 12 total transactions, 7 were made via **UPI**, accounting for **₹9,900** (~52.8%) of total spending.
2. ✈️ **Travel is the Top Expense Category:** Travel generated the highest expenditure at **₹7,000** (Rank 1), driven by large individual spends.
3. 💰 **High-Value Spends (> ₹2,000):** Only 4 transactions exceeded ₹2,000, yet they accounted for **₹12,700** (~67.7%) of total volume.
4. 📈 **Average Transaction Size:** The overall average spend across all 12 transactions is **₹1,562.50**.

---

## 📱 LinkedIn Post Draft (Ready to Share 🚀)

```text
🚀 Day 1 of #11Days11SQLProblems: SQL Detective Challenge Completed! 🕵️‍♂️💻

Today I completed Day 1 of my 11 Days SQL Challenge by performing personal finance analysis in PostgreSQL! 📊

Key SQL Skills Applied:
✅ Data Definition (DDL) & Data Manipulation (DML)
✅ Aggregation Functions (SUM, ROUND, AVG, COUNT)
✅ Filtering & Grouping (GROUP BY, ORDER BY, WHERE)
✅ Advanced Window Functions (RANK() OVER, SUM() OVER - Running Total)

💡 Key Analytical Findings:
• 📱 UPI is the #1 Payment Mode with 7 transactions (₹9,900 total spend).
• ✈️ Travel ranked #1 in category spend at ₹7,000.
• 💰 High-value transactions (> ₹2,000) account for over 67% of total expenses.
• 📈 Total cumulative expenditure reached ₹18,750 with an average spend of ₹1,562.50.

Check out the full queries and dataset on GitHub: [Your GitHub Repo Link Here]

#SQL #DataAnalytics #PostgreSQL #DataDetective #11DaysOfSQL #DataScience #DataEngineering
```

---

## ✅ Day 1 Status
- [x] Database Created (`day1_sql_detective`)
- [x] Table Created (`transactions`)
- [x] All 12 Records Inserted
- [x] All 6 SQL Queries Run & Validated
- [x] Window Functions Executed (`RANK() OVER`, `SUM() OVER`)
- [x] Real psql Terminal Screenshots Saved in `screenshots/`
- [x] Git Commit Completed (`git commit -m "Day 1 SQL Detective fully completed"`)
