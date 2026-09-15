# 🚨 Day 2: Banking & Fraud Detection Analytics

Welcome to **Day 2** of the **11 Days 11 SQL Problems** Challenge! 🚀  
In Day 2, we analyzed a real-world dataset of **2,512 Bank Transactions** in PostgreSQL database `day2_bank_analysis` to evaluate customer transaction behaviors, channel adoption, occupation spending, and identify high-risk fraud anomalies based on failed login attempt patterns.

---

## 📁 Project Structure

```text
Day2_Banking_Fraud_Analytics
│
├── README.md                 <-- Business & Risk Analytics Documentation
├── queries.sql               <-- Complete SQL Script (10 Queries)
├── screenshots/
│   ├── 01_create_db_and_table.png
│   ├── 02_copy_dataset_and_totals.png
│   ├── 03_transaction_type_channel_top10.png
│   ├── 04_occupation_loginattempts.png
│   ├── 05_high_risk_logins_query.png
│   └── 06_channel_avg_login_attempts.png
└── dataset/
    ├── bank_transactions_data_2.csv (2,512 Rows)
    └── schema_and_data.sql
```

---

## 🗄️ Database & Schema Setup

**Database:** `day2_bank_analysis`  
**Table:** `bank_transactions` (2,512 rows)

```sql
CREATE DATABASE day2_bank_analysis;
\c day2_bank_analysis;

CREATE TABLE bank_transactions(
    TransactionID VARCHAR(20),
    AccountID VARCHAR(20),
    TransactionAmount NUMERIC,
    TransactionDate TIMESTAMP,
    TransactionType VARCHAR(50),
    Loction VARCHAR(100),
    DeviceID VARCHAR(50),
    IP_Address VARCHAR(50),
    MerchantID VARCHAR(50),
    Channel VARCHAR(50),
    CustomerAge INT,
    CustomerOccupation VARCHAR(100),
    TransactionDuration INT,
    LoginAttempts INT,
    AccountBalance NUMERIC,
    PreviousTransationDate TIMESTAMP
);

\copy bank_transactions FROM 'C:/Users/kadam/Downloads/11_day_11_problem/Dataset/bank_transactions_data_2.csv' DELIMITER ',' CSV HEADER;
```

---

## 💻 Executed SQL Queries & Real Terminal Outputs

### 1️⃣ Dataset Overview Verification
```sql
SELECT COUNT(*) AS total_transactions FROM bank_transactions;
SELECT ROUND(SUM(TransactionAmount), 2) AS total_amount FROM bank_transactions;
SELECT ROUND(AVG(TransactionAmount), 2) AS average_amount FROM bank_transactions;
```
- **Total Transactions:** `2,512`
- **Total Amount Transacted:** `₹747,555.57`
- **Average Transaction Amount:** `₹297.59`

---

### 2️⃣ Transaction Type Breakdown (Debit vs Credit)
```sql
SELECT TransactionType,
       COUNT(*) AS total_transactions,
       ROUND(SUM(TransactionAmount), 2) AS total_amount
FROM bank_transactions
GROUP BY TransactionType
ORDER BY total_amount DESC;
```
| TransactionType | Total Transactions | Total Amount (₹) |
|---|---|---|
| **Debit** | 1,944 | ₹573,463.00 |
| **Credit** | 568 | ₹174,092.57 |

---

### 3️⃣ Banking Channel Analysis
```sql
SELECT Channel,
       COUNT(*) AS total_transactions
FROM bank_transactions
GROUP BY Channel
ORDER BY total_transactions DESC;
```
| Channel | Total Transactions |
|---|---|
| **Branch** | 868 |
| **ATM** | 833 |
| **Online** | 811 |

---

### 4️⃣ Customer Occupation Spending Breakdown
```sql
SELECT CustomerOccupation,
       ROUND(SUM(TransactionAmount), 2) AS total_amount
FROM bank_transactions
GROUP BY CustomerOccupation
ORDER BY total_amount DESC;
```
| CustomerOccupation | Total Amount (₹) |
|---|---|
| **Student** | ₹205,786.03 |
| **Doctor** | ₹184,693.81 |
| **Engineer** | ₹180,650.06 |
| **Retired** | ₹176,425.67 |

