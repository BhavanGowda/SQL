-- Question 86
-- Get the highest answer rate question from a table survey_log with these columns: id, action, question_id, answer_id, q_num, timestamp.

-- id means user id; action has these kind of values: "show", "answer", "skip"; answer_id is not null when action column is "answer", 
-- while is null for "show" and "skip"; q_num is the numeral order of the question in current session.

-- Write a sql query to identify the question which has the highest answer rate.

-- Example:

-- Input:
-- +------+-----------+--------------+------------+-----------+------------+
-- | id   | action    | question_id  | answer_id  | q_num     | timestamp  |
-- +------+-----------+--------------+------------+-----------+------------+
-- | 5    | show      | 285          | null       | 1         | 123        |
-- | 5    | answer    | 285          | 124124     | 1         | 124        |
-- | 5    | show      | 369          | null       | 2         | 125        |
-- | 5    | skip      | 369          | null       | 2         | 126        |
-- +------+-----------+--------------+------------+-----------+------------+
-- Output:
-- +-------------+
-- | survey_log  |
-- +-------------+
-- |    285      |
-- +-------------+
-- Explanation:
-- question 285 has answer rate 1/1, while question 369 has 0/1 answer rate, so output 285.
 

-- Note: The highest answer rate meaning is: answer number's ratio in show number in the same question.

-- Explanation:
-- Step1 : As in note it is mentioned that rate calculation is number of answers by number of shows for the particular question
-- Step2 : As the number of show is associated to an id of student we can count the id of student who have performed the action
-- Step3 : Finally once the number of answers and show with respect to id is calculated, rate can be calculated
-- Step4 : We need to consider the question with max rate


WITH activity_extn AS (SELECT question_id,
                       		  ROUND(COUNT(answer_id)/COUNT(DISTINCT CASE WHEN action = 'show' THEN id END),2) AS qstn_rate
                       FROM Activity
                       GROUP BY question_id)
SELECT question_id AS survey_log
FROM activity_extn
ORDER BY qstn_rate DESC
LIMIT 1;
