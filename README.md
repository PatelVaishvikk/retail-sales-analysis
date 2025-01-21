# Retail Sales Analysis

This repository contains SQL queries and insights for analyzing the **Retail Sales** dataset. Below are the steps performed, including data cleaning, analysis, findings, and insights.

---

## 1. Data Description

### Table Structure

**`retail_sales` Table Columns:**

| Column           | Data Type     | Description                               |
|------------------|---------------|-------------------------------------------|
| `transactions_id`| INT           | Unique transaction identifier             |
| `sale_date`      | DATE          | Date of the sale                          |
| `sale_time`      | TIME          | Time of the sale                          |
| `customer_id`    | INT           | Unique identifier for each customer       |
| `gender`         | VARCHAR(10)  | Gender of the customer                    |
| `age`            | INT           | Age of the customer                       |
| `category`       | VARCHAR(35)  | Product category                          |
| `quantity`       | INT           | Quantity of items sold                    |
| `price_per_unit` | FLOAT         | Price per unit of the item                |
| `cogs`           | FLOAT         | Cost of goods sold                        |
| `total_sale`     | FLOAT         | Total sales for the transaction           |

---

## 2. Data Cleaning

The dataset was cleaned to ensure accurate analysis. Steps performed include:

1. **Missing Value Detection and Removal**:
    - Identified rows with `NULL` values in critical columns (e.g., `sale_date`, `customer_id`, `category`, etc.).
    - Deleted rows containing `NULL` values.

    ```sql
    DELETE FROM retail_sales 
    WHERE 
        sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
        gender IS NULL OR age IS NULL OR category IS NULL OR 
        quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    ```

2. **Data Validation**:
    - Checked for valid ranges and data types for `age`, `quantity`, and `price_per_unit`.

3. **Duplicate Handling**:
    - Verified no duplicate `transactions_id` values since it is the primary key.

4. **Date Formatting**:
    - Ensured `sale_date` is properly formatted for analysis.

---

## 3. Data Analysis Queries

### 3.1. Sales on a Specific Date
Retrieve all sales made on **2022-11-05**:

```sql
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';
```

### 3.2. Category-Specific Transactions
Retrieve sales for the **Clothing** category where the quantity is greater than 4 in November 2022:

```sql
SELECT * FROM retail_sales
WHERE category = 'Clothing' AND
      quantity >= 4 AND
      TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';
```

### 3.3. Total Sales by Category
Calculate total sales (`total_sale`) for each product category:

```sql
SELECT category, SUM(total_sale) AS net_sale, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```

### 3.4. Average Customer Age for Beauty Products
Find the average age of customers who purchased items from the **Beauty** category:

```sql
SELECT ROUND(AVG(age), 2) AS avg_age_beauty
FROM retail_sales
WHERE category = 'Beauty';
```

### 3.5. High-Value Transactions
Retrieve all transactions where `total_sale` > 1000:

```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000;
```

### 3.6. Transactions by Gender and Category
Calculate the total number of transactions grouped by gender and category:

```sql
SELECT gender, category, COUNT(transactions_id) AS total_trans
FROM retail_sales
GROUP BY gender, category
ORDER BY gender;
```

### 3.7. Best-Selling Month
Find the best-selling month for each year based on average sales:

```sql
SELECT year, month, ROUND(CAST(avg_total_sale AS NUMERIC), 2) AS avg_total_sale
FROM (
    SELECT AVG(total_sale) AS avg_total_sale, 
           EXTRACT(MONTH FROM sale_date) AS month,
           EXTRACT(YEAR FROM sale_date) AS year,
           ROW_NUMBER() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) 
                              ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY year, month
) AS tempp
WHERE rank = 1;
```

### 3.8. Top 5 Customers
Identify the top 5 customers based on the highest total sales:

```sql
SELECT customer_id, SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;
```

### 3.9. Unique Customers by Category
Find the number of unique customers who purchased items in each category:

```sql
SELECT category, COUNT(DISTINCT customer_id) AS unique_cust
FROM retail_sales
GROUP BY category;
```

### 3.10. Shifts and Order Counts
Create sales shifts (Morning, Afternoon, Evening) and count orders in each shift:

```sql
WITH hourly_sale AS (
    SELECT *,
           CASE
               WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
               WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
               ELSE 'Evening'
           END AS Shift
    FROM retail_sales
)
SELECT Shift, COUNT(*) AS order_count
FROM hourly_sale
GROUP BY Shift;
```

---

## 4. Findings and Insights

### Key Findings:
1. **Customer Demographics**:
   - The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.

2. **High-Value Transactions**:
   - Several transactions had a total sale amount greater than 1000, indicating premium purchases.

3. **Sales Trends**:
   - Monthly analysis shows variations in sales, helping identify peak seasons.

4. **Customer Insights**:
   - The analysis identifies the top-spending customers and the most popular product categories.

### Reports:
1. **Sales Summary**:
   - A detailed report summarizing total sales, customer demographics, and category performance.

2. **Trend Analysis**:
   - Insights into sales trends across different months and shifts.

3. **Customer Insights**:
   - Reports on top customers and unique customer counts per category.

### Conclusion:
This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

---
