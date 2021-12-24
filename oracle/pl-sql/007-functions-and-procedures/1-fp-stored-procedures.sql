SET SERVEROUTPUT ON;

/*
  stored procedures|functions
  - reusable code
  - stored in database with names
  - compiled only once
  - can be called by another block of application
  - can return values
  - can take parameters
  
  structure:
  CREATE [OR REPLACE] PROCEDURE procedure_name
  [(paramter_name [IN | OUT | IN OUT] type [,...])] {IS | AS}
  .... 
  BEGIN
  ...
  EXCEPTION
  ...
  END;
  
*/
CREATE PROCEDURE increase_salaries AS
  CURSOR c_emps IS SELECT * FROM employees_copy FOR UPDATE;
  v_salary_increase NUMBER := 1.10;
  v_old_salary      NUMBER;
BEGIN
  FOR r_emp IN c_emps
  LOOP
    v_old_salary := r_emp.salary;
    r_emp.salary := r_emp.salary * v_salary_increase + r_emp.salary * NVL(r_emp.commission_pct,0);
    UPDATE employees_copy SET row = r_emp WHERE CURRENT OF c_emps;
    dbms_output.put_line('The salary of : '|| r_emp.employee_id || ' is increased from '||v_old_salary||' to '||r_emp.salary);
  END LOOP;
END;

/*procedure usage*/
BEGIN
  dbms_output.put_line('Start procedure calls!');
  INCREASE_SALARIES;
  INCREASE_SALARIES;
  dbms_output.put_line('End procedure calls!');
END;

/*create a procedure for new line*/
CREATE PROCEDURE new_line AS
BEGIN
  dbms_output.put_line('------------------------------------------');
END;


/*diffrent procedure calls*/
BEGIN
  dbms_output.put_line('Start procedure calls!');
  INCREASE_SALARIES;
  new_line;
  INCREASE_SALARIES;
  new_line;
  dbms_output.put_line('End procedure calls!');
END;

/*modify existing procedure*/
CREATE OR REPLACE PROCEDURE increase_salaries AS
  CURSOR c_emps IS SELECT * FROM employees_copy FOR UPDATE;
  v_salary_increase NUMBER := 1.10;
  v_old_salary      NUMBER;
BEGIN
  FOR r_emp IN c_emps
  LOOP
    v_old_salary := r_emp.salary;
    r_emp.salary := r_emp.salary * v_salary_increase + r_emp.salary * NVL(r_emp.commission_pct,0);
    UPDATE employees_copy SET row = r_emp WHERE CURRENT OF c_emps;
    dbms_output.put_line('The salary of : '|| r_emp.employee_id || ' is increased from '||v_old_salary||' to '||r_emp.salary);
  END LOOP;
  dbms_output.put_line('Procedure finished executing!');
END;