SET SERVEROUTPUT ON;

/*
  raise application error in a trigger
  
*/
CREATE OR REPLACE TRIGGER before_row_emp_cpy before
  INSERT OR UPDATE OR DELETE ON employees_copy REFERENCING OLD AS O NEW AS N FOR EACH row 
BEGIN 
  dbms_output.put_line('Before Row Trigger is Fired!.');
  dbms_output.put_line('The Salary of Employee '||:o.employee_id ||' -> Before:'|| :o.salary||' After:'||:n.salary);
  IF inserting THEN
    IF :n.hire_date > sysdate THEN
      raise_application_error(-20000,'You cannot enter a future hire..');
    END IF;
  elsif deleting THEN
    raise_application_error(-20001,'You cannot delete from the employees_copy table..');
  elsif updating ('salary') THEN
    IF :n.salary > 50000 THEN
      raise_application_error(-20002,'A salary cannot be higher than 50000..');
    END IF;
  elsif updating THEN
    dbms_output.put_line('An UPDATE occurred on employees_copy table');
  END IF;
END;