---

### 5️⃣ Security & Fraud Risk Audit: Login Attempts Distribution 🚨
```sql
SELECT LoginAttempts,
       COUNT(*) AS total_transactions
FROM bank_transactions
GROUP BY LoginAttempts
ORDER BY LoginAttempts;
```
| LoginAttempts | Total Transactions | Security Risk Status |
|---|---|---|
| **1 Attempt** | 2,390 | Normal Authenticated |
| **2 Attempts** | 27 | Low Risk |
| **3 Attempts** | 31 | Warning Level |
| **4 Attempts** | 32 | 🚨 **High Risk (Suspicious Authentication)** |
| **5 Attempts** | 32 | 🚨 **High Risk (Potential Credential Attack)** |

---

### 6️⃣ High Risk Transactions Audit (`LoginAttempts > 3`)
```sql
SELECT *
FROM bank_transactions
WHERE LoginAttempts > 3;
```
*Result:* **64 high-risk transactions** flagged for security review.

---

### 7️⃣ Average Login Attempts by Channel
```sql
SELECT Channel,
       AVG(LoginAttempts)
FROM bank_transactions
GROUP BY Channel;
```
| Channel | Average Login Attempts |
|---|---|
| **Online** | 1.1282 |
| **ATM** | 1.1236 |
| **Branch** | 1.1221 |

---

## 📊 Key Business & Security Insights

1. 💳 **High Debit Volume:** Customers perform **76.7%** of transactions via **Debit** (1,944 out of 2,512 transactions), representing high day-to-day liquidity reliance.
2. 🏦 **Physical Banking Dominance:** Physical channels (**Branch: 868** and **ATM: 833**) exceed digital channels (**Online: 811**).
3. 🚨 **Security Risk Alert:** **64 transactions** occurred after 4 or 5 login attempts. This signals potential brute-force or unauthorized access attempts that require fraud investigation.
4. 🎓 **Top Demographic Spenders:** **Students** represent the highest total expenditure (₹205,786.03), closely followed by Doctors and Engineers.

---

## 📱 LinkedIn Post Draft (Ready to Share 🚀)

```text
🚨 Day 2 of #11Days11SQLProblems: Banking & Fraud Risk Analytics! 🏦📊

Today I completed Day 2 by building a PostgreSQL database (2,512 Bank Transactions) and executing analytical + fraud detection queries! 🔍

Key Highlights:
✅ Data Ingestion & Schema Definition (\copy command, 2,512 rows)
✅ Aggregations & Distribution Metrics (SUM, AVG, ROUND, COUNT)
✅ Multidimensional Grouping (TransactionType, Channel, Occupation)
✅ Security & Risk Pattern Flagging (Multiple Login Attempt Anomalies)

💡 Insights Uncovered:
• 💳 Debit Preference: 76.7% of volume comes from Debit transactions (₹573k+).
• 🏦 Channel Preferences: Branch (868) and ATM (833) lead overall usage over Online (811).
• 🚨 Fraud Risk Audit: Flagged 64 suspicious transactions with > 3 failed login attempts.
• 📊 Average spend across 2,512 transactions stands at ₹297.59.

GitHub Repository: [Your GitHub Repo Link Here]

#SQL #DataAnalytics #BankingAnalytics #FraudDetection #PostgreSQL #DataScience #DataEngineering #11DaysOfSQL
```

---

## ✅ Day 2 Completion Check
- [x] Database Created (`day2_bank_analysis`)
- [x] Table Created (`bank_transactions`)
- [x] 2,512 Rows Imported via `\copy`
- [x] All 7 Core & Fraud Queries Executed
- [x] Real psql Screenshots Saved in `screenshots/`
- [x] Git Commit Completed (`git commit -m "Day 2 Banking & Fraud Analytics completed with real psql screenshots"`)
