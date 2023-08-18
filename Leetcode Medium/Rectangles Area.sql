-- Question 79
-- Table: Points

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | x_value       | int     |
-- | y_value       | int     |
-- +---------------+---------+
-- id is the primary key for this table.
-- Each point is represented as a 2D Dimensional (x_value, y_value).
-- Write an SQL query to report of all possible rectangles which can be formed by any two points of the table. 

-- Each row in the result contains three columns (p1, p2, area) where:

-- p1 and p2 are the id of two opposite corners of a rectangle and p1 < p2.
-- Area of this rectangle is represented by the column area.
-- Report the query in descending order by area in case of tie in ascending order by p1 and p2.

-- Points table:
-- +----------+-------------+-------------+
-- | id       | x_value     | y_value     |
-- +----------+-------------+-------------+
-- | 1        | 2           | 8           |
-- | 2        | 4           | 7           |
-- | 3        | 2           | 10          |
-- +----------+-------------+-------------+

-- Result table:
-- +----------+-------------+-------------+
-- | p1       | p2          | area        |
-- +----------+-------------+-------------+
-- | 2        | 3           | 6           |
-- | 1        | 2           | 2           |
-- +----------+-------------+-------------+

-- p1 should be less than p2 and area greater than 0.
-- p1 = 1 and p2 = 2, has an area equal to |2-4| * |8-7| = 2.
-- p1 = 2 and p2 = 3, has an area equal to |4-2| * |7-10| = 6.
-- p1 = 1 and p2 = 3 It's not possible because the rectangle has an area equal to 0.

-- Explanation:
-- Note : It's a bit tricky and good question, which will test your knowledge on conditional cross join
-- Step1 : First cross join the table itself as we need to check every point with every other point
-- Step2 : As given in the question p1 < p2, means we will have to apply condition of id's from both the table to follow the condition
--         or else we will get the same result with two different rows
-- Step3 : Finnaly we need to compute the output and filter all possible scenarios where the area will be zero

WITH points_extn AS (SELECT p1.id AS p1id,
			    p1.x_value AS p1x,
			    p1.y_value AS p1y,
			    p2.id AS p2id,
			    p2.x_value AS p2x,
			    p2.y_value AS p2y
		     FROM Points p1
		     CROSS JOIN Points p2
		     WHERE p1.id < p2.id),
					 
points_area AS (SELECT p1id AS p1,
		       p2id AS p2,
		       ABS(p1x - p2x)*ABS(p1y-p2y) AS area
		FROM points_extn)
				
SELECT p1,
       p2,
       area
FROM points_area
WHERE area <> 0
ORDER BY area DESC,p1,p2;
