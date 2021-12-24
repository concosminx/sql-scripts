SET SERVEROUTPUT ON;

/*
  qualifiers
  - only in row table triggers
  - old value not available on insert | new value not available on delete
*/
ALTER TABLE employees_copy DISABLE ALL TRIGGERS;

CREATE OR REPLACE TRIGGER before_row_emp_cpy before
  INSERT OR UPDATE OR DELETE ON employees_copy REFERENCING OLD AS O NEW AS N FOR EACH row 
BEGIN 
  dbms_output.put_line('Before Row Trigger is Fired!.');
  dbms_output.put_line('The Salary of Employee '||:o.employee_id ||' -> Before:'|| :o.salary||' After:'||:n.salary);
END;

UPDATE employees_copy SET salary = salary + 1 WHERE DEPARTMENT_ID = 30;