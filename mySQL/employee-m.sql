USE employees;

SELECT
	e.first_name,
	e.last_name
FROM
	employees e
LIMIT 10;

SELECT
	s.salary,
	COUNT(s.emp_no) AS emps_with_same_salary
FROM
	salaries s
WHERE
	s.salary > 80000
GROUP BY
	s.salary
ORDER BY
	s.salary ASC;

SELECT
	s.emp_no,
	AVG(s.salary) AS avg_salary
FROM
	salaries s
GROUP BY
	(s.emp_no)
HAVING
	avg_salary > 120000
ORDER BY
	s.emp_no ASC;

SELECT
	de.emp_no,
	de.dept_no,
	COUNT(de.dept_no) as dept_no_count
FROM
	dept_emp de
WHERE
	de.from_date > '2000-01-01'
GROUP BY
	de.emp_no,
	de.dept_no
HAVING
	dept_no_count > 1
ORDER BY
	dept_no_count DESC;

SELECT
	de.emp_no,
	COUNT(DISTINCT de.from_date) as start_date_count
FROM
	dept_emp de
WHERE
	de.from_date > '2000-01-01'
GROUP BY
	de.emp_no
HAVING
	start_date_count > 1
ORDER BY
	start_date_count DESC;

SELECT
	*
FROM
	salaries s
LIMIT 10;

SELECT
	*
FROM
	employees e
LIMIT 10;

SELECT
	*
FROM
	dept_manager dm
LIMIT 10;

SELECT
	e.emp_no,
	e.first_name, 
	e.last_name,
	dm.dept_no, 
	dm.from_date
FROM
	employees e
LEFT OUTER JOIN
	dept_manager dm
ON 
	e.emp_no = dm.emp_no
WHERE
	e.last_name = 'Markovitch'
ORDER BY 
	dm.dept_no DESC,
	e.emp_no ASC;

SELECT
	*
FROM
	titles t
LIMIT 10;

SELECT 
	e.emp_no,
	e.first_name,
	e.last_name,
	t.title
FROM
	employees e
JOIN
	titles t 
ON
	e.emp_no = t.emp_no
WHERE
	e.first_name = 'Margareta'
	AND
	e.last_name = 'Markovitch'
ORDER BY
	e.emp_no ASC;

SELECT
	*
FROM
	departments d;

SELECT
	*
FROM
	dept_emp de;

SELECT
	*
FROM
	dept_manager dm;

SELECT
	*
FROM
	employees e
LIMIT 10;

SELECT 
	dm.emp_no,
	e.first_name,
	e.last_name,
	e.hire_date,  
	t.title,
	dm.from_date,
	d.dept_name
FROM
	dept_manager dm
JOIN
	employees e 
ON
	dm.emp_no = e.emp_no
JOIN
	departments d 
ON
	dm.dept_no = d.dept_no
JOIN 
	titles t 
ON
	dm.emp_no = t.emp_no
	AND dm.from_date = t.from_date
ORDER BY
	e.emp_no ASC;

SELECT 
	e.gender,
	COUNT(dm.emp_no) as manager_count
FROM
	employees e
JOIN 
	dept_manager dm
ON
	e.emp_no = dm.emp_no
GROUP BY
	e.gender
ORDER BY
	manager_count DESC;

SELECT
	*
FROM
	salaries s
LIMIT 10;

SELECT
	*
FROM
	titles t
LIMIT 10;

SELECT 
	t.title,
	ROUND(AVG(s.salary), 2) AS avg_salary
FROM
	titles t
JOIN 
	salaries s 
ON
	t.emp_no = s.emp_no
GROUP BY 
	t.title
HAVING 
	avg_salary < 75000
ORDER BY
	avg_salary DESC;

SELECT
	*
FROM
	(
	SELECT
		e.emp_no,
		e.first_name,
		e.last_name,
		NULL AS dept_no,
		NULL AS from_date
	FROM
		employees e
	WHERE
		last_name = 'Denis'
UNION
	SELECT
		NULL AS emp_no,
		NULL AS first_name,
		NULL AS last_name,
		dm.dept_no,
		dm.from_date
	FROM
		dept_manager dm) as a
ORDER BY
	-a.emp_no DESC;

SELECT 
	e.*
FROM
	employees e
WHERE
	e.emp_no IN (
	SELECT
		dm.emp_no
	FROM
		dept_manager dm 
 )
	AND e.hire_date BETWEEN '1990-01-01' AND '1995-01-01';

SELECT
	dm.*
FROM
	dept_manager dm
WHERE
	dm.emp_no IN (
	SELECT
		e.emp_no
	FROM
		employees e
	WHERE
		e.birth_date > '1955-12-31'
	);

SELECT
	*
FROM
	dept_manager dm
LIMIT 10;

SELECT
	e.*
FROM
	employees e
WHERE
	EXISTS(
	SELECT
		t.emp_no
	FROM
		titles t
	WHERE
		t.emp_no = e.emp_no
		AND
		t.title = 'Assistant Engineer'
);

SELECT
	s.*
FROM
	salaries s
WHERE
	EXISTS(
	SELECT
		t.emp_no
	FROM
		titles t
	WHERE
		t.emp_no = s.emp_no
		AND
	t.title = 'Engineer'
);

SELECT
	e.emp_no as employee_ID,
	MIN(de.dept_no) as department_code,
	(
	SELECT
		dm.emp_no
	FROM
		dept_manager dm
	WHERE
		emp_no = 110022) as manager_ID
FROM
	employees e
JOIN dept_emp de ON
	e.emp_no = de.emp_no
WHERE
	e.emp_no <= 10020
GROUP BY
	e.emp_no
ORDER BY
	e.emp_no;