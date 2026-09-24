# 11 Days 11 SQL Problems Challenge

Comprehensive enterprise SQL and database engineering portfolio by Nirraj Kadam.
This repository documents an intensive, hands-on 11-day challenge solving production-grade business problems using PostgreSQL across financial, banking, e-commerce, fraud detection, and organizational hierarchy datasets.

---

## Challenge Roadmap & Project Directory

| Day | Project Folder | Primary SQL Focus | Dataset Domain |
|---|---|---|---|
| Day 1 | [Day1_SQL_Detective](Day1_SQL_Detective) | DDL, DML, Aggregations, Window Functions | Personal Finance |
| Day 2 | [Day2_Banking_Fraud_Analytics](Day2_Banking_Fraud_Analytics) | Financial Metrics, Pattern Detection, Fraud Queries | Banking & Fraud Analytics (2,512 rows) |
| Day 3 | [Day3_Ecommerce_JOINs_CaseWhen](Day3_Ecommerce_JOINs_CaseWhen) | INNER/LEFT JOINs, CASE WHEN, Delivery Funnels | E-Commerce Orders (1,590 rows) |
| Day 4 | [Day4_Subqueries_CTE_WindowFunctions](Day4_Subqueries_CTE_WindowFunctions) | Subqueries, HAVING, CTEs, RANK, Running Totals | E-Commerce Analytics |
| Day 5 | [Day5_Views_Indexes_QueryOptimization](Day5_Views_Indexes_QueryOptimization) | Database Views, B-Tree Indexes, EXPLAIN ANALYZE | Database Performance Tuning |
| Day 6 | [Day6_Functions_Procedures_Triggers](Day6_Functions_Procedures_Triggers) | User-Defined Functions, Stored Procedures, Audit Triggers | Procedural Database Programming |
| Day 7 | [Day7_String_Date_NULL_DataCleaning](Day7_String_Date_NULL_DataCleaning) | String/Date Functions, NULL Handling, COALESCE | Data Wrangling & Cleaning |
| Day 8 | [Day8_Advanced_JOINs](Day8_Advanced_JOINs) | RIGHT, FULL, SELF, CROSS & Anti-Joins | Relational Architecture & Hierarchies |
| Day 9 | [Day9_Advanced_Window_Functions](Day9_Advanced_Window_Functions) | ROW_NUMBER, RANK, DENSE_RANK, LEAD, LAG, NTILE, LAST_VALUE | Advanced Window Analytics |
| Day 10 | [Day10_Business_Case_Study](Day10_Business_Case_Study) | Full Business Intelligence Case Study, Executive Insights | E-Commerce Strategy & Diagnostics |
| Day 11 | [Day11_SQL_Portfolio_Project](Day11_SQL_Portfolio_Project) | Capstone Portfolio Project: E-Commerce BI System | Capstone Enterprise BI System |

---

## Core Technical Skills Mastered

1. Database Modeling & Architecture:
   - Schema design with primary, foreign keys, identity sequences, and cascading constraints.
   - Self-referencing tables for corporate reporting lines and organizational hierarchies.

2. Complex Query Construction:
   - Multi-table joins (INNER, LEFT, RIGHT, FULL OUTER, SELF, CROSS).
   - Anti-Join patterns utilizing `WHERE right.key IS NULL` for automated data quality diagnostics.
   - Correlated and non-correlated subqueries, Common Table Expressions (CTEs), and recursive logic.

3. Advanced Analytical Window Functions:
   - Competition and dense ranking algorithms (`RANK`, `DENSE_RANK`, `ROW_NUMBER`).
   - Time-series and chronological navigation (`LEAD`, `LAG`) for period-over-period variance analysis.
   - Boundary value extraction (`FIRST_VALUE`, `LAST_VALUE`) with explicit framing (`ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`).
   - Customer RFM and performance binning using `NTILE(n)`.

4. Performance Engineering & Query Optimization:
   - Modular business logic encapsulation via virtual database views.
   - Single-column and composite B-Tree indexes for multi-attribute query acceleration.
   - Query execution plan diagnostics using `EXPLAIN ANALYZE` to eliminate costly sequential scans.

5. Procedural Database Programming:
   - PL/pgSQL User-Defined Functions (UDFs) for standardized business calculations.
   - Parameterized Stored Procedures executed via `CALL` for atomic batch modifications.
   - Event-driven database triggers enforcing non-bypassable automated audit trails.

6. Data Quality, Wrangling & Cleaning:
   - Casing standardization (`INITCAP`, `UPPER`, `LOWER`) and whitespace sanitization (`TRIM`).
   - Temporal transformations (`AGE`, `EXTRACT`, `DATE_TRUNC`).
   - Robust missing value imputation using `COALESCE` and equality evaluation via `NULLIF`.

---

## Capstone Portfolio Project: E-Commerce BI System (Day 11)

The capstone project in `Day11_SQL_Portfolio_Project` synthesizes the entire challenge into an enterprise analytics dashboard analyzing 1,590 orders across 35 states and 305 cities:
- Topline Revenue: Rs 2.80M generated with an Average Order Value of Rs 1,762.90.
- Geographic Concentration: Maharashtra (17.43%) and Karnataka (12.15%) generate nearly 30% of total revenue.
- Product 80/20 Rule: 30-day comprehensive weight management programs generate 52.66% of gross revenue.
- Supply Chain Metrics: 88.11% fulfillment rate contrasted with an 11.76% return rate, locking up Rs 304,000+ in return logistics.
- Customer Tiering: RFM-based value tiering dividing customer base into Premium, Gold, and Regular cohorts.

---

## Environment & Prerequisites

- Database Engine: PostgreSQL 14+
- Terminal Client: psql interactive terminal
- Version Control: Git & GitHub
- Repository: [https://github.com/Nirrajkadam/11_Days_11_SQL_Problems](https://github.com/Nirrajkadam/11_Days_11_SQL_Problems)
