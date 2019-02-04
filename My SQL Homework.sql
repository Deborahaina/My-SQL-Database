
USE sakila;
-- 1a. Display the first and last names of all actors from the table actor.

SELECT first_name, 
last_name
FROM
actor a;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. 
-- Name the column Actor Name.

SELECT first_name,
last_name,
CONCAT(last_name, ", ", first_name) AS `Actor Name`
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?

SELECT first_name,
last_name,
actor_id
FROM 
actor WHERE first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT last_name,
first_name
FROM 
actor
WHERE 
last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order:

SELECT last_name,
first_name FROM 
actor WHERE
last_name LIKE '%LI%' 
ORDER BY last_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: 
-- Afghanistan, Bangladesh, and China:

USE sakila;

SELECT 
country_id,
country FROM country
WHERE 
country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
-- so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB,
-- as the difference between it and VARCHAR are significant).

ALTER TABLE actor ADD (
description BLOB NOT NULL);

-- 3b. Very quickly you realize that entering descriptions for each 
-- actor is too much effort. Delete the description column.

ALTER TABLE actor DROP description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name,
COUNT(*) as 'Counts of Last Names'
FROM actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors

SELECT last_name,
COUNT(*)
FROM actor
GROUP BY last_name
HAVING COUNT(*) >= 2;

-- 4c The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
-- Write a query to fix the record.
UPDATE actor
SET first_name = 'Harpo'
WHERE first_name= 'Groucho'
AND last_name = 'Williams';
-- Check to see if name updated
SELECT * FROM actor where last_name= 'Williams';


UPDATE actor
SET first_name = 'Groucho'
WHERE first_name= 'Harpo'
AND last_name = 'Williams';
-- Check to see if name updated
SELECT * FROM actor where last_name= 'Williams';

-- 5a. You cannot locate the schema of the address table.
-- Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a.Use JOIN to display the first and last names, as well as the address, of 
-- each staff member. Use the tables staff and address:
SELECT st.last_name,
st.first_name,
-- CONCAT(st.last_name,', ', st.first_name) AS `Staff Full Name`,
a.address
FROM staff st
INNER JOIN address a 
ON st.address_id = a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each 
-- staff member in August of 2005. Use tables staff and payment.

SELECT p.staff_id  AS `Staff ID`,
st.last_name AS `Last Name`,
st.first_name AS `First Name`,
SUM(p.amount) AS `Total Amount`,
p.payment_date AS `Payment Date`
FROM staff st
INNER JOIN payment p 
ON st.staff_id = p.staff_id
AND payment_date LIKE '%2005-08%'
GROUP BY st.last_name, st.first_name;

-- 6c. List each film and the number of actors who are listed for that film.
--  Use tables film_actor and film. Use inner join.

SELECT 
fa.film_id AS `Film `,
COUNT(fa.actor_id) as `Number of Actors`,
f.title as `Title`
FROM film_actor as fa
INNER JOIN film f
ON f.film_id= fa.film_ID
GROUP BY f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory
-- system?

SELECT Count(*) FROM inventory
WHERE film_id = 
(SELECT film_id FROM film 
WHERE 
title ='Hunchback Impossible');

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
SELECT 
c.first_name as `First Name`,
c.last_name as `Last Name`,
SUM(p.amount) as `Total Paid`
FROM customer c
INNER JOIN payment p
ON c.customer_id= p.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name, c.first_name ASC;

-- 7a.The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies 
-- starting with the letters K and Q whose language is English.
SELECT title as `Film Title`
FROM film 
WHERE language_id = (
SELECT language_id FROM language 
WHERE name = "English")
AND (title LIKE "K%" OR title LIKE "Q%");

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name AS `First Name`,
last_name AS `Last Name` FROM actor 
WHERE actor_id IN (
SELECT actor_id FROM film_actor
WHERE film_id IN (
SELECT film_id FROM film 
WHERE title = 'Alone Trip')
);

-- 7c.You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.
SELECT c.first_name as `First Name`,
c.last_name as `Last Name`, 
c.email as `Email Address`
FROM customer c
LEFT JOIN address a
ON c.address_id = a.address_id
LEFT JOIN city ci
ON a.city_id= ci.city_id
INNER JOIN country co
ON ci.country_id= co.country_id
WHERE country='Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT title as `Movie Titles` FROM film f
LEFT JOIN film_category fc
ON f.film_id= fc.film_id
INNER JOIN category c
ON fc.category_id= c.category_id 
WHERE name= 'Family';

-- 7e. Display the most frequently rented movies in descending order.
SELECT COUNT(*)rental_id, 
title as `Movie Title` FROM film f
INNER JOIN inventory i
ON f.film_id = i.film_id
INNER JOIN rental r
ON i.inventory_id =r.inventory_id
GROUP BY f.film_id
ORDER BY rental_id DESC;

-- 7f. Write a query to display how much business, 
-- in dollars, each store brought in.
SELECT staff_id as `Store ID`, 
SUM(amount) as `Business Brought In` 
FROM payment p
GROUP BY staff_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id as `Store`, city as `City`, country as `Country`
FROM store s
LEFT JOIN address a
ON s.address_id= a.address_id
LEFT JOIN city ci
ON a.city_id= ci.city_id
INNER JOIN country co
ON ci.country_id= co.country_id
GROUP BY country;

-- 7h. List the top five genres in gross revenue in descending order. 
SELECT c.name as `Top Genres`, SUM(amount) as `Amount`
FROM category c
LEFT JOIN film_category fc
ON c.category_id= fc.category_id
LEFT JOIN inventory i
ON fc.film_id= i.film_id
LEFT JOIN rental r
ON i.inventory_id= r.inventory_id
INNER JOIN payment p
ON r.rental_id= p.rental_id
GROUP BY c.name
ORDER BY amount DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the 
-- Top five genres by gross revenue.  Use the solution from the problem above to create a view. 
CREATE VIEW `Top Genres` as 
SELECT c.name as `Top Genres`, SUM(amount) as `Amount`
FROM category c
LEFT JOIN film_category fc
ON c.category_id= fc.category_id
LEFT JOIN inventory i
ON fc.film_id= i.film_id
LEFT JOIN rental r
ON i.inventory_id= r.inventory_id
INNER JOIN payment p
ON r.rental_id= p.rental_id
GROUP BY c.name
ORDER BY amount DESC
LIMIT 5;

-- How would you display the view that you created in 8a?
SELECT * FROM sakila.`top genres`;

-- 8c. You find that you no longer need the view top_five_genres. 
-- Write a query to delete it.
DROP VIEW `top genres`;





