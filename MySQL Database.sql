-- 1a. Display the first and last names of all actors from the table actor.
USE sakila;

SELECT a.first_name AS `First Name`,
a.last_name AS `Last Name`
FROM actor a;

-- 1b. Display the first and last name of each actor in a single column in upper case 
-- letters. Name the column Actor Name.
SELECT 
CONCAT(first_name, ", ", last_name) AS `Actor Name`
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you 
-- know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id,
first_name AS `First Name`,
last_name AS `Last Name`
FROM actor 
WHERE first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT last_name AS `Last Name`
FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order:
SELECT last_name AS `Last Name`,
first_name AS `First Name`
FROM actor
WHERE last_name LIKE '%Li%'
ORDER BY last_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: 
-- Afghanistan, Bangladesh, and China:
SELECT country_id,
country FROM country
WHERE country IN
('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries
--  on a description, so create a column in the table actor named description and use the data type BLOB 
-- (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor ADD(
Description BLOB not null);

-- 3b. Very quickly you realize that entering descriptions for each 
-- actor is too much effort. Delete the description column.
ALTER TABLE actor DROP
Description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name AS `Last Names`,
COUNT(*) AS `Counts`
FROM actor
GROUP BY last_name; 

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors
SELECT last_name AS `Last Names`,
COUNT(*) AS `2 or More`
FROM actor
GROUP BY last_name
HAVING count(*) >= 2;

-- 4c The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
-- Write a query to fix the record.
UPDATE actor
SET first_name ='Harpo'
WHERE first_name ='Groucho'
AND Last_name ='Williams';

SELECT * FROM actor
WHERE first_name= 'Harpo'
AND last_name= 'Williams';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor
SET first_name ='Groucho'
WHERE first_name ='Harpo'
AND Last_name ='Williams';

SELECT * FROM actor
WHERE first_name= 'Groucho'
AND last_name= 'Williams';

-- 5a. You cannot locate the schema of the address table.
-- Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a.Use JOIN to display the first and last names, as well as the address, of 
-- each staff member. 
SELECT st.first_name AS `First Name`,
st.last_name AS `Last Name`,
ad.address FROM staff st
INNER JOIN address ad
ON st.address_id = ad.address_id;

-- 6b. Use JOIN to display the total amount rung up by each 
-- staff member in August of 2005. 
SELECT st.first_name AS `First Name`,
st.last_name AS `Last Name`,
sum(p.amount) AS `Total amount`
FROM staff st
INNER JOIN payment p 
ON st.staff_id = p.staff_id 
AND payment_date LIKE '%2005-08%'
GROUP BY last_name;

-- 6c. List each film and the number of actors who are listed for that film.
--  Use inner join.

SELECT fa.film_id AS `Film`,
COUNT(fa.film_id) AS `Number of Actors`,
f.title as `Title`
FROM film_actor fa
INNER JOIN film f
ON f.film_id = fa.film_id
GROUP BY f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory
-- system?
SELECT count(*) AS `Number of Copies` FROM inventory
WHERE film_id=
(SELECT film_id FROM film
WHERE title='Hunchback Impossible');

-- 6e. list the total paid by each customer. 
-- List the customers alphabetically by last name:
SELECT c.last_name AS `Last Name`,
c.first_name AS `First Name`,
sum(amount) AS `Total paid`
FROM customer c
INNER JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY last_name
ORDER BY last_name ASC;

-- 7a.The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence,
-- films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies 
-- starting with the letters K and Q whose language is English.
SELECT title 
FROM film 
WHERE language_id=
(SELECT language_id FROM language l
WHERE name ='English') AND 
(title LIKE 'K%' or title LIKE 'Q%');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT a.first_name AS `First Name`,
a.last_name AS `Last Name`
FROM actor a
WHERE actor_id IN
(SELECT actor_id FROM film_actor 
WHERE film_id IN
(SELECT film_id FROM film
WHERE title ='Alone Trip')
);

-- 7c.You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.
SELECT c.first_name AS `First Name`,
c.last_name AS `Last Name`,
c.email
FROM customer c 
LEFT JOIN address a
ON c.address_id= a.address_id
LEFT JOIN city ci
ON a.city_id= ci.city_id
INNER JOIN country co
ON ci.country_id= co.country_id
WHERE country='Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT f.title AS `Movies`,
ca.Name as `Category`
FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
INNER JOIN category ca
ON fc.category_id = ca.category_id
WHERE ca.Name= 'Family';

-- 7e. Display the most frequently rented movies in descending order.
SELECT f.title AS `Movie`,
Count(*) rental_id
FROM film f
INNER JOIN inventory i
ON f.film_id =i.film_id
INNER JOIN rental r
ON i.inventory_id= r.inventory_id
GROUP BY f.film_id
ORDER BY rental_id DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT staff_id AS `Store`,
sum(amount) AS `Business Brought in`
FROM payment
GROUP BY staff_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id AS `Store`,
ci.city,
co.country
FROM store s
LEFT JOIN address a 
ON s.address_id = a.address_id
LEFT JOIN city ci
ON a.city_id = ci.city_id
INNER JOIN country co
ON ci.country_id =co.country_id;

-- 7h. List the top five genres in gross revenue in descending order. 
SELECT ca.Name AS `Film Category`,
sum(amount) AS `Gross Revenue`
FROM category ca
LEFT JOIN film_category fc
USING(category_id)
LEFT JOIN inventory i 
USING(film_id)
LEFT JOIN rental r 
USING(inventory_id)
INNER JOIN payment p
USING (rental_id)
GROUP BY ca.Name
ORDER BY amount DESC
Limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the 
-- Top five genres by gross revenue.  Use the solution from the problem above to create a view. 
CREATE VIEW `Top Genres` AS
SELECT ca.name as `Top Genres`, SUM(amount) as `Gross Revenue`
FROM category ca
LEFT JOIN film_category fc
USING(category_id)
LEFT JOIN inventory i 
USING(film_id)
LEFT JOIN rental r 
USING(inventory_id)
INNER JOIN payment p
USING (rental_id)
GROUP BY ca.Name
ORDER BY amount DESC
Limit 5;

-- How would you display the view that you created in 8a?
SELECT * FROM sakila.`top genres`;

-- 8c. You find that you no longer need the view top_five_genres. 
-- Write a query to delete it.
DROP VIEW `top genres`;






