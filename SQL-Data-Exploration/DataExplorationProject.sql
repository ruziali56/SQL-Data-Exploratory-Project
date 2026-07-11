--Explore All Objects in the Database
SELECT * FROM INFORMATION_SCHEMA.TABLES 



-- Explore All Columns in the Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'

--Explore All Countries our customers come from
SELECT DISTINCT country FROM gold.dim_customers



--Explore All Categories "The major Divisions"
SELECT DISTINCT category,subcategory,product_name FROM gold.dim_products
ORDER BY 1,2,3


--Find the date of the first and last order
SELECT 
	min(order_date) as first_order_date,
	max(order_date) as last_order_date,
	DATEDIFF(year,MIN(order_date),MAX(order_date)) as order_range_years
FROM gold.fact_sales


--Find the youngest and oldest customer
SELECT
	min(birthdate) as oldest_birthdate,
	DATEDIFF(year,min(birthdate),GETDATE()) as oldest_age,
	DATEDIFF(year,max(birthdate),GETDATE()) as youngest_age,
	max(birthdate) as youngest_birthdate
FROM gold.dim_customers


--Find the total sales
SELECT sum(sales_amount) as total_sales FROM gold.fact_sales

--Find how many items are sold
SELECT sum(quantity) as total_items FROM gold.fact_sales

--Find average selling price
SELECT avg(price) AS avg_price FROM gold.fact_sales

--Find total number of orders
SELECT count(order_number) as total_orders FROM gold.fact_sales
SELECT count(distinct order_number) as total_orders FROM gold.fact_sales

--Find the total number of products
SELECT count(DISTINCT product_name) FROM gold.dim_products

--Find total numbers of customers
SELECT count(customer_id)  as total_customers FROM gold.dim_customers

--Find total number of customers that has placed an order
SELECT count(distinct customer_key)  as total_customers FROM gold.fact_sales

--Generate a report that shows all key metrics of the business
SELECT 'Total sales' as measure_name,SUM(sales_amount) as measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity' ,SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price' , avg(price)  FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Orders' , count(distinct order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Products',count(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Nr. Customers',count(customer_key) FROM gold.dim_customers


--Find Total customers by countries
SELECT 
	country,
	count(customer_key) as total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC

--Find Total customers by gender
SELECT 
	gender,
	count(customer_key) as total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC

--Find total products by category
SELECT 
	category,
	count(product_key) as total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC

--Avg costs in each category 
SELECT
	category,
	avg(cost) as avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC

--Total revenue for each category
SELECT
	p.category,
	sum(f.sales_amount) as total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
on f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_revenue DESC

--Total revenue for each customers
SELECT
	c.customer_key,
	c.first_name,
	c.last_name,
	sum(f.sales_amount) as total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
on f.customer_key = c.customer_key
GROUP BY 
	c.customer_key,
	c.first_name,
	c.last_name
ORDER BY total_revenue DESC

--The distribution of items sold across countries

SELECT
	c.country,
	sum(f.quantity) as total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
on f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC

--Top 5 products generate the highest revenue
SELECT TOP 5
	p.product_name,
	sum(f.sales_amount) as total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
on f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC

SELECT * FROM(
	SELECT
		p.product_name,
		sum(f.sales_amount) as total_revenue,
		ROW_NUMBER() OVER(ORDER BY sum(f.sales_amount) DESC) AS rank_products
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	on f.product_key = p.product_key
	GROUP BY p.product_name
)t
WHERE rank_products <= 5



--The 5 worst-performing products in terms of sales
SELECT TOP 5
	p.product_name,
	sum(f.sales_amount) as total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
on f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue




SELECT * FROM(
	SELECT
		p.product_name,
		sum(f.sales_amount) as total_revenue,
		ROW_NUMBER() OVER(ORDER BY sum(f.sales_amount) DESC) AS rank_products
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	on f.product_key = p.product_key
	GROUP BY p.product_name
)t
WHERE rank_products <= 10










