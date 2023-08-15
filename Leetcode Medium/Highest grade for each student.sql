-- Question 63
-- Table: Enrollments

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | student_id    | int     |
-- | course_id     | int     |
-- | grade         | int     |
-- +---------------+---------+
-- (student_id, course_id) is the primary key of this table.

-- Write a SQL query to find the highest grade with its corresponding course for each student. In case of a tie, you should find the course with the smallest course_id. The output must be sorted by increasing student_id.

-- The query result format is in the following example:

-- Enrollments table:
-- +------------+-------------------+
-- | student_id | course_id | grade |
-- +------------+-----------+-------+
-- | 2          | 2         | 95    |
-- | 2          | 3         | 95    |
-- | 1          | 1         | 90    |
-- | 1          | 2         | 99    |
-- | 3          | 1         | 80    |
-- | 3          | 2         | 75    |
-- | 3          | 3         | 82    |
-- +------------+-----------+-------+

-- Result table:
-- +------------+-------------------+
-- | student_id | course_id | grade |
-- +------------+-----------+-------+
-- | 1          | 2         | 99    |
-- | 2          | 2         | 95    |
-- | 3          | 3         | 82    |
-- +------------+-----------+-------+

-- Explanation:
-- Step1 : As we have to find the second grade for the particluar student based upon the cours, we can use dense rank along with ordering
-- Step2 : Once the ordering is specified while applying dense rank, we can just take the 2nd record using the selection

WITH enrollment_extn AS (SELECT student_id,
	   							course_id,
       							grade,
       							DENSE_RANK() OVER(PARTITION BY student_id ORDER BY grade DESC,course_id) AS rnk
						FROM Enrollments)

SELECT student_id,
	   course_id,
       grade
FROM enrollment_extn
WHERE rnk = 1;
