--SQL Retail Sales Analysis - P1
CREATE Database sql_project_p2

--CREATE table
CREATE TABLE retail_sales (
 transactions_id INT PRIMARY KEY,
 sale_date DATE,			
 sale_time TIME,
 customer_id INT,
 gender VARCHAR(20),
 age INT,
 category VARCHAR(20),
 quantity INT,
 price_per_unit FLOAT,
 cogs FLOAT,
 total_sale FLOAT
 );

SELECT * FROM retail_sales

SELECT COUNT(*) FROM retail_sales

--DATA CLEANING
SELECT * FROM retail_sales
WHERE transactions_id IS NULL


SELECT * FROM retail_sales
WHERE transactions_id IS NULL
	OR
	 sale_date is NULL
	OR 
	 sale_time IS NULL
	OR
	 customer_id IS NULL
	OR
	 gender IS NULL
	OR
	 age IS NULL
	OR
	 category IS NULL
	OR
	 quantity IS NULL
	OR
	 price_per_unit IS NULL
	OR
	 cogs IS NULL
	OR
	total_sale IS NULL;

--
DELETE FROM retail_sales
WHERE transactions_id IS NULL
	OR
	 sale_date is NULL
	OR 
	 sale_time IS NULL
	OR
	 customer_id IS NULL
	OR
	 gender IS NULL
	OR
	 age IS NULL
	OR
	 category IS NULL
	OR
	 quantity IS NULL
	OR
	 price_per_unit IS NULL
	OR
	 cogs IS NULL
	OR
	total_sale IS NULL;

--DATA EXPLORATION

--how many sales we have
SELECT COUNT(*) FROM retail_sales

--how many unique customer we have
SELECT COUNT(DISTINCT customer_id) AS total_sale FROM retail_sales

--how many unique category we have
SELECT  DISTINCT category AS total_sale FROM retail_sales

-- DATA Analysis & Business Problems & Answers
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
-- Q.11. Average Quantity and Revenue Per Category
-- Q.12. Find repeat customers (customers with more than 1 order on the same day)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

--Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing' 
	 AND quantity > 3
	 AND  sale_date >= '2022-11-01'
     AND sale_date <= '2022-11-30';

--Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.(additional also count total orders of each category)
SELECT 
	category, 
	SUM(total_sale) AS cat_total_sales,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

--Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT  ROUND(AVG(age), 0) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

--Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, gender, COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY category

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT year, month, avg_sale
FROM (
SELECT 
	EXTRACT(YEAR FROM sale_date) AS year,
	EXTRACT(month FROM sale_date) AS month, 
	AVG(total_sale) AS avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
FROM retail_sales
GROUP BY 1, 2
) AS T1
WHERE RANK = 1
--ORDER BY 1, 3 DESC

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

--Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) AS count_of_unique_cust
FROM retail_sales
GROUP BY category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
--1.o/p
SELECT
  CASE
    WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
     WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
  END AS shift,
  COUNT(*) AS number_of_orders
FROM retail_sales
GROUP BY shift;

--2.0/p
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

--11. Average Quantity and Revenue Per Category
SELECT 
    category,
    AVG(quantity) AS avg_quantity,
    AVG(total_sale) AS avg_revenue
FROM retail_sales
GROUP BY category;

-- 12. Find repeat customers (customers with more than 1 order on the same day)
SELECT 
    customer_id, 
    sale_date,
    COUNT(*) AS orders_on_same_day
FROM retail_sales
GROUP BY customer_id, sale_date
HAVING COUNT(*) > 1;

--END OF PROJECT






