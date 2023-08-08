-- Question 65
-- Table: Events

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | business_id   | int     |
-- | event_type    | varchar |
-- | occurences    | int     | 
-- +---------------+---------+
-- (business_id, event_type) is the primary key of this table.
-- Each row in the table logs the info that an event of some type occured at some business for a number of times.
 

-- Write an SQL query to find all active businesses.

-- An active business is a business that has more than one event type with occurences greater than the average occurences of that event type among all businesses.

-- The query result format is in the following example:

-- Events table:
-- +-------------+------------+------------+
-- | business_id | event_type | occurences |
-- +-------------+------------+------------+
-- | 1           | reviews    | 7          |
-- | 3           | reviews    | 3          |
-- | 1           | ads        | 11         |
-- | 2           | ads        | 7          |
-- | 3           | ads        | 6          |
-- | 1           | page views | 3          |
-- | 2           | page views | 12         |
-- +-------------+------------+------------+

-- Result table:
-- +-------------+
-- | business_id |
-- +-------------+
-- | 1           |
-- +-------------+ 
-- Average for 'reviews', 'ads' and 'page views' are (7+3)/2=5, (11+7+6)/3=8, (3+12)/2=7.5 respectively.
-- Business with id 1 has 7 'reviews' events (more than 5) and 11 'ads' events (more than 8) so it is an active business.

-- Explaination
-- Step 1 : Calculate average of occurences of event types across that particular events for ex: average of event_type reviews will be (7+3)/2 = 5
-- Step 2: Comparision and filteration of event occurences for a business with the average calculated above for ex: 1st row with business id 1 has 7 occurences for reviews which is
-- more than of average which is 5
-- Step 3: Grouping the business_id's to check how many business_id is present more than once after the filteration done in step 2

SELECT business_id 
FROM
	(SELECT business_id, 
		   occurences, 
		   AVG(occurences) OVER(PARTITION BY event_type) AS avg_event_occ
	FROM Events)
WHERE occurences > avg_event_occ
GROUP BY business_id
HAVING COUNT(business_id)>1
