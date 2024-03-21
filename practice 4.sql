/*ex1: Write a query that calculates the total viewership for laptops and mobile devices where mobile is defined as the sum of tablet and phone viewership. Output the total viewership for laptops as laptop_reviews and the total viewership for mobile devices as mobile_views.
Effective 15 April 2023, the solution has been updated with a more concise and easy-to-understand approach.*/
SELECT
SUM(CASE
  WHEN device_type ='laptop' THEN 1
  ELSE 0
END) AS laptop_views,
SUM(CASE
  WHEN device_type ='laptop' THEN 0
  ELSE 1
END) AS mobile_views
FROM viewership
/*ex2: Report for every three line segments whether they can form a triangle.
Return the result table in any order.*/
SELECT x,y,z,
CASE 
    WHEN (x+y>z) AND (z+y>x) AND (x+z>y) THEN 'Yes'
    ELSE 'No'
END triangle
FROM Triangle
/*ex3: UnitedHealth Group has a program called Advocate4Me, which allows members to call an advocate and receive support for their health care needs – whether that's behavioural, clinical, well-being, health care financing, benefits, claims or pharmacy help.
Calls to the Advocate4Me call centre are categorised, but sometimes they can't fit neatly into a category. These uncategorised calls are labelled “n/a”, or are just empty (when a support agent enters nothing into the category field).
Write a query to find the percentage of calls that cannot be categorised. Round your answer to 1 decimal place.*/
SELECT 
ROUND(CAST(SUM(CASE WHEN call_category ='n/a' OR call_category ='' THEN 1 ELSE 0 END) AS DECIMAL)/ CAST(COUNT(*) AS DECIMAL) * 100.0,1)
FROM callers
/*Find the names of the customer that are not referred by the customer with id = 2.
Return the result table in any order.*/
SELECT name
FROM Customer
WHERE referee_id IS NULL OR referee_id != 2
/*ex5: Make a report showing the number of survivors and non-survivors by passenger class.
Classes are categorized based on the pclass value as:
pclass = 1: first_class
pclass = 2: second_classs
pclass = 3: third_class
Output the number of survivors and non-survivors by each class.*/
SELECT
CASE
    WHEN survived = 1 THEN 'The number of survivors'
    ELSE 'The number of non-survivors'
END AS survived,
SUM(CASE
    WHEN pclass = 1 AND survived = 1 THEN 1 
    ELSE 0 
    END) AS first_class,
SUM(CASE
    WHEN pclass = 2 AND survived = 1 THEN 1 
    ELSE 0 
    END) AS second_classs,
SUM(CASE
    WHEN pclass = 3 AND survived = 1 THEN 1 
    ELSE 0 
    END) AS third_class
FROM titanic
GROUP BY survived
