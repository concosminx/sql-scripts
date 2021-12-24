SET SERVEROUTPUT ON;

/*
  package visibility
  - variables
    * inside of the package spec (public)
    * inside of the package body (private, global package variable)
  - simialr rules for subprograms
*/

CREATE OR REPLACE PACKAGE BODY EMP AS
  /*declare private variables here, after AS*/
  v_sal_inc  INT := 500;
  v_sal_inc2 INT := 500;
  /*
    private subprogram -> cannot call this before is created,
    unless we are using forward declaration
  */
  FUNCTION get_sal(e_id employees.employee_id%type) return number;
  
  PROCEDURE print_test IS
  BEGIN
    dbms_output.put_line('Test 1 : '|| v_sal_inc);
    dbms_output.put_line('Test 2 : '|| get_sal(100));
  END;
  
  PROCEDURE increase_salaries AS
  BEGIN
    FOR r1 IN cur_emps
    LOOP
      UPDATE employees_copy
      SET salary        = salary + salary * v_salary_increase_rate
      WHERE employee_id = r1.employee_id;
    END LOOP;
  END increase_salaries;
  
  FUNCTION get_avg_sal(p_dept_id INT) RETURN NUMBER AS
    v_avg_sal NUMBER := 0;
  BEGIN
    print_test;
    SELECT AVG(salary)
    INTO v_avg_sal
    FROM employees_copy
    WHERE department_id = p_dept_id;
    RETURN v_avg_sal;
  END get_avg_sal;
  
  FUNCTION get_sal(e_id employees.employee_id%type) return number is
    v_sal NUMBER := 0;
  BEGIN
    select salary into v_sal from employees where employee_id = e_id;
    RETURN v_sal;
  END get_sal;
  
  /*package initialisation - first time in a session*/
  BEGIN
    v_sal_inc := 12;
    insert into logs values('EMP', 'Package initialised', sysdate);
END EMP;

CREATE TABLE logs (log_source varchar2(100), log_message varchar2(1000), log_date date);

EXEC dbms_output.put_line(EMP.GET_AVG_SAL(80));

SELECT * FROM logs;

