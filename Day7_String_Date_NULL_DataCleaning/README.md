# Day 7: String Functions, Date Functions, NULL Handling, and Data Cleaning

Welcome to Day 7 of the 11 Days 11 SQL Problems Challenge.
In Day 7, we focused on essential Data Cleaning, String Formatting, Date Manipulation, and NULL Handling techniques in PostgreSQL within database `day7_string_date_functions`. These operations reflect daily data preparation, data wrangling, and feature engineering tasks performed by Data Analysts and Data Engineers.

---

## Project Structure

```text
Day7_String_Date_NULL_DataCleaning
|
|-- README.md
|-- queries.sql
|-- screenshots/
|   |-- 01_create_db_table_and_insert.png
|   |-- 02_upper_lower_initcap.png
|   |-- 03_length_substring_replace.png
|   |-- 04_trim_current_date_timestamp_age.png
|   `-- 05_extract_coalesce_nullif.png
`-- dataset/
    `-- schema_and_data.sql
```

---

## Database and Table Setup

Database: `day7_string_date_functions`

```sql
CREATE DATABASE day7_string_date_functions;
\c day7_string_date_functions;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100),
    department VARCHAR(50),
    salary NUMERIC(10,2),
    email VARCHAR(100),
    joining_date DATE
);

INSERT INTO employees (emp_name, department, salary, email, joining_date)
VALUES
('rahul sharma', 'IT', 50000.00, 'rahul@gmail.com', '2023-01-15'),
('PRIYA PATIL', 'HR', 45000.00, 'priya@gmail.com', '2022-05-10'),
('Amit Kumar', 'IT', 70000.00, NULL, '2021-03-20'),
('Sneha Joshi', 'Finance', 60000.00, 'sneha@gmail.com', '2020-07-01'),
('Rohit Verma', 'IT', 80000.00, NULL, '2019-08-25');
```

Initial Employee Table State:

| emp_id | emp_name | department | salary (Rs) | email | joining_date |
|---|---|---|---|---|---|
| 1 | rahul sharma | IT | 50,000.00 | rahul@gmail.com | 2023-01-15 |
| 2 | PRIYA PATIL | HR | 45,000.00 | priya@gmail.com | 2022-05-10 |
| 3 | Amit Kumar | IT | 70,000.00 | NULL | 2021-03-20 |
| 4 | Sneha Joshi | Finance | 60,000.00 | sneha@gmail.com | 2020-07-01 |
| 5 | Rohit Verma | IT | 80,000.00 | NULL | 2019-08-25 |

---

## Part 1: String Functions

String operations standardize inconsistent text casing, isolate key identifiers, and clean up formatting issues.

### 1. UPPER(): Convert Name to Uppercase
```sql
SELECT emp_name,
       UPPER(emp_name) AS upper_name
FROM employees;
```
| emp_name | upper_name |
|---|---|
| rahul sharma | RAHUL SHARMA |
| PRIYA PATIL | PRIYA PATIL |
| Amit Kumar | AMIT KUMAR |
| Sneha Joshi | SNEHA JOSHI |
| Rohit Verma | ROHIT VERMA |

---

### 2. LOWER(): Convert Name to Lowercase
```sql
SELECT emp_name,
       LOWER(emp_name) AS lower_name
FROM employees;
```
| emp_name | lower_name |
|---|---|
| rahul sharma | rahul sharma |
| PRIYA PATIL | priya patil |
| Amit Kumar | amit kumar |
| Sneha Joshi | sneha joshi |
| Rohit Verma | rohit verma |

---

### 3. INITCAP(): Convert to Title Case / Proper Name Format
```sql
SELECT emp_name,
       INITCAP(emp_name) AS formatted_name
FROM employees;
```
| emp_name | formatted_name |
|---|---|
| rahul sharma | Rahul Sharma |
| PRIYA PATIL | Priya Patil |
| Amit Kumar | Amit Kumar |
| Sneha Joshi | Sneha Joshi |
| Rohit Verma | Rohit Verma |

---

### 4. LENGTH(): String Character Count
```sql
SELECT emp_name,
       LENGTH(emp_name) AS name_length
