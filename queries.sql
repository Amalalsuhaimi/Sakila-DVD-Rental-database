
/*Answer 1: set 1*/

SELECT DISTINCT(film_title)
,category_name
,COUNT(rental_ID) OVER (PARTITION BY film_title ) AS rental_count

FROM ( SELECT f.title film_title
      , c.name category_name
      ,r.rental_id rental_ID
      FROM category c
      JOIN film_category fc
      ON c.category_id = fc.category_id
      JOIN film f
      ON fc.film_id = f.film_id
      JOIN inventory i
      ON i.film_id = f.film_id
      JOIN rental r
      ON i.inventory_id = r.inventory_id
      WHERE c.name IN ('Animation' , 'Comedy' , 'Classic' , 'Children' ,'Family' , 'Music')
      ) Sub
ORDER BY category_name





/*Answer 2: set 1*/
WITH t1 AS (SELECT f.film_id AS film_id
                  , f.title AS film_title
                  , c.name AS category_name
                  , f.rental_duration AS rental_duration
                  FROM film AS f
                  JOIN film_category AS fc
                  ON f.film_id= fc.film_id
                  JOIN category AS c
                  ON c.category_id = fc.category_id
                 WHERE c.name LIKE 'Animation' OR
                 c.name LIKE 'Children' OR
                 c.name LIKE 'Classics' OR
                 c.name LIKE 'Comedy' OR
                 c.name LIKE 'Family' OR
                 c.name LIKE 'Music') ,
 t2 AS ( SELECT film_title
            , category_name
            , rental_duration,
            NTILE(4) OVER (ORDER BY rental_duration) AS standard_quartile
            FROM t1
            ORDER BY 3)

SELECT * FROM t2





/*Answer 3: set 1*/
WITH t1 AS(SELECT f.title
           , c.name AS name
           , f.rental_duration
           , NTILE(4) OVER(ORDER BY f.rental_duration) AS standard_quartile
           FROM category c
           JOIN film_category fc
           ON c.category_id = fc.category_id
           JOIN film f
           ON f.film_id = fc.film_id
           WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music'))

SELECT name,
        standard_quartile,
        COUNT(*) as count
FROM t1
GROUP BY 1,2
ORDER BY 1,2





/*Answer 1: set 2*/
SELECT
DATE_PART('month', r.rental_date ) as rental_month
,DATE_PART('year', r.rental_date ) as rental_year
,s.store_id
,COUNT(*) as count_rentals
FROM store s
JOIN staff st
ON s.store_id =st.store_id
JOIN rental r
ON st.staff_id =r.staff_id
GROUP BY 1,2,3
ORDER BY 4 DESC
