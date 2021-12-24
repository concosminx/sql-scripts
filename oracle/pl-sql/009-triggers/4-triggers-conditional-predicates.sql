SET SERVEROUTPUT ON;

/*
  conditional predicates
  - 
*/
CREATE OR REPLACE TRIGGER before_row_emp_cpy before
  INSERT OR UPDATE OR DELETE ON employees_copy REFERENCING OLD AS O NEW AS N FOR EACH row 
BEGIN 
  dbms_output.put_line('Before Row Trigger is Fired!.');
  dbms_output.put_line('The Salary of Employee '||:o.employee_id ||' -> Before:'|| :o.salary||' After:'||:n.salary);
  IF inserting THEN
    dbms_output.put_line('An INSERT occurred on employees_copy table');
  elsif deleting THEN
    dbms_output.put_line('A DELETE occurred on employees_copy table');
  elsif updating ('salary') THEN
    dbms_output.put_line('A DELETE occurred on the salary column');
  elsif updating THEN
    dbms_output.put_line('An UPDATE occurred on employees_copy table');
  END IF;
END;