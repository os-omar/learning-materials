USE employees;
-- COMMIT;

DROP TRIGGER IF EXISTS before_salaries_insert;
-- BEFORE INSERT TRIGGER
DELIMITER $$

CREATE TRIGGER before_salaries_insert
BEFORE
INSERT
	ON
	salaries
FOR EACH ROW
BEGIN
	IF NEW.salary < 0 THEN
		SET
	NEW.salary = 0;
END IF;
END$$
DELIMITER ;


SELECT
	s.*
FROM
	salaries s
WHERE
	s.emp_no = '10001';
-- INSERT
-- 	INTO
-- 	salaries
-- VALUES (
-- 	'10001',
-- 	-92891,
-- 	'2010-06-22',
-- 	'9999-01-01'
-- 	);


DROP TRIGGER IF EXISTS before_salaries_update;
-- BEFORE UPDATE
DELIMITER $$

CREATE TRIGGER before_salaries_update
BEFORE
UPDATE
	ON
	salaries
FOR EACH ROW
BEGIN
	IF NEW.salary < 0 THEN
		SET
	NEW.salary = OLD.salary;
END IF;
END$$
DELIMITER ;

UPDATE
	salaries s
SET
	s.salary = 98765
WHERE
	s.emp_no = '10001'
	AND from_date = '2010-06-22';

UPDATE
	salaries s
SET
	s.salary = -50000
WHERE
	s.emp_no = '10001'
	AND from_date = '2010-06-22';
-- Indexes
SELECT
	e.*
FROM
	employees e
WHERE
	hire_date > '2000-01-01';

CREATE INDEX i_hire_date ON
employees(hire_date);
-- using composite Index.
SELECT
	e.*
FROM
	employees e
WHERE
	e.first_name = 'Georgi'
	AND e.last_name = 'Facello';

CREATE INDEX i_composite ON
employees(first_name, last_name);

ALTER TABLE employees DROP INDEX i_hire_date;

SELECT
	de.*
FROM
	dept_emp de
LIMIT 10;

CREATE INDEX IF NOT EXISTS i_from_date ON
dept_emp(from_date);

SELECT
	s.*
FROM
	salaries s
LIMIT 10;

CREATE INDEX IF NOT EXISTS i_composite_salary ON
salaries(emp_no, salary);
-- understanding CASE Statement
SELECT
	e.emp_no,
	e.first_name,
	e.last_name,
	CASE
		WHEN e.gender = 'M' THEN 'Male'
		ELSE 'Female'
	END AS gender
FROM
	employees e
LIMIT 100;
-- new syntax which does not work with `IS NULL / IS NOT NULL`
SELECT
	e.emp_no,
	e.first_name,
	e.last_name,
	CASE
		e.gender
		WHEN 'M' THEN 'Male'
		ELSE 'Female'
	END AS gender
FROM
	employees e
LIMIT 100;
-- example: with `IS NULL / IS NOT NULL` only work with this syntax.
SELECT
	e.emp_no,
	e.first_name,
	e.last_name,
	CASE 
		WHEN dm.emp_no IS NOT NULL THEN 'Manager'
		ELSE 'Employer'
	END AS is_manager
FROM
	employees e
LEFT JOIN dept_manager dm ON
	dm.emp_no = e.emp_no
WHERE
	e.emp_no > 109990
ORDER BY
	is_manager DESC;
-- understanding IF condtion, only one condition is allowed with IF conditon.
SELECT
	e.emp_no,
	e.first_name,
	e.last_name,
	IF(e.gender = 'M', 'Male', 'Female') AS gender
FROM
	employees e;
-- CASE multiple condtion checking
SELECT
	dm.emp_no,
	e.first_name,
	e.last_name,
	MAX(s.salary) - MIN(s.salary) AS salary_difference,
	CASE
		WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary was raised by more than $30,000'
		WHEN MAX(s.salary) - MIN(s.salary) BETWEEN 20000 AND 30000 THEN 'Salary was raised by more than $20,000 but less than $30,000'
		ELSE 'Salary was raised by less than $20,000'
	END AS salary_increase
FROM
	dept_manager dm
JOIN 
	employees e ON
	 e.emp_no = dm.emp_no
JOIN
 salaries s ON
	s.emp_no = dm.emp_no
GROUP BY
	s.emp_no;

SELECT
	e.emp_no,
	e.first_name,
	e.last_name,
	CASE
		WHEN MAX(de.to_date) > SYSDATE() THEN 'Is still employed'
		ELSE 'Not an employee anymore'
	END AS current_employee
FROM
	employees e
JOIN 
	dept_emp de
	ON
	de.emp_no = e.emp_no
GROUP BY
	de.emp_no
LIMIT 100;

SELECT
	SYSDATE();
-- CASE multiple condtion checking
SELECT
	dm.emp_no,
	e.first_name,
	e.last_name,
	e.hire_date,
	MIN(s.salary) AS min_salary,
	MAX(s.salary) AS max_salary,
	MAX(s.salary) - MIN(s.salary) AS salary_difference,
	CASE
		WHEN MAX(s.salary) - MIN(s.salary) > 10000 THEN 'significant'
		WHEN MAX(s.salary) - MIN(s.salary) BETWEEN 0 AND 10000 THEN 'insignificant'
		ELSE 'salary decrease'
	END AS salary_raise
FROM
	dept_manager dm
JOIN 
	employees e ON
	 e.emp_no = dm.emp_no
JOIN
 salaries s ON
	s.emp_no = dm.emp_no
WHERE
	dm.emp_no > 10005
GROUP BY
	s.emp_no;

SELECT
	dm.emp_no,
	e.first_name,
	e.last_name,
	e.hire_date,
	MIN(s.salary) AS min_salary,
	MAX(s.salary) AS max_salary,
	MAX(s.salary) - MIN(s.salary) AS salary_difference,
	CASE
		WHEN MAX(s.salary) - MIN(s.salary) <= 10000
		AND MAX(s.salary) - MIN(s.salary) > 0 
    THEN 'insignificant'
		WHEN MAX(s.salary) - MIN(s.salary) > 10000 THEN 'significant'
		ELSE 'salary decrease'
	END as salary_raise
FROM
	dept_manager dm
JOIN 
	employees e ON
	 e.emp_no = dm.emp_no
JOIN
 salaries s ON
	s.emp_no = dm.emp_no
WHERE
	dm.emp_no > 10005
GROUP BY
	s.emp_no,
	e.first_name,
	e.last_name,
	e.hire_date
ORDER BY
	dm.emp_no;
