SET SERVEROUTPUT ON;

/*
  cursors with records
  example with record with 2 fields
*/
DECLARE
type r_emp
IS
  record
  (
    v_first_name employees.first_name%type,
    v_last_name employees.last_name%type);
  v_emp r_emp;
  CURSOR c_emps
  IS
    SELECT first_name,last_name FROM employees;
BEGIN
  OPEN c_emps;
  FETCH c_emps INTO v_emp;
  dbms_output.put_line(v_emp.v_first_name|| ' ' || v_emp.v_last_name);
  CLOSE c_emps;
END;



/* cursor with table rowtype */
DECLARE
  v_emp employees%rowtype;
  CURSOR c_emps
  IS
    SELECT first_name,last_name FROM employees order by first_name desc;
BEGIN
  OPEN c_emps;
  FETCH c_emps INTO v_emp.first_name,v_emp.last_name;
  dbms_output.put_line(v_emp.first_name|| ' ' || v_emp.last_name);
  CLOSE c_emps;
END;

/* cursors with cursor%rowtype to avoid extra fields */
DECLARE
  CURSOR c_emps
  IS
    SELECT first_name,last_name FROM employees;
  v_emp c_emps%rowtype;
BEGIN
  OPEN c_emps;
  FETCH c_emps INTO v_emp.first_name,v_emp.last_name;
  dbms_output.put_line(v_emp.first_name|| ' ' || v_emp.last_name);
  CLOSE c_emps;
END;