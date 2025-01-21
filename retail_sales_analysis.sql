create table retail_sales (
	transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
)

select * from retail_sales


copy retail_sales
FROM 'C:/Drive(D)/Retail Sales Analysis/SQL - Retail Sales Analysis_utf .csv'
WITH (FORMAT CSV,	
HEADER TRUE,
	DELIMITER ',')


SELECT COUNT(*) FROM retail_sales

SELECT DISTINCT(customer_id) FROM retail_sales


SELECT DISTINCT(category) FROM retail_sales

SELECT * FROM retail_sales
	WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;



DELETE FROM retail_sales 
WHERE 
	sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
		



-- Data Analysis & Findings

-- The following SQL queries were developed to answer specific business questions:


-- 1 .Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05'



-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT * FROM retail_sales
WHERE category = 'Clothing' AND
quantity >= 4 AND
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' 


-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT category,SUM(total_sale) AS net_sale , COUNT(*) total_orders FROM retail_sales
GROUP BY category

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT ROUND(AVG(age),2) AS avg_age_BEAUTY FROM retail_sales
WHERE category = 'Beauty'

-- 5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:

SELECT * FROM retail_sales
WHERE total_sale > 1000


-- 6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
 
SELECT gender, category, COUNT(transactions_id) AS total_trans FROM retail_sales
GROUP BY gender , category
ORDER BY 1

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT  year,month, ROUND(CAST(avg_total_sale AS NUMERIC), 2) AS avg_total_sale FROM 
(
SELECT AVG(total_sale) AS avg_total_sale, 
		EXTRACT(MONTH FROM sale_date) AS month,
		EXTRACT(YEAR FROM sale_date) AS year,
		ROW_NUMBER() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
		FROM retail_sales
	GROUP BY year,month
	ORDER BY year ASC
) AS tempp
WHERE rank = 1

-- 8 .Write a SQL query to find the top 5 customers based on the highest total sales **:

SELECT * FROM retail_sales

SELECT customer_id, SUM(total_sale) AS total_sale
	FROM retail_sales
	GROUP BY customer_id
	ORDER BY total_sale DESC
	LIMIT 5


-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category,
		COUNT(DISTINCT customer_id) AS unique_cust
	FROM retail_sales
	GROUP BY category


-- 10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sale	
AS
	(
	
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) > 12 AND EXTRACT(HOUR FROM sale_time) < 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as Shift
	FROM
	retail_sales
)
SELECT Shift, COUNT(*)
	FROM hourly_sale
GROUP BY Shift
