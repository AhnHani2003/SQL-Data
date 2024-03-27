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
