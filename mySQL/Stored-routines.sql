USE employees;

DROP PROCEDURE IF EXISTS select_employees;
-- change it from the default `;` to `$$`
DELIMITER $$
CREATE PROCEDURE select_employees ()
BEGIN
	SELECT
	*
FROM
	employees
LIMIT 1000;
END$$
-- back to the default `;`
DELIMITER ;
-- call the newly create stored-procedure `select_employees ()`
-- call select_employees();

DROP PROCEDURE IF EXISTS emp_salary;
DELIMITER $$

CREATE PROCEDURE emp_salary (IN p_emp_no INTEGER)
BEGIN
	SELECT
	e.emp_no,
	e.first_name,
	e.last_name,
	s.salary,
	s.from_date,
	s.to_date
FROM
	employees e
JOIN salaries s ON
	e.emp_no = s.emp_no
WHERE
	e.emp_no = p_emp_no;
END$$
DELIMITER ;
-- CALL emp_salary(11300);




DROP PROCEDURE IF EXISTS emp_avg_salary;
DELIMITER $$

CREATE PROCEDURE emp_avg_salary (IN p_emp_no INTEGER)
BEGIN
SELECT
	e.emp_no,
	AVG(s.salary) AS avg_salary
FROM
	employees e
JOIN salaries s ON
	e.emp_no = s.emp_no
WHERE
	e.emp_no = p_emp_no
GROUP BY
	e.emp_no;
END$$
DELIMITER ;
-- CALL emp_avg_salary(11300);




DROP PROCEDURE IF EXISTS emp_avg_salary_out;
DELIMITER $$

CREATE PROCEDURE emp_avg_salary_out (IN p_emp_no INTEGER, OUT p_avg_salary DECIMAL(10, 2))
BEGIN
SELECT
	AVG(s.salary)
	INTO
	p_avg_salary
FROM
	employees e
JOIN salaries s ON
	e.emp_no = s.emp_no
WHERE
	e.emp_no = p_emp_no
GROUP BY
	e.emp_no;
END$$
DELIMITER ;


SET
@v_avg_salary = 0;

CALL employees.emp_avg_salary_out(11300,
@v_avg_salary);
-- SELECT
-- 	@v_avg_salary AS avg_salary;



DROP PROCEDURE IF EXISTS emp_info;
DELIMITER $$

CREATE PROCEDURE emp_info(IN p_first_name VARCHAR(255), IN p_last_name VARCHAR(255), OUT p_emp_no INTEGER)
BEGIN
SELECT
	e.emp_no
INTO
	p_emp_no
FROM
	employees e
WHERE
	e.first_name = p_first_name
	AND e.last_name = p_last_name;
END$$
DELIMITER ;


SET
@v_emp_no = 0;

CALL employees.emp_info('Aruna',
'Journel',
@v_emp_no);
-- SELECT
-- 	@v_emp_no AS out_emp_no;
-- understanding user-defined functions
DROP FUNCTION IF EXISTS f_emp_avg_salary;
DELIMITER $$

CREATE FUNCTION f_emp_avg_salary (p_emp_no INTEGER) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN

DECLARE v_avg_salary DECIMAL(10, 2);

SELECT
	ROUND(AVG(s.salary), 2)
INTO
	v_avg_salary
FROM
	employees e
JOIN salaries s ON
	e.emp_no = s.emp_no
WHERE
	e.emp_no = p_emp_no;
	
RETURN v_avg_salary;

END$$
DELIMITER ;


SELECT
	f_emp_avg_salary(11300);
