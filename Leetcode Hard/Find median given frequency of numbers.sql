-- Question 107
-- The Numbers table keeps the value of number and its frequency.

-- +----------+-------------+
-- |  Number  |  Frequency  |
-- +----------+-------------|
-- |  0       |  7          |
-- |  1       |  1          |
-- |  2       |  3          |
-- |  3       |  1          |
-- +----------+-------------+
-- In this table, the numbers are 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, so the median is (0 + 0) / 2 = 0.

-- +--------+
-- | median |
-- +--------|
-- | 0.0000 |
-- +--------+
-- Write a query to find the median of all numbers and name the result as median.

-- Explanation : Tricky question
-- Step1 : Understanding of Median is important to solve this problem. Median for a set of numbers is calculated by first ordering
--         them in ascending order and check the counts of number in the set, if its even, avg of two middle values to be taken 
--         else middle value should be taken
-- Step2 : In the question we have been provided with frequency of occurance of each numbers, so its important to compute the mid
--         value i.e. count of numbers/2 in whichever range the mid value occurs we need to caluclate the average of those numbers
--        CumFrequency is being used to calculate the range
-- For eg : Freqeuncy for 0 is 7 and 1 is 2, so range for number 0 is (0,7) and for 1 is (7,9) in the set

WITH numbers_extn AS (SELECT Number,
                             Frequency,
                      		   SUM(Frequency) OVER (ORDER BY Number) AS CumFrequency,
                      	     SUM(Frequency) OVER () AS Mid
                      FROM Numbers)

SELECT AVG(Number) AS median
FROM numbers_extn
WHERE Mid/2 BETWEEN (CumFrequency - Frequency) AND CumFrequency;
