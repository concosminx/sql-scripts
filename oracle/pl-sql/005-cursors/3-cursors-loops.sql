SET SERVEROUTPUT ON;

/*infinite basic loop*/
DECLARE
  CURSOR c_emps
  IS
    SELECT * FROM employees WHERE department_id = 30;
  v_emps c_emps%rowtype;
BEGIN
  OPEN c_emps;
  LOOP
    FETCH c_emps INTO v_emps;
    dbms_output.put_line(v_emps.employee_id|| ' ' ||v_emps.first_name|| ' ' ||v_emps.last_name);
  END LOOP;
  CLOSE c_emps;
END;


/* stop with %notfound*/
DECLARE
  CURSOR c_emps
  IS
    SELECT * FROM employees WHERE department_id = 30;
  v_emps c_emps%rowtype;
BEGIN
  OPEN c_emps;
  LOOP
    FETCH c_emps INTO v_emps;
    EXIT
  WHEN c_emps%notfound;
    dbms_output.put_line(v_emps.employee_id|| ' ' ||v_emps.first_name|| ' ' ||v_emps.last_name);
  END LOOP;
  CLOSE c_emps;
END;

/*while loop*/
DECLARE
  CURSOR c_emps
  IS
    SELECT * FROM employees WHERE department_id = 30;
  v_emps c_emps%rowtype;
BEGIN
  OPEN c_emps;
  FETCH c_emps INTO v_emps;
  WHILE c_emps%found
  LOOP
    dbms_output.put_line(v_emps.employee_id|| ' ' ||v_emps.first_name|| ' ' ||v_emps.last_name);
    FETCH c_emps INTO v_emps;
    --exit when c_emps%notfound;
  END LOOP;
  CLOSE c_emps;
END;


/*for loop*/
DECLARE
  CURSOR c_emps
  IS
    SELECT * FROM employees WHERE department_id = 30;
  v_emps c_emps%rowtype;
BEGIN
  OPEN c_emps;
  FOR i IN 1..6
  LOOP
    FETCH c_emps INTO v_emps;
    dbms_output.put_line(v_emps.employee_id|| ' ' ||v_emps.first_name|| ' ' ||v_emps.last_name);
  END LOOP;
  CLOSE c_emps;
END;


/* FOR..IN*/
DECLARE
  CURSOR c_emps
  IS
    SELECT *
    FROM employees
    WHERE department_id = 30;
BEGIN
  FOR i IN c_emps
  LOOP
    dbms_output.put_line(i.employee_id|| ' ' ||i.first_name|| ' ' ||i.last_name);
  END LOOP;
END;

/* FOR..IN with select*/
BEGIN
  FOR i IN
  (SELECT * FROM employees WHERE department_id = 30
  )
  LOOP
    dbms_output.put_line(i.employee_id|| ' ' ||i.first_name|| ' ' ||i.last_name);
  END LOOP;
END;