-- Question 75
-- The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.

-- +------+----------+-----------+----------+
-- |Id    |Name 	  |Department |ManagerId |
-- +------+----------+-----------+----------+
-- |101   |John 	  |A 	      |null      |
-- |102   |Dan 	  	  |A 	      |101       |
-- |103   |James 	  |A 	      |101       |
-- |104   |Amy 	      |A 	      |101       |
-- |105   |Anne 	  |A 	      |101       |
-- |106   |Ron 	      |B 	      |101       |
-- +------+----------+-----------+----------+
-- Given the Employee table, write a SQL query that finds out managers with at least 5 direct report. For the above table, your SQL query should return:

-- +-------+
-- | Name  |
-- +-------+
-- | John  |
-- +-------+
-- Note:
-- No one would report to himself.

-- Explanation:
-- Step1 : As we need to find out the number of managers having at leat 5 reportees, we can first find group of manager ID's
-- Step2 : Once we get the manager ID's with more than or equals 5 reportee's, we can get the name by joining by itself

WITH manager_extn AS (SELECT ManagerId
					  FROM Employee
					  GROUP BY ManagerId
					  HAVING COUNT(ManagerId) >= 5)

SELECT Name
FROM Employee e
INNER JOIN manager_extn m
ON e.Id = m.ManagerId;
