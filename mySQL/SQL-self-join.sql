USE employees;
-- observing the table obtanied
SELECT
	*
FROM
	emp_manager em;

SELECT
	DISTINCT
	em.*
FROM
	emp_manager em
JOIN emp_manager em2 ON
	em.emp_no = em2.manager_no;

SELECT
	em.*
FROM
	emp_manager em
JOIN emp_manager em2 ON
	em.emp_no = em2.manager_no
WHERE
	em2.emp_no IN (
	SELECT
		DISTINCT
		em3.manager_no
	FROM
		emp_manager em3);

SELECT
	DISTINCT em3.manager_no
FROM
	emp_manager em3;

SELECT
	em.*
FROM
	emp_manager em
WHERE
	em.emp_no IN (
	SELECT
		DISTINCT
		em2.manager_no
	FROM
		emp_manager em2)
ORDER BY
	em.emp_no DESC;