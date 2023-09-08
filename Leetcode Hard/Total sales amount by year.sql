-- Question 114
-- Table: Product

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | product_name  | varchar |
-- +---------------+---------+
-- product_id is the primary key for this table.
-- product_name is the name of the product.
 

-- Table: Sales

-- +---------------------+---------+
-- | Column Name         | Type    |
-- +---------------------+---------+
-- | product_id          | int     |
-- | period_start        | varchar |
-- | period_end          | date    |
-- | average_daily_sales | int     |
-- +---------------------+---------+
-- product_id is the primary key for this table. 
-- period_start and period_end indicates the start and end date for sales period, both dates are inclusive.
-- The average_daily_sales column holds the average daily sales amount of the items for the period.

-- Write an SQL query to report the Total sales amount of each item for each year, with corresponding product name, product_id, product_name and report_year.

-- Dates of the sales years are between 2018 to 2020. Return the result table ordered by product_id and report_year.

-- The query result format is in the following example:


-- Product table:
-- +------------+--------------+
-- | product_id | product_name |
-- +------------+--------------+
-- | 1          | LC Phone     |
-- | 2          | LC T-Shirt   |
-- | 3          | LC Keychain  |
-- +------------+--------------+

-- Sales table:
-- +------------+--------------+-------------+---------------------+
-- | product_id | period_start | period_end  | average_daily_sales |
-- +------------+--------------+-------------+---------------------+
-- | 1          | 2019-01-25   | 2019-02-28  | 100                 |
-- | 2          | 2018-12-01   | 2020-01-01  | 10                  |
-- | 3          | 2019-12-01   | 2020-01-31  | 1                   |
-- +------------+--------------+-------------+---------------------+

-- Result table:
-- +------------+--------------+-------------+--------------+
-- | product_id | product_name | report_year | total_amount |
-- +------------+--------------+-------------+--------------+
-- | 1          | LC Phone     |    2019     | 3500         |
-- | 2          | LC T-Shirt   |    2018     | 310          |
-- | 2          | LC T-Shirt   |    2019     | 3650         |
-- | 2          | LC T-Shirt   |    2020     | 10           |
-- | 3          | LC Keychain  |    2019     | 31           |
-- | 3          | LC Keychain  |    2020     | 31           |
-- +------------+--------------+-------------+--------------+
-- LC Phone was sold for the period of 2019-01-25 to 2019-02-28, and there are 35 days for this period. Total amount 35*100 = 3500. 
-- LC T-shirt was sold for the period of 2018-12-01 to 2020-01-01, and there are 31, 365, 1 days for years 2018, 2019 and 2020 respectively.
-- LC Keychain was sold for the period of 2019-12-01 to 2020-01-31, and there are 31, 31 days for years 2019 and 2020 respectively.

-- Explanation: (Tricky Question)
-- Step1 : As you need an extented version of the sales table you need to have a dimension table which have products related wrt all years required
-- Step2 : You need to apply time based conditions to check hwo many days for a particular year from the abovde dimension table is lying in the range of
--		   period start and end date, and calculate the total_amount
-- Step3 : Finally if the total_amount is 0, we have to filter them

WITH dim_product_year AS (SELECT product_id,
								 product_name,
								 report_year
						 FROM Product
						 CROSS JOIN (SELECT '2018' AS report_year
									 UNION ALL
									 SELECT '2019' AS report_year
									 UNION ALL
									 SELECT '2020' AS report_year) a),
									 

SELECT p.product_id,
 	   product_name,
       report_year,
 	   SUM((CASE WHEN YEAR(period_start) = report_year AND YEAR(period_end) = report_year THEN DATEDIFF(period_end, period_start)+1
 				 WHEN YEAR(period_start) = report_year AND YEAR(period_end) != report_year THEN DATEDIFF(CONCAT(report_year, '-12-31'),period_start)+1
 				 WHEN YEAR(period_start) != report_year AND YEAR(period_end) = report_year THEN DATEDIFF(period_end, CONCAT(report_year, '-01-01'))+1
 				 WHEN YEAR(period_start) < report_year AND YEAR(period_end) > report_year THEN DATEDIFF(CONCAT(report_year, '-12-31'), CONCAT(report_year, '-01-01'))+1
 				 ELSE 0
     	    END)*average_daily_sales) AS total_amount
FROM dim_product_year p
LEFT JOIN Sales s
USING(product_id)
GROUP BY p.product_id,
 		 product_name,
 		 report_year
HAVING total_amount > 0
ORDER BY product_id,
         report_year;
