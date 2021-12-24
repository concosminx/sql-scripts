SET SERVEROUTPUT ON;

/*
  update using where current of (need for update)
  do not use this with aggregations | joins
*/
DECLARE
  CURSOR c_emps
  IS
    SELECT * FROM employees WHERE department_id = 30 FOR UPDATE;
BEGIN
  FOR r_emps IN c_emps
  LOOP
    UPDATE employees SET salary = salary + 60 WHERE CURRENT OF c_emps;
  END LOOP;
END;


/*use rowid with join*/
DECLARE
  CURSOR c_emps
  IS
    SELECT e.rowid,
      e.salary
    FROM employees e,
      departments d
    WHERE e.department_id = d.department_id
    AND e.department_id   = 30 FOR UPDATE;
BEGIN
  FOR r_emps IN c_emps
  LOOP
    UPDATE employees SET salary = salary + 60 WHERE rowid = r_emps.rowid;
  END LOOP;
END;