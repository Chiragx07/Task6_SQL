CREATE DATABASE online_sales_db;
USE online_sales_db;
CREATE TABLE online_sales_orders (
    transaction_id      INT PRIMARY KEY,
    order_date          DATE,
    product_category    VARCHAR(100),
    product_name        VARCHAR(150),
    units_sold          INT,
    unit_price          DECIMAL(10,2),
    total_revenue       DECIMAL(12,2),
    region              VARCHAR(100),
    payment_method      VARCHAR(50)
);
SELECT COUNT(*) FROM online_sales_orders;
DESCRIBE online_sales_orders;
SELECT order_date, total_revenue FROM online_sales_orders LIMIT 5;
SELECT DATE_FORMAT(order_date,'%Y-%m') FROM online_sales_orders LIMIT 5;
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS `year_month`,
    SUM(total_revenue) AS `total_revenue`,
    COUNT(DISTINCT transaction_id) AS `total_orders`
FROM online_sales_orders
GROUP BY `year_month`
ORDER BY `year_month`;
SELECT DATE_FORMAT(order_date,'%Y-%m') AS ym, SUM(total_revenue) AS total_rev, COUNT(DISTINCT transaction_id) AS total_orders FROM online_sales_orders GROUP BY ym ORDER BY ym;
SELECT DATE_FORMAT(STR_TO_DATE(order_date,'%Y-%m-%d'),'%Y-%m') AS ym, SUM(total_revenue) AS total_rev, COUNT(DISTINCT transaction_id) AS total_orders FROM online_sales_orders GROUP BY ym ORDER BY ym;
SELECT 
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    SUM(total_revenue) AS total_revenue,
    COUNT(DISTINCT transaction_id) AS total_orders
FROM online_sales_orders
GROUP BY year, month
ORDER BY year, month;

SELECT 
    DATE_FORMAT(order_date,'%Y-%m') AS ym,
    SUM(total_revenue) AS total_revenue,
    COUNT(DISTINCT transaction_id) AS total_orders
FROM online_sales_orders
WHERE YEAR(order_date) = 2024
GROUP BY ym
ORDER BY ym;

SELECT 
    ym,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY ym) AS prev_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY ym)) 
        / LAG(total_revenue) OVER (ORDER BY ym) * 100, 2
    ) AS growth_percent
FROM (
    SELECT DATE_FORMAT(order_date,'%Y-%m') AS ym,
           SUM(total_revenue) AS total_revenue
    FROM online_sales_orders
    GROUP BY ym
) AS t;
