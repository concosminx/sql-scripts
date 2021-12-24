SET SERVEROUTPUT ON;

/*
  cursors
  types: implicit, explicit (created in code)
  
  structure:
  - declare
  - open
  - fetch
  - check 
  - close
  
declare
  cursor cursor_name is select_statement;
begin 
  open cursor_name;
  fetch cursor_name into variables, records, etc.;
  close cursor_name;
end;
*/
DECLARE
  CURSOR c_emps
  IS
    SELECT first_name,last_name FROM employees;
  v_first_name employees.first_name%type;
  v_last_name employees.last_name%type;
BEGIN
  OPEN c_emps;
  FETCH c_emps INTO v_first_name,v_last_name;
  FETCH c_emps INTO v_first_name,v_last_name;
  FETCH c_emps INTO v_first_name,v_last_name;
  dbms_output.put_line(v_first_name|| ' ' || v_last_name);
  FETCH c_emps INTO v_first_name,v_last_name;
  dbms_output.put_line(v_first_name|| ' ' || v_last_name);
  CLOSE c_emps;
END;

/*join example*/
DECLARE
  CURSOR c_emps
  IS
    SELECT first_name,
      last_name,
      department_name
    FROM employees
    JOIN departments USING (department_id)
    WHERE department_id BETWEEN 30 AND 60;
  v_first_name employees.first_name%type;
  v_last_name employees.last_name%type;
  v_department_name departments.department_name%type;
BEGIN
  OPEN c_emps;
  FETCH c_emps INTO v_first_name, v_last_name,v_department_name;
  dbms_output.put_line(v_first_name|| ' ' || v_last_name|| ' in the department of '|| v_department_name);
  CLOSE c_emps;
END;