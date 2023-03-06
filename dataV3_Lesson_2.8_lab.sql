-- Lab | SQL Join (Part II)
-- In this lab, you will be using the Sakila database of movie rentals.

USE sakila;

-- Instructions
-- 1.  Write a query to display for each store its store ID, city, and country.

SELECT  s.store_id, c.city, k.country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
JOIN country k ON c.country_id = k.country_id;


-- 2. Write a query to display how much business, in dollars, each store brought in.

SELECT s.store_id AS store, CONCAT('$', FORMAT(sum(p.amount),2)) AS amount 
FROM store s
JOIN customer c ON s.store_id = c.store_id
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY store;


-- 3. Which film categories are longest?

SELECT c.name AS cat_name, SEC_TO_TIME(avg(f.length*60)) AS avg_time
FROM category c
JOIN film_category m ON c.category_id = m.category_id
JOIN film f ON m.film_id = f.film_id
GROUP BY cat_name
ORDER BY avg_time desc;


-- 4. Display the most frequently rented movies in descending order.

SELECT f.title, COUNT(r.rental_date) AS times_rented
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY times_rented DESC;


-- 5. List the top five genres (category) in gross revenue in descending order.

SELECT c.name AS cat_name, CONCAT('$', FORMAT(sum(p.amount),2)) AS gross_revenue
FROM category c
JOIN film_category f USING (category_id) 
JOIN inventory i USING (film_id)
JOIN rental r USING (inventory_id)
JOIN payment p USING (rental_id)
GROUP BY cat_name
ORDER BY gross_revenue desc
LIMIT 5;



-- 6. Is "Academy Dinosaur" available for rent from Store 1?

SELECT CASE
	WHEN COUNT(*) > 0 THEN 'Available in Store 1' ELSE 'Not available in Store 1' 
    END AS available_for_rent
FROM rental
JOIN inventory USING (inventory_id)
JOIN film USING (film_id) 
JOIN store USING (store_id)
WHERE film.title = 'Academy Dinosaur' AND store.store_id = 1;


-- 7. Get all pairs of actors that worked together.

SELECT * FROM actor LIMIT 5; #actor_id
SELECT * FROM film_actor limit 5; #actor_id / film_id
SELECT * FROM film limit 5; #film id

WITH temp_table as(
	SELECT CONCAT(a.first_name," ",a.last_name) AS full_name, f.title
    FROM actor a
    JOIN film_actor fa USING (actor_id)
    JOIN film f USING (film_id)
	)
SELECT t1.title, t1.full_name, t2.full_name
FROM temp_table t1
JOIN temp_table t2
ON (t1.title = t2.title) AND (t1.full_name<>t2.full_name) #SELF JOIN
ORDER BY full_name;


-- 8. Get all pairs of customers that have rented the same film more than 3 times.

SELECT * FROM customer LIMIT 10; #customer_id, CONCAT(c.first_name," ",c.last_name) AS full_name
SELECT * FROM rental LIMIT 10; #customer_id, rental_id, inventory_id
SELECT * FROM payment LIMIT 10; # rental_id, payment_id
select * from inventory limit 5; # film_id,inventory_id
SELECT * FROM film limit 5; #film_id

#not done
SELECT customer_id
FROM customer
WHERE customer_id IN (
	SELECT rental_id
	FROM rental
	WHERE inventory_id IN (
		SELECT inventory_id
		FROM inventory
		WHERE film_id IN (
			SELECT film_id
			FROM FILM
        )));







SELECT r1.rental_id, r1.customer_id, r2.customer_id
FROM rental r1
JOIN rental r2
ON (r1.rental_id <> r2.rental_id) AND (r1.customer_id<>r2.customer_id) #SELF JOIN
ORDER BY r1.customer_id;









-- 9. For each film, list actor that has acted in more films.
-- PER CADA PEL$LÍCULA, L'ACTOR QUE MÉS N'HA INTERPRETAT
#WITH actor_most as (

SELECT * FROM actor limit 10; #actor_id
SELECT * FROM film_actor LIMIT 10; #actor_id, film_id
SELECT * FROM film LIMIT 10; #film_id

#SELECT f.title, CONCAT(a.first_name," ",a.last_name) AS full_name;

#actors and appearances. --> inner query
SELECT actor_id
FROM film_actor
GROUP BY actor_id
ORDER BY COUNT(film_id) desc; # list ordered of actors appearances
#LIMIT 1;    # actor_id 107 --> most appearances

select first_name, last_name from actor where actor_id = 107; #gina degeneres 1st
select first_name, last_name from actor where actor_id = 102; # walter torn 2nd
select first_name, last_name from actor where actor_id = 198; # mary keitel 3rd


# ATTEMPT 1
SELECT f.title, CONCAT(a.first_name, ' ', a.last_name) AS most_prolific_artist
FROM film f
JOIN film_actor fa USING (film_id)
JOIN actor a USING (actor_id)
WHERE a.actor_id IN (
		SELECT actor_id
		FROM film_actor
		GROUP BY actor_id
		ORDER BY COUNT(*) desc    #NOT WORKING AS EXPECTED
        )
ORDER BY f.title;                 # show ordered LIST of actors according to number of appearances (desc) for each film
                                  # how to reduce to 1?


#ATTEMPT 2
SELECT f.title, CONCAT(a.first_name, ' ', a.last_name) AS most_prolific_artist_in_the_movie
FROM film f
JOIN film_actor fa USING (film_id)
JOIN actor a USING (actor_id)
WHERE a.actor_id = (
		SELECT actor_id
		FROM film_actor
		GROUP BY actor_id
		ORDER BY COUNT(*) desc    #NOT WORKING AS EXPECTED
        LIMIT 1)
ORDER BY f.title;                 # only shows films from GINA DEGENERES








