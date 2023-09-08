-- Question 105
-- A U.S graduate school has students from Asia, Europe and America. The students' location information are stored in table student as below.
 

-- | name   | continent |
-- |--------|-----------|
-- | Jack   | America   |
-- | Pascal | Europe    |
-- | Xi     | Asia      |
-- | Jane   | America   |

-- Pivot the continent column in this table so that each name is sorted alphabetically and displayed underneath its corresponding continent. The output headers should be America, Asia and Europe respectively. It is guaranteed that the student number from America is no less than either Asia or Europe.
 

-- For the sample input, the output is:
 

-- | America | Asia | Europe |
-- |---------|------|--------|
-- | Jack    | Xi   | Pascal |
-- | Jane    |      |        |

-- Explanation:
-- Step1 : We can pivot the data using CASE WHEN and to fill but we need the data to be sorted in their respective for which we will have to use min,
--		   columns.

WITH students_extn AS (SELECT name,
							  continent,
							  ROW_NUMBER() OVER (PARTITION BY continent ORDER BY name) AS rnk
					   FROM students)
					   
SELECT MIN(CASE WHEN continent = 'America' THEN name END) AS America,
	   MIN(CASE WHEN continent = 'Asia' THEN name END) AS Asia,
	   MIN(CASE WHEN continent = 'Europe' THEN name END) AS Europe
FROM students_extn
GROUP BY rnk;
