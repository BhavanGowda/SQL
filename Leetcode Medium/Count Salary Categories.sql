/*Table: Accounts

+-------------+------+
| Column Name | Type |
+-------------+------+
| account_id  | int  |
| income      | int  |
+-------------+------+
account_id is the primary key (column with unique values) for this table.
Each row contains information about the monthly income for one bank account.
 

Write a solution to calculate the number of bank accounts for each salary category. The salary categories are:

"Low Salary": All the salaries strictly less than $20000.
"Average Salary": All the salaries in the inclusive range [$20000, $50000].
"High Salary": All the salaries strictly greater than $50000.
The result table must contain all three categories. If there are no accounts in a category, return 0.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Accounts table:
+------------+--------+
| account_id | income |
+------------+--------+
| 3          | 108939 |
| 2          | 12747  |
| 8          | 87709  |
| 6          | 91796  |
+------------+--------+
Output: 
+----------------+----------------+
| category       | accounts_count |
+----------------+----------------+
| Low Salary     | 1              |
| Average Salary | 0              |
| High Salary    | 3              |
+----------------+----------------+
Explanation: 
Low Salary: Account 2.
Average Salary: No accounts.
High Salary: Accounts 3, 6, and 8.*/

-- Explanation:
-- Step1 : As we need all the categories to be present in the output we would be needing dimention table for categories
-- Step2 : We need to compute in which category the accounts are part of based on conditions given
-- Step3 : Lastly, we need to aggregate the data based on category by performing a left join

WITH dim_category AS (SELECT 'Low Salary' AS category,1 AS id
                      UNION ALL
                      SELECT 'Average Salary' AS category,2 AS id
                      UNION ALL
                      SELECT 'High Salary' AS category,3 AS id),

accounts_agg AS (SELECT account_id,
                        CASE WHEN income < 20000 THEN 1
                             WHEN income BETWEEN 20000 AND 50000 THEN 2
                             ELSE 3
                        END AS id
                 FROM Accounts)

SELECT c.category, COUNT(a.account_id) AS accounts_count
FROM dim_category c
LEFT JOIN accounts_agg a
USING(id)
GROUP BY c.category;
