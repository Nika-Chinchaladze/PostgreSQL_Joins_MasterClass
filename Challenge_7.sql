-- get employees, order_dates, category_names and revenues in 1998
select
	e.first_name||' '||e.last_name as employer,
	o.order_date,
	c.category_name,
	cast(round(sum((d.unit_price*d.quantity) - (d.unit_price*d.quantity*discount))) as varchar)||' $' as revenue
from employees e
	left join orders o using(employee_id)
	left join order_details d using(order_id)
	left join products p using(product_id)
	left join categories c using(category_id)
where o.order_date::text like '1998%'
group by employer, o.order_date, c.category_name
order by revenue desc;


-- get revenue per employee per product category for 1998
select
	e.first_name||' '||e.last_name as employer,
	concat('$ ',to_char(round(sum((d.unit_price*d.quantity) - (d.unit_price*d.quantity*discount))), 'FM9,999,999')) as revenue,
	string_agg(c.category_name, ', ') as category_name
from employees e
	left join orders o using(employee_id)
	left join order_details d using(order_id)
	left join products p using(product_id)
	left join categories c using(category_id)
where o.order_date::text like '1998%'
group by employer;


-- show the list of customers whose orders the employees had managed
select
	e.first_name||' '||e.last_name as employer,
	string_agg(distinct c.company_name, ', ') as customer_names
from employees e
	inner join orders o using(employee_id)
	inner join customers c using(customer_id)
group by employer;


-- get employees, the list of suppliers and the list of shippers in three different columns
select
	e.first_name||' '||e.last_name as employer,
	string_agg(distinct l.company_name, ', ') as supplier_names,
	string_agg(distinct s.company_name, ', ') as shipper_name
from employees e
	inner join orders o using(employee_id)
	inner join shippers s on s.shipper_id = o.ship_via
	inner join order_details d using(order_id)
	inner join products p using(product_id)
	inner join suppliers l using(supplier_id)
group by employer;
	
	
-- each employee is assigned to a region, show this
select
	e.first_name||' '||e.last_name as employer,
	string_agg(distinct r.region_description, ', ') as regions
from employees e
	inner join employee_territories et using(employee_id)
	inner join territories t using(territory_id)
	inner join region r using(region_id)
group by employer;	


-- each employee is assigned to a region, show regions with it's employees
select
	r.region_description as regions,
	string_agg(distinct e.first_name||' '||e.last_name, ', ') as employers
from employees e
	inner join employee_territories et using(employee_id)
	inner join territories t using(territory_id)
	inner join region r using(region_id)
group by regions;


-- show the first name of each employee, the region and the list of customers in three columns
select
	e.first_name||' '||e.last_name as employer,
	string_agg(distinct r.region_description, ', ') as regions,
	string_agg(distinct c.company_name, ', ') as customer_names
from employees e
	inner join employee_territories et using(employee_id)
	inner join territories t using(territory_id)
	inner join region r using(region_id)
	inner join orders o using(employee_id)
	inner join customers c using(customer_id)
group by employer;


-- show order_ids, product names, suppliers, customers and the employees who managed the orders
select
	o.order_id,
	p.product_name,
	s.company_name,
	c.company_name,
	string_agg(distinct e.first_name||' '||e.last_name, ', ') as employers
from employees e
	inner join orders o using(employee_id)
	inner join customers c using(customer_id)
	inner join order_details d using(order_id)
	inner join products p using(product_id)
	inner join suppliers s using(supplier_id)
group by o.order_id,
		 p.product_name,
		 s.company_name,
		 c.company_name
order by o.order_id asc;


-- show order_id, customers, a string showing products-to-supplier-price description and the employee
-- who managed the order
with chincho as
(
select
	o.order_id,
	c.company_name as customer_name,
	p.product_name,
	s.company_name as supplier_name,
	t.category_name,
	e.first_name||' '||e.last_name as employers,
	round(sum((d.unit_price*d.quantity)-(d.unit_price*d.quantity*discount))) as amount
from employees e
	inner join orders o using(employee_id)
	inner join customers c using(customer_id)
	inner join order_details d using(order_id)
	inner join products p using(product_id)
	inner join suppliers s using(supplier_id)
	inner join categories t using(category_id)
group by o.order_id,
		 p.product_name,
		 s.company_name,
		 c.company_name,
		 t.category_name,
		 employers
)
select 
	order_id,
	customer_name,
	concat(product_name,' - ',category_name,' - was supplied by ',supplier_name,' at $',amount),
	employers
from chincho;
