-- Question 52
-- Write a SQL query to find all numbers that appear at least three times consecutively.

-- +----+-----+
-- | Id | Num |
-- +----+-----+
-- | 1  |  1  |
-- | 2  |  1  |
-- | 3  |  1  |
-- | 4  |  2  |
-- | 5  |  1  |
-- | 6  |  2  |
-- | 7  |  2  |
-- +----+-----+
-- For example, given the above Logs table, 1 is the only number that appears consecutively for at least three times.

-- +-----------------+
-- | ConsecutiveNums |
-- +-----------------+
-- | 1               |
-- +-----------------+
-- Explanation:
-- Step1 : As we have to find numbers which are present consecutively 3 times, there is no use case of Id column
-- Step2 : To compare the columnar data of leading row, we will use functions to put them in current row
-- Step3 : Once we have the leading row data in the current, we can compare if they are equal and return the result

WITH logs_extn AS (SELECT Num,
						              LEAD(Num) OVER() AS first_lead_num,
						              LEAD(Num,2) OVER() AS sec_lead_num
				           FROM Logs)

SELECT DISTINCT Num
FROM logs_extn
WHERE Num = first_lead_num AND Num = sec_lead_num;
