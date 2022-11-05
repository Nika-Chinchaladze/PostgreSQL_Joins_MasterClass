-- list of products purchased by White Clover Markets in 1996?
select
	c.company_name,
	string_agg(distinct product_name, ', ') as bought_products
from customers c
	inner join orders o using(customer_id)
	inner join order_details d using(order_id)
	inner join products p using(product_id)
where c.company_name = 'White Clover Markets' and o.order_date::text like '1996%'
group by c.company_name
order by 1 asc;


-- how many products had been purchased by Ernst Handel from the company
select
	c.company_name,
	count(product_name) as bought_products_quantity
from customers c
	inner join orders o using(customer_id)
	inner join order_details d using(order_id)
	inner join products p using(product_id)
where c.company_name = 'Ernst Handel'
group by c.company_name
order by 1 asc;


-- find the order_id, name of the products, total amount and the date of the last order paced by Maison Dewey?
with chincho as
(
select
	c.company_name,
	o.order_id,
	o.order_date,
	product_name,
	round(sum((d.quantity * d.unit_price) - (d.quantity * d.unit_price * discount))) as total_amount
from customers c
	inner join orders o using(customer_id)
	inner join order_details d using(order_id)
	inner join products p using(product_id)
where c.company_name = 'Maison Dewey'
group by c.company_name, o.order_id, o.order_date, product_name
order by 3 desc
limit 2
)
select 
	company_name,
	order_id,
	order_date,
	string_agg(product_name, ', ') as product,
	sum(total_amount)::text ||' $' as amounts
from chincho
group by company_name, order_id, order_date;


-- write a report for each order with the product names, the customer and the employee who managed it
with chincho as
(
select
	o.order_id,
	string_agg(product_name, ', ') as product,
	c.company_name,
	e.first_name ||' '|| e.last_name as employer
from customers c
	inner join orders o using(customer_id)
	inner join order_details d using(order_id)
	inner join products p using(product_id)
	inner join employees e using(employee_id)
group by o.order_id, c.company_name, employer
)
select
	concat('The order with number ',cast(order_id as varchar),' which contains ',product,' was placed by ',company_name,' and managed by ',employer) as "result"
from chincho;


-- return the customer name, list of products per order, the delay suffered and the employees who handled the
-- orders. start from the product that suffered the highest delay to the least delayed
select 
	c.company_name,
	o.order_id,
	string_agg(distinct product_name, ', ') as product,
	e.first_name||' '||e.last_name as employer,
	shipped_date - required_date as delay
from customers c
	inner join orders o using(customer_id)
	inner join order_details d using(order_id)
	inner join products p using(product_id)
	inner join employees e using(employee_id)
where o.required_date - o.shipped_date < 0
group by c.company_name, o.order_id, employer, delay
order by delay desc;
