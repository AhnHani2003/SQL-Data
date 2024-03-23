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
/*ex5: For this problem, we will consider a manager an employee who has at least 1 other employee reporting to them.
Write a solution to report the ids and the names of all managers, the number of employees who report directly to them, and the average age of the reports rounded to the nearest integer.
Return the result table ordered by employee_id.*/
select mng.employee_id, mng.name, 
count(emp.reports_to) as reports_count, 
round(avg(emp.age),0) as average_age 
from Employees mng 
left join Employees emp on mng.employee_id=emp.reports_to 
where emp.reports_to is not null
group by mng.employee_id, mng.name
order by mng.employee_id
/*ex6: Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.
Return the result table in any order.*/
select a.product_name,
sum(b.unit) as unit
from Products a
join Orders b
on a.product_id = b.product_id  
where b.order_date between '2020-02-01' and '2020-02-29'
group by a.product_name
having sum(b.unit) >=100
/*ex7: Assume you're given two tables containing data about Facebook Pages and their respective likes (as in "Like a Facebook Page").
Write a query to return the IDs of the Facebook pages that have zero likes. The output should be sorted in ascending order based on the page IDs.*/
SELECT a.page_id
FROM pages a
LEFT JOIN page_likes b
ON a.page_id = b.page_id
WHERE b.liked_date IS NULL
ORDER BY a.page_id
--Question 1
select 
distinct min(replacement_cost)
from film
--Question 2



