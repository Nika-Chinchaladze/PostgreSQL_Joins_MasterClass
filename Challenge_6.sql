-- answer from company to customers, whose orders have been delayed
with chincho as
(
select
	c.company_name,
	o.order_id,
	string_agg(product_name, ', ') as product,
	e.first_name||' '||e.last_name as employer,
	o.shipped_date - o.required_date as delay
from customers c
	inner join orders o using(customer_id)
	inner join order_details d using(order_id)
	inner join products p using(product_id)
	inner join employees e using(employee_id)
where o.required_date - o.shipped_date < 0
group by c.company_name, o.order_id, employer, delay
order by delay desc
)
select
	*,
	case
		when delay > 14 then 'coordinator apologise customer'
		when delay between 10 and 14 then 'CEO call customer'
		when delay between 1 and 9 then 'Sales President call customer'
		else 'nothing'
	end as "action"
from chincho;


-- generate a report showing rental date, film title, film category, customer, actors in the movie,
-- language used in the movie and the country
select
	r.rental_date,
	f.title,
	c.name as category_name,
	t.first_name ||' '|| t.last_name as customer_name,
	string_agg(a.first_name ||' '|| a.last_name, ', ') as actor_name,
	l.name as language_name,
	u.country
from rental r
	inner join inventory i using(inventory_id)
	inner join customer t using(customer_id)
	inner join film f using(film_id)
	inner join film_category fc using(film_id)
	inner join category c using(category_id)
	inner join film_actor fa using(film_id)
	inner join actor a using(actor_id)
	inner join language l using(language_id)
	inner join address d using(address_id)
	inner join city y using(city_id)
	inner join country u using(country_id)
group by r.rental_date, f.title, category_name, customer_name, language_name, u.country;	
	

-- generate a report showing actor's names and the titles of the movies they acted
select
	a.first_name||' '||a.last_name as actor_name,
	f.title
from actor a
	inner join film_actor fa using(actor_id)
	inner join film f using(film_id)
order by actor_name asc, title asc;

select
	a.first_name||' '||a.last_name as actor_name,
	string_agg(f.title, ', ') as movie_name
from actor a
	inner join film_actor fa using(actor_id)
	inner join film f using(film_id)
group by actor_name
order by actor_name asc;


-- show list of actors who acted in each movie
select
	f.title,
	string_agg(a.first_name||' '||a.last_name, ', ') as actor_name
from actor a
	inner join film_actor fa using(actor_id)
	inner join film f using(film_id)
group by f.title
order by f.title asc;


-- how many actors acted in each movie. also show the category of each movie
select
	f.title,
	c.name,
	count(fa.actor_id) as actor_quantity
from film f
	left join film_actor fa using(film_id)
	left join film_category fc using(film_id)
	left join category c using(category_id)
group by f.title, c.name
order by actor_quantity asc;


-- how many movies in the database has each of the actors acted in?
with chincho as
(
select
	a.first_name||' '||a.last_name as actor_name,
	count(distinct f.title) as number_of_movie
from film f
	inner join film_actor fa using(film_id)
	inner join actor a using(actor_id)
group by actor_name
)
select * from chincho
order by actor_name asc;


-- among the actors who acted in the highest number of movies?
with chincho as
(
select
	a.first_name||' '||a.last_name as actor_name,
	count(f.title) as number_of_movie
from film f
	inner join film_actor fa using(film_id)
	inner join actor a using(actor_id)
group by actor_name
)
select * from chincho
order by number_of_movie desc
limit 1;


-- get actor who acted in the least number of movies, second to the least and third to the least 
-- to the 10-th position: a) in ascending and in descending order
select
	a.first_name||' '||a.last_name as actor_name,
	count(f.title) as number_of_movie
from film f
	inner join film_actor fa using(film_id)
	inner join actor a using(actor_id)
group by actor_name
order by number_of_movie asc
limit 10;


with chincho as
(
select
	a.first_name||' '||a.last_name as actor_name,
	count(f.title) as number_of_movie
from film f
	inner join film_actor fa using(film_id)
	inner join actor a using(actor_id)
group by actor_name
order by number_of_movie asc
limit 10
)
select * from chincho
order by number_of_movie desc;


-- report the following: movie titles, paid amounts, customer names, rental_date
select
	f.title,
	sum(p.amount) as paid_amount,
	c.first_name||' '||c.last_name as customer_name,
	r.rental_date
from customer c
	left join rental r using(customer_id)
	left join payment p using(rental_id)
	left join inventory i using(inventory_id)
	left join film f using(film_id)
group by f.title, customer_name, r.rental_date;


-- get total revenue from each customer and the corresponding list of movies
select
	c.first_name||' '||c.last_name as customer_name,
	string_agg(f.title, ', ') as movies,
	sum(p.amount) as paid_amount
from customer c
	left join rental r using(customer_id)
	left join payment p using(rental_id)
	left join inventory i using(inventory_id)
	left join film f using(film_id)
group by customer_name;
