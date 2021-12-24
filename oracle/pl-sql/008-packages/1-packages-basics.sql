SET SERVEROUTPUT ON;
/*
packages:
- group subprograms, types, variabiles is one container
- Storage -> loading in PGA - user vs. package content is loaded in SGA - System Global Area (shared)
(not variables, these are in PGA area)
advantages:
- modularity
- easy maintenance
- encapsulation & security
- performance PGA vs. SGA
- functionality
- overloading
2 parts:
- package specification (spec)
- package body (body)
*/
/* package specification */
CREATE OR REPLACE PACKAGE EMP
AS
  /*all definitions are public*/
  v_salary_increase_rate NUMBER := 0.057;
  CURSOR cur_emps
  IS
    SELECT * FROM employees;
  PROCEDURE increase_salaries;
  FUNCTION get_avg_sal(
      p_dept_id INT)
    RETURN NUMBER;
END EMP;
/* package body */
CREATE OR REPLACE PACKAGE BODY EMP
AS
  PROCEDURE increase_salaries
  AS
  BEGIN
    FOR r1 IN cur_emps
    LOOP
      UPDATE employees_copy SET salary = salary + salary * v_salary_increase_rate;
    END LOOP;
  END increase_salaries;
  FUNCTION get_avg_sal(
      p_dept_id INT)
    RETURN NUMBER
  AS
    v_avg_sal NUMBER := 0;
  BEGIN
    SELECT AVG(salary)
    INTO v_avg_sal
    FROM employees_copy
    WHERE department_id = p_dept_id;
    RETURN v_avg_sal;
  END get_avg_sal;
END EMP;
/*how to use package content: procdures, variables, etc.*/
EXEC EMP.increase_salaries;
/*and*/
BEGIN
  dbms_output.put_line(emp.get_avg_sal(50));
  dbms_output.put_line(emp.v_salary_increase_rate);
END;