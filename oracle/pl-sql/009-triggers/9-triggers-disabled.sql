SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER prevent_high_salary before
  INSERT OR UPDATE OF salary ON employees_copy FOR EACH row disable WHEN (new.salary > 50000) 
BEGIN 
  raise_application_error(-20006,'A salary cannot be higher than 50000!.');
END;

SELECT * FROM USER_OBJECTS WHERE OBJECT_TYPE = 'TRIGGER';

SELECT * FROM USER_TRIGGERS;

ALTER TRIGGER trigger_name ENABLE /*| DISABLE*/;

ALTER TABLE base_object_name ENABLE /*| DISABLE*/ ALL TRIGGERS;

ALTER TRIGGER trigger_name COMPILE;

DROP TRIGGER trigger_name;

