-- Question 56
-- Mary is a teacher in a middle school and she has a table seat storing students' names and their corresponding seat ids.

-- The column id is continuous increment.

-- Mary wants to change seats for the adjacent students.
 
-- Can you write a SQL query to output the result for Mary?
 
-- +---------+---------+
-- |    id   | student |
-- +---------+---------+
-- |    1    | Abbot   |
-- |    2    | Doris   |
-- |    3    | Emerson |
-- |    4    | Green   |
-- |    5    | Jeames  |
-- +---------+---------+
-- For the sample input, the output is:
-- +---------+---------+
-- |    id   | student |
-- +---------+---------+
-- |    1    | Doris   |
-- |    2    | Abbot   |
-- |    3    | Green   |
-- |    4    | Emerson |
-- |    5    | Jeames  |
-- +---------+---------+

-- Explanation :
-- Step 1: As we can see we need a pattern to solve the problem based upon the number being even and odd
-- Step 2: If the number is odd we need to take the current id and leaded name and when it is event we have to take id with laged name
-- Step 3: For cases where the last id is odd, we won't have next adjacent student so we need to return the same student name


WITH students_extn AS (SELECT id,
	   student,
       LEAD(id) OVER() AS ld_id,
       LEAD(student) OVER() AS ld_student,
       LAG(id) OVER() AS lg_id,
       LAG(student) OVER() AS lg_student
FROM Students)

SELECT id,
       COALESCE(CASE WHEN id % 2 = 1 THEN ld_student
                	 ELSE lg_student
           		END, student) AS student
FROM students_extn
