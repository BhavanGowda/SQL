-- Question 113
-- Table: Spending

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | user_id     | int     |
-- | spend_date  | date    |
-- | platform    | enum    | 
-- | amount      | int     |
-- +-------------+---------+
-- The table logs the spendings history of users that make purchases from an online shopping website which has a desktop and a mobile application.
-- (user_id, spend_date, platform) is the primary key of this table.
-- The platform column is an ENUM type of ('desktop', 'mobile').
-- Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only and both mobile and desktop together for each date.

-- The query result format is in the following example:

-- Spending table:
-- +---------+------------+----------+--------+
-- | user_id | spend_date | platform | amount |
-- +---------+------------+----------+--------+
-- | 1       | 2019-07-01 | mobile   | 100    |
-- | 1       | 2019-07-01 | desktop  | 100    |
-- | 2       | 2019-07-01 | mobile   | 100    |
-- | 2       | 2019-07-02 | mobile   | 100    |
-- | 3       | 2019-07-01 | desktop  | 100    |
-- | 3       | 2019-07-02 | desktop  | 100    |
-- +---------+------------+----------+--------+

-- Result table:
-- +------------+----------+--------------+-------------+
-- | spend_date | platform | total_amount | total_users |
-- +------------+----------+--------------+-------------+
-- | 2019-07-01 | desktop  | 100          | 1           |
-- | 2019-07-01 | mobile   | 100          | 1           |
-- | 2019-07-01 | both     | 200          | 1           |
-- | 2019-07-02 | desktop  | 100          | 1           |
-- | 2019-07-02 | mobile   | 100          | 1           |
-- | 2019-07-02 | both     | 0            | 0           |
-- +------------+----------+--------------+-------------+ 
-- On 2019-07-01, user 1 purchased using both desktop and mobile, user 2 purchased using mobile only and user 3 purchased using desktop only.
-- On 2019-07-02, user 2 purchased using mobile only, user 3 purchased using desktop only and no one purchased using both platforms.

-- Explanation:
-- Step1 : We need to have a fixed dimension table wrt to all spend_date we need to find the spends on desktop, mobile and both
-- Step2 : We need to map the users wrt to platform i.e. in which category they belong for the spent date
-- Step3 : Finally we need to join the results of step 1 and 2 to get the final result

WITH dim_spends AS (SELECT spend_date,
                           platform
                    FROM (SELECT DISTINCT spend_date AS spend_date FROM Spending) a
                    CROSS JOIN (SELECT 'desktop' AS platform
                                UNION ALL
                                SELECT 'mobile' AS platform
                                UNION ALL
                                SELECT 'both' AS platform) b),

spending_extn AS (SELECT user_id,
                         spend_date,
                         platform,
                         amount,
                         COUNT(user_id) OVER(PARTITION BY user_id, spend_date) AS cnt
                  FROM Spending)


SELECT d.spend_date,
       d.platform,
       SUM(COALESCE(amount, 0)) AS total_amount,
       COUNT(DISTINCT user_id) AS total_users
FROM dim_spends d
LEFT JOIN spending_extn s
ON d.spend_date = s.spend_date
AND d.platform = CASE WHEN cnt = 2 THEN 'both' ELSE s.platform END
GROUP BY d.spend_date,d.platform;
