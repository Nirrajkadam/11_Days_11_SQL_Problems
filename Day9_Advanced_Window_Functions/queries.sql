-- =============================================================================
-- Day 9: Advanced Window Functions (ROW_NUMBER, RANK, DENSE_RANK, LEAD, LAG, NTILE, etc.)
-- Database: day9_advanced_window_functions
-- Author: Nirraj Kadam
-- 11 Days 11 SQL Problems Challenge
-- =============================================================================

-- -----------------------------------------------------------------------------
-- SECTION 1: VERIFY INITIAL DATA
-- -----------------------------------------------------------------------------

SELECT * FROM sales;


-- -----------------------------------------------------------------------------
-- PART 1: RANKING FUNCTIONS
-- -----------------------------------------------------------------------------

-- Query 1: ROW_NUMBER()
-- Assigns a unique, strictly sequential integer to every row based on order.
SELECT salesperson,
       sale_amount,
       ROW_NUMBER() OVER(
            ORDER BY sale_amount DESC
       ) AS row_num
FROM sales;

-- Query 2: RANK()
-- Assigns rank with gaps when tied values are present.
SELECT salesperson,
       sale_amount,
       RANK() OVER(
            ORDER BY sale_amount DESC
       ) AS rank_no
FROM sales;

-- Query 3: DENSE_RANK()
-- Assigns rank without gaps for tied values.
SELECT salesperson,
       sale_amount,
       DENSE_RANK() OVER(
            ORDER BY sale_amount DESC
       ) AS dense_rank_no
FROM sales;


-- -----------------------------------------------------------------------------
-- PART 2: VALUE & NAVIGATION FUNCTIONS
-- -----------------------------------------------------------------------------

-- Query 4: Running Total (Cumulative Revenue)
SELECT sale_date,
       sale_amount,
       SUM(sale_amount) OVER(
            ORDER BY sale_date
       ) AS running_total
FROM sales;

-- Query 5: LEAD() - Next Transaction Value
SELECT salesperson,
       sale_amount,
       LEAD(sale_amount) OVER(
            ORDER BY sale_date
       ) AS next_sale
FROM sales;

-- Query 6: LAG() - Previous Transaction Value
SELECT salesperson,
       sale_amount,
       LAG(sale_amount) OVER(
            ORDER BY sale_date
       ) AS previous_sale
FROM sales;

-- Query 7: FIRST_VALUE() - Highest Overall Transaction in Dataset
SELECT salesperson,
       sale_amount,
       FIRST_VALUE(sale_amount) OVER(
            ORDER BY sale_amount DESC
       ) AS highest_sale
FROM sales;

-- Query 8: LAST_VALUE() - Lowest Overall Transaction (Explicit Framing Required)
SELECT salesperson,
       sale_amount,
       LAST_VALUE(sale_amount) OVER(
            ORDER BY sale_amount DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND UNBOUNDED FOLLOWING
       ) AS lowest_sale
FROM sales;


-- -----------------------------------------------------------------------------
-- PART 3: DISTRIBUTION & PARTITIONED WINDOWING
-- -----------------------------------------------------------------------------

-- Query 9: NTILE(4) - Quartile Distribution
SELECT salesperson,
       sale_amount,
       NTILE(4) OVER(
            ORDER BY sale_amount DESC
       ) AS quartile
FROM sales;

-- Query 10: Top Performer Per Region (PARTITION BY + Top-N Filter)
SELECT *
FROM
(
    SELECT salesperson,
           region,
           sale_amount,
           ROW_NUMBER() OVER(
               PARTITION BY region
               ORDER BY sale_amount DESC
           ) AS rn
    FROM sales
) x
WHERE rn = 1;


-- -----------------------------------------------------------------------------
-- PART 4: BONUS INTERVIEW PROBLEMS
-- -----------------------------------------------------------------------------

-- Bonus 1: Region-wise Ranking
SELECT salesperson,
       region,
       sale_amount,
       RANK() OVER(
            PARTITION BY region
            ORDER BY sale_amount DESC
       ) AS region_rank
FROM sales;

-- Bonus 2: Percentage Contribution to Total Sales
SELECT salesperson,
       sale_amount,
       ROUND(
           sale_amount * 100.0 /
           SUM(sale_amount) OVER(),
           2
       ) AS contribution_percent
FROM sales;

-- Bonus 3: Difference From Previous Sale (Transaction Velocity / Growth)
SELECT salesperson,
       sale_amount,
       sale_amount -
       LAG(sale_amount) OVER(
            ORDER BY sale_date
       ) AS difference
FROM sales;
