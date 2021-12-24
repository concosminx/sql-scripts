SET SERVEROUTPUT ON;

/*
  compound triggers
  - single trigger that allows actions for each DML trigger types
  
  structure:
  CREATE OR REPLACE TRIGGER trigger_name FOR
  dml_event_clause ON table_name
  COMPOUND TRIGGER
  -INITIALISATION SECTIONS
   * DECLARATION AREA
   * SUBPROGRAMS
    BEFORE STATEMENT IS ... END BEFORE STATEMENT;
    AFTER STATEMENT IS ... END AFTER STATEMENT;
    BEFORE EACH ROW IS ... END BEFORE EACH ROW;
    AFTER EACH ROW IS ... AFTER EACH ROW;
  END;
  
  - actions for common data / various timing
  - bulk inserts
  - avoiding mutating table errors
  
  structure:
  CREATE OR REPLACE TRIGGER compound_trigger_name
FOR [INSERT|DELETE]UPDATE [OF column] ON table
COMPOUND TRIGGER
   -- Declarative Section (optional)
   -- Variables declared here have firing-statement duration.
     
     --Executed before DML statement
     BEFORE STATEMENT IS
     BEGIN
       NULL;
     END BEFORE STATEMENT;
   
     --Executed before each row change- :NEW, :OLD are available
     BEFORE EACH ROW IS
     BEGIN
       NULL;
     END BEFORE EACH ROW;
   
     --Executed aftereach row change- :NEW, :OLD are available
     AFTER EACH ROW IS
     BEGIN
       NULL;
     END AFTER EACH ROW;
   
     --Executed after DML statement
     AFTER STATEMENT IS
     BEGIN
       NULL;
     END AFTER STATEMENT;

END compound_trigger_name;
*/
CREATE OR REPLACE TRIGGER trg_comp_emps FOR INSERT OR
  UPDATE OR DELETE ON employees_copy compound TRIGGER 
  
v_dml_type VARCHAR2(10);

before STATEMENT IS
BEGIN
  IF inserting THEN
    v_dml_type := 'INSERT';
  elsif updating THEN
    v_dml_type := 'UPDATE';
  elsif deleting THEN
    v_dml_type := 'DELETE';
  END IF;
  dbms_output.put_line('Before statement section is executed with the '||v_dml_type ||' event!.');
END before STATEMENT;

before EACH row
IS
  t NUMBER;
BEGIN
  dbms_output.put_line('Before row section is executed with the '||v_dml_type ||' event!.');
END before EACH row;

AFTER EACH row
IS
BEGIN
  dbms_output.put_line('After row section is executed with the '||v_dml_type ||' event!.');
END AFTER EACH row;

AFTER STATEMENT
IS
BEGIN
  dbms_output.put_line('After statement section is executed with the '||v_dml_type ||' event!.');
END AFTER STATEMENT;
END;


CREATE OR REPLACE TRIGGER TRG_COMP_EMPS FOR INSERT OR
  UPDATE OR
  DELETE ON EMPLOYEES_COPY COMPOUND TRIGGER TYPE T_AVG_DEPT_SALARIES IS TABLE OF EMPLOYEES_COPY.SALARY%TYPE INDEX BY PLS_INTEGER;
  AVG_DEPT_SALARIES T_AVG_DEPT_SALARIES;
  BEFORE STATEMENT
IS
BEGIN
  FOR AVG_SAL IN
  (SELECT AVG(SALARY) SALARY , NVL(DEPARTMENT_ID,999) DEPARTMENT_ID
  FROM EMPLOYEES_COPY
  GROUP BY NVL(DEPARTMENT_ID,999))
  LOOP
    AVG_DEPT_SALARIES(AVG_SAL.DEPARTMENT_ID) := AVG_SAL.SALARY;
  END LOOP;
END BEFORE STATEMENT;
AFTER EACH ROW
IS
  V_INTERVAL NUMBER := 15;
BEGIN
  IF :NEW.SALARY > AVG_DEPT_SALARIES(:NEW.DEPARTMENT_ID) + AVG_DEPT_SALARIES(:NEW.DEPARTMENT_ID)*V_INTERVAL/100 THEN
    RAISE_APPLICATION_ERROR(                        -20005,'A raise cannot be '|| V_INTERVAL|| ' percent higher than its department''s average!');
  END IF;
END AFTER EACH ROW;
AFTER STATEMENT
IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('All the changes are done successfully!');
END AFTER STATEMENT;
END;