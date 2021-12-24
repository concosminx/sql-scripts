SET SERVEROUTPUT ON;

/*
  raise application error
  - raises the error to the caller
  
  raise_application_error(error_number, error_message [,TRUE|FALSE]);
  3rd parameter for error stack
  error number must by between -20000 -20999
*/

DECLARE
  too_high_salary EXCEPTION;
  v_salary_check pls_integer;
BEGIN
  SELECT salary INTO v_salary_check FROM employees WHERE employee_id = 100;
  IF v_salary_check > 20000 THEN
    --raise too_high_salary;
    raise_application_error(-20243,'The salary of the selected employee is too high!');
  END IF;
  --we do our business if the salary is under 2000
  dbms_output.put_line('The salary is in an acceptable range');
EXCEPTION
WHEN too_high_salary THEN
  dbms_output.put_line('This salary is too high. You need to decrease it.');
END;

/*raise inside of the exception section*/
DECLARE
  too_high_salary EXCEPTION;
  v_salary_check pls_integer;
BEGIN
  SELECT salary INTO v_salary_check FROM employees WHERE employee_id = 100;
  IF v_salary_check > 20000 THEN
    raise too_high_salary;
  END IF;
  --we do our business if the salary is under 2000
  dbms_output.put_line('The salary is in an acceptable range');
EXCEPTION
WHEN too_high_salary THEN
  dbms_output.put_line('This salary is too high. You need to decrease it.');
  raise_application_error(-01403,'The salary of the selected employee is too high!',true);
END;