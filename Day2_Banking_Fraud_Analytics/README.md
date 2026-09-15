# 🚨 Day 2: Banking & Fraud Detection Analytics

Welcome to **Day 2** of the **11 Days 11 SQL Problems** Challenge! 🚀  
Moving beyond basic aggregations, Day 2 focuses on **Real Banking Analytics & Fraud Risk Detection** using a production-scale dataset of **2,512 transactions**.

---

## 📁 Project Structure

```text
Day2_Banking_Fraud_Analytics
│
├── README.md                 <-- Business Insights & Documentation
├── queries.sql               <-- Complete SQL Script (12 Queries)
├── screenshots/
│   ├── 01_dataset_overview.png
│   ├── 02_transaction_type_analysis.png
│   ├── 03_channel_analysis.png
│   ├── 04_occupation_spending.png
│   ├── 05_fraud_login_attempts.png
│   └── 06_high_risk_fraud_txns.png
└── dataset/
    ├── bank_transactions_data_2.csv
    └── schema_and_data.sql
```

---

## 🗄️ Database & Schema Setup

**Database:** `day2_banking_db`  
**Table:** `bank_transactions` (2,512 rows)

| Column Name | Data Type | Description |
|---|---|---|
| `TransactionID` | `VARCHAR(20) PRIMARY KEY` | Unique Transaction ID |
| `AccountID` | `VARCHAR(20)` | Customer Account ID |
| `TransactionAmount` | `NUMERIC(10,2)` | Transaction Value in ₹ |
| `TransactionDate` | `TIMESTAMP` | Timestamp of Transaction |
| `TransactionType` | `VARCHAR(20)` | `Debit` or `Credit` |
| `Channel` | `VARCHAR(20)` | `Branch`, `ATM`, or `Online` |
| `CustomerOccupation` | `VARCHAR(50)` | Student, Doctor, Engineer, Retired |
| `LoginAttempts` | `INT` | Number of authentication attempts |
| `AccountBalance` | `NUMERIC(12,2)` | Remaining Account Balance |

---

## 💻 SQL Queries & Key Findings

### 1️⃣ Dataset Overview Verification
```sql
SELECT COUNT(*) AS total_transactions,
       ROUND(SUM(TransactionAmount), 2) AS total_amount,
       ROUND(AVG(TransactionAmount), 2) AS average_amount
FROM bank_transactions;
```
**Output:**
- **Total Transactions:** `2,512`
- **Total Amount Transacted:** `₹747,555.57`
- **Average Transaction Amount:** `₹297.59`

---

### 2️⃣ Transaction Type Analysis (Debit vs Credit)
```sql
SELECT TransactionType,
       COUNT(*) AS total_transactions,
       ROUND(SUM(TransactionAmount), 2) AS total_amount
FROM bank_transactions
GROUP BY TransactionType
ORDER BY total_amount DESC;
```
**Output:**
| TransactionType | Total Transactions | Total Amount (₹) | Share (%) |
|---|---|---|---|
| **Debit** | 1,944 | ₹573,463.00 | **76.7%** |
| **Credit** | 568 | ₹174,092.57 | **23.3%** |

---

### 3️⃣ Channel Analysis (Branch vs ATM vs Online)
```sql
SELECT Channel,
       COUNT(*) AS total_transactions,
       ROUND(SUM(TransactionAmount), 2) AS total_amount
FROM bank_transactions
GROUP BY Channel
ORDER BY total_transactions DESC;
```
**Output:**
| Channel | Total Transactions | Total Amount (₹) |
|---|---|---|
| **Branch** | 868 | ₹250,183.00 |
| **ATM** | 833 | ₹256,331.43 |
| **Online** | 811 | ₹241,041.14 |

---

### 4️⃣ Customer Occupation Spending Profile
```sql
SELECT CustomerOccupation,
       COUNT(*) AS txn_count,
       ROUND(SUM(TransactionAmount), 2) AS total_amount
FROM bank_transactions
GROUP BY CustomerOccupation
ORDER BY total_amount DESC;
```
**Output:**
| CustomerOccupation | Txn Count | Total Amount (₹) |
|---|---|---|
| **Student** | 657 | ₹205,786.03 |
| **Doctor** | 631 | ₹184,693.81 |
| **Engineer** | 625 | ₹180,650.06 |
| **Retired** | 599 | ₹176,425.67 |

---

