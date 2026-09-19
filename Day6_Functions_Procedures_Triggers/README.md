# Day 6: PostgreSQL Functions, Stored Procedures, and Triggers

Welcome to Day 6 of the 11 Days 11 SQL Problems Challenge.
In Day 6, we focused on procedural database programming in PostgreSQL within database `day6_functions_procedures_triggers`. We implemented User-Defined Functions (UDFs) for business calculations, parameterized Stored Procedures for transactional data manipulation, and automated Triggers with dedicated audit logging tables to track historical salary changes and employee onboarding.

---

## Project Structure

```text
Day6_Functions_Procedures_Triggers
|
|-- README.md
|-- queries.sql
|-- screenshots/
|   |-- 01_create_db.png
|   |-- 02_create_table_and_insert.png
|   |-- 03_annual_salary_function.png
|   |-- 04_bonus_function.png
|   `-- 05_increase_salary_procedure.png
`-- dataset/
    `-- schema_and_data.sql
```

---

## Database and Table Setup

Database: `day6_functions_procedures_triggers`

```sql
CREATE DATABASE day6_functions_procedures_triggers;
\c day6_functions_procedures_triggers;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary NUMERIC(10,2) NOT NULL,
    joining_date DATE NOT NULL
);

INSERT INTO employees (emp_name, department, salary, joining_date)
VALUES
('Rahul', 'IT', 50000.00, '2023-01-15'),
('Priya', 'HR', 45000.00, '2022-05-10'),
('Amit', 'IT', 70000.00, '2021-03-20'),
('Sneha', 'Finance', 60000.00, '2020-07-01'),
('Rohit', 'IT', 80000.00, '2019-08-25');
```

Initial Employee Table State:

| emp_id | emp_name | department | salary (Rs) | joining_date |
|---|---|---|---|---|
| 1 | Rahul | IT | 50,000.00 | 2023-01-15 |
| 2 | Priya | HR | 45,000.00 | 2022-05-10 |
| 3 | Amit | IT | 70,000.00 | 2021-03-20 |
| 4 | Sneha | Finance | 60,000.00 | 2020-07-01 |
| 5 | Rohit | IT | 80,000.00 | 2019-08-25 |

---

## Part 1: User-Defined Functions (UDFs)

PostgreSQL user-defined functions encapsulate reusable analytical computation logic and return a scalar value or dataset directly into `SELECT` queries.

### 1. Function 1: Annual Salary Calculator
```sql
CREATE OR REPLACE FUNCTION annual_salary(
    monthly_salary NUMERIC
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN monthly_salary * 12;
END;
$$;

SELECT emp_name,
       salary,
       annual_salary(salary) AS annual_package
FROM employees;
```

Output:

| emp_name | salary (Rs) | annual_package (Rs) |
|---|---|---|
| Rahul | 50,000.00 | 600,000.00 |
| Priya | 45,000.00 | 540,000.00 |
| Amit | 70,000.00 | 840,000.00 |
| Sneha | 60,000.00 | 720,000.00 |
| Rohit | 80,000.00 | 960,000.00 |

---

### 2. Function 2: Performance Bonus Calculator (10%)
```sql
CREATE OR REPLACE FUNCTION add_bonus(
    salary NUMERIC
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN salary * 1.10;
END;
$$;

SELECT emp_name,
       salary,
       add_bonus(salary) AS salary_with_bonus
FROM employees;
```

Output:

| emp_name | salary (Rs) | salary_with_bonus (Rs) |
|---|---|---|
| Rahul | 50,000.00 | 55,000.00 |
| Priya | 45,000.00 | 49,500.00 |
| Amit | 70,000.00 | 77,000.00 |
| Sneha | 60,000.00 | 66,000.00 |
| Rohit | 80,000.00 | 88,000.00 |

---

## Part 2: Stored Procedures

Unlike functions, stored procedures are executed using the `CALL` statement and are designed to perform transactional data manipulation language (DML) operations in-place without requiring a return statement.

### 1. Procedure 1: Bulk Salary Increment
```sql
CREATE OR REPLACE PROCEDURE increase_salary(
    percent_increase NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE employees
    SET salary = salary + (salary * percent_increase / 100);
END;
$$;

CALL increase_salary(10);

SELECT * FROM employees;
```

Updated Employee Table State (Post 10% Increment):

| emp_id | emp_name | department | previous_salary (Rs) | updated_salary (Rs) |
|---|---|---|---|---|
| 1 | Rahul | IT | 50,000.00 | 55,000.00 |
| 2 | Priya | HR | 45,000.00 | 49,500.00 |
| 3 | Amit | IT | 70,000.00 | 77,000.00 |
| 4 | Sneha | Finance | 60,000.00 | 66,000.00 |
| 5 | Rohit | IT | 80,000.00 | 88,000.00 |

---

## Part 3: Triggers and Audit Logging

Triggers automatically fire a trigger function in response to specific events (`INSERT`, `UPDATE`, `DELETE`) on a designated table, providing non-bypassable enterprise audit logging.

### 1. Salary Modification Audit Table
```sql
CREATE TABLE salary_audit (
    audit_id SERIAL PRIMARY KEY,
    emp_id INT NOT NULL,
    old_salary NUMERIC(10,2) NOT NULL,
    new_salary NUMERIC(10,2) NOT NULL,
    changed_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 2. Trigger Function and Binding
```sql
CREATE OR REPLACE FUNCTION log_salary_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO salary_audit (emp_id, old_salary, new_salary)
    VALUES (OLD.emp_id, OLD.salary, NEW.salary);
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_salary_update
AFTER UPDATE OF salary
ON employees
FOR EACH ROW
EXECUTE FUNCTION log_salary_change();
```

### 3. Trigger Verification Test
```sql
UPDATE employees
SET salary = 95000.00
WHERE emp_id = 5;

SELECT * FROM salary_audit;
```

Audit Log Record:

| audit_id | emp_id | old_salary (Rs) | new_salary (Rs) | changed_on |
|---|---|---|---|---|
| 1 | 5 | 88,000.00 | 95,000.00 | Current Timestamp |

---

## Part 4: Extra Practice & Interview Scenarios

### Scenario 1: Tax Deduction UDF (18%)
```sql
CREATE OR REPLACE FUNCTION calculate_tax(
    amount NUMERIC
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN ROUND(amount * 0.18, 2);
END;
$$;

SELECT emp_name,
       salary,
       calculate_tax(salary) AS tax_deduction,
       salary - calculate_tax(salary) AS net_in_hand
FROM employees;
```

### Scenario 2: Department-Targeted Increment Procedure
```sql
CREATE OR REPLACE PROCEDURE increment_it_salary()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE employees
    SET salary = salary * 1.15
    WHERE department = 'IT';
END;
$$;

CALL increment_it_salary();
```

### Scenario 3: Employee Onboarding Insert Trigger
```sql
CREATE TABLE employee_audit (
    audit_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    inserted_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_new_employee()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO employee_audit (emp_name, department)
    VALUES (NEW.emp_name, NEW.department);
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_employee_insert
AFTER INSERT
ON employees
FOR EACH ROW
EXECUTE FUNCTION log_new_employee();
```

---

## Architectural Comparison: Functions vs Procedures vs Triggers

| Feature | User-Defined Function (UDF) | Stored Procedure | Database Trigger |
|---|---|---|---|
| Primary Purpose | Return calculated data | Execute business logic & DML | Enforce rules & record audits |
| Invocation | Called in `SELECT` queries | Called explicitly via `CALL` | Fired automatically by database events |
| Return Value | Mandatory (scalar or table) | None / OUT parameters | Returns `TRIGGER` (`NEW`/`OLD`) |
| Transaction Support | Cannot commit/rollback transactions | Full transaction control (`COMMIT`/`ROLLBACK`) | Runs inside parent transaction |
| Typical Use Case | Calculations, string transforms, formatting | Batch payroll updates, ETL processes | Change data capture, audit trails |

---

## Terminal Verification Screenshots

All steps and executions were verified in the PostgreSQL terminal:

1. `01_create_db.png`: Database creation and connection setup
2. `02_create_table_and_insert.png`: Table definition and initial data population
3. `03_annual_salary_function.png`: Annual salary function creation and verification
4. `04_bonus_function.png`: 10% bonus calculation function execution
5. `05_increase_salary_procedure.png`: Procedure creation, execution (`CALL`), and verification

---

## Key Business Insights

1. Logic Encapsulation: Storing calculations (annual packages, bonus tiers, tax deductions) inside database functions guarantees consistent calculation rules across web applications, analytics tools, and reporting dashboards.
2. Controlled Data Modification: Stored procedures standardize DML operations, allowing atomic batch updates without exposing table access directly to client applications.
3. Automated Regulatory Compliance: Database-level triggers guarantee non-bypassable auditing for financial and compensation modifications, capturing historical records even during manual DBA interventions.

---

## LinkedIn Post Draft

```text
Day 6 of #11Days11SQLProblems: PostgreSQL Functions, Stored Procedures & Triggers

Today I completed Day 6 of my 11 Days SQL Challenge by diving into procedural SQL development in PostgreSQL.

Key Technical Skills Applied:
- User-Defined Functions (PL/pgSQL functions for repeatable business calculations)
- Stored Procedures (Transactional DML batch processing using CALL)
- Event-Driven Triggers (AFTER UPDATE and AFTER INSERT execution triggers)
- Enterprise Audit Logging (Change Data Capture capturing OLD vs NEW values)

Key Technical Implementations:
- User-Defined Functions: Created annual_salary() and add_bonus() to standardize payroll logic directly inside SELECT queries.
- Stored Procedures: Implemented increase_salary() to manage atomic, parameter-driven salary revisions across employee records.
- Automated Audit Logging: Configured trg_salary_update trigger with a dedicated salary_audit table to log historical wage revisions automatically with timestamps.

GitHub Repository:
https://github.com/Nirrajkadam/11_Days_11_SQL_Problems/tree/main/Day6_Functions_Procedures_Triggers

#SQL #PostgreSQL #StoredProcedures #DatabaseFunctions #DatabaseTriggers #AuditLogging #DataEngineering #DatabaseAdministration #11DaysOfSQL
```

---

## Day 6 Completion Checklist
- Database Created (`day6_functions_procedures_triggers`)
- Employees Table Created & 5 Records Seeded
- Function 1 Created (`annual_salary`) & Verified
- Function 2 Created (`add_bonus`) & Verified
- Stored Procedure Created (`increase_salary`) & Executed
- Salary Audit Table & Trigger Configured (`log_salary_change`)
- Extra Practice Questions Documented
- All Terminal Screenshots Verified and Linked
- Git Repository Synchronized and Pushed
