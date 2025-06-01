USE employees;
-- using sub-query inside a where clause
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
-- group them all as `A` group.
SELECT
	A.*
FROM
	(
	SELECT
		e.emp_no AS employee_ID,
		MIN(de.dept_no) AS department_code,
		(
		SELECT
			dm.emp_no
		FROM
			dept_manager dm
		WHERE
			emp_no = 110022) AS manager_ID
	FROM
		employees e
	JOIN dept_emp de ON
		e.emp_no = de.emp_no
	WHERE
		e.emp_no <= 10020
	GROUP BY
		e.emp_no
	ORDER BY
		e.emp_no) AS A;
-- merge group `A` with group `B` together.
SELECT
	A.*
FROM
	(
	SELECT
		e.emp_no AS employee_ID,
		MIN(de.dept_no) AS department_code,
		(
		SELECT
			dm.emp_no
		FROM
			dept_manager dm
		WHERE
			emp_no = 110022) AS manager_ID
	FROM
		employees e
	JOIN dept_emp de ON
		e.emp_no = de.emp_no
	WHERE
		e.emp_no <= 10020
	GROUP BY
		e.emp_no
	ORDER BY
		e.emp_no) AS A
UNION
SELECT
	 B.*
FROM
	(
	SELECT
		e.emp_no AS employee_ID,
		MIN(de.dept_no) AS department_code,
		(
		SELECT
			dm.emp_no
		FROM
			dept_manager dm
		WHERE
			emp_no = 110039) AS manager_ID
	FROM
		employees e
	JOIN dept_emp de ON
		e.emp_no = de.emp_no
	WHERE
		e.emp_no > 10020
	GROUP BY
		e.emp_no
	ORDER BY
		e.emp_no
	LIMIT 20) AS B;
-- now we want to seed a new table `employees.emp_manager` with the data we SELECTed
CREATE TABLE IF NOT EXISTS employees.emp_manager (
emp_no INT(11) NOT NULL,
dept_no CHAR(4) NULL,
manager_no INT(11) NOT NULL
);
-- should be empty
SELECT
	*
FROM
	emp_manager em;
-- now seed based on the existing tables and joning them
INSERT
	INTO
	emp_manager
SELECT
	u.*
FROM
	(
	SELECT
		a.*
	FROM
		(
		SELECT
			e.emp_no AS employee_ID,
			MIN(de.dept_no) AS department_code,
			(
			SELECT
				emp_no
			FROM
				dept_manager
			WHERE
				emp_no = 110022) AS manager_ID
		FROM
			employees e
		JOIN dept_emp de ON
			e.emp_no = de.emp_no
		WHERE
			e.emp_no <= 10020
		GROUP BY
			e.emp_no
		ORDER BY
			e.emp_no) AS a
UNION
	SELECT
		b.*
	FROM
		(
		SELECT
			e.emp_no AS employee_ID,
			MIN(de.dept_no) AS department_code,
			(
			SELECT
				emp_no
			FROM
				dept_manager
			WHERE
				emp_no = 110039) AS manager_ID
		FROM
			employees e
		JOIN dept_emp de ON
			e.emp_no = de.emp_no
		WHERE
			e.emp_no > 10020
		GROUP BY
			e.emp_no
		ORDER BY
			e.emp_no
		LIMIT 20) AS b
UNION
	SELECT
		c.*
	FROM
		(
		SELECT
			e.emp_no AS employee_ID,
			MIN(de.dept_no) AS department_code,
			(
			SELECT
				emp_no
			FROM
				dept_manager
			WHERE
				emp_no = 110039) AS manager_ID
		FROM
			employees e
		JOIN dept_emp de ON
			e.emp_no = de.emp_no
		WHERE
			e.emp_no = 110022
		GROUP BY
			e.emp_no) AS c
UNION
	SELECT
		d.*
	FROM
		(
		SELECT
			e.emp_no AS employee_ID,
			MIN(de.dept_no) AS department_code,
			(
			SELECT
				emp_no
			FROM
				dept_manager
			WHERE
				emp_no = 110022) AS manager_ID
		FROM
			employees e
		JOIN dept_emp de ON
			e.emp_no = de.emp_no
		WHERE
			e.emp_no = 110039
		GROUP BY
			e.emp_no) AS d) AS u;
-- observing the table obtanied
SELECT
	*
FROM
	emp_manager em;

SELECT
	t.emp_no,
	t.title,
	(
	SELECT
		ROUND(AVG(s.salary), 2)
	FROM
		salaries s
	WHERE
		s.emp_no = t.emp_no) as avg_salary
FROM
	titles t
WHERE
	t.title = 'Staff'
	OR t.title = 'Engineer'
ORDER BY
	avg_salary DESC;