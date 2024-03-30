/*ex1: Assume you're given a table containing information about Wayfair user transactions for different products. Write a query to calculate the year-on-year growth rate for the total spend of each product, grouping the results by product ID.
The output should include the year in ascending order, product ID, current year's spend, previous year's spend and year-on-year growth percentage, rounded to 2 decimal places.*/
SELECT EXTRACT (YEAR FROM transaction_date) as year,
product_id, spend as curr_year_spend,
LAG(spend) OVER (PARTITION BY product_id ORDER BY transaction_date) as prev_year_spend,
ROUND((spend - (LAG(spend) OVER (PARTITION BY product_id ORDER BY transaction_date)))/LAG(spend) OVER (PARTITION BY product_id ORDER BY transaction_date)*100,2) as yoy_rate
FROM user_transactions 
/*ex2: Your team at JPMorgan Chase is soon launching a new credit card. You are asked to estimate how many cards you'll issue in the first month.
Before you can answer this question, you want to first get some perspective on how well new credit card launches typically do in their first month.
Write a query that outputs the name of the credit card, and how many cards were issued in its launch month. The launch month is the earliest record in the monthly_cards_issued table for a given card. Order the results starting from the biggest issued amount.*/
WITH issued_amount AS (SELECT card_name,
FIRST_VALUE (issued_amount) OVER(PARTITION BY card_name ORDER BY issue_year, issue_month) as issued_amount
FROM monthly_cards_issued)

SELECT DISTINCT card_name, issued_amount
FROM issued_amount
ORDER BY issued_amount DESC
/*ex3: Assume you are given the table below on Uber transactions made by users. Write a query to obtain the third transaction of every user. Output the user id, spend and transaction date.*/
SELECT user_id, spend, transaction_date
FROM (SELECT user_id, spend, transaction_date,
RANK() OVER(PARTITION BY user_id ORDER BY transaction_date) as stt
FROM transactions) as a
WHERE a.stt = 3
/*ex4: Assume you're given a table on Walmart user transactions. Based on their most recent transaction date, write a query that retrieve the users along with the number of products they bought.
Output the user's most recent transaction date, user ID, and the number of products, sorted in chronological order by the transaction date.*/
WITH cte AS (SELECT transaction_date, user_id, product_id, 
RANK() OVER (PARTITION BY user_id ORDER BY transaction_date DESC) AS rank 
FROM user_transactions) 
  
SELECT transaction_date, user_id,
  COUNT(product_id) AS purchase_count
FROM cte
WHERE rank = 1 
GROUP BY transaction_date, user_id
ORDER BY transaction_date;
