-- # SQL INTRODUCCIÓN

---------------------- PARTE 1 ---------------------

-- Mostrar los nombres y apellidos de todos los actores de la tabla actor.
SELECT first_name, last_name 
FROM actor;

-- Mostrar el nombre y el apellido de cada actor en una sola columna en mayúsculas. Nombre la columna Actor Name.
SELECT UPPER(first_name)||' '||UPPER(last_name) AS 'Actor Name'
FROM actor;

-- Encontrar el número de identificación, el nombre y el apellido de un actor, del que sólo se conoce el nombre, "Joe". ¿Qué consulta utilizarías para obtener esta información?
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name LIKE 'JOE';

-- Encontrar todos los actores cuyo apellido contenga las letras GEN
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';

-- Encontrar todos los actores cuyos apellidos contengan las letras LI. Esta vez, ordena las filas por apellido y nombre, en ese orden:
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name ASC, first_name ASC;

-- Utilizar IN, para mostrar las columnas country_id y country de los siguientes países: Afganistán, Bangladesh y China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

---------------------- PARTE 2 ---------------------

-- Enumera los apellidos de los actores, así como cuántos actores tienen ese apellido.
SELECT last_name, count(last_name)
FROM actor
GROUP BY last_name;

-- Enumere los apellidos de los actores y el número de actores que tienen ese apellido, pero sólo para los nombres que comparten al menos dos actores.
SELECT last_name, count(last_name)
FROM actor
GROUP BY last_name
HAVING count(last_name)>1;

-- Utilice JOIN para mostrar los nombres y apellidos, así como la dirección, de cada miembro del personal. Utilice las tablas staff y address:
SELECT st.first_name, st.last_name, st.address_id
FROM staff st  -- PARA DIFERENCIAR LAS COLUMNAS PROVENIENTES DE LOS DIFERENTES DF QUE INVOCAS EN EL QUERY
INNER JOIN address ad 
ON st.address_id = ad.address_id; -- PRIMERO VA LA VARIABLE DEL PRIMER DF Y LUEGO LA DEL SEGUNDO

-- Utilice JOIN para mostrar el importe total recaudado por cada miembro del personal en agosto de 2005. Utilice las tablas personal y pago.
SELECT st.first_name, st.last_name, st.staff_id, sum(pay.amount) AS total_payment
FROM staff st
INNER JOIN payment pay
ON st.staff_id = pay.staff_id
GROUP BY st.staff_id;

-- Enumere cada película y el número de actores que figuran en ella. Utilice las tablas actor_película y película. Utilice la unión interna.
SELECT movie.film_id, movie.title, count(actor.actor_id) AS number_actors
FROM film movie
LEFT JOIN film_actor actor
ON movie.film_id = actor.film_id
GROUP BY movie.film_id;

-- ¿Cuántas copias de la película Jorobado Imposible existen en el sistema de inventario?
SELECT movie.film_id, movie.title, count(inv.inventory_id) AS copies_inventory
FROM film movie
LEFT JOIN inventory inv
ON movie.film_id = inv.film_id
WHERE movie.title = 'HUNCHBACK IMPOSSIBLE'
GROUP BY movie.title;

-- Utilizando las tablas payment y customer y el comando JOIN, enumera el total pagado por cada cliente. Enumera los clientes alfabéticamente por su apellido.
SELECT client.customer_id, client.first_name, client.last_name, round(sum(pay.amount),2) as total_payment
FROM customer client
INNER JOIN payment pay
ON client.customer_id = pay.customer_id
GROUP BY client.customer_id
ORDER BY client.last_name ASC;

---------------------- PARTE 3 ---------------------

-- La música de Queen ha experimentado un improbable resurgimiento. Como consecuencia involuntaria, las películas que empiezan por la letra Q también han aumentado su popularidad. Utilice subconsultas para mostrar los títulos de las películas que empiezan por la letra Q y cuyo idioma es el inglés.
SELECT movie.title, movie.language_id, lan.name
FROM film movie
INNER JOIN language lan
ON movie.language_id = lan.language_id
WHERE movie.title LIKE "Q%"
AND lan.name = 'English' -- USAS AND CUANDO TIENES DOS CONDICIONES QUE DEBEN SATISFACERSE SIMULTÁNEAMENTE
GROUP BY movie.title;

-- Utiliza las subconsultas para mostrar todos los actores que aparecen en la película Alone Trip.
SELECT movie.title, names.first_name, names.last_name
FROM film movie
INNER JOIN film_actor actor
ON movie.film_id = actor.film_id -- DE FILM_ACTOR LO JUNTO CON FILM ID PARA OBTENER LOS IDS DE LOS ACTORES
INNER JOIN actor names
ON actor.actor_id = names.actor_id -- DE ACTOR OBTENGO LOS NOMBRES DE LOS ACTORES SEGÚN EL ID ANTERIOR
WHERE movie.title = 'ALONE TRIP';

-- Desea realizar una campaña de marketing por correo electrónico en Canadá, para lo cual necesitará los nombres y las direcciones de correo electrónico de todos los clientes canadienses. Utilice uniones para recuperar esta información.
SELECT country.country, client.first_name, client.last_name, client.email
FROM customer client
INNER JOIN address ad ON ad.address_id = client.address_id -- VINCULAS CON ADDRESS ID
INNER JOIN city city ON city.city_id = ad.city_id -- VINCULAS CON CITY ID
INNER JOIN country country ON country.country_id = city.country_id -- VINCULAS CON COUNTRY ID
WHERE country.country = 'Canada'; -- FILTRAS SOLO EL PAÍS

-- Las ventas han disminuido entre las familias jóvenes, y usted desea dirigirse a todas las películas familiares para una promoción. Identifique todas las películas categorizadas como familiares.
SELECT fam.name AS category, movie.title 
FROM film movie
INNER JOIN film_category cat ON cat.film_id = movie.film_id
INNER JOIN category fam ON fam.category_id = cat.category_id
WHERE fam.name = 'Family';

-- Muestre las películas más alquiladas en orden descendente.
SELECT movie.title, movie.rental_rate
FROM film movie
ORDER BY movie.rental_rate DESC;

-- Escriba una consulta para mostrar el volumen de negocio, en dólares, de cada tienda.
SELECT st.store_id, round(sum(pay.amount),2) AS total_volume
FROM store st
INNER JOIN customer client ON client.store_id = st.store_id
INNER JOIN payment pay ON pay.customer_id = client.customer_id
GROUP BY st.store_id;

-- Escribir una consulta para mostrar para cada tienda su ID de tienda, ciudad y país.
SELECT st.store_id, city.city, country.country
FROM store st
INNER JOIN address ad ON ad.address_id = st.address_id
INNER JOIN city city ON city.city_id = ad.address_id
INNER JOIN country country ON country.country_id = city.country_id
GROUP BY st.store_id;

-- Enumere los cinco géneros más importantes en ingresos brutos en orden descendente. 
-- (Sugerencia: es posible que tenga que utilizar las siguientes tablas: categoría, film_category, inventario, pago y alquiler).
SELECT cat.name AS category, round(sum(pay.amount),2) AS gross_income
FROM payment pay
INNER JOIN rental r ON r.rental_id = pay.rental_id
INNER JOIN inventory inv ON inv.inventory_id = r.inventory_id
INNER JOIN film_category fc ON fc.film_id = inv.film_id
INNER JOIN category cat ON cat.category_id = fc.category_id
GROUP BY cat.name
ORDER BY gross_income DESC
LIMIT 5;
