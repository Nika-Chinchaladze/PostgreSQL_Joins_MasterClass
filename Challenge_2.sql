-- convert the unit price of each product to two decimal places with and without using double colons
select
	product_name,
	round(unit_price::numeric, 2) as "unit price",
	round(cast(unit_price as numeric), 2) as "price"
from products;


-- convert 20124.85574 to one decimal place
select round(20124.85574, 1) as rounded;
select round(cast(20124.85574 as numeric), 1) as rounded;
select round(20124.85574::numeric, 1) as rounded;


-- return the current values of products in stock. Amounts must be in two decimal places
select
	product_name,
	'$' || round(sum(units_in_stock * unit_price::numeric), 2) as stock_unit
from products
group by product_name
order by stock_unit desc;


-- get all customers details in ascending order by the customers name
select
	*
from customers
order by company_name asc;


-- return all the columns in the orders table, sort ascending by the customer id and descending by the order id
select * from orders
order by customer_id asc, order_id desc;


-- what are the details of the sales managers?
select
	*
from employees
where title ilike '%Sales Manager%';


-- return the following companies with contact_title Owner: company_name, address, city, country, phone
select
	company_name,
	address,
	city,
	country,
	phone
from customers
where contact_title = 'Owner';


-- get the details of the order with order_id number: 10249
select
	*
from orders
where order_id = 10249;


-- what is the name of the product whose unit price is 30?
select
	product_name,
	unit_price
from products
where unit_price = 30;


-- what is the name of the product whose unit price is 25.89?
select
	product_name,
	unit_price
from products
where unit_price = '25.89';


-- which customer's id is LETSS
select
	company_name,
	customer_id
from customers
where customer_id = 'LETSS';


-- what are the names of the products whose unit prices are above 32.8?
select
	product_name,
	unit_price
from products
where unit_price > 32.8
order by unit_price asc;


-- what are the names of the products whose unit prices are less than 10?
select
	product_name,
	unit_price
from products
where unit_price < 10
order by unit_price desc;


-- what are the names of the products whose unit prices are 40 and above?
select
	product_name,
	unit_price
from products
where unit_price >= 40
order by unit_price asc;


-- get the details of the orders whose order ids are below 10252 and above 11075
select
	*
from orders
where order_id < 10252 or order_id > 10175
order by order_id asc;


-- get the names of the products that are due for restocking
select
	product_name,
	reorder_level,
	units_in_stock
from products
where reorder_level > units_in_stock
order by reorder_level desc;


-- which orders have their total amounts of 10540.00 or more?
select
	order_id,
	round(sum(cast(unit_price * quantity as numeric)), 2) as amounts
from order_details
group by order_id
having sum(unit_price * quantity) >= 10540
order by amounts asc;


-- get the details of all employes who are not Mr.
select
	*
from employees
where title_of_courtesy != 'Mr.';


-- what are the details of those who are not sales representatives?
select
	*
from employees
where not title = 'Sales Representative';


-- what are the names of the products whose prices are between 18 and 19
select
	product_name,
	unit_price
from products
where unit_price between 18 and 19
order by unit_price desc;


-- return the details of the products whose prices are not between 6 and 100
select
	product_name,
	unit_price
from products
where not unit_price between 6 and 100
order by unit_price asc;


-- get the details of the products whose prices are between 2 and 3 or between 50 and 53
select
	product_name,
	unit_price
from products
where (unit_price between 2 and 3) or (unit_price between 50 and 53)
order by unit_price desc;


-- get the details of the customers whose city is Berlin or Sao Paulo or Graz
select
	company_name,
	city
from customers
where city in ('Berlin', 'Sao Paulo', 'Graz');


-- select all customers except those from the UK, Brazil and Spain
select
	company_name,
	country
from customers
where not country in ('UK', 'Brazil', 'Spain');


-- get customers from Lyon, France
select
	company_name,
	city,
	country
from customers
where city = 'Lyon' and country = 'France';


-- what are the details of the sales manager and vice president, sales
select
	*
from employees
where title in ('Vice President, Sales', 'Sales Manager');