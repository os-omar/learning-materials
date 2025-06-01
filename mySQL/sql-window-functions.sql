USE employees;

SELECT
	s.emp_no,
	s.salary,
	ROW_NUMBER() OVER (
	PARTITION BY s.emp_no
ORDER BY
	s.salary DESC
	) AS row_num
FROM
	salaries s;

WITH rancked_salaries AS (
SELECT
	s.emp_no,
	s.salary,
	ROW_NUMBER() OVER (
	PARTITION BY s.emp_no
ORDER BY
	s.salary DESC
	) AS row_num
FROM
	salaries s
)
SELECT
	rs.emp_no,
	rs.salary
FROM
	rancked_salaries rs
WHERE
	rs.row_num = 1;

SELECT
	dm.*,
	ROW_NUMBER() OVER (
ORDER BY
	dm.emp_no) AS row_num
FROM
	dept_manager dm;

SELECT
	e.*,
	ROW_NUMBER() OVER (PARTITION BY e.first_name
ORDER BY
	e.last_name) AS row_num
FROM
	employees e;
-- adding hight and lowest salary row_numbers
SELECT
	s.emp_no,
	s.salary,
	ROW_NUMBER() OVER (PARTITION BY s.emp_no
ORDER BY
	s.salary ASC) as row_num2,
	ROW_NUMBER() OVER (PARTITION BY s.emp_no
ORDER BY
	s.salary DESC) as row_num3
FROM
	salaries s;

SELECT
	dm.emp_no,
	s.salary,
	ROW_NUMBER() OVER () AS row_num1,
	ROW_NUMBER() OVER (
	PARTITION BY dm.emp_no
ORDER BY
	s.salary ASC
	) AS row_num2
FROM
	dept_manager dm
JOIN salaries s ON
	dm.emp_no = s.emp_no
ORDER BY
	row_num1,
	s.salary ASC;

SELECT
	dm.emp_no,
	s.salary,
	ROW_NUMBER() OVER (
	PARTITION BY dm.emp_no
ORDER BY
	s.salary ASC
	) AS row_num1,
		ROW_NUMBER() OVER (
	PARTITION BY dm.emp_no
ORDER BY
	s.salary DESC
	) AS row_num2
FROM
	dept_manager dm
JOIN salaries s ON
	dm.emp_no = s.emp_no;

SELECT
	ROW_NUMBER() OVER () AS row_num1,
	t.emp_no,
	t.title,
	s.salary,
	ROW_NUMBER() OVER (
	PARTITION BY t.emp_no
ORDER BY
	s.salary DESC
	) AS row_num2
FROM
	titles t
JOIN salaries s ON
	t.emp_no = s.emp_no
WHERE
	t.title = 'Staff'
	AND t.emp_no <= 10006
ORDER BY
	t.emp_no,
	s.salary,
	row_num1 ASC;

SELECT
	t.emp_no,
	t.title,
	s.salary,
	ROW_NUMBER() OVER (
		PARTITION BY t.emp_no
ORDER BY
	s.salary ASC) AS row_num1,
	ROW_NUMBER() OVER (
	PARTITION BY t.emp_no
ORDER BY
	s.salary DESC
	) AS row_num2
FROM
	titles t
JOIN salaries s ON
	t.emp_no = s.emp_no
WHERE
	t.title = 'Staff'
	AND t.emp_no <= 10006
ORDER BY
	t.emp_no,
	s.salary,
	row_num1 ASC;

SELECT
	s.emp_no,
	s.salary,
	ROW_NUMBER() OVER w AS row_num
FROM
	salaries s
WINDOW w AS (PARTITION BY s.emp_no
ORDER BY
	s.salary DESC);

SELECT
	e.emp_no,
	e.first_name,
	ROW_NUMBER() OVER w AS row_num
FROM
	employees e
WINDOW w AS (PARTITION BY e.first_name
ORDER BY
	e.emp_no ASC);
-- using sub-query
SELECT
	a.emp_no,
	a.salary AS max_salary
FROM
	(
	SELECT
		s.emp_no,
		s.salary,
		ROW_NUMBER() OVER (PARTITION BY s.emp_no
	ORDER BY
		s.salary DESC) as row_num
	FROM
		salaries s
) a
WHERE
	row_num = 1;
-- same results can be coptained as group-by
SELECT
	s.emp_no,
	MAX(s.salary) AS max_salary
FROM
	salaries s
GROUP BY
	s.emp_no
ORDER BY
	s.emp_no ASC;
-- select the employees who signed 2 or more contract of the same salary value
SELECT
	s.emp_no,
	(COUNT(s.salary) - COUNT(DISTINCT s.salary)) AS diff
FROM
	salaries s
GROUP BY
	s.emp_no
HAVING
	diff > 0
ORDER BY
	diff DESC;

SELECT
	s.*
FROM
	salaries s
WHERE
	s.emp_no = 11839
