/*ex1: Assume you're given a table containing job postings from various companies on the LinkedIn platform. Write a query to retrieve the count of companies that have posted duplicate job listings.
Definition:
Duplicate job listings are defined as two job listings within the same company that share identical titles and descriptions.*/
SELECT COUNT(DISTINCT company_id) AS duplicate_companies
FROM job_listings
WHERE (title, description, company_id) IN (
    SELECT title, description, company_id
    FROM job_listings
    GROUP BY title, description, company_id
    HAVING COUNT(*) > 1
);
/*ex2: Assume you're given a table containing data on Amazon customers and their spending on products in different category, write a query to identify the top two highest-grossing products within each category in the year 2022. The output should include the category, product, and total spend.*/
--Tạo bảng sum_spend gồm category, product, total_spend (tổng số tiền của từng sản phẩm theo loại) ORDER BY category, total_spend DESC
WITH sum_spend AS
(SELECT category, product,
SUM(spend) as total_spend
FROM product_spend a
WHERE EXTRACT(YEAR FROM transaction_date) = '2022'
GROUP BY category, product
ORDER BY category, total_spend DESC ),
-- Dựa vào bảng sum_spend để tạo ra bảng Summ để tìm ra 2 sản phẩm có tổng số tiền cao nhất của từng loại
Summ AS
(SELECT category, product, total_spend
FROM sum_spend a
WHERE ( SELECT
        COUNT(DISTINCT product)
        FROM sum_spend AS c
        WHERE c.category = a.category AND c.total_spend >= a.total_spend
    ) <= 2
)
SELECT a.category, a.product, b.total_spend
FROM product_spend a
JOIN Summ b ON (a.category, a.product) = (b.category, b.product)
GROUP BY a.category, a.product, b.total_spend
ORDER BY a.category, b.total_spend DESC
/*ex3: UnitedHealth has a program called Advocate4Me, which allows members to call an advocate and receive support for their health care needs – whether that's behavioural, clinical, well-being, health care financing, benefits, claims or pharmacy help.
Write a query to find how many UHG members made 3 or more calls. case_id column uniquely identifies each call made.*/
SELECT
COUNT(policy_holder_id) AS member_count
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3
/*ex4: Assume you're given two tables containing data about Facebook Pages and their respective likes (as in "Like a Facebook Page").
Write a query to return the IDs of the Facebook pages that have zero likes. The output should be sorted in ascending order based on the page IDs.*/
SELECT a.page_id
FROM pages a
LEFT JOIN page_likes b
ON a.page_id = b.page_id
WHERE b.liked_date IS NULL
ORDER BY a.page_id
/*ex5: Assume you're given a table containing information on Facebook user actions. Write a query to obtain number of monthly active users (MAUs) in July 2022, including the month in numerical format "1, 2, 3".
Hint:
An active user is defined as a user who has performed actions such as 'sign-in', 'like', or 'comment' in both the current month and the previous month.*/
SELECT 
    EXTRACT(MONTH FROM event_date) AS month,
    COUNT(DISTINCT user_id) AS monthly_active_users
FROM user_actions
WHERE EXTRACT(MONTH FROM event_date) = 7 AND user_id IN (
        SELECT user_id
        FROM user_actions
        WHERE EXTRACT(MONTH FROM event_date) = 6
    )
GROUP BY month;
/*ex6: Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.
Return the result table in any order.
The query result format is in the following example.*/
SELECT DATE_FORMAT(trans_date, '%Y-%m') AS month,
    country,
    COUNT(*) AS trans_count,
    SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY month, country
/*ex7: Write a solution to select the product id, year, quantity, and price for the first year of every product sold.
Return the resulting table in any order.*/
SELECT s.product_id,
s.year AS first_year,
s.quantity, s.price
FROM Sales s
JOIN Product p ON s.product_id = p.product_id
WHERE (s.product_id, s.year) IN (
SELECT product_id,
MIN(year)
FROM Sales
GROUP BY product_id)
GROUP BY s.product_id, s.quantity, s.price;
/*ex8: Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.
Return the result table in any order.*/
SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT
COUNT(*) FROM Product)
/*ex9: Find the IDs of the employees whose salary is strictly less than $30000 and whose manager left the company. When a manager leaves the company, their information is deleted from the Employees table, but the reports still have their manager_id set to the manager that left.
Return the result table ordered by employee_id.*/