FROM employees;
```
| emp_name | name_length |
|---|---|
| rahul sharma | 12 |
| PRIYA PATIL | 11 |
| Amit Kumar | 10 |
| Sneha Joshi | 11 |
| Rohit Verma | 11 |

---

### 5. SUBSTRING(): Substring Extraction (First 5 Characters)
```sql
SELECT emp_name,
       SUBSTRING(emp_name, 1, 5) AS substring
FROM employees;
```
| emp_name | substring |
|---|---|
| rahul sharma | rahul |
| PRIYA PATIL | PRIYA |
| Amit Kumar | Amit |
| Sneha Joshi | Sneha |
| Rohit Verma | Rohit |

---

### 6. REPLACE(): String Pattern Replacement
```sql
SELECT email,
       REPLACE(email, 'gmail.com', 'company.com') AS replace
FROM employees;
```
| email | replace |
|---|---|
| rahul@gmail.com | rahul@company.com |
| priya@gmail.com | priya@company.com |
| NULL | NULL |
| sneha@gmail.com | sneha@company.com |
| NULL | NULL |

---

### 7. TRIM(): Whitespace Cleaning
```sql
SELECT TRIM('    SQL Learning    ') AS btrim;
```
| btrim |
|---|
| SQL Learning |

---

## Part 2: Date and Time Functions

Temporal functions enable cohort analysis, tenure calculations, and chronological reporting.

### 8. CURRENT_DATE: System Calendar Date
```sql
SELECT CURRENT_DATE AS current_date;
```
- Output: `2026-09-20`

---

### 9. CURRENT_TIMESTAMP: High-Precision Timestamp with Timezone
```sql
SELECT CURRENT_TIMESTAMP AS current_timestamp;
```
- Output: `2026-09-20 12:27:24.989393+05:30`

---

### 10. AGE(): Employee Tenure Calculation
```sql
SELECT emp_name,
       AGE(CURRENT_DATE, joining_date) AS age
FROM employees;
```
| emp_name | age |
|---|---|
| rahul sharma | 3 years 8 mons 5 days |
| PRIYA PATIL | 4 years 4 mons 10 days |
| Amit Kumar | 5 years 6 mons |
| Sneha Joshi | 6 years 2 mons 19 days |
| Rohit Verma | 7 years 26 days |

---

### 11. EXTRACT(): Extract Specific Date Component (Joining Year)
```sql
SELECT emp_name,
       EXTRACT(YEAR FROM joining_date) AS extract
FROM employees;
```
| emp_name | extract |
|---|---|
| rahul sharma | 2023 |
| PRIYA PATIL | 2022 |
| Amit Kumar | 2021 |
| Sneha Joshi | 2020 |
| Rohit Verma | 2019 |

---

## Part 3: NULL Handling and Conditional Logic

Handling missing attributes is essential to prevent erroneous statistical aggregations and broken application pipelines.

### 12. COALESCE(): Missing Value Imputation
```sql
SELECT emp_name,
       COALESCE(email, 'No Email') AS coalesce
FROM employees;
```
| emp_name | coalesce |
|---|---|
| rahul sharma | rahul@gmail.com |
| PRIYA PATIL | priya@gmail.com |
| Amit Kumar | No Email |
| Sneha Joshi | sneha@gmail.com |
| Rohit Verma | No Email |

---

### 13. NULLIF(): Equality Verification
Returns NULL if the two arguments are identical; otherwise returns the first argument.
```sql
SELECT NULLIF(100, 100) AS nullif;
```
| nullif |
|---|
| NULL |

---

### 14. CASE WHEN: Conditional Categorization
```sql
SELECT emp_name,
       salary,
       CASE
           WHEN salary >= 70000 THEN 'High Salary'
           WHEN salary >= 50000 THEN 'Medium Salary'
           ELSE 'Low Salary'
       END AS salary_group
