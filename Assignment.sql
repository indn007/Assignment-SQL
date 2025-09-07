create database AssignmentSql;

Use AssignmentSql;


/* 1. Create a table called employees with constraints */
CREATE TABLE employees (
    emp_id INT NOT NULL PRIMARY KEY,
    emp_name TEXT NOT NULL,
    age INT CHECK (age >= 18),
    email TEXT UNIQUE,
    salary DECIMAL(12,2) DEFAULT 30000.00
);

/* 2. Purpose of constraints and examples:
   Constraints are rules defined on table columns that enforce data integrity and correctness.
   They prevent invalid data, enforce relationships, and help maintain consistency.
   Common constraints:
   - PRIMARY KEY: Uniquely identifies each row and implies NOT NULL and UNIQUE.
   - NOT NULL: Ensures a column cannot be NULL.
   - UNIQUE: Ensures all values in a column are distinct.
   - FOREIGN KEY: Enforces referential integrity between related tables.
   - CHECK: Enforces a condition on column values (e.g., age >= 18).
   - DEFAULT: Provides a default value when none is supplied.
*/

/* 3. Why apply NOT NULL? Can a primary key contain NULL?
   NOT NULL prevents missing values where a value is required (e.g., emp_name).
   A primary key cannot contain NULL values because it must uniquely identify each row.
   NULL represents unknown/absent and cannot serve as a unique identifier.
*/

/* 4. Add or remove constraints on an existing table */
-- Add UNIQUE constraint to email
ALTER TABLE employees ADD CONSTRAINT uq_employees_email UNIQUE (email);

-- Add CHECK constraint to age
ALTER TABLE employees ADD CONSTRAINT chk_age CHECK (age >= 18);

-- Remove UNIQUE constraint in MySQL (created as index)
ALTER TABLE employees DROP INDEX uq_employees_email;

/* 5. Consequences of violating constraints:
   - INSERT duplicate primary key or unique value -> error, no row inserted.
   - INSERT/UPDATE violating CHECK or NOT NULL -> error.
   - DELETE referenced parent row without ON DELETE CASCADE -> foreign key violation.
   Example errors:
   - ERROR 1062 (23000): Duplicate entry '...' for key 'PRIMARY'
   - ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails
   - ERROR 3819 (HY000): Check constraint 'chk_age' is violated
*/

/* 6. Modify products table to add constraints */
-- Option A: Modify existing table
ALTER TABLE products
    ADD CONSTRAINT pk_products PRIMARY KEY (product_id);

-- MySQL syntax to set default
ALTER TABLE products MODIFY price DECIMAL(10,2) DEFAULT 50.00;

-- Option B: Recreate table with constraints
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    price DECIMAL(10,2) DEFAULT 50.00
);

/* 7. Fetch student_name and class_name using INNER JOIN */
SELECT s.student_name, c.class_name
FROM students s
INNER JOIN classes c ON s.class_id = c.class_id;

/* 8. Show all products even if not associated with an order */
SELECT o.order_id, c.customer_name, p.product_name
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
LEFT JOIN customers c ON o.customer_id = c.customer_id
ORDER BY p.product_id;

/* 9. Total sales amount for each product */
SELECT p.product_id, p.product_name, SUM(o.quantity * o.price_each) AS total_sales
FROM products p
INNER JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name;

/* 10. Display order_id, customer_name, and quantity ordered */
SELECT o.order_id, c.customer_name, oi.quantity
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id;

												---- SQL Commands (Maven Movies DB - Sakila-like) -----

/* 1 - Identify the primary keys and foreign keys in Maven Movies DB.
   Primary keys uniquely identify rows.
   Foreign keys reference primary keys in other tables to enforce referential integrity.
   Examples (Sakila-style):
   - film(film_id PK)
   - actor(actor_id PK)
   - film_actor(film_id, actor_id) with:
       FK film_id -> film(film_id)
       FK actor_id -> actor(actor_id)
*/

/* 2 - List all details of actors */
SELECT * FROM actor;

/* 3 - List all customer information from DB */
SELECT * FROM customer;

/* 4 - List different countries */
SELECT DISTINCT country FROM country;

/* 5 - Display all active customers */
SELECT * FROM customer WHERE active = 1;  -- or active = 'true' depending on schema

/* 6 - List of all rental IDs for customer with ID 1 */
SELECT rental_id FROM rental WHERE customer_id = 1;

/* 7 - Display all the films whose rental duration is greater than 5 */
SELECT * FROM film WHERE rental_duration > 5;

/* 8 - List the total number of films whose replacement cost is greater than $15 and less than $20 */
SELECT COUNT(*) FROM film WHERE replacement_cost > 15 AND replacement_cost < 20;

