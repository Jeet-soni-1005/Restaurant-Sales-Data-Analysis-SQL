-- Creating a database
CREATE DATABASE restaurant_sales_data;

-- Creating tables(we can also use table data import wizard to import table)
CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);

CREATE TABLE order_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
);

CREATE TABLE pizzas (
    pizza_id TEXT NOT NULL,
    pizza_type_id TEXT NOT NULL,
    size TEXT NOT NULL,
    price FLOAT NOT NULL,
    PRIMARY KEY (pizza_id)
);

CREATE TABLE pizza_types (
    pizza_type_id TEXT NOT NULL,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    ingredients TEXT NOT NULL,
    PRIMARY KEY (pizza_type_id)
);
-- Importing the csv data into table using table data import wizard

-- Total no. of orders placed
SELECT 
    COUNT(order_id) AS total_orders
FROM
    orders;

-- Calculate the total revenue generated from pizza sales.
SELECT 
    SUM(order_details.quantity * pizzas.price) AS t_revenue
FROM 
    order_details 
JOIN 
    pizzas ON pizzas.pizza_id = order_details.pizza_id;


-- Identify the highest-priced pizza.
SELECT 
    pizzas.price, pizza_types.name
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
ORDER BY price DESC
LIMIT 1;


-- Identify the most common pizza size ordered.
SELECT 
    pizzas.size,
    sum(order_details.quantity) AS order_count
FROM

    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;

-- List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pizzas.pizza_type_id,
    COUNT(order_details.quantity) AS type_order_count
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.pizza_type_id
ORDER BY type_order_count DESC
LIMIT 5;



-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pizza_types.category, COUNT(order_details.quantity)
FROM
    (order_details
    JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id)
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.category;

-- Determine the distribution of orders by hour of the day.
select 
	hour(order_time) as hour, count(order_id) 
	from orders 
    group by hour;


-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(quantity), 0)
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_quantity;


-- Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pizzas.pizza_type_id,
    sum(order_details.quantity*pizzas.price) AS revenue_by_type
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.pizza_type_id
ORDER BY revenue_by_type DESC
LIMIT 3;



-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pizza_types.category,
    (SUM(order_details.quantity * pizzas.price) / total_revenue) * 100 AS revenue_percentage
FROM
    pizza_types
        JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN order_details ON order_details.pizza_id = pizzas.pizza_id,
    (SELECT 
        SUM(order_details.quantity * pizzas.price) AS total_revenue
     FROM 
        order_details
        JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id
    ) AS total
GROUP BY pizza_types.category
ORDER BY revenue_percentage DESC;


-- Analyze the cumulative revenue generated over time.
select 
order_date, 
sum(revenue) over(order by order_date) as cum_revenue 
from 
	(select orders.order_date, 
    sum(order_details.quantity*pizzas.price) as revenue 
    from orders 
		join 
        order_details on orders.order_id = order_details.order_id 
        join pizzas 
        on pizzas.pizza_id = order_details.pizza_id 
        group by orders.order_date) as sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name, revenue from (select category, name, revenue, rank() over(partition by category order by revenue desc) as rn from
(SELECT 
    pizza_types.category,
    pizza_types.name,
    sum((order_details.quantity) * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category, pizza_types.name) as a) as b
where rn <= 3;