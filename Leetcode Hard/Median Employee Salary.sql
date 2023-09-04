-- Question 105
-- The Employee table holds all employees. The employee table has three columns: Employee Id, Company Name, and Salary.

-- +-----+------------+--------+
-- |Id   | Company    | Salary |
-- +-----+------------+--------+
-- |1    | A          | 2341   |
-- |2    | A          | 341    |
-- |3    | A          | 15     |
-- |4    | A          | 15314  |
-- |5    | A          | 451    |
-- |6    | A          | 513    |
-- |7    | B          | 15     |
-- |8    | B          | 13     |
-- |9    | B          | 1154   |
-- |10   | B          | 1345   |
-- |11   | B          | 1221   |
-- |12   | B          | 234    |
-- |13   | C          | 2345   |
-- |14   | C          | 2645   |
-- |15   | C          | 2645   |
-- |16   | C          | 2652   |
-- |17   | C          | 65     |
-- +-----+------------+--------+
-- Write a SQL query to find the median salary of each company. Bonus points if you can solve it without using any built-in SQL functions.

-- +-----+------------+--------+
-- |Id   | Company    | Salary |
-- +-----+------------+--------+
-- |5    | A          | 451    |
-- |6    | A          | 513    |
-- |12   | B          | 234    |
-- |9    | B          | 1154   |
-- |14   | C          | 2645   |
-- +-----+------------+--------+

-- Explanation:
-- Step1 : Understanding of Median is important to solve this problem. Median for a list of numbers is calculated by first ordering
--         them in ascending order and check the counts of number in the list, if its even avg of two middle values should be taken 
--         else middle value should be taken
-- Step2 : As we do not have to use any built in function we can solve this question using row number and total count concept over 
--		   the partitioned data of Company
-- Step3 : Finally we can filter the data that will lie in the range cnt/2 and cnt+2/2, as this will ensure for both even and odd the
--		   median values are selected


WITH employee_extn AS (SELECT Id,
                              Company,
                              Salary,
                              ROW_NUMBER() OVER(PARTITION BY Company ORDER BY Salary) AS rnk,
                              COUNT(Id) OVER(PARTITION BY Company) AS cnt 
                       FROM Employee)

SELECT Id,
       Company,
       Salary
FROM employee_extn
WHERE rnk BETWEEN cnt/2 AND (cnt+2)/2;
