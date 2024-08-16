use joins;
select * from customer;
select * from payment;

# inner join
select * from customer as c INNER JOIN payment as p ON c.customer_id = p.customer_id;
select c.customer_id,c.first_name ,p.amount,p.mode from customer as c INNER JOIN payment as p ON c.customer_id = p.customer_id;

# left join
select * from customer as c LEFT JOIN payment as p on c.customer_id = p.customer_id;

# RIGHT JOIN
select * from customer as c RIGHT JOIN payment as p on c.customer_id = p.customer_id;

# FULL JOIN
SELECT *
FROM customer AS c
LEFT JOIN payment AS p ON c.customer_id = p.customer_id
UNION
SELECT *
FROM customer AS c
RIGHT JOIN payment AS p ON c.customer_id = p.customer_id;

# self join
select * from customer;
select T1.customer_id, T1.first_name, T1.address_id, T2.address_id , T2.first_name as t2name from customer as T1 JOIN customer as T2 ON T2.customer_id = T1.address_id;

# sub query
select * from payment where amount >= (select avg(amount) from payment);
select * from customer where customer_id IN (select customer_id from payment where amount > (select avg(amount) from payment));
select customer_id , amount, mode from payment where customer_id IN (select customer_id from customer);
select c.first_name,c.last_name from customer  c where exists(select c.customer_id, amount from payment p where p.customer_id=c.customer_id AND amount>50);

# WINDOW FUNCTIONS
select * from payment;
# aggregate functions
select customer_id, mode,
sum(amount) OVER (partition by mode order by customer_id) as "Total",
avg(amount) OVER (partition by mode order by customer_id) as "Avarage",
count(amount) OVER (partition by mode order by customer_id) as "Count",
min(amount) OVER (partition by mode order by customer_id) as "MIN",
max(amount) OVER (partition by mode order by customer_id) as "MAX"
from payment;

# aggrregate functions with row
select customer_id, mode, 
sum(amount)  OVER (order by customer_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as "Total",
avg(amount)  OVER (order by customer_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as "Avarage",
count(amount)  OVER (order by customer_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as "Count",
min(amount)  OVER (order by customer_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as "Min",
max(amount)  OVER (order by customer_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as "Max"
from payment;

# ranking function
select amount,
row_number() OVER (order by  amount) as "Row Number",
rank() OVER (order by  amount) as "Rank",
dense_rank() OVER (order by  amount) as "Dense Rank",
percent_rank() OVER (order by  amount) as "Percent Rank"
from payment; 


# analytic functions
select amount,
first_value (amount) over (order by amount) as "first value",
last_value (amount) over (order by amount) as "last value",
lead(amount) over (order by amount) as "lead",
lag(amount) over (order by amount) as "Lag"
from payment;

# CASE statement
select customer_id,mode,amount,
CASE
  WHEN amount <=30  then "cheap product"
  WHEN amount>30 AND amount<=60 then "Moderate product"
  ELSE "Expensive product"
END as ProductStatus
from payment order by amount;

# case expression
select customer_id,amount,
CASE amount
  WHEN  90 then "prime customer"
  WHEN 60 then "plus customer"
  ELSE "regular customer"
END as CustomerStatus
from payment order by amount;

# common table expression
WITH my_cp AS(
select * ,
        avg(amount) OVER (order by p.customer_id) as "Avarage Privce",
		count(address_id) OVER (order by c.customer_id) as "Count"
        from payment as p
        INNER JOIN customer as c ON p.customer_id = c.customer_id
),
my_ca as (
 select * 
 from customer as c
 inner join address as a 
 ON a.address_id = c.address_id
 inner join country as cc
 on cc.city_id = a.city_id
)
select cp.first_name,cp.last_name ,ca.amount 
from my_ca as ca, my_cp as cp;

# recursice cte
with recursive my_cte as (
select 1 as n

UNION ALL 

select n+1 from my_cte where n<3
)
select * from my_cte;

# recurcive cte practical example
CREATE TABLE employees (
emp_id serial PRIMARY KEY,
emp_name VARCHAR(30) NOT NULL,
manager_id INT );

INSERT INTO employees (
emp_id, emp_name, manager_id)
VALUES
(1, 'Madhav', NULL),
(2, 'Sam', 1),
(3, 'Tom', 2),
(4, 'Arjun', 6),
(5, 'Shiva', 4),
(6, 'Keshav', 1),
(7, 'Damodar', 5);

select * from employees;

with recursive empCTE as (
select emp_id,emp_name,	manager_id  from employees where emp_id=7

UNION ALL
 
select e.emp_id, e.emp_name,e.manager_id  from employess as e JOIN empCTE 
ON e.emp_id = empCTE.manager_id
)
select * from empCTE;