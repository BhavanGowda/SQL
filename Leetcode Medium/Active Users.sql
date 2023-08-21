--Question 94
-- Table Accounts:

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | name          | varchar |
-- +---------------+---------+
-- the id is the primary key for this table.
-- This table contains the account id and the user name of each account.
 

-- Table Logins:

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | login_date    | date    |
-- +---------------+---------+
-- There is no primary key for this table, it may contain duplicates.
-- This table contains the account id of the user who logged in and the login date. A user may log in multiple times in the day.
 

-- Write an SQL query to find the id and the name of active users.

-- Active users are those who logged in to their accounts for 5 or more consecutive days.

-- Return the result table ordered by the id.

-- The query result format is in the following example:

-- Accounts table:
-- +----+----------+
-- | id | name     |
-- +----+----------+
-- | 1  | Winston  |
-- | 7  | Jonathan |
-- +----+----------+

-- Logins table:
-- +----+------------+
-- | id | login_date |
-- +----+------------+
-- | 7  | 2020-05-30 |
-- | 1  | 2020-05-30 |
-- | 7  | 2020-05-31 |
-- | 7  | 2020-06-01 |
-- | 7  | 2020-06-02 |
-- | 7  | 2020-06-02 |
-- | 7  | 2020-06-03 |
-- | 1  | 2020-06-07 |
-- | 7  | 2020-06-10 |
-- +----+------------+

-- Result table:
-- +----+----------+
-- | id | name     |
-- +----+----------+
-- | 7  | Jonathan |
-- +----+----------+
-- User Winston with id = 1 logged in 2 times only in 2 different days, so, Winston is not an active user.
-- User Jonathan with id = 7 logged in 7 times in 6 different days, five of them were consecutive days, so, Jonathan is an active user.

-- Explaination
-- Step 1: As Logins table may contain duplicates, we should use distinct to have deduplicated data
-- Step 2: Once we have proper data, we can check by taking the 5th leading login_date for records in Logins table
-- Step 3: Check if the difference between the dates between login_date and leaded date is 5 or not and filter it
-- Step 4: Finally join the table with Accounts tabel to get the names


WITH dedup_logins AS (SELECT DISTINCT id,
				      login_date
		      FROM Logins),

logins_lead AS (SELECT id,
		       login_date,
		       LEAD(login_date,4) OVER(PARTITION BY id ORDER BY login_date) AS leaded_date
		FROM dedup_logins),
				
active_ids AS (SELECT distinct id
	       FROM logins_lead
	       WHERE leaded_date IS NOT NULL AND DATEDIFF(leaded_date, login_date) = 5)
			   
SELECT i.id, a.name
FROM active_ids i
INNER JOIN Accounts b
ON i.id = b.id;
