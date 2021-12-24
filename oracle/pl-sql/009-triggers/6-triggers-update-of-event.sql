SET SERVEROUTPUT ON;

/*update of event*/
CREATE OR REPLACE TRIGGER prevent_updates_of_constant_columns before
  UPDATE OF hire_date, salary ON employees_copy FOR EACH row 
BEGIN 
  raise_application_error(-20005,'You cannot modify the hire_date and salary columns');
END;