FROM employees;
```
| emp_name | salary (Rs) | salary_group |
|---|---|---|
| rahul sharma | 50,000.00 | Medium Salary |
| PRIYA PATIL | 45,000.00 | Low Salary |
| Amit Kumar | 70,000.00 | High Salary |
| Sneha Joshi | 60,000.00 | Medium Salary |
| Rohit Verma | 80,000.00 | High Salary |

---

## Part 4: Practical Data Cleaning Tasks

### 15. Standardize Inconsistent Name Casing
```sql
SELECT INITCAP(emp_name) AS clean_name
FROM employees;
```

### 16. Identify Missing Contact Records
```sql
SELECT *
FROM employees
WHERE email IS NULL;
```
| emp_id | emp_name | department | salary | email | joining_date |
|---|---|---|---|---|---|
| 3 | Amit Kumar | IT | 70000.00 | NULL | 2021-03-20 |
| 5 | Rohit Verma | IT | 80000.00 | NULL | 2019-08-25 |

### 17. Quantify Data Incompleteness (Missing Email Count)
```sql
SELECT COUNT(*) AS missing_email_count
FROM employees
WHERE email IS NULL;
```
- Missing Email Count: `2`

---

## Terminal Verification Screenshots

All executions were verified directly in the PostgreSQL interactive terminal:

1. `01_create_db_table_and_insert.png`: Database creation, schema instantiation, and sample record insertion
2. `02_upper_lower_initcap.png`: String casing standardization using UPPER(), LOWER(), and INITCAP()
3. `03_length_substring_replace.png`: Character length analysis, string extraction, and domain replacement
4. `04_trim_current_date_timestamp_age.png`: Whitespace trimming, system date/time extraction, and tenure calculation with AGE()
5. `05_extract_coalesce_nullif.png`: EXTRACT(YEAR), COALESCE() default substitution, and NULLIF() evaluation

---

## Key Business & Engineering Insights

1. Data Standardization: Raw inputs frequently contain inconsistent casing (all caps or all lowercase). Functions like `INITCAP()` enforce standard title-case presentation for customer-facing reports.
2. Robust Null Treatment: `COALESCE()` prevents missing email attributes from corrupting downstream communications or generating unintended blanks in reporting dashboards.
3. Automated Tenure Tracking: `AGE(CURRENT_DATE, joining_date)` computes accurate dynamic experience intervals without manual date recalculation.
4. Domain Migration: `REPLACE()` enables programmatic email migrations and bulk string transformations directly in SQL pipelines.

---

## LinkedIn Post Draft

```text
Day 7 of #11Days11SQLProblems: String Functions, Date Functions, NULL Handling & Data Cleaning

Today I completed Day 7 of my 11 Days SQL Challenge by focusing on essential data wrangling and cleaning operations in PostgreSQL.

Key Technical Skills Applied:
- String Standardization: UPPER(), LOWER(), INITCAP(), LENGTH(), SUBSTRING(), REPLACE(), TRIM()
- Temporal Analytics: CURRENT_DATE, CURRENT_TIMESTAMP, AGE(), EXTRACT()
- NULL Handling & Fallbacks: COALESCE(), NULLIF()
- Conditional Grouping: CASE WHEN logic for multi-tier salary classification
- Data Hygiene: Identifying and counting incomplete records (WHERE email IS NULL)

Key Takeaways:
- Standardizing raw text with INITCAP() and TRIM() resolves presentation inconsistencies.
- Utilizing AGE() dynamically calculates accurate employee tenures across multi-year intervals.
- COALESCE() provides fallback values for missing records, safeguarding downstream analytics.

GitHub Repository:
https://github.com/Nirrajkadam/11_Days_11_SQL_Problems/tree/main/Day7_String_Date_NULL_DataCleaning

#SQL #PostgreSQL #DataCleaning #DataWrangling #DataAnalytics #DataEngineering #DatabaseManagement #11DaysOfSQL
```

---

## Day 7 Completion Checklist
- Database Created (`day7_string_date_functions`)
- Employees Table Created & 5 Inconsistent Records Seeded
- String Functions Executed (UPPER, LOWER, INITCAP, LENGTH, SUBSTRING, REPLACE, TRIM)
- Date Functions Executed (CURRENT_DATE, CURRENT_TIMESTAMP, AGE, EXTRACT)
- NULL Handling Operations Verified (COALESCE, NULLIF)
- Conditional Business Logic Implemented (CASE WHEN)
- Data Cleaning Hygiene Queries Documented
- All Terminal Screenshots Verified and Linked
- Git Repository Synchronized and Pushed
