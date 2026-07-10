SELECT * FROM customer LIMIT 20;

-- Q.1 What is revenue genterated by male vs. female customers?
SELECT gender, SUM(purchase_amount) AS revenue
FROM customer
GROUP BY gender;

-- Q.2 Which customers used a discount but still spent more than the average purchase amount?
SELECT customer_id, purchase_amount 
FROM customer
WHERE discount_applied ='Yes' and purchase_amount>= (SELECT AVG(purchase_amount) FROM customer);

-- Q.3 Which are the top 5 products with the highest average review rating?
SELECT item_purchased, ROUND(AVG(review_rating)::numeric,2) AS "average_product_rating"
FROM customer
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;

--Q.4 Compare the average purchase amounts between standard aand express shipping.
SELECT shipping_type,
	ROUND(AVG(purchase_amount),2)
FROM customer
WHERE shipping_type IN ('Standard','Express')
GROUP BY shipping_type;	

-- Q.5 Do subscribed customers spend more? Compare average spend and total revenue between subscribers and non-subscribers.
SELECT subscription_status,
	COUNT(customer_id) AS total_customers,
	ROUND(AVG(purchase_amount),2) AS avg_spend,
	ROUND(SUM(purchase_amount),2) AS total_revenue
FROM customer
GROUP BY subscription_status
ORDER BY total_revenue, avg_spend DESC;

-- Q.6 Which 5 products have the highest percentage of purchases with discounts applied?
SELECT item_purchased,
	ROUND(100*SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS discount_rate
FROM customer 
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;

-- Q.7 Segment customers into New, Returning, and 
--Loyal based on their total number of previous purchases, and show the count of each segment.
WITH customer_type AS(
SELECT customer_id, previous_purchases,
CASE 
	WHEN previous_purchases=1 THEN 'New'
	WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
	ELSE 'Loyal'
	END AS customer_segment
FROM customer
)

SELECT customer_segment, COUNT(*) AS "number_of_customers"
FROM customer_type
GROUP BY customer_segment;

-- Q.8 What are the top 3 most purchased products within each category.
WITH item_counts AS(
SELECT category,
	item_purchased,
	COUNT(customer_id) AS total_orders,
ROW_NUMBER() OVER(PARTITION BY category ORDER BY COUNT (customer_id) DESC ) AS item_rank
FROM customer 
GROUP BY category, item_purchased
)

SELECT item_rank, category ,item_purchased,total_orders
FROM item_counts
WHERE item_rank<=3;

-- Q.9 Are customers who are repeat buyers(more than 5 previous purchases ) also likely to subscribe?
SELECT subscription_status,
	COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases >5
GROUP BY subscription_status;

-- Q.10 What is the revenue contribution of each age group?
SELECT age_group,
	SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC;

-- Q.11 Who are the top 10 customers based on total purchase amount?
SELECT customer_id,
       SUM(purchase_amount) AS total_spent
FROM customer
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- Q.12 Which product categories generate the highest total revenue?
SELECT category,
       SUM(purchase_amount) AS revenue
FROM customer
GROUP BY category
ORDER BY revenue DESC;

-- Q.13 How does the average purchase amount vary across different age groups and genders?
SELECT age_group,
       gender,
       ROUND(AVG(purchase_amount),2) AS avg_purchase
FROM customer
GROUP BY age_group, gender
ORDER BY age_group;

-- Q.14 Which payment method contributes the highest revenue?
SELECT payment_method,
       SUM(purchase_amount) AS revenue
FROM customer
GROUP BY payment_method
ORDER BY revenue DESC;

-- Q.15 Which location has generated the highest total sales?
SELECT location,
       SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY location
ORDER BY total_revenue DESC;

-- Q.16 Which season records the highest customer spending?
SELECT season,
       SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY season
ORDER BY total_revenue DESC;

-- Q.17 Which payment method is most preferred by customers?
SELECT payment_method,
       COUNT(*) AS total_transactions
FROM customer
GROUP BY payment_method
ORDER BY total_transactions DESC;

-- Q.18 Which size of products is purchased most frequently?
SELECT size,
       COUNT(*) AS total_orders
FROM customer
GROUP BY size
ORDER BY total_orders DESC;

-- Q.19 Which color of products is purchased most frequently?
SELECT color,
       COUNT(*) AS total_orders
FROM customer
GROUP BY color
ORDER BY total_orders DESC;

-- Q.20 Which shipping type generates the highest total revenue?
SELECT shipping_type,
       SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY shipping_type
ORDER BY total_revenue DESC;