SET SERVEROUTPUT ON;

/*using when*/
CREATE OR REPLACE TRIGGER prevent_high_salary before
  UPDATE OF salary ON employees_copy FOR EACH row 
  WHEN (new.salary > 50000) 
BEGIN 
  raise_application_error(-20006,'A salary cannot be higher than 50000!.');
END;


