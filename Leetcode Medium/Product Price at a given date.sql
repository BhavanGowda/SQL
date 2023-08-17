-- Question 67
-- Table: Products

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | new_price     | int     |
-- | change_date   | date    |
-- +---------------+---------+
-- (product_id, change_date) is the primary key of this table.
-- Each row of this table indicates that the price of some product was changed to a new price at some date.

-- Write an SQL query to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.

-- The query result format is in the following example:

-- Products table:
-- +------------+-----------+-------------+
-- | product_id | new_price | change_date |
-- +------------+-----------+-------------+
-- | 1          | 20        | 2019-08-14  |
-- | 2          | 50        | 2019-08-14  |
-- | 1          | 30        | 2019-08-15  |
-- | 1          | 35        | 2019-08-16  |
-- | 2          | 65        | 2019-08-17  |
-- | 3          | 20        | 2019-08-18  |
-- +------------+-----------+-------------+

-- Result table:
-- +------------+-------+
-- | product_id | price |
-- +------------+-------+
-- | 2          | 50    |
-- | 1          | 35    |
-- | 3          | 10    |
-- +------------+-------+

-- Explanation:
-- Step1 : We need to find the last updated price less than or equal to 16th Aug 2020 in the Products table
-- Step2 : As a part of first step as few products may be filtered, we need to have a dimention product table
-- Step3 : Finally, we can do left join and add the price for each products and for the products whose data is not available through
--         Step1, they will be given 10 as the price

WITH product_extn AS (SELECT DISTINCT product_id, 
                             FIRST_VALUE(new_price) OVER(PARTITION BY product_id ORDER BY change_date DESC) AS price
		      FROM Products
		      WHERE change_date<= '2019-08-16'),
					  
dim_product AS (SELECT DISTINCT product_id
		FROM Products)

SELECT d.product_id, COALESCE(p.price, 10) AS price
FROM dim_product d
LEFT JOIN product_extn p
USING(product_id);
