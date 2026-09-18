-- Day 5: Views, Indexes & Query Optimization Database Setup
CREATE DATABASE day5_views_indexes_optimization;

\c day5_views_indexes_optimization;

CREATE TABLE orders (
    row_index INT,
    id INT,
    name VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    address TEXT,
    iscod BOOLEAN,
    date_placed TIMESTAMP,
    status VARCHAR(50),
    ivr VARCHAR(50),
    remarks TEXT,
    total NUMERIC,
    date_delivered TIMESTAMP,
    date_returned TIMESTAMP,
    pid VARCHAR(20),
    category VARCHAR(20),
    quantity INT,
    product_name VARCHAR(255)
);

\copy orders FROM 'dataset/OrdersCleaned_UTF8.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8';
