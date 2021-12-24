SET SERVEROUTPUT ON;


/* IN parameters*/
CREATE OR REPLACE PROCEDURE increase_salaries(
    v_salary_increase IN NUMBER,
    v_department_id pls_integer)
AS
  CURSOR c_emps IS SELECT * FROM employees_copy WHERE department_id = v_department_id FOR UPDATE;
  v_old_salary NUMBER;
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


/* OUT parameters*/
CREATE OR REPLACE PROCEDURE increase_salaries(
    v_salary_increase IN OUT NUMBER,
    v_department_id pls_integer,
    v_affected_employee_count OUT NUMBER)
AS
  CURSOR c_emps IS SELECT * FROM employees_copy WHERE department_id = v_department_id FOR UPDATE;
  v_old_salary NUMBER;
  v_sal_inc    NUMBER := 0;
BEGIN
  v_affected_employee_count := 0;
  FOR r_emp IN c_emps
  LOOP
    v_old_salary := r_emp.salary;
    r_emp.salary := r_emp.salary * v_salary_increase + r_emp.salary * NVL(r_emp.commission_pct,0);
    UPDATE employees_copy SET row = r_emp WHERE CURRENT OF c_emps;
    dbms_output.put_line('The salary of : '|| r_emp.employee_id || ' is increased from '||v_old_salary||' to '||r_emp.salary);
    v_affected_employee_count := v_affected_employee_count + 1;
    v_sal_inc                 := v_sal_inc                 + v_salary_increase + NVL(r_emp.commission_pct,0);
  END LOOP;
  v_salary_increase := v_sal_inc / v_affected_employee_count;
  dbms_output.put_line('Procedure finished executing!');
END;

/*print with IN parameter*/
CREATE OR REPLACE PROCEDURE PRINT(TEXT IN VARCHAR2) IS
BEGIN
  DBMS_OUTPUT.PUT_LINE(TEXT);
END;

/*using procedures*/
BEGIN
  PRINT('PROCEDURE STARTED!');
  INCREASE_SALARIES(1.15,90);
  PRINT('PROCEDURE FINISHED!');
END;

/*using procedures*/
DECLARE
  v_sal_inc       NUMBER := 1.2;
  v_aff_emp_count NUMBER;
BEGIN
  PRINT('PROCEDURE CALL STARTED!');
  INCREASE_SALARIES(v_sal_inc,80,v_aff_emp_count);
  PRINT('The affected employee count is : '|| v_aff_emp_count);
  PRINT('The average salary increase is : '|| v_sal_inc || ' percent!..');
  PRINT('PROCEDURE CALL FINISHED!');
END;