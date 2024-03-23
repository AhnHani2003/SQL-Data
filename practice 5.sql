/*ex1: Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY.Continent) and their respective average city populations (CITY.Population) rounded down to the nearest integer.
Note: CITY.CountryCode and COUNTRY.Code are matching key columns.*/
select b.CONTINENT as CONTINENT,
round(avg(a.POPULATION),0) as AVG_CITY_POPULATION
from CITY as a
join COUNTRY as b
on a.COUNTRYCODE = b.CODE
group by b.CONTINENT
order by avg(a.POPULATION)
/*ex2: New TikTok users sign up with their emails. They confirmed their signup by replying to the text confirmation to activate their accounts. Users may receive multiple text messages for account confirmation until they have confirmed their new account.
A senior analyst is interested to know the activation rate of specified users in the emails table. Write a query to find the activation rate. Round the percentage to 2 decimal places.*/
SELECT ROUND(CAST(SUM(CASE
              WHEN b.signup_action = 'Confirmed' THEN 1 ELSE 0 END)AS DECIMAL)/CAST(COUNT(signup_action)AS DECIMAL),2) AS confirm_rate
FROM emails as a
JOIN texts as b 
ON a.email_id = b.email_id
/*ex3: Assume you're given tables with information on Snapchat users, including their ages and time spent sending and opening snaps.
Write a query to obtain a breakdown of the time spent sending vs. opening snaps as a percentage of total time spent on these activities grouped by age group. Round the percentage to 2 decimal places in the output.*/
SELECT b.age_bucket,
ROUND(SUM(CASE WHEN a.activity_type = 'send' THEN time_spent ELSE 0 END)/SUM(CASE WHEN a.activity_type = 'send' OR a.activity_type = 'open' THEN time_spent ELSE 0 END)*100,2) AS send_perc,
ROUND(SUM(CASE WHEN a.activity_type = 'open' THEN time_spent ELSE 0 END)/SUM(CASE WHEN a.activity_type = 'send' OR a.activity_type = 'open' THEN time_spent ELSE 0 END)*100,2) AS open_perc
FROM activities AS a  
JOIN age_breakdown AS b 
ON a.user_id = b.user_id
GROUP BY b.age_bucket
/*ex4: A Microsoft Azure Supercloud customer is defined as a company that purchases at least one product from each product category.
Write a query that effectively identifies the company ID of such Supercloud customers.*/
SELECT customer_id
FROM customer_contracts as a  
JOIN products as b  
ON a.product_id = b.product_id
WHERE b.product_name LIKE 'Azure%'
GROUP BY customer_id
HAVING COUNT(DISTINCT b.product_category) = (SELECT COUNT(DISTINCT product_category) FROM products)