### 5️⃣ Fraud Risk Indicator: Login Attempts Analysis 🚨
```sql
SELECT LoginAttempts,
       COUNT(*) AS total_transactions
FROM bank_transactions
GROUP BY LoginAttempts
ORDER BY LoginAttempts DESC;
```
**Output:**
| LoginAttempts | Total Transactions | Fraud Risk Flag |
|---|---|---|
| **5 Attempts** | 32 | 🚨 **High Risk (Potential Brute-Force)** |
| **4 Attempts** | 32 | 🚨 **High Risk (Suspicious Auth)** |
| **3 Attempts** | 31 | ⚠️ Warning Level |
| **2 Attempts** | 27 | Low Risk |
| **1 Attempt** | 2,390 | Normal Authenticated |

---

### 6️⃣ High-Risk Suspicious Transactions Flagging
```sql
SELECT TransactionID,
       AccountID,
       TransactionAmount,
       Channel,
       CustomerOccupation,
       LoginAttempts
FROM bank_transactions
WHERE LoginAttempts > 3
ORDER BY TransactionAmount DESC
LIMIT 5;
```
**Output:**
| TransactionID | AccountID | Amount (₹) | Channel | Occupation | Login Attempts |
|---|---|---|---|---|---|
| `TX000899` | AC00083 | ₹1,531.31 | Online | Student | **4** 🚨 |
| `TX001214` | AC00170 | ₹1,192.20 | Branch | Retired | **5** 🚨 |
| `TX000275` | AC00454 | ₹1,176.28 | ATM | Engineer | **5** 🚨 |
| `TX000773` | AC00093 | ₹827.14 | Branch | Engineer | **4** 🚨 |
| `TX002125` | AC00039 | ₹737.46 | Branch | Doctor | **4** 🚨 |

---

## 🔍 Key Business & Risk Insights

1. 💳 **Debit Preference (76.7% Volume):** Customers perform debit transactions nearly 3.4x more frequently than credit, indicating higher liquidity reliance.
2. 🏦 **Physical vs Digital Channels:** Branch (868) and ATM (833) outpace Online transactions (811). Over 67.7% of transactions rely on physical touchpoints.
3. 🚨 **Fraud Risk Flag (64 Suspicious Accounts):** **64 transactions** occurred after 4 or 5 login attempts. These represent candidate unauthorized login or credential stuffing attempts requiring security audit.
4. 🎓 **High Volume Demographic:** Students account for the highest total spending volume (₹205,786.03 across 657 transactions), followed by Doctors and Engineers.

---

## 📱 LinkedIn Post Draft (Ready to Share 🚀)

```text
🚨 Day 2 of #11Days11SQLProblems: Banking & Fraud Risk Analytics! 🏦📊

Today I leveled up Day 2 by diving into a production-scale dataset of 2,512 Bank Transactions in PostgreSQL to uncover transaction behaviors and flag potential security anomalies! 🔍

Key Technical Focus:
✅ Aggregations & Distribution Metrics (SUM, AVG, ROUND, COUNT)
✅ Multidimensional Grouping (TransactionType, Channel, Occupation)
✅ Security & Risk Pattern Flagging (Multiple Login Attempt Anomalies)
✅ High-Risk Audit Filtering (LoginAttempts > 3)

💡 Key Insights Uncovered:
• 💳 Debit Dominance: 76.7% of total transaction value comes from Debit transactions (₹573k+).
• 🏦 Physical Channels Rule: Branch (868) and ATM (833) channels outpace Online banking.
• 🚨 Fraud Risk Audit: Flagged 64 transactions with >= 4 failed login attempts for security investigation.
• 📊 Average spend across 2,512 transactions stands at ₹297.59.

Check out the full SQL scripts and analytical breakdown on GitHub: [Your GitHub Repo Link Here]

#SQL #DataAnalytics #BankingAnalytics #FraudDetection #PostgreSQL #DataScience #DataEngineering #11DaysOfSQL
```

---

## ✅ Day 2 Completion Criteria Check
- [x] Database Created (`day2_banking_db`)
- [x] Table Created (`bank_transactions`)
- [x] Full Dataset Imported (2,512 rows)
- [x] 12 Analytical & Fraud Detection Queries Executed
- [x] Terminal Screenshots Generated in `screenshots/`
- [x] Detailed `README.md` Documentation Created
- [x] Git Commit Completed (`git commit -m "Day 2 Banking & Fraud Analytics completed"`)
