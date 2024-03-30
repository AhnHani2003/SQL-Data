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
/*ex5: Given a table of tweet data over a specified time period, calculate the 3-day rolling average of tweets for each user. Output the user ID, tweet date, and rolling averages rounded to 2 decimal places.
Notes:
A rolling average, also known as a moving average or running mean is a time-series technique that examines trends in data over a specified period of time.
In this case, we want to determine how the tweet count for each user changes over a 3-day period.*/
WITH cte as(
SELECT user_id, tweet_date, tweet_count,
LAG(tweet_count) OVER(PARTITION BY user_id ORDER BY tweet_date) as rl1,
LAG(tweet_count,2) OVER(PARTITION BY user_id ORDER BY tweet_date) as rl2,
LAG(tweet_count,3) OVER(PARTITION BY user_id ORDER BY tweet_date) as rl3
FROM tweets)

SELECT user_id, tweet_date,
CASE 
  WHEN rl1 IS NULL THEN ROUND(tweet_count/1.0,2)
  WHEN rl2 IS NULL THEN ROUND((tweet_count+rl1)/2.0,2)
  ELSE ROUND((tweet_count+rl1+rl2)/3.0,2)
END rolling_avg_3d
FROM cte
/*ex6: Sometimes, payment transactions are repeated by accident; it could be due to user error, API failure or a retry error that causes a credit card to be charged twice.
Using the transactions table, identify any payments made at the same merchant with the same credit card for the same amount within 10 minutes of each other. Count such repeated payments.
Assumptions:
The first transaction of such payments should not be counted as a repeated payment. This means, if there are two transactions performed by a merchant with the same credit card and for the same amount within 10 minutes, there will only be 1 repeated payment.*/\
WITH cte AS(
SELECT merchant_id, EXTRACT(MINUTE FROM transaction_timestamp - LAG(transaction_timestamp) 
OVER(PARTITION BY merchant_id, credit_card_id, amount ORDER BY transaction_timestamp)) AS diff_min 
FROM transactions)

SELECT COUNT(merchant_id) as payment_count
FROM cte
WHERE diff_min < 10
