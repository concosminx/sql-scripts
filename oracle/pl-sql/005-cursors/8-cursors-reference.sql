SET SERVEROUTPUT ON;

/*
  reference cursors (ref cursors)
  - cursors are pointers
  - you cand use a cursor for multiple queries
  - we cannot (assing null values, use in table-view create codes, store in collections, compare)
  - types (strong (restrictive) and weak (nonrestrictive)
  
  structure:
  type cursor_type_name is ref cursor [return return_type];
  open cursor_variable_name for query;
*/
DECLARE
  type t_emps IS ref CURSOR RETURN employees%rowtype;
  rc_emps t_emps;
  r_emps employees%rowtype;
BEGIN
  OPEN rc_emps FOR SELECT * FROM employees;
  LOOP
    FETCH rc_emps INTO r_emps;
  EXIT WHEN rc_emps%notfound;
  dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name);
END LOOP;
CLOSE rc_emps;
END;


/*2 queries*/
DECLARE
  type t_emps IS ref CURSOR RETURN employees%rowtype;
    rc_emps t_emps;
    r_emps employees%rowtype;
BEGIN
  OPEN rc_emps FOR SELECT * FROM retired_employees;
  LOOP
    FETCH rc_emps INTO r_emps;
    EXIT WHEN rc_emps%notfound;
    dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name);
  END LOOP;
  CLOSE rc_emps;

  dbms_output.put_line('--------------');
  OPEN rc_emps FOR SELECT * FROM employees WHERE job_id = 'IT_PROG';
  LOOP
    FETCH rc_emps INTO r_emps;
    EXIT WHEN rc_emps%notfound;
  dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name);
  END LOOP;
  CLOSE rc_emps;
END;


/* using with %type */
DECLARE
  r_emps employees%rowtype;
  type t_emps IS ref CURSOR RETURN r_emps%type;
  rc_emps t_emps;
BEGIN
NULL;
END;


/* manually declared record type with cursors*/
DECLARE
  type ty_emps IS record
  (e_id NUMBER,
   first_name employees.last_name%type,
   last_name employees.last_name%type,
   department_name departments.department_name%type
   );
  r_emps ty_emps;
  type t_emps IS ref CURSOR RETURN ty_emps;
  rc_emps t_emps;
BEGIN
  OPEN rc_emps FOR SELECT employee_id, first_name, last_name, department_name FROM employees JOIN departments USING (department_id);
  LOOP
    FETCH rc_emps INTO r_emps;
    EXIT WHEN rc_emps%notfound;
    dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name|| ' is at the department of : '|| r_emps.department_name );
  END LOOP;
  CLOSE rc_emps;
END;


/* weak ref cursors with dynamic query*/
DECLARE
  type ty_emps IS record(
    e_id NUMBER,
    first_name employees.last_name%type,
    last_name employees.last_name%type,
    department_name departments.department_name%type);
  r_emps ty_emps;
  type t_emps IS ref CURSOR;
  rc_emps t_emps;
  q VARCHAR2(200);
BEGIN
    q := 'select employee_id,first_name,last_name,department_name                       
from employees join departments using (department_id)';
    OPEN rc_emps FOR q;
    LOOP
      FETCH rc_emps INTO r_emps;
    EXIT
  WHEN rc_emps%notfound;
    dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name|| ' is at the department of : '|| r_emps.department_name );
  END LOOP;
  CLOSE rc_emps;
END;


/* bind variables*/
DECLARE
  type ty_emps IS record (
    e_id NUMBER,
    first_name employees.last_name%type,
    last_name employees.last_name%type,
    department_name departments.department_name%type);
  r_emps ty_emps;
  type t_emps IS ref CURSOR;
  rc_emps t_emps;
  r_depts departments%rowtype;
  q VARCHAR2(200);
BEGIN
  q := 'select employee_id,first_name,last_name,department_name                       
  from employees join departments using (department_id)                      
  where department_id = :t';
  OPEN rc_emps FOR q USING '50';
  LOOP
    FETCH rc_emps INTO r_emps;
    EXIT WHEN rc_emps%notfound;
    dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name|| ' is at the department of : '|| r_emps.department_name );
  END LOOP;
  CLOSE rc_emps;
  OPEN rc_emps FOR SELECT * FROM departments;
  LOOP
    FETCH rc_emps INTO r_depts;
    EXIT WHEN rc_emps%notfound;
    dbms_output.put_line(r_depts.department_id|| ' ' || r_depts.department_name);
  END LOOP;
  CLOSE rc_emps;
END;

/* sys_refcursor*/
DECLARE
  type ty_emps IS record
  (
    e_id NUMBER,
    first_name employees.last_name%type,
    last_name employees.last_name%type,
    department_name departments.department_name%type);
  r_emps ty_emps;
  rc_emps sys_refcursor;
  r_depts departments%rowtype;
  q VARCHAR2(200);
BEGIN
  q := 'select employee_id,first_name,last_name,department_name                       
  from employees join departments using (department_id)                      
  where department_id = :t';
  OPEN rc_emps FOR q USING '50';
  LOOP
    FETCH rc_emps INTO r_emps;
    EXIT WHEN rc_emps%notfound;
    dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name|| ' is at the department of : '|| r_emps.department_name );
  END LOOP;
  CLOSE rc_emps;
  OPEN rc_emps FOR SELECT * FROM departments;
  LOOP
    FETCH rc_emps INTO r_depts;
    EXIT WHEN rc_emps%notfound;
    dbms_output.put_line(r_depts.department_id|| ' ' || r_depts.department_name);
  END LOOP;
  CLOSE rc_emps;
END;