USE testdb;
CREATE TABLE customer (
    ID BIGINT PRIMARY KEY,
    custName VARCHAR(30) NOT NULL,
    Age INT NOT NULL,
    City CHAR(50),
    Salary NUMERIC(10,2)
);

INSERT INTO customer (ID,custName,Age,City,Salary) VALUES 
(1,'Sam',25,'Bengaluru',30000),
(2,'Naveen',22,'Chennai',50000),
(3,'Kiran',27,'Chennai',60000),
(4,'Avi',30,'Bengaluru',45000),
(5,'Kalki',28,'Bengaluru',70000);

select * from customer;

UPDATE customer SET custName="Amar",Age=30,Salary=40000 WHERE ID=1;

select * from customer;

DELETE FROM customer WHERE ID=4;

select * from customer;

INSERT INTO customer VALUES (4,"Avi",30,"Bengaluru",55000);

select * from customer;

ALTER TABLE customer ADD COLUMN gender char(6);

UPDATE customer SET gender="Male" WHERE ID=1; 

ALTER TABLE customer DROP COLUMN gender;

ALTER TABLE customer MODIFY COLUMN salary BIGINT;

ALTER TABLE customer MODIFY COLUMN Salary BIGINT;

ALTER TABLE customer CHANGE Salary  wages BIGINT;

select * from customer;

select ID from customer; 
select custName from customer;
select custName, wages from customer;



select distinct wages,City from customer;

select custName,wages from customer WHERE ID;

select custName from customer WHERE City='Bengaluru' AND wages > 50000;

SELECT wages + 1000 AS increased_salary FROM customer;

select * from customer WHERE NOT City='Bengaluru' ;

select * from customer LIMIT 3;
select custName, Age,wages from customer WHERE wages > 45000 LIMIT 3;

select * from customer ORDER BY custName DESC;

# STRING FUNCTION

select upper(City) from customer;
select lower(custName) from customer;
select concat(custName, City) from customer;
select substring(custName,1,3) from customer;
select trim(custName) from customer;
select replace(custName,"Naveen","Naveen K") from customer;
select now() from customer;
select format() from customer;
select length(City) from customer;

select * from customer;
# AGGREGATE FUNCTION:

select count(City) as cnt from customer;
select count(City) from customer;
select avg(Age) from customer;
select avg(wages) as avarage from customer;
select sum(wages ) from customer;
select max(Age) from customer;
select min(Age) from customer;
select round(avg(Age),2) from customer;

# GROUP BY
select custName,sum(wages) from customer group by  custName order by sum(wages) ASC;
select City,sum(wages) from customer group by  City order by sum(wages) ASC;

#having clause
select City,sum(wages) as total from customer group by City having total >= 110000 AND total <= 200000 ORDER BY total ASC;

# SHOW TIMEZONE
SELECT NOW();
SELECT TIMEOFDAY();
SELECT CURRENT_TIME();
SELECT CURRENT_DATE();
SELECT NOW(6) AS current_time_with_microseconds;
select extract(YEAR from payment_date) AS payment_month , payment_date from payment;


