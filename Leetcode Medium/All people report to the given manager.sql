-- Question 55
-- Table: Employees

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | employee_id   | int     |
-- | employee_name | varchar |
-- | manager_id    | int     |
-- +---------------+---------+
-- employee_id is the primary key for this table.
-- Each row of this table indicates that the employee with ID employee_id and name employee_name reports his
-- work to his/her direct manager with manager_id
-- The head of the company is the employee with employee_id = 1.
 

-- Write an SQL query to find employee_id of all employees that directly or indirectly report their work to the head of the company.

-- The indirect relation between managers will not exceed 3 managers as the company is small.

-- Return result table in any order without duplicates.

-- The query result format is in the following example:

-- Employees table:
-- +-------------+---------------+------------+
-- | employee_id | employee_name | manager_id |
-- +-------------+---------------+------------+
-- | 1           | Boss          | 1          |
-- | 3           | Alice         | 3          |
-- | 2           | Bob           | 1          |
-- | 4           | Daniel        | 2          |
-- | 7           | Luis          | 4          |
-- | 8           | Jhon          | 3          |
-- | 9           | Angela        | 8          |
-- | 77          | Robert        | 1          |
-- +-------------+---------------+------------+

-- Result table:
-- +-------------+
-- | employee_id |
-- +-------------+
-- | 2           |
-- | 77          |
-- | 4           |
-- | 7           |
-- +-------------+

-- The head of the company is the employee with employee_id 1.
-- The employees with employee_id 2 and 77 report their work directly to the head of the company.
-- The employee with employee_id 4 report his work indirectly to the head of the company 4 --> 2 --> 1. 
-- The employee with employee_id 7 report his work indirectly to the head of the company 7 --> 4 --> 2 --> 1.
-- The employees with employee_id 3, 8 and 9 don't report their work to head of company directly or indirectly.

-- Note : There are two ways to solve this problem either through joins as the window is given as 3 in the problem or by using recursive CTE.
-- Using Recursive CTE
-- Explanation
-- Step1 : The employee_id 1 is the head of the company which creates the top node of the company we will store that information (BASE CONDITION)
-- Step2 : Once we have the base with us we can find the other nodes i.e. employees by joining other employees information with the head and keep on
--         continuing this recursive loop until we reach the bottom most node i.e. employees in the company's herirachy
-- STEP3 : Excluding the base case after recurive query is executed as we want to find other employees who report to the head

WITH recur_employee AS (SELECT employee_id  -- base case
			FROM Employees
			WHERE employee_id = 1 
						
			UNION ALL -- for merging the records while tracing backward in recursion
						
			SELECT e.employee_id AS employee_id -- recursive case
			FROM Employees e
			INNER JOIN recur_employee r
			ON r.employee_id = e.manager_id)

SELECT employee_id 
FROM recur_employee
WHERE employee_id <> 1;