/* 9 - Display the count of unique first names of actors */
SELECT COUNT(DISTINCT first_name) FROM actor;

/* 10 - Display the first 10 records from the customer table */
SELECT * FROM customer LIMIT 10;

/* 11 - Display the first 3 records from the customer table whose first name starts with ‘b’ */
SELECT * FROM customer WHERE first_name LIKE 'b%' LIMIT 3;

/* 12 - Display the names of the first 5 movies which are rated as ‘G’ */
SELECT title FROM film WHERE rating = 'G' LIMIT 5;

/* 13 - Find all customers whose first name starts with "a" */
SELECT * FROM customer WHERE first_name LIKE 'a%';

/* 14 - Find all customers whose first name ends with "a" */
SELECT * FROM customer WHERE first_name LIKE '%a';

/* 15 - Display the list of first 4 cities which start and end with ‘a’ */
SELECT city FROM city WHERE city LIKE 'a%a' LIMIT 4;

/* 16 - Find all customers whose first name have "NI" in any position */
SELECT * FROM customer WHERE first_name LIKE '%NI%';  -- case-sensitive in MySQL unless collation is case-insensitive

/* 17 - Find all customers whose first name have "r" in the second position */
SELECT * FROM customer WHERE first_name LIKE '_r%';

/* 18 - Find all customers whose first name starts with "a" and are at least 5 characters in length */
SELECT * FROM customer WHERE first_name LIKE 'a%' AND CHAR_LENGTH(first_name) >= 5;

/* 19 - Find all customers whose first name starts with "a" and ends with "o" */
SELECT * FROM customer WHERE first_name LIKE 'a%o';

/* 20 - Get the films with PG and PG-13 rating using IN operator */
SELECT * FROM film WHERE rating IN ('PG','PG-13');

/* 21 - Get the films with length between 50 to 100 using BETWEEN operator */
SELECT * FROM film WHERE length BETWEEN 50 AND 100;

/* 22 - Get the top 50 actors using LIMIT operator */
SELECT * FROM actor LIMIT 50;

/* 23 - Get the distinct film ids from inventory table */
SELECT DISTINCT film_id FROM inventory;

															---- Functions ----
                                                    
/* 1 - Retrieve the total number of rentals made in the Sakila database */
SELECT COUNT(*) AS total_rentals FROM rental;

/* 2 - Find the average rental duration (in days) of movies rented */
SELECT AVG(rental_duration) AS avg_rental_duration FROM film;
/* If rental durations are computed from dates:
   SELECT AVG(DATEDIFF(return_date, rental_date)) AS avg_rental_duration FROM rental;
*/

/* 3 - Display the first name and last name of customers in uppercase */
SELECT UPPER(first_name) AS first_name, UPPER(last_name) AS last_name FROM customer;

/* 4 - Extract the month from the rental date and display it alongside the rental ID */
SELECT rental_id, MONTH(rental_date) AS rental_month FROM rental;

/* 5 - Retrieve the count of rentals for each customer */
SELECT customer_id, COUNT(*) AS rentals_count
FROM rental
GROUP BY customer_id;

/* 6 - Find the total revenue generated by each store */
SELECT store_id, SUM(amount) AS total_revenue
FROM payment
GROUP BY store_id;

/* 7 - Determine the total number of rentals for each category of movies */
SELECT fc.category_id, c.name AS category_name, COUNT(r.rental_id) AS rental_count
FROM film_category fc
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY fc.category_id, c.name;

/* 8 - Find the average rental rate of movies in each language */
SELECT l.language_id, l.name AS language_name, AVG(f.rental_rate) AS avg_rental_rate
FROM film f
JOIN language l ON f.language_id = l.language_id
GROUP BY l.language_id, l.name;

																			----- Joins ----
/* 9 - Display the title of the movie, customer's first name, and last name who rented it */
SELECT f.title, c.first_name, c.last_name
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN customer c ON r.customer_id = c.customer_id;

/* 10 - Retrieve the names of all actors who have appeared in the film "Gone with the Wind" */
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Gone with the Wind';

/* 11 - Retrieve the customer names along with the total amount they've spent on rentals */
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

/* 12 - List the titles of movies rented by each customer in a particular city (e.g., 'London') */
SELECT c.customer_id, c.first_name, c.last_name, f.title
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE ci.city = 'London'
GROUP BY c.customer_id, c.first_name, c.last_name, f.title;


														---- Advanced Joins and GROUP BY ----

/* 13 - Display the top 5 rented movies along with the number of times they've been rented */
SELECT f.title, COUNT(r.rental_id) AS times_rented
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY times_rented DESC
LIMIT 5;

