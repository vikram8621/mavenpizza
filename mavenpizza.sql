CREATE DATABASE mavenpizza;
USE mavenpizza;
SELECT * FROM order_details;
SELECT * FROM orders;
SELECT * FROM pizza_types;
SELECT * FROM pizzas;


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



SELECT
pizza_type_id,
AVG(price) AS average_price,
SUM(price) AS total_revenue,
COUNT(DISTINCT order_details.order_id) AS no_of_orders
FROM 
pizzas
LEFT JOIN order_details
ON 
pizzas.category_id = order_details.category_id
WHERE price >0
AND quantity >0
GROUP BY pizza_type_id
ORDER BY price DESC;
