SET SERVEROUTPUT ON;

/* 
  mutating table error
  - row level triggers | statemet level only in case of delete cascade

  mutating table is: 
  a) a table that being modified
  b) a table that might be update with the DELETE CASCADE
  
  handle errors: 
  - store related data in another table (the data data u want to query)
  - store related data in a package (for statement ...)
  - use compound triggers (best solution!)
*/
CREATE OR REPLACE TRIGGER trg_mutating_emps before
  INSERT OR UPDATE ON employees_copy FOR EACH row 
  DECLARE 
  v_interval NUMBER := 15;
  v_avg_salary NUMBER;
  BEGIN
    SELECT AVG(salary)
    INTO v_avg_salary
    FROM employees_copy
    WHERE department_id = :new.department_id;
    IF :new.salary      > v_avg_salary*v_interval/100 THEN
      RAISE_APPLICATION_ERROR(        -20005, 'A raise cannot be '|| v_interval|| ' percent higher than its department''s average');
    END IF;
  END;

--uodate employee_copy set salary = salary + 1 WHERE EMPLOYEE_ID = 154;

/* mutating table error within a compound trigger*/
CREATE OR REPLACE TRIGGER trg_comp_emps FOR INSERT OR
  UPDATE OR
  DELETE ON employees_copy compound TRIGGER type t_avg_dept_salaries IS TABLE OF employees_copy.salary%type INDEX BY pls_integer;
  avg_dept_salaries t_avg_dept_salaries;
  before STATEMENT
IS
BEGIN
  FOR avg_sal IN
  (SELECT AVG(salary) salary,
    NVL(department_id,999) department_id
  FROM employees_copy
  GROUP BY NVL(department_id,999)
  )
  LOOP
    avg_dept_salaries(avg_sal.department_id) := avg_sal.salary;
  END LOOP;
END before STATEMENT;
AFTER EACH row
IS
  v_interval NUMBER := 15;
BEGIN
  UPDATE employees_copy SET commission_pct = commission_pct;
  IF :new.salary > avg_dept_salaries(:new.department_id)*v_interval/100 THEN
    RAISE_APPLICATION_ERROR(                            -20005, 'A raise cannot be '|| v_interval|| ' percent higher than its department''s average');
  END IF;
END AFTER EACH row;
AFTER STATEMENT
IS
BEGIN
  dbms_output.put_line('All the updates are done successfully!.');
END AFTER STATEMENT;
END;

/* getting maximum level of recursive SQL levels*/
CREATE OR REPLACE TRIGGER trg_comp_emps FOR INSERT OR
  UPDATE OR
  DELETE ON employees_copy compound TRIGGER type t_avg_dept_salaries IS TABLE OF employees_copy.salary%type INDEX BY pls_integer;
  avg_dept_salaries t_avg_dept_salaries;
  before STATEMENT
IS
BEGIN
  UPDATE employees_copy
  SET commission_pct = commission_pct
  WHERE employee_id  = 100;
  FOR avg_sal IN
  (SELECT AVG(salary) salary,
    NVL(department_id,999) department_id
  FROM employees_copy
  GROUP BY NVL(department_id,999)
  )
  LOOP
    avg_dept_salaries(avg_sal.department_id) := avg_sal.salary;
  END LOOP;
END before STATEMENT;
AFTER EACH row
IS
  v_interval NUMBER := 15;
BEGIN
  IF :new.salary > avg_dept_salaries(:new.department_id)*v_interval/100 THEN
    RAISE_APPLICATION_ERROR(                            -20005, 'A raise cannot be '|| v_interval|| ' percent higher than its department''s average');
  END IF;
END AFTER EACH row;
AFTER STATEMENT
IS
BEGIN
  UPDATE employees_copy
  SET commission_pct = commission_pct
  WHERE employee_id  = 100;
  dbms_output.put_line('All the updates are done successfully!.');
END AFTER STATEMENT;
END;