USE employees;

WITH cte AS (
SELECT
	AVG(s.salary) AS avg_salary
FROM
	salaries s
)
SELECT
	SUM(CASE WHEN s2.salary > c.avg_salary THEN 1 ELSE 0 END) AS no_f_salaries_above_avg_using_sum,
	COUNT(CASE WHEN s2.salary > c.avg_salary THEN s2.salary ELSE NULL END) AS no_f_salaries_above_avg_using_count,
	COUNT(s2.salary) AS total_no_of_salary_contracts
FROM
	salaries s2
JOIN employees e ON
	s2.emp_no = e.emp_no
CROSS JOIN cte c
WHERE
	e.gender = 'F';

WITH cte AS (
SELECT
	AVG(s.salary) AS avg_salary
FROM
	salaries s
)
SELECT
	SUM(CASE WHEN s.salary <= c.avg_salary THEN 1 ELSE 0 END) AS no_f_salaries_below_or_equal_avg_using_sum,
	COUNT(CASE WHEN s.salary <= c.avg_salary THEN s.salary ELSE NULL END) AS no_f_salaries_below_or_equal_avg_using_count,
	COUNT(s.salary) AS total_no_of_salary_contracts
FROM
	salaries s
JOIN employees e ON
	s.emp_no = e.emp_no
CROSS JOIN cte c
WHERE
	e.gender = 'M';

SELECT
	SUM(CASE WHEN s.salary < c.avg_salary THEN 1 ELSE 0 END) AS no_f_salaries_below_avg_using_sum,
	COUNT(CASE WHEN s.salary < c.avg_salary THEN s.salary ELSE NULL END) AS no_f_salaries_below_avg_using_count,
	COUNT(s.salary) AS total_no_of_salary_contracts
FROM
	salaries s
JOIN employees e ON
	s.emp_no = e.emp_no
CROSS JOIN (
	SELECT
		AVG(s.salary) AS avg_salary
	FROM
		salaries s) AS c
WHERE
	e.gender = 'M';

SELECT
	AVG(s.salary) AS avg_salary
FROM
	salaries s;

SELECT
	e.emp_no,
	MAX(s.salary) AS max_salary
FROM
	employees e
JOIN salaries s ON
	e.emp_no = s.emp_no
WHERE
	e.gender = 'F'
GROUP BY
	e.emp_no;

WITH avg AS (
SELECT
	AVG(s.salary) AS avg_salary
FROM
	salaries s),
f_salary AS (
SELECT
	e.emp_no,
	MAX(s.salary) AS max_salary
FROM
	employees e
JOIN salaries s ON
	e.emp_no = s.emp_no
WHERE
	e.gender = 'F'
GROUP BY
	e.emp_no)
SELECT
	SUM(CASE WHEN f.max_salary > a.avg_salary THEN 1 ELSE 0 END) AS f_highest_salaries_above_avg,
	COUNT(CASE WHEN f.max_salary > a.avg_salary THEN f.emp_no ELSE NULL END) AS f_highest_salaries_above_avg_using_count,
	COUNT(f.emp_no) AS total_no_female_contracts
FROM
	f_salary f
CROSS JOIN avg a;

WITH cte_avg_salary AS (
SELECT
	AVG(s.salary) AS avg_salary
FROM
	salaries s),
cte_f_highest_salary AS (
SELECT
	e.emp_no,
	MAX(s.salary) AS max_salary
FROM
	employees e
JOIN salaries s ON
	e.emp_no = s.emp_no
WHERE
	e.gender = 'F'
GROUP BY
	e.emp_no), 
	cte_f_counts AS (
SELECT
	SUM(CASE WHEN f.max_salary > a.avg_salary THEN 1 ELSE 0 END) AS f_highest_salaries_above_avg,
	COUNT(CASE WHEN f.max_salary > a.avg_salary THEN f.emp_no ELSE NULL END) AS f_highest_salaries_above_avg_using_count,
	COUNT(f.emp_no) AS total_no_female_contracts
FROM
	cte_f_highest_salary f
CROSS JOIN cte_avg_salary a)
SELECT
	fc.*,
	CONCAT(ROUND((fc.f_highest_salaries_above_avg_using_count / fc.total_no_female_contracts) * 100, 2),
	'%') AS '% percentage'
FROM
	cte_f_counts fc;
