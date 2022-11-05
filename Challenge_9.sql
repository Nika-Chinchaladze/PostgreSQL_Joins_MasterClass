/*
Get customers who watched at least one film. 
As an additional information, query should return:
a) Country of customers
b) Movie Title
c) Movie Category
d) Actors in this movie
e) Language of movie
f) Staff name who managed customer
g) Paid Amount
*/
select
	c.first_name||' '||c.last_name as customer_name,
	f.title as seen_movies,
	g.name as category_name,
	string_agg(distinct ac.first_name||' '||ac.last_name, ', ') as actor_name,
	l.name as language_name,
	s.first_name||' '||s.last_name as staff_name,
	cast(sum(amount) as varchar) ||' $' as paid_amount
from customer c
	inner join address a using(address_id)
	inner join city t using(city_id)
	inner join country n using(country_id)
	inner join rental r using(customer_id)
	inner join payment p using(rental_id)
	inner join staff s on s.staff_id = r.staff_id
	inner join inventory i using(inventory_id)
	inner join film f using(film_id)
	inner join film_category fc using(film_id)
	inner join category g using(category_id)
	inner join film_actor fa using(film_id)
	inner join actor ac using(actor_id)
	inner join language l using(language_id)
group by customer_name,
	seen_movies,
	category_name,
	language_name,
	staff_name
order by customer_name asc, 
	seen_movies asc;
	
	
