SET SERVEROUTPUT ON;
SET AUTOPRINT ON;

/*
    bind variables
    - created in the host environment
    - scope is whole worksheet
*/

VARIABLE var_text VARCHAR2(30);
-- cannot create with type NUMBER(5,2)
VARIABLE var_number NUMBER;
-- cannot create this type of bind variable
-- VARIABLE var_date DATE; 

DECLARE
    v_text VARCHAR2(30);
BEGIN
    :var_text := 'Hello Kitty';
    :var_number := 20;
    v_text := :var_text;
    dbms_output.put_line(v_text);
    dbms_output.put_line(:var_text);
END;

PRINT var_text;


/* define and instantiate a variable*/
VARIABLE var_sql NUMBER;
BEGIN
    :var_sql := 100;
END;

/* use the variable in statements */
SELECT * FROM employees WHERE employee_id = :var_sql;