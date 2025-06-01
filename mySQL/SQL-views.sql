SELECT
	*
FROM
	dept_emp de;

SELECT
	de.emp_no,
	COUNT(de.emp_no) AS entry_count
FROM
	dept_emp de
GROUP BY
	de.emp_no
HAVING
	entry_count > 1;

CREATE OR REPLACE
VIEW v_dept_emp_latest_date AS
SELECT
	de.emp_no,
	MAX(from_date) AS from_date,
	MAX(to_date) AS to_date
FROM
	dept_emp de
GROUP BY
	de.emp_no;

SELECT
	*
FROM
	v_dept_emp_latest_date;

SELECT
	*
FROM
	salaries s;

SELECT
	*
FROM
	emp_manager em;

CREATE OR REPLACE
VIEW v_manager_avg_salary AS
SELECT
	s.emp_no AS manager_no,
	ROUND(AVG(s.salary), 2) AS avg_salary
FROM
	salaries s
JOIN emp_manager em ON
	s.emp_no = em.manager_no
GROUP BY
	s.emp_no
ORDER BY
	avg_salary DESC;

CREATE OR REPLACE
VIEW v_manager_avg_salary AS
SELECT
	ROUND(AVG(s.salary), 2) AS avg_salary
FROM
	salaries s
WHERE
	s.emp_no IN ('10002', '10005', '10007')
	AND s.from_date BETWEEN '1991-01-01' AND '1996-12-31';
