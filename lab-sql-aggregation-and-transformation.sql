use sakila;
show tables;

-- CHALLENGE 1 --

-- 1.1. Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
select min(length) as min_duration
, max(length) as max_duration
from film;

-- 1.2. Express the average movie duration in hours and minutes. Don't use decimals.
Select
concat (
    floor(avg(length) / 60), "h" ,
    round(avg(length)) % 60, "min"
) as "average_movie_duration"
from film;

-- 2.1 Calculate the number of days that the company has been operating
select min(rental_date),
max(rental_date),
datediff(max(rental_date), min(rental_date)) as operating_days
from rental;

-- 2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.

Select *,
    date_format(rental_date, '%M') as rental_month,
    date_format(rental_date, '%W') as rental_weekday
from rental
limit 20;

-- 2.3 Bonus: Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week.
Select *,
date_format(rental_date, '%W') as rental_weekday,
case when dayofweek(rental_date) in ('Saturday', 'Sunday') then 'weekend'
	 else 'workday'
	 end as day_type
from rental;

-- 3. You need to ensure that customers can easily access information about the movie collection. To achieve this, retrieve the film titles and their rental duration. If any rental duration value is NULL, replace it with the string 'Not Available'. Sort the results of the film title in ascending order.

Select title, rental_duration,
ifnull(rental_duration, 'Not Available') as rental_duration2
from film
order by title asc;

-- 4. Bonus: The marketing team for the movie rental company now needs to create a personalized email campaign for customers. To achieve this, you need to retrieve the concatenated first and last names of customers, along with the first 3 characters of their email address, so that you can address them by their first name and use their email address to send personalized recommendations. The results should be ordered by last name in ascending order to make it easier to use the data.

Select first_name, last_name,
concat(first_name, ' ', last_name) as full_name,
left(email ,3) as email_begins_with
from customer
order by last_name asc;

-- CHALLENGE 2 --

-- 1. Next, you need to analyze the films in the collection to gain some more insights. Using the film table, determine:
-- 1.1 The total number of films that have been released.

Select count(1) as released_films from film;

-- 1.2 The number of films for each rating.
-- 1.3 The number of films for each rating, sorting the results in descending order of the number of films. This will help you to better understand the popularity of different film ratings and adjust purchasing decisions accordingly.

Select rating, count(1) as number_of_films
from film
group by rating
order by count(1) desc;

-- 2.1 The mean film duration for each rating, and sort the results in descending order of the mean duration. Round off the average lengths to two decimal places. This will help identify popular movie lengths for each category.

Select rating, round(avg(length), 2) as avg_film_duration
from film
group by rating
order by round(avg(length), 2) desc;

-- 2.2 Identify which ratings have a mean duration of over two hours in order to help select films for customers who prefer longer movies.

-- 1st attempt 
Select rating,
avg(length) as mean_duration,
case when avg(length) > 120 then 'Long Film' else 'Short Film' end as film_category
from film
group by rating;

-- 2nd attempt with 'having' statement
Select rating,
avg(length) as mean_duration
from film
group by rating
having avg(length) > 120;

-- 3. Bonus: determine which last names are not repeated in the table actor.

-- 1st attempt
Select last_name, count(*),
case when count(*) = 1 then 'Not repeated' else last_name end as not_repeated
from actor
group by last_name;

-- 2nd attempt with 'having' statement
Select last_name
from actor
group by last_name
having count(*) = 1;

