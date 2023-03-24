CREATE DATABASE mavenpizza;
USE mavenpizza;
SELECT * FROM order_details;
SELECT * FROM orders;
SELECT * FROM pizza_types;
SELECT * FROM pizzas;


/* Calculate Total orders and average price by Pizza types  */
SELECT
pizza_type_id,
AVG(price) AS average_price,
COUNT(DISTINCT order_details.order_id) as no_of_orders
FROM 
pizzas
LEFT JOIN order_details
ON 
pizzas.category_id = order_details.category_id
WHERE price >0
AND quantity >0
GROUP BY pizza_type_id
ORDER BY price DESC;


/* Calculate Total revenue and average price by Pizza types  */
SELECT 
pizza_type_id,
MAX(average_price) AS max_avg_price,
MAX(total_revenue) AS max_total_revenue,
MAX(no_of_orders) AS total_pizza_qty_order
FROM (
SELECT
pizza_type_id,
AVG(price) AS average_price,
SUM(price) AS total_revenue,
COUNT(DISTINCT order_details.order_id) as no_of_orders
FROM 
pizzas
LEFT JOIN order_details
ON 
pizzas.category_id = order_details.category_id
WHERE price >0
AND quantity >0
GROUP BY pizza_type_id
)
AS rev_avg_totals
GROUP BY pizza_type_id;

/* Create a Stored procedure as per previous question */
CREATE PROCEDURE sp_AvgpizzaValueOrders()
BEGIN

	SELECT 
	pizza_type_id,
	MAX(average_price) AS max_avg_price,
	MAX(total_revenue) AS max_total_revenue,
	MAX(no_of_orders) AS total_pizza_qty_order
	FROM (
	SELECT
	pizza_type_id,
	AVG(price) AS average_price,
	SUM(price) AS total_revenue,
	COUNT(DISTINCT order_details.order_id) as no_of_orders
	FROM 
	pizzas
	LEFT JOIN order_details
	ON 
	pizzas.category_id = order_details.category_id
	WHERE price >0
	AND quantity >0
	GROUP BY pizza_type_id
	)
	AS rev_avg_totals
	GROUP BY pizza_type_id;

END;
CALL sp_AvgpizzaValueOrders();


/* Calculate total pizza orders by size */
SELECT
pizza_id,
COUNT(*) AS no_of_orders_by_size
FROM order_details
GROUP BY pizza_id;

/* Window Function 1
Calculate total order quantiity by pizza_id, category_id */
SELECT
DISTINCT(pizza_id),
category_id,
SUM(quantity)
OVER (
PARTITION BY category_id
ORDER BY pizza_id
RANGE UNBOUNDED PRECEDING) total
FROM
order_details;

/* Window Function 2
Rank pizzas by order quantity and having orders not more than 3*/
SELECT 
DISTINCT(pizza_id),
category_id,
RANK() OVER pizza_sold_avg
FROM
order_details
WHERE quantity BETWEEN 1 AND 3
GROUP BY pizza_id,
category_id
HAVING SUM(quantity) < 1000
WINDOW pizza_sold_avg AS (
PARTITION BY pizza_id
ORDER BY avg(quantity) DESC)
ORDER BY 
pizza_id,
category_id;
