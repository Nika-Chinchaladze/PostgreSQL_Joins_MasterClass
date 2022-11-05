-- help get the names of shippers and the corresponding customers they shipped to
select
 	s.company_name as shipper_name,
	c.company_name as customer_name
from customers c
	inner join orders o using (customer_id)
	inner join shippers s on o.ship_via = s.shipper_id
order by s.company_name asc, c.company_name asc;


-- who supplied the most expensive product?
select
	company_name,
	product_name as most_expensive_product,
	unit_price
from products p
	inner join suppliers s using (supplier_id)
where unit_price = (
	select max(unit_price) from products
);


-- count the number of orders per customer
select 
	c.company_name,
	count(o.order_id) as order_quantity
from customers c
	left join orders o using (customer_id)
group by c.company_name
order by 2 desc;


-- what category is the second to the cheapest product?
select 
	category_name,
	product_name,
	unit_price
from products p
	inner join categories c using (category_id)
order by unit_price asc
offset 1
fetch first 1 row only;

select 
	'The category of second to the cheapest product is ' || category_name as "category name"
from products p
	inner join categories c using (category_id)
order by unit_price asc
offset 1
fetch first 1 row only;


-- how many orders were managed by each employees?
select
	concat(first_name,' ',last_name) as full_name,
	count(order_id) as completed_orders
from orders o
	right join employees e using(employee_id)
group by full_name
order by 2 desc;


-- what is the number of shipments carried out by each shipping company?
select
	s.shipper_id,
	s.company_name,
	count(o.order_id) as completed_shipments
from orders o
	right join shippers s on s.shipper_id = o.ship_via
group by s.shipper_id, s.company_name
order by 3 desc;


-- what is the number of shipments carried out by each shipping company in 1998?
select
	s.shipper_id,
	s.company_name,
	count(o.order_id) as completed_shipments
from orders o
	right join shippers s on s.shipper_id = o.ship_via
where extract(year from shipped_date) = 1998
group by s.shipper_id, s.company_name
order by 3 desc;


-- how many times were shipments done to each country for each customer. Arrange the countries
-- in ascending order and the number of shipments in descending order
select
	o.ship_country,
	c.company_name,
	count(o.ship_country) as completed_shipment
from customers c
	left join orders o using(customer_id)
group by o.ship_country, c.company_name
order by o.ship_country asc, completed_shipment desc;


-- get the list of territory per region
select
	r.region_id,
	region_description,
	string_agg(cast(territory_description as varchar), ', ') as territory
from territories t
	inner join region r using(region_id)
group by r.region_id, region_description
order by region_id asc;


-- each employee is assigned to at least a territory. what are the territories for each employee?
select 
	e.employee_id,
	first_name||' '||last_name as full_name,
	array_agg(distinct cast(territory_description as varchar)) as territory
from employee_territories e
	inner join territories t using (territory_id)
	inner join employees m using (employee_id)
group by e.employee_id, full_name
order by e.employee_id asc;


-- what are the categories of products supplied by each supplier?
select
	s.company_name,
	string_agg(distinct cast(c.category_name as varchar), ', ') as category_name
from suppliers s
	left join products p using(supplier_id)
	left join categories c using(category_id)
group by s.company_name
order by s.company_name asc;


-- show the most purhased product to the least purchased product
-- a) arrange by product_id, product_name
-- b) arrange by category name
with chincho as
(
select 
	p.product_id,
	product_name,
	count(order_id) as sold_quantity
from products p
	left join order_details d using (product_id)
group by p.product_id, product_name
)
select * from chincho
where sold_quantity = (
	select 
		max(sold_quantity) 
	from chincho
) or sold_quantity = (
	select 
		min(sold_quantity) 
	from chincho
);


with chincho as
(
select 
	category_name,
	count(order_id) as sold_quantity
from categories c
	left join products p using(category_id)
	left join order_details d using (product_id)
group by category_name
)
select * from chincho
where sold_quantity = (
	select 
		max(sold_quantity) 
	from chincho
) or sold_quantity = (
	select 
		min(sold_quantity) 
	from chincho
);


-- what are the revenues in dollars from each customer?
select
	c.company_name,
	cast(round(sum((unit_price*quantity) - (unit_price*quantity*discount))) as varchar) ||' $' as revenue
from customers c
	left join orders o using(customer_id)
	left join order_details d using(order_id)
group by c.company_name
order by 1 asc
nulls last;


-- what were revenues in dollars from each customer in the month june 1997?
select
	c.company_name,
	cast(round(sum((unit_price*quantity) - (unit_price*quantity*discount))) as varchar) ||' $' as revenue
from customers c
	left join orders o using(customer_id)
	left join order_details d using(order_id)
where o.order_date between '1997-06-01' and '1997-06-30'
group by c.company_name
order by 1 asc
nulls last;


-- what were revenues in dollars from each customer in 1996?
select
	c.company_name,
	cast(round(sum((unit_price*quantity) - (unit_price*quantity*discount))) as varchar) ||' $' as revenue
from customers c
	left join orders o using(customer_id)
	left join order_details d using(order_id)
where o.order_date::text like '1996%'
group by c.company_name
order by 1 asc
nulls last;


-- list of products purchased by each customer
select
	c.company_name,
	string_agg(distinct cast(product_name as varchar), ', ') as bought_products
from customers c
	inner join orders o using(customer_id)
	inner join order_details d using(order_id)
	inner join products p using(product_id)
group by c.company_name
order by 1 asc;
