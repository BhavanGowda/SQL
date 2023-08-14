-- Question 91
-- Table: Activity

-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | player_id    | int     |
-- | device_id    | int     |
-- | event_date   | date    |
-- | games_played | int     |
-- +--------------+---------+
-- (player_id, event_date) is the primary key of this table.
-- This table shows the activity of players of some game.
-- Each row is a record of a player who logged in and played a number of games (possibly 0) 
-- before logging out on some day using some device.
 

-- Write an SQL query that reports the fraction of players that logged in again 
-- on the day after the day they first logged in, rounded to 2 decimal places. 
-- In other words, you need to count the number of players that logged in for at least two consecutive 
-- days starting from their first login date, then divide that number by the total number of players.

-- The query result format is in the following example:

-- Activity table:
-- +-----------+-----------+------------+--------------+
-- | player_id | device_id | event_date | games_played |
-- +-----------+-----------+------------+--------------+
-- | 1         | 2         | 2016-03-01 | 5            |
-- | 1         | 2         | 2016-03-02 | 6            |
-- | 2         | 3         | 2017-06-25 | 1            |
-- | 3         | 1         | 2016-03-02 | 0            |
-- | 3         | 4         | 2018-07-03 | 5            |
-- +-----------+-----------+------------+--------------+

-- Result table:
-- +-----------+
-- | fraction  |
-- +-----------+
-- | 0.33      |
-- +-----------+
-- Only the player with id 1 logged back in after the first day he had logged in so the answer is 1/3 = 0.33

-- Explanation:
-- Step1 : We need to find the lead_event_date for each of the player along with min_event_date
-- Step2 : min_event_date is important as it is given to check if the player has logged in just after the first log in date
-- Stpe3 : once we have the lead_event_date and min_event_date we can check the counts of players having the date difference of
--         these dates as 1 and counts of overall customer
-- Step4 : Finnaly we can calculate the fraction

WITH activity_extn AS (SELECT player_id,
                        	  DATEDIFF(LEAD(event_date) OVER(PARTITION BY player_id ORDER BY event_date),
                              MIN(event_date) OVER(PARTITION BY player_id)) AS date_diff 
                       FROM Activity)

SELECT ROUND(COUNT(DISTINCT CASE WHEN date_diff = 1 THEN player_id END)/COUNT(DISTINCT player_id),2) AS fraction
FROM activity_extn;
