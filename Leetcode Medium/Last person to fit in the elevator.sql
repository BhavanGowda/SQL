-- Question 68
-- Table: Queue

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | person_id   | int     |
-- | person_name | varchar |
-- | weight      | int     |
-- | turn        | int     |
-- +-------------+---------+
-- person_id is the primary key column for this table.
-- This table has the information about all people waiting for an elevator.
-- The person_id and turn columns will contain all numbers from 1 to n, where n is the number of rows in the table.
 

-- The maximum weight the elevator can hold is 1000.

-- Write an SQL query to find the person_name of the last person who will fit in the elevator without exceeding the weight limit. It is guaranteed that the person who is first in the queue can fit in the elevator.

-- The query result format is in the following example:

-- Queue table
-- +-----------+-------------------+--------+------+
-- | person_id | person_name       | weight | turn |
-- +-----------+-------------------+--------+------+
-- | 5         | George Washington | 250    | 1    |
-- | 3         | John Adams        | 350    | 2    |
-- | 6         | Thomas Jefferson  | 400    | 3    |
-- | 2         | Will Johnliams    | 200    | 4    |
-- | 4         | Thomas Jefferson  | 175    | 5    |
-- | 1         | James Elephant    | 500    | 6    |
-- +-----------+-------------------+--------+------+

-- Result table
-- +-------------------+
-- | person_name       |
-- +-------------------+
-- | Thomas Jefferson  |
-- +-------------------+

-- Queue table is ordered by turn in the example for simplicity.
-- In the example George Washington(id 5), John Adams(id 3) and Thomas Jefferson(id 6) will enter the elevator as their weight sum is 250 + 350 + 400 = 1000.
-- Thomas Jefferson(id 6) is the last person to fit in the elevator because he has the last turn in these three people.

-- Explanation:
-- Step1 : As we need to find the last person to enter first we need to find where the limit of weight will get exceed
-- Step2 : Once we have the exceeding point post that we can find one person before the exceeding point
-- Step3 : Two ways to find person before exceeding point - 1. Order By and Limit 2. First Value

WITH queue_extn AS (SELECT person_name,
						   SUM(weight) OVER (ORDER BY turn) AS rnng_sum
					FROM Queue)

SELECT DISTINCT FIRST_VALUE(person_name) OVER(ORDER BY rnng_sum DESC) AS person_name
FROM queue_extn
WHERE rnng_sum<=1000;
