SET SERVEROUTPUT ON;

/*
  using collections
*/
CREATE OR REPLACE PACKAGE EMP_PKG AS 
  type emp_table_type IS TABLE OF employees%rowtype INDEX BY pls_integer;
  v_salary_increase_rate NUMBER := 1000;
  v_min_employee_salary  NUMBER := 5000;
  CURSOR cur_emps IS SELECT * FROM employees;
  PROCEDURE increase_salaries;
  FUNCTION get_avg_sal(p_dept_id INT) RETURN NUMBER;
  v_test   INT := 4;
  FUNCTION get_employees RETURN emp_table_type;
  FUNCTION get_employees_tobe_incremented RETURN emp_table_type;
  PROCEDURE increase_low_salaries;
  FUNCTION arrange_for_min_salary(v_emp employees%rowtype) RETURN employees%rowtype;
END EMP_PKG;

/* package body*/
CREATE OR REPLACE PACKAGE BODY EMP_PKG AS
  v_sal_inc  INT := 500;
  v_sal_inc2 INT := 500;
  FUNCTION get_sal(e_id employees.employee_id%type) RETURN NUMBER;
  PROCEDURE print_test IS BEGIN
      dbms_output.put_line('Test : '|| v_sal_inc);
      dbms_output.put_line('Tests salary :'|| get_sal(102));
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
  
  FUNCTION get_sal(e_id employees.employee_id%type) RETURN NUMBER IS
    v_sal NUMBER := 0;
  BEGIN
    SELECT salary
    INTO v_sal
    FROM employees
    WHERE employee_id = e_id;
    RETURN v_sal;
  END;

  /*employees in employees table*/
  FUNCTION get_employees RETURN emp_table_type IS
    v_emps emp_table_type;
  BEGIN
    FOR cur_emps IN (SELECT * FROM employees_copy)
    LOOP
      v_emps(cur_emps.employee_id) := cur_emps;
    END LOOP;
    RETURN v_emps;
  END;
  
  /* 
    returns the employees which are under the minimum salary
    of the company standards and to be incremented by the new minimum salary
  */
  FUNCTION get_employees_tobe_incremented RETURN emp_table_type IS
    v_emps emp_table_type;
    i employees.employee_id%type;
  BEGIN
    v_emps  := get_employees;
    i       := v_emps.first;
    WHILE i IS NOT NULL
    LOOP
      IF v_emps(i).salary > v_min_employee_salary THEN
        v_emps.delete(i);
      END IF;
      i := v_emps.next(i);
    END LOOP;
    RETURN v_emps;
  END;

  /*
    increases the salary of the employees who has a less salary
    then the company standard
  */
  PROCEDURE increase_low_salaries AS
    v_emps emp_table_type;
    v_emp employees%rowtype;
    i employees.employee_id%type;
  BEGIN
    v_emps  := get_employees_tobe_incremented;
    i       := v_emps.first;
    WHILE i IS NOT NULL
    LOOP
      v_emp := arrange_for_min_salary(v_emps(i));
      UPDATE employees_copy SET row = v_emp WHERE employee_id = i;
      i := v_emps.next(i);
    END LOOP;
  END increase_low_salaries;

  /*
    returns the employee by arranging the salary based on the
    company standard.
  */
  FUNCTION arrange_for_min_salary(v_emp IN OUT employees%rowtype) RETURN employees%rowtype IS
  BEGIN
    v_emp.salary   := v_emp.salary + v_salary_increase_rate;
    IF v_emp.salary < v_min_employee_salary THEN
      v_emp.salary := v_min_employee_salary;
    END IF;
    RETURN v_emp;
  END;

  /*init area*/
  BEGIN
    v_salary_increase_rate := 500;
    INSERT INTO logs VALUES
      ('EMP_PKG','Package initialized!',sysdate
      );
  END EMP_PKG;