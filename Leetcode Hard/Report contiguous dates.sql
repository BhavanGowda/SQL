-- Question 104
-- Table: Failed

-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | fail_date    | date    |
-- +--------------+---------+
-- Primary key for this table is fail_date.
-- Failed table contains the days of failed tasks.
-- Table: Succeeded

-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | success_date | date    |
-- +--------------+---------+
-- Primary key for this table is success_date.
-- Succeeded table contains the days of succeeded tasks.
 

-- A system is running one task every day. Every task is independent of the previous tasks. The tasks can fail or succeed.

-- Write an SQL query to generate a report of period_state for each continuous interval of days in the period from 2019-01-01 to 2019-12-31.

-- period_state is 'failed' if tasks in this interval failed or 'succeeded' if tasks in this interval succeeded. Interval of days are retrieved as start_date and end_date.

-- Order result by start_date.

-- The query result format is in the following example:

-- Failed table:
-- +-------------------+
-- | fail_date         |
-- +-------------------+
-- | 2018-12-28        |
-- | 2018-12-29        |
-- | 2019-01-04        |
-- | 2019-01-05        |
-- +-------------------+

-- Succeeded table:
-- +-------------------+
-- | success_date      |
-- +-------------------+
-- | 2018-12-30        |
-- | 2018-12-31        |
-- | 2019-01-01        |
-- | 2019-01-02        |
-- | 2019-01-03        |
-- | 2019-01-06        |
-- +-------------------+


-- Result table:
-- +--------------+--------------+--------------+
-- | period_state | start_date   | end_date     |
-- +--------------+--------------+--------------+
-- | succeeded    | 2019-01-01   | 2019-01-03   |
-- | failed       | 2019-01-04   | 2019-01-05   |
-- | succeeded    | 2019-01-06   | 2019-01-06   |
-- +--------------+--------------+--------------+

-- The report ignored the system state in 2018 as we care about the system in the period 2019-01-01 to 2019-12-31.
-- From 2019-01-01 to 2019-01-03 all tasks succeeded and the system state was "succeeded".
-- From 2019-01-04 to 2019-01-05 all tasks failed and system state was "failed".
-- From 2019-01-06 to 2019-01-06 all tasks succeeded and system state was "succeeded".

-- Explanation (UNION ALL pattern)
-- Step1 : As we need to only find the intervals for the range of dates in 2019 year, so we will put a filter for the dates
-- Step2 : Post, we need to union all both the tables along with a flag to get the overall dates for finding the continuous intervals for
--		   the states(SUCCESS, FAILED)
-- Step3 : Continuity can be found be retrieved using two functions (ROW_NUMBER, DATE_DIFF) which is explained in previous problems
-- Step4 : Grouping the states and retrieving the max and min dates for that interval

WITH state_flag AS (SELECT fail_date AS period_dt,
							'failed' AS period_state
					 FROM Failed
					 WHERE fail_date BETWEEN '2019-01-01' AND '2019-12-31'
					 UNION ALL
					 SELECT success_date AS period_dt,
							'succeeded' AS period_state
					 FROM Succeeded
					 WHERE success_date BETWEEN '2019-01-01' AND '2019-12-31'),

state_extn AS (SELECT period_dt,
					  period_state,
					  DATE_ADD(period_dt, INTERVAL -(ROW_NUMBER() OVER(PARTITION BY period_state ORDER BY period_dt)) DAY) AS cnty
			   FROM state_flag)

SELECT period_state, MIN(period_dt) AS start_date, MAX(period_dt) AS end_date
FROM state_extn
GROUP BY period_state, cnty
ORDER BY start_date;
