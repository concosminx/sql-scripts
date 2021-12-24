SET SERVEROUTPUT ON;

/*create sequence for pk*/
CREATE sequence seq_dep_cpy start with 280 increment BY 10;

/*create a trigger to populate the primary key*/
CREATE OR REPLACE TRIGGER trg_before_insert_dept_cpy before
  INSERT ON departments_copy FOR EACH row 
BEGIN
  --select seq_dep_cpy.nextval into :new.department_id from dual;
  :new.department_id := seq_dep_cpy.nextval;
END;

/*insert example*/
INSERT INTO departments_copy (department_name,manager_id,location_id) VALUES ('Security',200,1700);


/* audit table creation*/
CREATE TABLE log_departments_copy
  (
    log_user        VARCHAR2(30),
    log_date        DATE,
    dml_type        VARCHAR2(10),
    department_id   NUMBER(4),
    old_department_name VARCHAR2(30),
    new_department_name VARCHAR2(30),
    old_manager_id     NUMBER(6),
    new_manager_id     NUMBER(6),
    old_location_id   NUMBER(4),
    new_location_id   NUMBER(4)
  );

/*audit log trigger*/
CREATE OR REPLACE TRIGGER trg_department_copy_log AFTER
  INSERT OR UPDATE OR DELETE ON departments_copy FOR EACH row 
DECLARE 
  v_dml_type VARCHAR2(10);
BEGIN
  IF inserting THEN
    v_dml_type := 'INSERT';
  elsif updating THEN
    v_dml_type := 'UPDATE';
  elsif deleting THEN
    v_dml_type := 'DELETE';
  END IF;
  INSERT
  INTO log_departments_copy VALUES
    (USER,
      sysdate,
      v_dml_type,
      :old.department_id,
      :new.department_id,
      :old.department_name,
      :new.department_name,
      :old.manager_id,
      :new.manager_id,
      :old.location_id,
      :new.location_id
    );
END;

/*sql codes used*/
INSERT INTO departments_copy(department_name,manager_id,location_id) VALUES ('Cyber Security',100,1700);
SELECT * FROM LOG_DEPARTMENTS_COPY;
UPDATE departments_copy SET manager_id = 200 WHERE DEPARTMENT_NAME = 'Cyber Security';
DELETE FROM departments_copy WHERE DEPARTMENT_NAME = 'Cyber Security';