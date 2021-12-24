SET SERVEROUTPUT ON;

/*
  triggers
  - usages: 
    - security
    - auditing
    - data integrity (complex)
    - table logging
    - event logging
    - derived data
  
  - types
    - DML triggers (before / after / instead of)
    - compound triggers
    - non-DML triggers (DDL event triggers/ DB event triggers)
    
  - structure
  CREATE [OR REPLACE] TRIGGER trigger_name
  Timing = BEFORE | AFTER | INSTEAD OF
  Event = INSERT | UPDATE | DELETE | UPDATE OF column_list
  ON object_name
  [REFERECING OLD AS old NEW AS new]
  [FOR EACH ROW]
  [WHEN (Condition) ]
  [DECLARE variables, types, etc]
  BEGIN
    trigger_body
  [EXCEPTION]
  END;
*/

/*
  BEFORE
  - allow or reject the specified action 
  - specify default values for the columns
  - validate complex business rules
  
  
  AFTER
  - make some after check 
  - duplicate tables or add log records
  
  INSTEAD OF
  - update tables behind a view 
*/

/*fire once per insert / update statement*/
CREATE OR REPLACE TRIGGER trigger_ec_ins_upd BEFORE INSERT OR UPDATE ON employees_copy 
BEGIN dbms_output.put_line('Insert | Update occured on employees_copy table');
END;

/*runs for update/insert; it not runs for delete*/
UPDATE employees_copy SET salary = salary + 100;
DELETE FROM employees_copy;


