use sakila;

# 1a. Display the first and last names of all actors from the table `actor`.
select first_name, last_name
  from actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
select upper(concat(first_name," ", last_name)) as 'Full Name'
  from actor;

# 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name
  from actor
 where first_name = 'Joe';
 
# 2b. Find all actors whose last name contain the letters `GEN`
select *
   from actor
  where last_name like '%gen%';

# 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
select *
  from actor
 where last_name like '%li%'
 order by last_name, first_name;

# 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country
  from country
 where country in ('Afghanistan', 'Bangladesh', 'China');

# 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a 
# column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
alter table actor
 add column description blob;
  
select *
  from actor;

# 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(actor_id) 'num_actors'
  from actor
group by last_name;

# 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(actor_id) 'num_actors'
  from actor
 group by last_name
having num_actors >= 2;

# 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
update actor a2
  join actor a1
    on a2.actor_id = a1.actor_id
   set a2.first_name = 'HARPO'
where a1.first_name = 'GROUCHO';
 
select *
from actor
where last_name like 'WILLIAMS'; 

# 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
update actor
   set first_name =
  case 
	when "Harpo" then "Groucho"
    else first_name 
   end;
  
# 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
show create table address;

# 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
select first_name, last_name, address
  from staff s
 inner join address a
    on (s.address_id = a.address_id);


# 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
select first_name, last_name, sum(amount) as "Total_Payments"
  from staff s
  join payment p
    on (s.staff_id = p.staff_id)
 group by s.staff_id;

# 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
select title, count(actor_id) as "Num_Actors"
  from film f
 inner join film_actor fa
    on (f.film_id = fa.film_id)
group by title;

# 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select title, count(title) as "Num_Copies"
  from film
 group by title
having title like "Hunchback Impossible";

# 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name: Join clause using where instead of join/on
select c.customer_id, first_name, last_name, email, sum(amount)
  from customer c, payment p
 where c.customer_id = p.customer_id
 group by c.customer_id
 order by last_name;

# 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and
# `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
select title
  from film f
 where (language_id = 
		(select language_id
          from language
		 where name like "English")
		and
        (title like "K%"
         or
         title like "Q%"));

# 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
select first_name, last_name
  from actor
where actor_id in
	  (select actor_id
        from film_actor
	   where film_id =
			 (select film_id
                from film
			   where title like "Alone Trip"));

# 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select first_name, last_name, address, address2, city, postal_code, country
#select cu.first_name, cu.last_name, a.address, a.address2, ci.city, a.postal_code, co.country - can call fields with aliased table names
  from customer cu
  join address a on cu.address_id = a.address_id
  join city ci on a.city_id = ci.city_id
  join country co on ci.country_id = co.country_id
 where co.country like "Canada";

# 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
select title
  from film f
  join film_category fc
    on f.film_id = fc.film_id
 where category_id =
		(select category_id
           from category
		  where name like "Family");
    

# 7e. Display the most frequently rented movies in descending order.
select title, count(r.inventory_id)
  from film f
  join inventory i on f.film_id = i.film_id
  join rental r on i.inventory_id = r.inventory_id
 group by title
 order by count(r.inventory_id) desc;

# 7f. Write a query to display how much business, in dollars, each store brought in.
select store.store_id, sum(amount)
  from store
  join staff on store.store_id = staff.store_id
  join payment p on staff.staff_id = p.staff_id
 group by store.store_id;

# 7g. Write a query to display for each store its store ID, city, and country.
select s.store_id, ci.city, co.country
  from store s
  join address a on s.address_id = a.address_id
  join city ci on ci.city_id = a.city_id
  join country co on co.country_id = ci.country_id;

# 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select name, sum(amount)
 from category c
 join film_category fc on c.category_id = fc.category_id
 join inventory i on i.film_id = fc.film_id
 join rental r on i.inventory_id = r.inventory_id
 join payment p on p.rental_id = r.rental_id
group by name desc
limit 5;
# 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view top_five_genres as
select name, sum(amount)
 from category c
 join film_category fc on c.category_id = fc.category_id
 join inventory i on i.film_id = fc.film_id
 join rental r on i.inventory_id = r.inventory_id
 join payment p on p.rental_id = r.rental_id
group by name desc
limit 5;

# 8b. How would you display the view that you created in 8a?
select *
  from top_five_genres;

# 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
drop view top_five_genres;