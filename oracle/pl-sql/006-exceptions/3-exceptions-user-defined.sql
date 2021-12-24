SET SERVEROUTPUT ON;
/*
  user defined exceptions
*/


/*user defined exception*/
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
END;

/*raising a predefined exception*/
DECLARE
  v_salary_check pls_integer;
BEGIN
  SELECT salary INTO v_salary_check FROM employees WHERE employee_id = 100;
  IF v_salary_check > 20000 THEN
    raise invalid_number;
  END IF;
  --we do our business if the salary is under 2000
  dbms_output.put_line('The salary is in an acceptable range');
EXCEPTION
WHEN invalid_number THEN
  dbms_output.put_line('This salary is too high. You need to decrease it.');
END;


/*raising inside of the exception*/
DECLARE
  v_salary_check pls_integer;
BEGIN
  SELECT salary INTO v_salary_check FROM employees WHERE employee_id = 100;
  IF v_salary_check > 20000 THEN
    raise invalid_number;
  END IF;
  --we do our business if the salary is under 2000
  dbms_output.put_line('The salary is in an acceptable range');
EXCEPTION
WHEN invalid_number THEN
  dbms_output.put_line('This salary is too high. You need to decrease it.');
  raise;
END;