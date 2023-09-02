-- Question 99
-- X city built a new stadium, each day many people visit it and the stats are saved as these columns: id, visit_date, people

-- Please write a query to display the records which have 3 or more consecutive rows and the amount of people more than 100(inclusive).

-- For example, the table stadium:
-- +------+------------+-----------+
-- | id   | visit_date | people    |
-- +------+------------+-----------+
-- | 1    | 2017-01-01 | 10        |
-- | 2    | 2017-01-02 | 109       |
-- | 3    | 2017-01-03 | 150       |
-- | 4    | 2017-01-04 | 99        |
-- | 5    | 2017-01-05 | 145       |
-- | 6    | 2017-01-06 | 1455      |
-- | 7    | 2017-01-07 | 199       |
-- | 8    | 2017-01-08 | 188       |
-- +------+------------+-----------+
-- For the sample data above, the output is:

-- +------+------------+-----------+
-- | id   | visit_date | people    |
-- +------+------------+-----------+
-- | 5    | 2017-01-05 | 145       |
-- | 6    | 2017-01-06 | 1455      |
-- | 7    | 2017-01-07 | 199       |
-- | 8    | 2017-01-08 | 188       |
-- +------+------------+-----------+
-- Note:
-- Each day only have one row record, and the dates are increasing with id increasing.
-- Note : This problem can be solved using row number and count
-- Explanation:
-- Step1 : To solve this problem we would require to know previous 2 days status or next 2 days status or previous 1, next 1 status
--         along with the current day status
-- Step2: We can use lead and lag functions to perform the above conditions

WITH stadium_extn AS (SELECT id,
                             visit_date,
                             people,
                             LEAD(people) OVER wnd AS ld_one,
                             LEAD(people, 2) OVER wnd AS ld_two,
                             LAG(people) OVER wnd AS lg_one,
                             LAG(people,2) OVER wnd AS lg_two
                      FROM Stadium
                      WINDOW wnd AS (ORDER BY visit_date))

SELECT id,
       visit_date,
       people
FROM stadium_extn
WHERE ((ld_one>=100 AND ld_two>=100) OR (lg_one>=100 AND lg_two>=100) OR (lg_one>=100 AND ld_one>=100)) AND people>=100;
