select
	first_name,
	last_name,
	address,
	country
from employees;

-- show old price and new price(x1.5) along with the product name
select
	product_name,
	unit_price as old_price,
	unit_price * 1.5 as new_price
from products;

-- in customers table include a new column being first column stating: "Our Customer =>"
select
	'Our Customer =>' as our_customer,
	*
from customers;

-- what are the names of the our customer's countries
select distinct
	country
from customers
order by 1 asc;

-- display the full names of employees along with their titles
select
	concat(title_of_courtesy,' ',first_name,' ',last_name) as full_name,
	title
from employees;

-- display customers locations along with their names
select
	company_name,
	concat('is from ',city,' in ',country) as locations
from customers;

select
	concat(company_name,' is from ',city,' in ',country) as "about customer location"
from customers;

-- what is the total value of each product in stock
select
	product_name,
	concat('$',round(sum(unit_price * units_in_stock))) as total_value
from products
group by product_name
order by 2 desc;

-- show format()-s tricky abilities:
select format('united states of %s', 'America');
select format('%s %s %s', 'They', 'are', 'United');
select format('%3$s %1$s %2$s', 'They', 'are', 'United');
select format('%2$s woman, %1$s man', 'married', 'single');

-- generate without using the space bar the fifteen spaces befor and after sql in the brackets
select format('(%15s)', 'sql');
select format('(%-15s)', 'sql');

-- display first and last names of the employees in the same output column, without concatenation
select
	format('%1$s %2$s', first_name, last_name) as full_name_1,
	format('%s %s', first_name, last_name) as full_name_2,
	format('%2$s %1$s', last_name, first_name) as full_name_3
from employees;

-- display the first and last names of the employees in the same collumn as shown below:
select
	format('FirstName: %-20s LastName: %s', first_name, last_name) as full_name
from employees;

-- using format function, get the following from the employees table
select
	format('%s %s %s', title_of_courtesy, last_name, first_name) as full_name_1,
	format('%1$s %2$s %3$s', title_of_courtesy, last_name, first_name) as full_name_2,
	format('%2$s %3$s %1$s', first_name, title_of_courtesy, last_name) as full_name_3
from employees;

-- forat 1000, 10000, 623514, 60014241, 5124584, 4568 and 0.26854 to two decimal places 
-- and with commas where necessary
select 1000, to_char(1000, 'FM9,999,999,999,999,999,999,999,999,999');
select 10000, to_char(10000, 'FM9,999,999,999,999,999,999,999,999,999');
select 623514, to_char(623514, 'FM9,999,999,999,999,999,999,999,999,999');
select 60014241, to_char(60014241, 'FM9,999,999,999,999,999,999,999,999,999');
select 5124584, to_char(5124584, 'FM9,999,999,999,999,999,999,999,999,999');
select 4568, to_char(4568, 'FM9,999,999,999,999,999,999,999,999,999');
select 0.26854, to_char(0.26854, 'FM9,999,999,999,999,999,999,999,999,999.99');

-- convert the unit price of each product to two decimal places
select
	unit_price,
	round(unit_price::numeric, 2) as rounded_1,
	round(cast(unit_price as numeric), 2) as rounded_2
from products;



