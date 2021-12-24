SET SERVEROUTPUT ON;

/*before statement*/
CREATE OR REPLACE TRIGGER before_statement_emp_cpy before
  INSERT OR UPDATE ON employees_copy 
BEGIN 
  dbms_output.put_line('Before Statement Trigger is Fired!.');
END;

/*after statement*/
CREATE OR REPLACE TRIGGER after_statement_emp_cpy AFTER
  INSERT OR UPDATE ON employees_copy 
BEGIN 
  dbms_output.put_line('After Statement Trigger is Fired!.');
END;

/*before row*/
CREATE OR REPLACE TRIGGER before_row_emp_cpy before
  INSERT OR UPDATE ON employees_copy FOR EACH row 
BEGIN 
  dbms_output.put_line('Before Row Trigger is Fired!.');
END;

/*after row*/
CREATE OR REPLACE TRIGGER after_row_emp_cpy AFTER
  INSERT OR UPDATE ON employees_copy FOR EACH row 
BEGIN 
  dbms_output.put_line('After Row Trigger is Fired!.');
END;

/*sqls*/
UPDATE employees_copy SET salary = salary + 100 WHERE employee_id = 100;
UPDATE employees_copy SET salary = salary + 100 WHERE employee_id = 99;
UPDATE employees_copy SET salary = salary + 100 WHERE department_id = 30;