-- =============================================================================
-- Day 6: PostgreSQL Functions, Stored Procedures, and Triggers
-- Database: day6_functions_procedures_triggers
-- Author: Nirraj Kadam
-- 11 Days 11 SQL Problems Challenge
-- =============================================================================

-- -----------------------------------------------------------------------------
-- SECTION 1: VERIFY INITIAL DATA
-- -----------------------------------------------------------------------------

SELECT * FROM employees;


-- -----------------------------------------------------------------------------
-- PART 1: USER-DEFINED FUNCTIONS (UDF)
-- -----------------------------------------------------------------------------

-- Function 1: Calculate Annual Salary
-- Multiplies the monthly salary by 12.
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

-- Test Function 1
SELECT emp_name,
       salary,
       annual_salary(salary) AS annual_package
FROM employees;


-- Function 2: Add Performance Bonus (10%)
-- Computes the updated salary after appending a 10% bonus.
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

-- Test Function 2
SELECT emp_name,
       salary,
       add_bonus(salary) AS salary_with_bonus
FROM employees;


-- -----------------------------------------------------------------------------
-- PART 2: STORED PROCEDURES
-- -----------------------------------------------------------------------------

-- Procedure 1: Bulk Increment Employee Salaries
-- Executes an in-place UPDATE across the employee table by a parameter percentage.
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

-- Execute Procedure: Increase All Salaries by 10%
CALL increase_salary(10);

-- Verify Updated Salaries
SELECT * FROM employees;


-- -----------------------------------------------------------------------------
-- PART 3: TRIGGERS & AUDIT LOGGING
-- -----------------------------------------------------------------------------

-- Salary Change Log Table
CREATE TABLE salary_audit (
    audit_id SERIAL PRIMARY KEY,
    emp_id INT,
    old_salary NUMERIC,
    new_salary NUMERIC,
    changed_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger Function: Log Salary Changes
CREATE OR REPLACE FUNCTION log_salary_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO salary_audit(
        emp_id,
        old_salary,
        new_salary
    )
    VALUES(
        OLD.emp_id,
        OLD.salary,
        NEW.salary
    );
    RETURN NEW;
END;
$$;

-- Trigger on Salary Update
CREATE TRIGGER trg_salary_update
AFTER UPDATE OF salary
ON employees
FOR EACH ROW
EXECUTE FUNCTION log_salary_change();

-- Test Trigger: Update Salary for Rahul (emp_id = 1)
UPDATE employees
SET salary = 90000
WHERE emp_id = 1;

-- Verify Audit Log Record
SELECT * FROM salary_audit;


-- -----------------------------------------------------------------------------
-- PART 4: EXTRA PRACTICE & INTERVIEW CHALLENGES
-- -----------------------------------------------------------------------------

-- Extra Question 1: Calculate 18% Tax
CREATE OR REPLACE FUNCTION calculate_tax(
    amount NUMERIC
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN amount * 0.18;
END;
$$;

-- Test Extra Function 1
SELECT emp_name,
       salary,
       calculate_tax(salary) AS tax
FROM employees;


-- Extra Question 2: Increase Salary of IT Department by 15%
CREATE OR REPLACE PROCEDURE increment_it_salary()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE employees
    SET salary = salary * 1.15
    WHERE department = 'IT';
END;
$$;

-- Execute Extra Procedure 2
CALL increment_it_salary();

-- Verify IT Department Updated Salaries
SELECT *
FROM employees
WHERE department = 'IT';


-- Extra Question 3: Employee Insert Audit
CREATE TABLE employee_audit (
    audit_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100),
    department VARCHAR(50),
    inserted_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger Function: Log Employee Insert
CREATE OR REPLACE FUNCTION log_new_employee()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO employee_audit(
        emp_name,
        department
    )
    VALUES(
        NEW.emp_name,
        NEW.department
    );
    RETURN NEW;
END;
$$;

-- Trigger: On Employee Insert
CREATE TRIGGER trg_employee_insert
AFTER INSERT
ON employees
FOR EACH ROW
EXECUTE FUNCTION log_new_employee();