/* 14 - Determine the customers who have rented movies from both stores (store ID 1 and store ID 2) */
SELECT c.customer_id, c.first_name, c.last_name
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(CASE WHEN i.store_id = 1 THEN 1 ELSE 0 END) > 0
AND SUM(CASE WHEN i.store_id = 2 THEN 1 ELSE 0 END) > 0;
   
																---- Window Functions ----

/* 1 - Rank the customers based on the total amount they've spent on rentals */
SELECT customer_id, total_spent,
       RANK() OVER (ORDER BY total_spent DESC) AS rank_no
FROM (
  SELECT c.customer_id, SUM(p.amount) AS total_spent
  FROM customer c
  JOIN payment p ON c.customer_id = p.customer_id
  GROUP BY c.customer_id
) t;

/* 2 - Calculate the cumulative revenue generated by each film over time */
/* NOTE: Replace the derived table with actual logic to get film_id, payment_date, revenue */
SELECT film_id, payment_date, revenue,
       SUM(revenue) OVER (PARTITION BY film_id ORDER BY payment_date
                          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue
FROM (
  -- Example: SELECT f.film_id, p.payment_date, SUM(p.amount) AS revenue ...
) s;

/* 3 - Determine the average rental duration for each film, considering films with similar lengths */
SELECT f.film_id, f.title,
       AVG(r.rental_duration) OVER (PARTITION BY f.length) AS avg_rental_duration_for_length
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id;

/* 4 - Identify the top 3 films in each category based on their rental counts */
SELECT category_id, film_id, title, times_rented
FROM (
  SELECT fc.category_id, f.film_id, f.title,
         COUNT(r.rental_id) AS times_rented,
         ROW_NUMBER() OVER (PARTITION BY fc.category_id ORDER BY COUNT(r.rental_id) DESC) AS rn
  FROM film_category fc
  JOIN film f ON fc.film_id = f.film_id
  JOIN inventory i ON f.film_id = i.film_id
  JOIN rental r ON i.inventory_id = r.inventory_id
  GROUP BY fc.category_id, f.film_id, f.title
) t
WHERE rn <= 3;

/* 5 - Difference in rental counts between each customer's total rentals and the average rentals */
WITH cust_counts AS (
  SELECT customer_id, COUNT(*) AS rentals_count
  FROM rental
  GROUP BY customer_id
),
avg_r AS (
  SELECT AVG(rentals_count) AS avg_rentals FROM cust_counts
)
SELECT c.customer_id, c.rentals_count,
       c.rentals_count - a.avg_rentals AS diff_from_avg
FROM cust_counts c
CROSS JOIN avg_r a;

/* 6 - Monthly revenue trend for the entire rental store over time */
SELECT DATE_FORMAT(payment_date, '%Y-%m-01') AS month, SUM(amount) AS revenue
FROM payment
GROUP BY DATE_FORMAT(payment_date, '%Y-%m-01')
ORDER BY month;

/* 7 - Customers whose total spending falls within the top 20% */
WITH totals AS (
  SELECT customer_id, SUM(amount) AS total_spent
  FROM payment
  GROUP BY customer_id
)
SELECT customer_id, total_spent
FROM (
  SELECT customer_id, total_spent,
         CUME_DIST() OVER (ORDER BY total_spent) AS cum_dist
  FROM totals
) t
WHERE cum_dist >= 0.80;

/* 8 - Running total of rentals per category, ordered by rental count */
SELECT category_id, title, times_rented,
       SUM(times_rented) OVER (ORDER BY times_rented DESC
                               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM (
  SELECT fc.category_id, f.title, COUNT(r.rental_id) AS times_rented
  FROM film_category fc
  JOIN film f ON fc.film_id = f.film_id
  JOIN inventory i ON f.film_id = i.film_id
  JOIN rental r ON i.inventory_id = r.inventory_id
  GROUP BY fc.category_id, f.title
) s;

/* 9 - Films rented less than the average rental count for their category */
WITH counts AS (
  SELECT fc.category_id, f.film_id, f.title, COUNT(r.rental_id) AS times_rented
  FROM film_category fc
  JOIN film f ON fc.film_id = f.film_id
  LEFT JOIN inventory i ON f.film_id = i.film_id
  LEFT JOIN rental r ON i.inventory_id = r.inventory_id
  GROUP BY fc.category_id, f.film_id, f.title
),
category_avg AS (
  SELECT category_id, AVG(times_rented) AS avg_rented
  FROM counts
  GROUP BY category_id
)
SELECT c.film_id, c.title, c.times_rented, ca.avg_rented
FROM counts c
JOIN category_avg ca ON c.category_id = ca.category_id
WHERE c.times_rented < ca.avg_rented;

/* 10 - Top 5 months with the highest revenue */
SELECT month, revenue
FROM (
  SELECT DATE_FORMAT(payment_date, '%Y-%m-01') AS month, SUM(amount) AS revenue
  FROM payment
  GROUP BY DATE_FORMAT(payment_date, '%Y-%m-01')
) t
ORDER BY revenue DESC
LIMIT 5;

														--- Normalization & CTE ----
                                                        
/* 1 - First Normal Form (1NF)
   Example violation: customer_with_phones table with columns phone1, phone2, phone3.
   To normalize: create a separate phone table with columns (customer_id, phone_number)
   so each row holds a single phone number.
*/

/* 2 - Second Normal Form (2NF)
   2NF requires 1NF and no partial dependency on a composite PK.
   Example: film_actor(film_id, actor_id) — if non-key attributes depend only on actor_id,
   move them to actor table to remove partial dependency.
*/

/* 3 - Third Normal Form (3NF)
   Example: customer table with address, city, and country columns.
   city -> country is a transitive dependency.
   Normalize: customer -> address -> city -> country.
*/

/* 4 - Normalization Process
   Start with unnormalized customer data with multiple phone numbers in columns.
   1NF: split phone numbers into separate rows in a phones table.
   2NF: ensure composite keys have no partial dependencies.
*/

/* 5 - CTE Basics: distinct list of actor names and number of films */
WITH actor_counts AS (
  SELECT actor_id, COUNT(film_id) AS film_count
  FROM film_actor
  GROUP BY actor_id
)
SELECT a.actor_id, a.first_name, a.last_name, ac.film_count
FROM actor a
LEFT JOIN actor_counts ac ON a.actor_id = ac.actor_id
ORDER BY ac.film_count DESC;

/* 6 - CTE with Joins: film title, language name, rental rate */
WITH film_lang AS (
  SELECT f.film_id, f.title, l.name AS language_name, f.rental_rate
  FROM film f
  JOIN language l ON f.language_id = l.language_id
)
SELECT * FROM film_lang;

/* 7 - CTE for Aggregation: total revenue by customer */
WITH cust_revenue AS (
  SELECT customer_id, SUM(amount) AS total_revenue
  FROM payment
  GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, c.last_name, cr.total_revenue
FROM customer c
LEFT JOIN cust_revenue cr ON c.customer_id = cr.customer_id
ORDER BY cr.total_revenue DESC;

/* 8 - CTE with Window Functions: rank films by rental duration */
WITH film_dur AS (
  SELECT film_id, title, rental_duration
  FROM film
)
SELECT film_id, title, rental_duration,
       RANK() OVER (ORDER BY rental_duration DESC) AS duration_rank
FROM film_dur;

/* 9 - CTE and Filtering: customers with more than two rentals */
WITH frequent_customers AS (
  SELECT customer_id, COUNT(*) AS rentals_count
  FROM rental
  GROUP BY customer_id
  HAVING COUNT(*) > 2
)
SELECT fc.customer_id, fc.rentals_count, c.first_name, c.last_name, c.email
FROM frequent_customers fc
JOIN customer c ON fc.customer_id = c.customer_id;

/* 10 - CTE for Date Calculations: rentals per month */
WITH monthly AS (
  SELECT DATE_FORMAT(rental_date, '%Y-%m-01') AS mon, COUNT(*) AS rentals_count
  FROM rental
  GROUP BY DATE_FORMAT(rental_date, '%Y-%m-01')
)
SELECT mon, rentals_count
FROM monthly
ORDER BY mon;

/* 11 - CTE and Self-Join: pairs of actors in the same film */
WITH fa_pairs AS (
  SELECT fa1.actor_id AS actor1, fa2.actor_id AS actor2, fa1.film_id
  FROM film_actor fa1
  JOIN film_actor fa2
    ON fa1.film_id = fa2.film_id
   AND fa1.actor_id < fa2.actor_id
)
SELECT ap.actor1, CONCAT(a1.first_name, ' ', a1.last_name) AS actor1_name,
       ap.actor2, CONCAT(a2.first_name, ' ', a2.last_name) AS actor2_name,
       ap.film_id
FROM fa_pairs ap
JOIN actor a1 ON ap.actor1 = a1.actor_id
JOIN actor a2 ON ap.actor2 = a2.actor_id
ORDER BY ap.film_id;

/* 12 - CTE for Recursive Search: employees reporting to a specific manager */
WITH RECURSIVE reports AS (
  -- Anchor member: start with the manager
  SELECT staff_id, first_name, last_name, reports_to
  FROM staff
  WHERE staff_id = 1   -- yahan apne manager ka actual ID daalo

  UNION ALL

  -- Recursive member: find employees who report to the previous level
  SELECT s.staff_id, s.first_name, s.last_name, s.reports_to
  FROM staff s
  JOIN reports r ON s.reports_to = r.staff_id
)
SELECT * 
FROM reports;
