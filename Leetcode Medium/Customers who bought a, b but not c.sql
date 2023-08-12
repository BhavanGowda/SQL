-- Question 72
-- Table: Customers

-- +---------------------+---------+
-- | Column Name         | Type    |
-- +---------------------+---------+
-- | customer_id         | int     |
-- | customer_name       | varchar |
-- +---------------------+---------+
-- customer_id is the primary key for this table.
-- customer_name is the name of the customer.
 

-- Table: Orders

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | order_id      | int     |
-- | customer_id   | int     |
-- | product_name  | varchar |
-- +---------------+---------+
-- order_id is the primary key for this table.
-- customer_id is the id of the customer who bought the product "product_name".
 

-- Write an SQL query to report the customer_id and customer_name of customers who bought products "A", "B" but did not buy the product "C" since we want to recommend them buy this product.

-- Return the result table ordered by customer_id.

-- The query result format is in the following example.

 

-- Customers table:
-- +-------------+---------------+
-- | customer_id | customer_name |
-- +-------------+---------------+
-- | 1           | Daniel        |
-- | 2           | Diana         |
-- | 3           | Elizabeth     |
-- | 4           | Jhon          |
-- +-------------+---------------+

-- Orders table:
-- +------------+--------------+---------------+
-- | order_id   | customer_id  | product_name  |
-- +------------+--------------+---------------+
-- | 10         |     1        |     A         |
-- | 20         |     1        |     B         |
-- | 30         |     1        |     D         |
-- | 40         |     1        |     C         |
-- | 50         |     2        |     A         |
-- | 60         |     3        |     A         |
-- | 70         |     3        |     B         |
-- | 80         |     3        |     D         |
-- | 90         |     4        |     C         |
-- +------------+--------------+---------------+

-- Result table:
-- +-------------+---------------+
-- | customer_id | customer_name |
-- +-------------+---------------+
-- | 3           | Elizabeth     |
-- +-------------+---------------+
-- Only the customer_id with id 3 bought the product A and B but not the product C.

-- Explanation:
-- Step1 : As we have to find if a customer has bought two products, we will have to take running COUNT i.e. case condition while aggrgation
-- Step2 : We will then calculate if customer have bought A and B by taking counts along with that counts for not buying C
-- Step3 : Once we have the above result we can filter the customers

WITH customer_agg AS (SELECT c.customer_id,
	   		     c.customer_name,
       			     COUNT(DISTINCT CASE WHEN o.product_name IN ('A','B') THEN product_name END) AS bought_cnts,
       			     COUNT(DISTINCT CASE WHEN o.product_name = 'C' THEN product_name END) AS not_bough_cnts
		      FROM Orders o
	              INNER JOIN Customers c
		      ON o.customer_id = c.customer_id)

SELECT customer_id,
       customer_name
FROM customer_agg
WHERE bought_cnts = 2 and not_bough_cnts = 0;
