-- get the first and last name of employees in the same column
select first_name from employees
union
select last_name from employees;


-- get the first and title of employees in the same column
select first_name from employees
union
select title from employees;


-- get shippers, suppliers and customers in one column with proper titles in second column
select
	company_name,
	'customer name' as description
from customers
union
select
	company_name,
	'shipper name' as description
from shippers
union
select
	company_name,
	'supplier name' as descripton
from suppliers
order by 2 asc;


-- get the names and phone numbers of the external stakeholders
select '--- customer name ---', '--- phone ---'
union all
select
	company_name, phone
from customers
union all
select '--- shipper name ---', '--- phone ---'
union all
select
	company_name, phone
from shippers
union all
select '--- supplier name ---', '--- phone ---'
union all
select
	company_name, phone
from suppliers;
