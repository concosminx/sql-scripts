SET SERVEROUTPUT ON;

/*
  use for update in cursors
  - default option is wait
  - for update of: specify column names
  
  structure:
  cursor cursor_name(parameter_name datatype, ...)
    is select_statement
    for update [of column(s)] [nowait | wait n]
*/
DECLARE
  CURSOR c_emps
  IS
    SELECT employee_id,
      first_name,
      last_name,
      department_name
    FROM employees_copy
    JOIN departments USING (department_id)
    WHERE employee_id IN (100,101,102) FOR UPDATE;
BEGIN
  /* for r_emps in c_emps loop
  update employees_copy set phone_number = 3
  where employee_id = r_emps.employee_id;
  end loop; */
  OPEN c_emps;
END;

/* wait with second */
DECLARE
  CURSOR c_emps
  IS
    SELECT employee_id,
      first_name,
      last_name,
      department_name
    FROM employees_copy
    JOIN departments USING (department_id)
    WHERE employee_id IN (100,101,102) FOR UPDATE OF employees_copy.phone_number,
      departments.location_id wait 5;
BEGIN
  /* for r_emps in c_emps loop
  update employees_copy set phone_number = 3
  where employee_id = r_emps.employee_id;
  end loop; */
  OPEN c_emps;
END;

/* nowait */
DECLARE
  CURSOR c_emps
  IS
    SELECT employee_id,
      first_name,
      last_name,
      department_name
    FROM employees_copy
    JOIN departments USING (department_id)
    WHERE employee_id IN (100,101,102) FOR UPDATE OF employees_copy.phone_number,
      departments.location_id nowait;
BEGIN
  /* for r_emps in c_emps loop
  update employees_copy set phone_number = 3
  where employee_id = r_emps.employee_id;
  end loop; */
  OPEN c_emps;
END;