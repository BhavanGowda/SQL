-- Question 70
-- In facebook, there is a follow table with two columns: followee, follower.

-- Please write a sql query to get the amount of each follower’s follower if he/she has one.

-- For example:

-- +-------------+------------+
-- | followee    | follower   |
-- +-------------+------------+
-- |     A       |     B      |
-- |     B       |     C      |
-- |     B       |     D      |
-- |     D       |     E      |
-- +-------------+------------+
-- should output:
-- +-------------+------------+
-- | follower    | num        |
-- +-------------+------------+
-- |     B       |  2         |
-- |     D       |  1         |
-- +-------------+------------+
-- Explaination:
-- Both B and D exist in the follower list, when as a followee, B's follower is C and D, and D's follower is E. A does not exist in follower list.
 

-- Note:
-- Followee would not follow himself/herself in all cases.
-- Please display the result in follower's alphabet order.

-- Explanation
-- Step1 : We need to check if the people in follower section have ever followed anyone, if they have then we need to find there follower 
--         counts
-- Step2 : By doing left join we can retain the existing data and check the step1 condition and finally aggregate the data


SELECT f1.followee AS follower, COUNT(f1.follower) AS num
FROM Follow f1
LEFT JOIN Follow f2
ON f1.followee = f2.follower
WHERE f2.followee is NOT NULL
GROUP BY f1.followee;
