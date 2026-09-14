CREATE DATABASE day1_sql_detective;

\c day1_sql_detective

CREATE TABLE transactions(
    transaction_id INT,
    transation_date DATE,
    category VARCHAR(50),
    amount DECIMAL(10,2),
    payment_mode VARCHAR(20)
);

INSERT INTO transactions VALUES
(1,'2025-09-01','Food',250,'UPI'),
(2,'2025-09-01','Fuel',500,'UPI'),
(3,'2025-09-02','Shopping',1200,'Card'),
(4,'2025-09-03','Travel',2500,'Card'),
(5,'2025-09-04','Medical',800,'UPI');
