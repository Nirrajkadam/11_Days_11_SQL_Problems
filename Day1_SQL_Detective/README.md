# 🔍 Day 1: SQL Detective (Personal Finance Analysis)

Welcome to **Day 1** of the **11 Days 11 SQL Problems** Challenge! 🚀  
In this project, we explore personal transaction data using SQL to uncover spending habits, identify high-value expenditures, rank categories, and calculate cumulative spending using SQL window functions.

---

## 📁 Project Structure

```text
Day1_SQL_Detective
│
├── README.md
├── queries.sql
├── screenshots/
│   ├── 01_table_data.png
│   ├── 02_category_spending.png
│   ├── 03_ranking_result.png
│   └── 04_top_transactions.png
└── dataset/
    ├── schema_and_data.sql
    └── transactions.csv
```

---

## 🗄️ Database & Table Schema

**Database:** `day1_sql_detective`  
**Table:** `transactions`

| Column | Data Type | Description |
|---|---|---|
| `transaction_id` | `SERIAL PRIMARY KEY` | Unique Transaction Identifier |
| `transation_date` | `DATE` | Date of Transaction |
| `category` | `VARCHAR(50)` | Expenditure Category (Food, Travel, etc.) |
| `amount` | `NUMERIC(10, 2)` | Transaction Amount in ₹ |
| `payment_mode` | `VARCHAR(20)` | Payment Method (UPI, Card, Cash) |

---

## 💻 SQL Queries & Key Results

### 1️⃣ Payment Mode Analysis
```sql
SELECT payment_mode,
       COUNT(*) AS transactions,
       SUM(amount) AS total_amount
FROM transactions
GROUP BY payment_mode
ORDER BY total_amount DESC;
```
**Output:**
| Payment Mode | Transactions | Total Amount (₹) |
|---|---|---|
| **UPI** | 7 | ₹9,900.00 |
| **Card** | 4 | ₹8,400.00 |
| **Cash** | 1 | ₹450.00 |

---

### 2️⃣ Average Transaction Amount
```sql
SELECT ROUND(AVG(amount), 2) AS avg_amount
FROM transactions;
```
**Output:** `₹1562.50`

---

### 3️⃣ High Value Transactions (> ₹2000)
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

### 4️⃣ Category Spending & Ranking (Window Function: `RANK()`)
```sql
SELECT category,
       SUM(amount) AS total,
       RANK() OVER(ORDER BY SUM(amount) DESC) AS rank_no
FROM transactions
GROUP BY category;
```
**Output:**
| Category | Total (₹) | Rank |
|---|---|---|
| **Travel** | ₹7,000.00 | 1 |
| **Shopping** | ₹4,400.00 | 2 |
| **Medical** | ₹3,300.00 | 3 |
| **Entertainment** | ₹1,500.00 | 4 |
| **Food** | ₹1,350.00 | 5 |
| **Fuel** | ₹1,200.00 | 6 |

---

### 5️⃣ Cumulative Spend / Running Total (Window Function: `SUM() OVER()`)
```sql
SELECT transation_date,
       amount,
       SUM(amount) OVER(
         ORDER BY transation_date, transaction_id
       ) AS running_total
FROM transactions;
```
**Output:**
| transation_date | amount | running_total |
|---|---|---|
| 2025-09-01 | ₹450.00 | ₹450.00 |
| 2025-09-01 | ₹1200.00 | ₹1650.00 |
| 2025-09-02 | ₹400.00 | ₹2050.00 |
| 2025-09-03 | ₹2500.00 | ₹4550.00 |
| 2025-09-04 | ₹1500.00 | ₹6050.00 |
| 2025-09-05 | ₹800.00 | ₹6850.00 |
| 2025-09-06 | ₹3200.00 | ₹10050.00 |
| 2025-09-07 | ₹4500.00 | ₹14550.00 |
| 2025-09-08 | ₹1200.00 | ₹15750.00 |
| 2025-09-09 | ₹300.00 | ₹16050.00 |
| 2025-09-10 | ₹2500.00 | ₹18550.00 |
| 2025-09-11 | ₹200.00 | ₹18750.00 |

---

## 📊 Business Insights

1. 💳 **UPI Dominance:** UPI is the most frequently used payment method (7 out of 12 transactions) accounting for **₹9,900** (~53%) of total spending.
2. ✈️ **Travel Spending:** Travel emerged as the **#1 expenditure category** (₹7,000 across 2 transactions), driven by high-value transactions.
3. 🛍️ **High-Value Spends:** 4 out of 12 transactions were over ₹2,000, contributing to **₹12,700** (~67.7%) of overall expenditure.
4. 🍔 **Frequent Low-Value Spends:** Food and Fuel categories consist of smaller, frequent transactions, maintaining consistent daily cash/UPI liquidity.

---

## 📱 LinkedIn Post Draft (Ready to Share 🚀)

```text
🚀 Day 1 of #11Days11SQLProblems: SQL Detective Challenge Completed! 🕵️‍♂️💻

Today I kicked off Day 1 of my SQL challenge by analyzing personal transaction data in PostgreSQL! 📊

Key SQL Skills Applied:
✅ Data Definition (DDL) & Insertion (DML)
✅ Aggregations (SUM, AVG, COUNT, ROUND)
✅ Grouping & Filtering (GROUP BY, ORDER BY, HAVING/WHERE)
✅ Advanced Window Functions (RANK() OVER, SUM() OVER - Running Total)

💡 Top Insights Uncovered:
• 📱 UPI is the #1 Payment Mode with 7 transactions (₹9,900 total).
• ✈️ Travel ranked #1 in category spend at ₹7,000.
• 💰 High-value transactions (> ₹2,000) account for over 67% of total expenses.

Check out the full queries and dataset on GitHub: [Your Repository Link Here]

#SQL #DataAnalytics #PostgreSQL #DataDetective #11DaysOfSQL #DataScience #CareerInData
```

---

## ✅ Day 1 Completion Criteria Check
- [x] Database Created (`day1_sql_detective`)
- [x] Table Created (`transactions`)
- [x] 12 Records Inserted
- [x] 5+ Analytical SQL Queries Executed
- [x] Running Total Window Function Completed
- [x] Screenshots & Query Outputs Saved
- [x] Git Repository Updated & Ready
