SET SERVEROUTPUT ON;

/*cursor attributes*/
DECLARE
  CURSOR c_emps
  IS
    SELECT * FROM employees WHERE department_id = 50;
  v_emps c_emps%rowtype;
BEGIN
  IF NOT c_emps%isopen THEN
    OPEN c_emps;
    dbms_output.put_line('hello');
  END IF;
  dbms_output.put_line(c_emps%rowcount);
  FETCH c_emps INTO v_emps;
  dbms_output.put_line(c_emps%rowcount);
  dbms_output.put_line(c_emps%rowcount);
  FETCH c_emps INTO v_emps;
  dbms_output.put_line(c_emps%rowcount);
  CLOSE c_emps;
  OPEN c_emps;
  LOOP
    FETCH c_emps INTO v_emps;
    EXIT
  WHEN c_emps%notfound OR c_emps%rowcount>5;
    dbms_output.put_line(c_emps%rowcount|| ' ' ||v_emps.first_name|| ' ' ||v_emps.last_name);
  END LOOP;
  CLOSE c_emps;
END;