-- CREATE DUPLICATE TABLE FOR DATA CLEANING --

CREATE TABLE `record_sales2` (
  `Order_ID` int DEFAULT NULL,
  `Order_Date` text,
  `Ship_Date` text,
  `Customer_Name` text,
  `Region` text,
  `Product` text,
  `Category` text,
  `Quantity` int DEFAULT NULL,
  `Unit_Price` int DEFAULT NULL,
  `Total_Sales` int DEFAULT NULL,
  `Payment_Method` text,
  `Status` text,
  row_num INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM record_sales2
;

-- INSERT VALUES INTO DUPLICATE TABLE --

INSERT INTO record_sales2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY Order_ID ) AS row_num
FROM record_sales;

SELECT *
FROM record_sales2
;

-- DELETE DUPLICATE --

DELETE
FROM record_sales2
WHERE row_num > 1;

SELECT *
FROM record_sales2;

-- STANDARDIZING DATA --

SELECT Customer_Name, TRIM(Customer_Name)
FROM record_sales2;

UPDATE record_sales2
SET Customer_Name = TRIM(Customer_Name);

-- FORMATING DATE TO ACTUAL DATE --

SELECT Order_Date, STR_TO_DATE(Order_Date, '%m/%d/%Y')
FROM record_sales2;

UPDATE record_sales2
SET Order_Date = STR_TO_DATE(Order_Date, '%m/%d/%Y');

SELECT Ship_Date, STR_TO_DATE(Ship_Date, '%m/%d/%Y')
FROM record_sales2;

SELECT *
FROM record_sales2;

SELECT Ship_Date
FROM record_sales2
WHERE Ship_Date LIKE '%/%'
;

UPDATE record_sales2
SET Ship_Date = STR_TO_DATE(Ship_Date, '%d/%m/%Y')
WHERE Ship_Date LIKE '__/__/____'
;

SELECT Ship_Date, STR_TO_DATE(Ship_Date, '%d/%m/%Y')
FROM record_sales2;

UPDATE record_sales2
SET Ship_Date = STR_TO_DATE(Ship_Date, '%d/%m/%Y')
WHERE Ship_Date LIKE '_/__/____'
;

SELECT *
FROM record_sales2;
SELECT Ship_Date, STR_TO_DATE(Ship_Date, '%d/%m/%Y')
FROM record_sales2;

UPDATE record_sales2
SET Ship_Date = STR_TO_DATE(Ship_Date, '%m/%d/%Y')
WHERE Ship_Date LIKE '_/__/____'
;

-- Handle Missing Date --

UPDATE record_sales2
SET Ship_Date = 'Not Specified'
WHERE Ship_Date IS NULL OR Ship_Date = '';

SELECT *
FROM record_sales2;

-- Handle Missing Customer Name --

UPDATE record_sales2
SET Customer_Name = 'Unknown'
WHERE Customer_Name IS NULL OR Customer_Name = '';

SELECT *
FROM record_sales2;

-- Clean Quantity (Remove 'abc') --

UPDATE record_sales2
SET quantity = NULL
WHERE quantity REGEXP '[^0-9-]';

SELECT *
FROM record_sales2;

-- Convert to integer --

ALTER TABLE record_sales2
MODIFY quantity INT;

SELECT *
FROM record_sales2;

-- Fix Unit Price (Fill Missing) --

UPDATE record_sales2
SET unit_price = total_sales / quantity
WHERE (unit_price IS NULL OR unit_price = '')
AND quantity IS NOT NULL;

SELECT *
FROM record_sales2;

-- Convert to numeric --

ALTER TABLE record_sales2
MODIFY unit_price DECIMAL(10,2);

SELECT *
FROM record_sales2;

-- Recalculate Total Sales --

UPDATE record_sales2
SET total_sales = quantity * unit_price;

SELECT *
FROM record_sales2;

-- Region (Uppercase) --

UPDATE record_sales2
SET region = UPPER(TRIM(region));

SELECT *
FROM record_sales2;

-- Handling Missing Product Name --

UPDATE record_sales2
SET Product = 'Unknown'
WHERE Product IS NULL OR Product = '';

SELECT *
FROM record_sales2;

-- Product --

UPDATE record_sales2
SET product = CONCAT(UCASE(LEFT(product,1)), LCASE(SUBSTRING(product,2)));

SELECT *
FROM record_sales2;


-- Handle Payment Method --

UPDATE record_sales2
SET payment_method = 'Not Specified'
WHERE payment_method IS NULL OR payment_method = '';

SELECT *
FROM record_sales2;

-- Remove Duplicates --

DELETE t1 FROM record_sales2 t1
JOIN record_sales2 t2 
ON t1.order_id = t2.order_id
AND t1.order_id > t2.order_id;

SELECT *
FROM record_sales2;

-- Handle Negative Quantity (Returns) --

UPDATE record_sales2
SET status = 'Returned'
WHERE quantity < 0;

SELECT *
FROM record_sales2;

-- Check for nulls --

SELECT * FROM record_sales2
WHERE quantity IS NULL 
   OR unit_price IS NULL;
   
   SELECT *
FROM record_sales2;

-- Check totals --

SELECT order_id, quantity, unit_price, total_sales,
(quantity * unit_price) AS recalculated
FROM record_sales2;

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

SELECT *
FROM record_sales2;

   
   


