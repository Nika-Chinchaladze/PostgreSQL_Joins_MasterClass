-- what are the names of the products whose unit prices are 21.35 and 21 respectively
select
	product_name,
	unit_price
from products
where unit_price in (21.35, 21)
order by unit_price desc;


-- get the unit prices of products less han 10 but greater than or equal to 9.
-- None of the product_ids should be 45
select
	product_id,
	product_name,
	unit_price
from products
where unit_price >= 9 and unit_price < 10 and product_id != 45;


/*
we need the employees that meet the following conditions:
a) must be female
b) must be from USA
c) must be into Sales
d) regions must not be null
e) employee with id number 6 is not inclusive
*/
select 
	employee_id,
	title_of_courtesy,
	country,
	title,
	region
from employees
where title_of_courtesy in ('Ms.', 'Mrs.')
	and country = 'USA'
	and title like '%Sales%'
	and region is not null
	and employee_id <> 6;
	

-- all employees in the UK whose regions read null
select * from employees
where country = 'UK' and region is null;


-- what are the details of employees whose titles contain Sales
select
	*
from employees
where title ilike '%sales%';


-- get the customers' details whose phone number start with (171)
select * from customers
where phone ilike '(171)%'


-- get tha customers whose contact_title end with Representative
select * from customers
where contact_title like '%Representative';


-- the second letter in the names of some of the customers is 'i', who are those customers?
select 
	company_name
from customers
where company_name like '_i%';


-- get company names whose names have letter 'd' as the third letter
select
	company_name
from customers
where company_name like '__d%';


-- get the customers' details whose city names contain four letters only
select * from customers
where length(city) = 4;

select * from customers
where city like '____';


-- get the customers details whose city names start with L and end with n
select
	*
from customers
where city like 'L%n';


-- get the customers' details whose names start with letter other than N
select * from customers
where company_name not like 'N%';


-- what is the minimum and maximum unit prices of the products
select
	product_name,
	unit_price
from products
where unit_price = (
	select 
		min(unit_price)
	from products
) or unit_price = (
	select 
		max(unit_price)
	from products
);


-- what is the date of the first shipment ever made
select
	min(shipped_date) as first_shipment
from orders;


-- what is the number of unique products in products table
select
	count(distinct product_name) as quantity
from products;


-- how many orders the company had in 1997
select
	count(order_id) as order_quantity
from orders
where extract(year from order_date) = 1997;


-- what is the average price of the products
select round(avg(unit_price)) from products;


-- without discount, what is the average purchase
select
	round(avg(unit_price * quantity)) as average
from order_details;


-- what is the total number of products in stock generally
select sum(units_in_stock) from products;


-- what is total of sales
select
	sum(unit_price * quantity - unit_price*quantity*discount) as total_sales_1,
	sum(unit_price * quantity) - sum(unit_price*quantity*discount) as total_sales_2
from order_details;


-- what re the names of the employees? return the names in an array format
select
	array_agg(concat(first_name,' ',last_name)) as full_names
from employees;


-- what are the names of the employees? return the names in a string format
select
	string_agg(first_name || ' ' || last_name,', ') as full_names
from employees;


-- give the list of customers in an array format
select
	array_agg(company_name) as customer_array
from customers;


-- select product name with maximum price
select
	product_name,
	unit_price
from products
order by unit_price desc
limit 2;

select
	product_name,
	unit_price
from products
order by unit_price desc
fetch first 1 rows only;


-- get first three rows from the suppliers table
select * from suppliers
fetch first 3 rows only;


-- get the third, fourth and fifth suppliers details
select * from suppliers
offset 2 fetch first 3 rows only;


-- which supplier supplied the third most expensive product
select 
	supplier_id,
	unit_price
from products
order by unit_price desc
offset 2 rows
fetch first 1 row only;


-- the sixth most productive employee
select
	o.employee_id,
	concat(first_name,' ',last_name) as full_name,
	count(o.order_id) as completed
from orders o
	inner join employees e using (employee_id)
group by o.employee_id, full_name
order by completed desc
offset 5 rows
fetch first 1 row only;



-- the least productive
select
	o.employee_id,
	concat(first_name,' ',last_name) as full_name,
	count(o.order_id) as completed
from orders o
	inner join employees e using (employee_id)
group by o.employee_id, full_name
order by completed asc
fetch first 1 row only;


-- the most productive
select
	o.employee_id,
	concat(first_name,' ',last_name) as full_name,
	count(o.order_id) as completed
from orders o
	inner join employees e using (employee_id)
group by o.employee_id, full_name
order by completed desc
fetch first 1 row only;


-- the second to the least productive employee
select
	o.employee_id,
	concat(first_name,' ',last_name) as full_name,
	count(o.order_id) as completed
from orders o
	inner join employees e using (employee_id)
group by o.employee_id, full_name
order by completed asc
offset 1 row
fetch first 1 row only;