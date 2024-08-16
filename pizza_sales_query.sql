create database pizzasales;
use pizzasales;

create table orders(
order_id int not null primary key,
order_date date not null,
order_time time not null
);

create table order_details(
order_details_id int not null primary key,
order_id int not null ,
pizza_id text not null,
quantity int  not null
);

select * from pizzas;
select * from pizza_types;
select * from orders;
select * from order_details;

-- 1. Retrieve the total number of orders placed.
select count(order_id) as total_orders from orders;

-- 2. Calculate the total revenue generated from pizza sales.
select  sum(o.quantity * p.price) as total_sales from order_details as o
JOIN pizzas as p ON p.pizza_id = o.pizza_id;

select  round(sum(o.quantity * p.price),2) as total_sales from order_details as o
JOIN pizzas as p ON p.pizza_id = o.pizza_id;

-- 3. Identify the highest-priced pizza.
select pt.name,p.price from pizza_types as pt 
JOIN pizzas as p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC limit 1;

-- 4. Identify the most common pizza size ordered.
SELECT 
    quantity, COUNT(order_details_id)
FROM
    order_details
GROUP BY quantity;

SELECT 
    p.size, COUNT(od.order_details_id) AS order_count
FROM
    order_details AS od
        JOIN
    pizzas AS p ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY order_count DESC;

-- 5. List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pt.name, SUM(od.quantity) AS quantity
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY PT.name
ORDER BY quantity DESC
LIMIT 5;

-- 6. Join the necessary tables to find the total quantity of each pizza category ordered.
select * from pizza_types;
select * from order_details;
SELECT 
    pt.category, SUM(od.quantity) AS quantity
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY quantity DESC;


-- 7. Determine the distribution of orders by hour of the day.
select * from orders;
SELECT 
    HOUR(order_time) AS order_hour,
    COUNT(order_id) AS order_count
FROM
    orders
GROUP BY order_hour;

-- 8. Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category; 

-- 9. Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    AVG(quantity)
FROM
    (SELECT 
        o.order_date, SUM(od.quantity) AS quantity
    FROM
        orders AS o
    JOIN order_details AS od ON o.order_id = od.order_id
    GROUP BY o.order_date) AS order_quantity;
    
-- 10. Determine the top 3 most ordered pizza types based on revenue.
 
 SELECT 
    pt.name, SUM(od.quantity * p.price) AS revenue
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;

-- 11. Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pt.category,
    ROUND(SUM(od.quantity * p.price) / (SELECT 
                    SUM(od.quantity * p.price) AS total_sales
                FROM
                    order_details AS od
                        JOIN
                    pizzas AS p ON p.pizza_id = od.pizza_id) * 100,
            2) AS revenue
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY revenue DESC;

 







