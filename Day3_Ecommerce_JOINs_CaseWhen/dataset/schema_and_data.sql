-- Day 3: E-Commerce Database Setup
CREATE DATABASE day3_ecommerce_db;

\c day3_ecommerce_db;

CREATE TABLE orders (
    order_index INT,
    id INT,
    name VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    address TEXT,
    iscod BOOLEAN,
    date_placed TIMESTAMP,
    status VARCHAR(50),
    ivr VARCHAR(50),
    remarks TEXT,
    total NUMERIC(10, 2),
    date_delivered TIMESTAMP,
    date_returned TIMESTAMP,
    pid VARCHAR(50),
    category VARCHAR(50),
    quantity INT,
    product_name VARCHAR(255)
);

\copy orders FROM 'dataset/OrdersCleaned_UTF8.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE customers AS
SELECT DISTINCT
       id AS customer_id,
       name,
       city,
       state
FROM orders;
