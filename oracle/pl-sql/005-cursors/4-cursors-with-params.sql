SET SERVEROUTPUT ON;

/*cursors with parameters*/
DECLARE
  CURSOR c_emps (p_dept_id NUMBER)
  IS
    SELECT first_name,
      last_name,
      department_name
    FROM employees
    JOIN departments USING (department_id)
    WHERE department_id = p_dept_id;
  v_emps c_emps%rowtype;
BEGIN
  OPEN c_emps(20);
  FETCH c_emps INTO v_emps;
  dbms_output.put_line('The employees in department of '|| v_emps.department_name|| ' are :');
  CLOSE c_emps;
  OPEN c_emps(20);
  LOOP
    FETCH c_emps INTO v_emps;
    EXIT
  WHEN c_emps%notfound;
    dbms_output.put_line(v_emps.first_name|| ' ' ||v_emps.last_name);
  END LOOP;
  CLOSE c_emps;
END;

/* bind variables*/
DECLARE
  CURSOR c_emps (p_dept_id NUMBER)
  IS
    SELECT first_name,
      last_name,
      department_name
    FROM employees
    JOIN departments USING (department_id)
    WHERE department_id = p_dept_id;
  v_emps c_emps%rowtype;
BEGIN
  OPEN c_emps(:b_emp);
  FETCH c_emps INTO v_emps;
  dbms_output.put_line('The employees in department of '|| v_emps.department_name|| ' are :');
  CLOSE c_emps;
  OPEN c_emps(:b_emp);
  LOOP
    FETCH c_emps INTO v_emps;
    EXIT
  WHEN c_emps%notfound;
    dbms_output.put_line(v_emps.first_name|| ' ' ||v_emps.last_name);
  END LOOP;
  CLOSE c_emps;
END;


/*open cursor 2 times*/
DECLARE
  CURSOR c_emps (p_dept_id NUMBER)
  IS
    SELECT first_name,
      last_name,
      department_name
    FROM employees
    JOIN departments USING (department_id)
    WHERE department_id = p_dept_id;
  v_emps c_emps%rowtype;
BEGIN
  OPEN c_emps(:b_dept_id);
  FETCH c_emps INTO v_emps;
  dbms_output.put_line('The employees in department of '|| v_emps.department_name|| ' are :');
  CLOSE c_emps;
  OPEN c_emps(:b_dept_id);
  LOOP
    FETCH c_emps INTO v_emps;
    EXIT
  WHEN c_emps%notfound;
    dbms_output.put_line(v_emps.first_name|| ' ' ||v_emps.last_name);
  END LOOP;
  CLOSE c_emps;
  OPEN c_emps(:b_dept_id2);
  FETCH c_emps INTO v_emps;
  dbms_output.put_line('The employees in department of '|| v_emps.department_name|| ' are :');
  CLOSE c_emps;
  OPEN c_emps(:b_dept_id2);
  LOOP
    FETCH c_emps INTO v_emps;
    EXIT
  WHEN c_emps%notfound;
    dbms_output.put_line(v_emps.first_name|| ' ' ||v_emps.last_name);
  END LOOP;
  CLOSE c_emps;
END;


/* cursor with parameters - for in loops*/
DECLARE
  CURSOR c_emps (p_dept_id NUMBER)
  IS
    SELECT first_name,
      last_name,
      department_name
    FROM employees
    JOIN departments USING (department_id)
    WHERE department_id = p_dept_id;
  v_emps c_emps%rowtype;
BEGIN
  OPEN c_emps(:b_dept_id);
  FETCH c_emps INTO v_emps;
  dbms_output.put_line('The employees in department of '|| v_emps.department_name|| ' are :');
  CLOSE c_emps;
  OPEN c_emps(:b_dept_id);
  LOOP
    FETCH c_emps INTO v_emps;
    EXIT
  WHEN c_emps%notfound;
    dbms_output.put_line(v_emps.first_name|| ' ' ||v_emps.last_name);
  END LOOP;
  CLOSE c_emps;
  OPEN c_emps(:b_dept_id2);
  FETCH c_emps INTO v_emps;
  dbms_output.put_line('The employees in department of '|| v_emps.department_name|| ' are :');
  CLOSE c_emps;
  FOR i IN c_emps(:b_dept_id2)
  LOOP
    dbms_output.put_line(i.first_name|| ' ' ||i.last_name);
  END LOOP;
END;

/* cursors with multiple parameters */
DECLARE
  CURSOR c_emps (p_dept_id NUMBER , p_job_id VARCHAR2)
  IS
    SELECT first_name,
      last_name,
      job_id,
      department_name
    FROM employees
    JOIN departments USING (department_id)
    WHERE department_id = p_dept_id
    AND job_id          = p_job_id;
  v_emps c_emps%rowtype;
BEGIN
  FOR i IN c_emps(50,'ST_MAN')
  LOOP
    dbms_output.put_line(i.first_name|| ' ' ||i.last_name|| ' - ' || i.job_id);
  END LOOP;
  dbms_output.put_line(' - ');
  FOR i IN c_emps(80,'SA_MAN')
  LOOP
    dbms_output.put_line(i.first_name|| ' ' ||i.last_name|| ' - ' || i.job_id);
  END LOOP;
END;