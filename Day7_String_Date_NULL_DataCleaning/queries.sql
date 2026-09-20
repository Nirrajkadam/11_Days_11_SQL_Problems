-- =============================================================================
-- Day 7: String Functions, Date Functions, NULL Handling, and Data Cleaning
-- Database: day7_string_date_functions
-- Author: Nirraj Kadam
-- 11 Days 11 SQL Problems Challenge
-- =============================================================================

-- -----------------------------------------------------------------------------
-- SECTION 1: VERIFY INITIAL DATA
-- -----------------------------------------------------------------------------

SELECT * FROM employees;


-- -----------------------------------------------------------------------------
-- PART 1: STRING FUNCTIONS
-- -----------------------------------------------------------------------------

-- Query 1: Convert Name to Uppercase
SELECT emp_name,
       UPPER(emp_name) AS upper_name
FROM employees;

-- Query 2: Convert Name to Lowercase
SELECT emp_name,
       LOWER(emp_name) AS lower_name
FROM employees;

-- Query 3: Proper Name Formatting (Title Case)
SELECT emp_name,
       INITCAP(emp_name) AS formatted_name
FROM employees;

-- Query 4: Character Length of Names
SELECT emp_name,
       LENGTH(emp_name) AS name_length
FROM employees;

-- Query 5: Substring Extraction (First 5 Characters)
SELECT emp_name,
       SUBSTRING(emp_name, 1, 5) AS substring
FROM employees;

-- Query 6: Domain Replacement in Email Addresses
SELECT email,
       REPLACE(email, 'gmail.com', 'company.com') AS replace
FROM employees;

-- Query 7: Trim Leading and Trailing Whitespace
SELECT TRIM('    SQL Learning    ') AS btrim;


-- -----------------------------------------------------------------------------
-- PART 2: DATE AND TIME FUNCTIONS
-- -----------------------------------------------------------------------------

-- Query 8: Current Date
SELECT CURRENT_DATE AS current_date;

-- Query 9: Current Timestamp with Timezone
SELECT CURRENT_TIMESTAMP AS current_timestamp;

-- Query 10: Employee Tenure / Experience (Years, Months, Days)
SELECT emp_name,
       AGE(CURRENT_DATE, joining_date) AS age
FROM employees;

-- Query 11: Extract Joining Year
SELECT emp_name,
       EXTRACT(YEAR FROM joining_date) AS extract
FROM employees;


-- -----------------------------------------------------------------------------
-- PART 3: NULL HANDLING
-- -----------------------------------------------------------------------------

-- Query 12: Handle NULL Values using COALESCE
SELECT emp_name,
       COALESCE(email, 'No Email') AS coalesce
FROM employees;

-- Query 13: Compare Values using NULLIF
SELECT NULLIF(100, 100) AS nullif;

-- Query 14: Salary Tier Classification using CASE WHEN
SELECT emp_name,
       salary,
       CASE
           WHEN salary >= 70000 THEN 'High Salary'
           WHEN salary >= 50000 THEN 'Medium Salary'
           ELSE 'Low Salary'
       END AS salary_group
FROM employees;


-- -----------------------------------------------------------------------------
-- PART 4: DATA CLEANING & RECTIFICATION TASKS
-- -----------------------------------------------------------------------------

-- Query 15: Standardize All Employee Names to Proper Case
SELECT INITCAP(emp_name) AS clean_name
FROM employees;

-- Query 16: Identify Employees with Missing Contact Information
SELECT *
FROM employees
WHERE email IS NULL;

-- Query 17: Aggregate Count of Missing Emails
SELECT COUNT(*) AS missing_email_count
FROM employees
WHERE email IS NULL;
