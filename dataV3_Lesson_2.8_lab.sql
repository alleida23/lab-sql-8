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

SELECT * FROM payment limit 2;
SELECT * FROM film_category limit 2;
select * FROM CATEGORY LIMIT 2;

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

SELECT * FROM film LIMIT 2; #film_id / title
SELECT * FROM inventory LIMIT 2; #film_id
SELECT * FROM rental LIMIT 2; #inventory_id
SELECT * FROM store LIMIT 2; #store_id


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
SELECT *
FROM temp_table t1
JOIN temp_table t2
ON (t1.title = t2.title) AND (t1.full_name<>t2.full_name)
ORDER BY full_name;

#self join?

#select *
#from bank.account a1
#join bank.account a2
#on (a1.district_id = a2.district_id) AND (a1.account_id > a2.account_id);

-- 8. Get all pairs of customers that have rented the same film more than 3 times.


-- 9. For each film, list actor that has acted in more films.