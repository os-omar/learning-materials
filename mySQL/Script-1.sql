SET
@p_avg_salary = 0.0;

{ 
CALL employees.emp_avg_salary_out(:p_emp_no,
@p_avg_salary);

}

SELECT @p_avg_salary;