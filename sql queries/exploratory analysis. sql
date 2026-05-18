-- ANALYSIS QUERIES --

-- Total Sales by Region --

SELECT region, SUM(total_sales) AS revenue
FROM record_sales2
GROUP BY region
ORDER BY revenue DESC;

-- Top Selling Product --

SELECT product, SUM(total_sales) AS revenue
FROM record_sales2
GROUP BY product
ORDER BY revenue DESC;

-- Monthly Sales Trend --

SELECT 
DATE_FORMAT(order_date, '%Y-%m') AS month,
SUM(total_sales) AS revenue
FROM record_sales2
GROUP BY month
ORDER BY month;

-- Average Customer Spending --

SELECT AVG(customer_total) AS avg_customer_spending
FROM (
    SELECT customer_name,
           SUM(Total_sales) AS customer_total
    FROM record_sales2
    GROUP BY customer_name
) AS customer_spending;

-- Revenue distribution --

SELECT 
    CASE 
        WHEN Total_sales BETWEEN 0 AND 500 THEN '0-500'
        WHEN Total_sales BETWEEN 501 AND 1000 THEN '501-1000'
        WHEN Total_sales BETWEEN 1001 AND 1500 THEN '1001-1500'
        ELSE '1500+'
    END AS revenue_range,
    COUNT(*) AS number_of_orders,
    SUM(Total_sales) AS total_revenue
FROM record_sales2
GROUP BY 
    CASE 
        WHEN Total_sales BETWEEN 0 AND 500 THEN '0-500'
        WHEN Total_sales BETWEEN 501 AND 1000 THEN '501-1000'
        WHEN Total_sales BETWEEN 1001 AND 1500 THEN '1001-1500'
        ELSE '1500+'
    END
ORDER BY revenue_range;


-- Top Customers --

SELECT customer_name,
       SUM(Total_sales) AS total_spent
FROM record_sales2
GROUP BY customer_name
ORDER BY total_spent DESC
LIMIT 5;

SELECT *
FROM record_sales2;
