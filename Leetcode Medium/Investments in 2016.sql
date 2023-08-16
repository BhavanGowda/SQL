-- Question 96
-- Write a query to print the sum of all total investment values in 2016 (TIV_2016), to a scale of 2 decimal places, for all policy holders who meet the following criteria:

-- Have the same TIV_2015 value as one or more other policyholders.
-- Are not located in the same city as any other policyholder (i.e.: the (latitude, longitude) attribute pairs must be unique).
-- Input Format:
-- The insurance table is described as follows:

-- | Column Name | Type          |
-- |-------------|---------------|
-- | PID         | INTEGER(11)   |
-- | TIV_2015    | NUMERIC(15,2) |
-- | TIV_2016    | NUMERIC(15,2) |
-- | LAT         | NUMERIC(5,2)  |
-- | LON         | NUMERIC(5,2)  |
-- where PID is the policyholder's policy ID, TIV_2015 is the total investment value in 2015, TIV_2016 is the total investment value in 2016, LAT is the latitude of the policy holder's city, and LON is the longitude of the policy holder's city.

-- Sample Input

-- | PID | TIV_2015 | TIV_2016 | LAT | LON |
-- |-----|----------|----------|-----|-----|
-- | 1   | 10       | 5        | 10  | 10  |
-- | 2   | 20       | 20       | 20  | 20  |
-- | 3   | 10       | 30       | 20  | 20  |
-- | 4   | 10       | 40       | 40  | 40  |
-- Sample Output

-- | TIV_2016 |
-- |----------|
-- | 45.00    |
-- Explanation

-- The first record in the table, like the last record, meets both of the two criteria.
-- The TIV_2015 value '10' is as the same as the third and forth record, and its location unique.

-- The second record does not meet any of the two criteria. Its TIV_2015 is not like any other policyholders.

-- And its location is the same with the third record, which makes the third record fail, too.

-- So, the result is the sum of TIV_2016 of the first and last record, which is 45.

-- Explanation:
-- Note : This problem can be solved in two ways first is to calculate separate sub query for LAT/LON and TIV_2015 and second is direct count
-- Step1 : Calculate the count of lat and lon and count of TIV_2015 present in the table
-- Step2 : Remove the LAT, LON counts other than 1 and consider TIV_2015 value which is greater than 1

WITH insurance_extn AS (SELECT TIV_2016,
							   COUNT(TIV_2015) OVER(PARTITION BY TIV_2015) AS cnt_amt,
							   COUNT(CONCAT(LAT, ',', LON)) OVER(PARTITION BY CONCAT(LAT, ',', LON)) AS cnt_geo
					    FROM Insurance)
						
SELECT SUM(TIV_2016)
FROM insurance_extn
WHERE cnt_amt>1 and cnt_geo = 1;

/*ALTERNATIVE 
WITH lat_lon AS (SELECT CONCAT(LAT, ',', LON) AS cnt
					    FROM Insurance
                        GROUP BY CONCAT(LAT, ',', LON)
                        HAVING COUNT(CONCAT(LAT, ',', LON))=1),

tiv_15 AS (SELECT TIV_2015
           FROM Insurance
           GROUP BY TIV_2015
           HAVING COUNT(TIV_2015)>1)
			
SELECT SUM(TIV_2016)
FROM Insurance i
LEFT JOIN lat_lon l
ON CONCAT(i.LAT, ',', i.LON) = l.cnt
LEFT JOIN tiv_15 t
ON i.TIV_2015 = t.TIV_2015
WHERE l.cnt IS NOT NULL AND t.TIV_2015 IS NOT NULL; */