ORDER BY
	s.salary DESC;
-- you can see row_num = 3 & 4 are equal in salary
SELECT
	s.emp_no,
	s.salary,
	ROW_NUMBER() OVER (PARTITION BY s.emp_no
ORDER BY
	s.salary DESC) AS row_num
FROM
	salaries s
WHERE
	s.emp_no = 11839;
-- if that is not the desired outout the use RANK() now both records as the same number 3 the next record is 5 no 4 found
SELECT
	s.emp_no,
	s.salary,
	RANK() OVER (PARTITION BY s.emp_no
ORDER BY
	s.salary DESC) AS rank_num
FROM
	salaries s
WHERE
	s.emp_no = 11839;
-- if you do not like skipping number 4 use DENSE_RANK()
SELECT
	s.emp_no,
	s.salary,
	DENSE_RANK() OVER (PARTITION BY s.emp_no
ORDER BY
	s.salary DESC) AS dense_rank_num
FROM
	salaries s
WHERE
	s.emp_no = 11839;
-- combine everything you have learned
SELECT
	dm.dept_no,
	d.dept_name,
	dm.emp_no,
	RANK() OVER (PARTITION BY dm.dept_no
ORDER BY
	s.salary DESC) AS department_salary_ranking,
	s.salary,
	s.from_date AS salary_from_date,
	s.to_date AS salary_to_date,
	dm.from_date AS dept_manager_from_date,
	dm.to_date AS dept_manager_to_date
FROM
	dept_manager dm
JOIN salaries s ON
	dm.emp_no = s.emp_no
	AND s.from_date BETWEEN dm.from_date AND dm.to_date
	AND s.to_date BETWEEN dm.from_date AND dm.to_date
JOIN departments d ON
	dm.dept_no = d.dept_no;
-- WHERE
-- 	s.from_date BETWEEN dm.from_date AND dm.to_date
-- 	AND s.to_date BETWEEN dm.from_date AND dm.to_date;


SELECT
	e.emp_no,
	s.salary,
	RANK() OVER (PARTITION BY e.emp_no
ORDER BY
	s.salary DESC) AS salary_rank_desc
FROM
	employees e
JOIN salaries s ON
	s.emp_no = e.emp_no
WHERE
	e.emp_no BETWEEN 10500 AND 10600;

SELECT
	e.emp_no,
	s.salary,
	DENSE_RANK() OVER (PARTITION BY e.emp_no
ORDER BY
	s.salary DESC) AS salary_rank_desc,
	YEAR(s.from_date) - YEAR(e.hire_date) AS contract_distance_from_hire_date
FROM
	employees e
JOIN salaries s ON
	s.emp_no = e.emp_no
WHERE
	e.emp_no BETWEEN 10500 AND 10600
	AND YEAR(s.from_date) - YEAR(e.hire_date) >= 5;
-- use of LAG() & LEAD() only for s.emp_no = 10001
SELECT
	s.emp_no,
	LAG(s.salary) OVER w AS previous_salary,
	s.salary AS current_salary,
	LEAD(s.salary) OVER w AS next_salary,
	s.salary - LAG(s.salary) OVER w AS diff_salary_current_previous,
	LEAD(s.salary) OVER w - s.salary AS diff_salary_next_current
FROM
	salaries s
WHERE
	s.emp_no = 10001
WINDOW w AS (
ORDER BY
	s.salary ASC);
-- use of LAG() & LEAD() for all s.emp_no
SELECT
	s.emp_no,
	LAG(s.salary) OVER w AS previous_salary,
	s.salary AS current_salary,
	LEAD(s.salary) OVER w AS next_salary,
	s.salary - LAG(s.salary) OVER w AS diff_salary_current_previous,
	LEAD(s.salary) OVER w - s.salary AS diff_salary_next_current
FROM
	salaries s
WINDOW w AS (
PARTITION BY s.emp_no
ORDER BY
	s.salary ASC);

SELECT
	emp_no,
	salary,
	LAG(salary) OVER w AS previous_salary,
	LAG(salary, 2) OVER w AS 1_before_previous_salary,
	LEAD(salary) OVER w AS next_salary,
	LEAD(salary, 2) OVER w AS 1_after_next_salary
FROM
	salaries
WINDOW w AS (PARTITION BY emp_no
ORDER BY
	salary)
LIMIT 1000;

SELECT
	s.emp_no,
	s.salary,
	LAG(s.salary) OVER w AS previous_salary,
	LEAD(s.salary) OVER w AS next_salary,
	s.salary - LAG(s.salary) OVER w AS diff_salary_current_previous,
	LEAD(s.salary) OVER w - s.salary AS diff_salary_next_current
FROM
	salaries s
WHERE
	s.salary < 70000
	AND s.emp_no BETWEEN 10003 AND 10008
WINDOW w AS (
PARTITION BY s.emp_no
ORDER BY
	s.salary ASC);


