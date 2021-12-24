SET SERVEROUTPUT ON;

/* 
    variables 
    * types
        - scalar, reference, large objects, composite (collections, records)
    * naming rules
        - must start with a letter
        - cat contain some special characters (like _#$)
        - max 30 characters
        - cannot be Oracle reserved words
    * naming conventions (example):
        - VARIABLE: v_variable_name 
        - CURSOR: cur_cursor_name
        - PROCEDURE: p_procedure_name
        - FUNCTION: f_function_name
        - EXCEPTION: e_exception_name
        - BIND VARIABLE: b_bind_name
*/
DECLARE
    v VARCHAR2(20) := 'Hello, ' || 'Kitty!';
BEGIN
    dbms_output.put_line(v);
END;

/*
    declaring variables
    * general rule:
    - Name [CONSTANT] datatype [NOT NULL] [:= DEFAULT value|expression];
*/
DECLARE
    v_text     VARCHAR2(35) NOT NULL DEFAULT 'Hi!';
    v_number   NUMBER := 35;
    v_number2  NUMBER(2) := 35.42;
    v_number3  NUMBER(10, 2) := 35.42;
    v_number4  PLS_INTEGER := 35;
    v_number5  BINARY_FLOAT := 35.42;
    v_date     DATE := '15-DEC-21 15:04:32';
    v_date2    TIMESTAMP := systimestamp;
    v_date3    TIMESTAMP(9) WITH TIME ZONE := systimestamp;
    v_date4    INTERVAL DAY ( 4 ) TO SECOND ( 3 ) := '24 02:05:21.012 ';
    v_date5    INTERVAL YEAR TO MONTH := '11-3';
BEGIN
    v_text := 'PL/SQL' || 'Rules!';
    dbms_output.put_line(v_text);
    dbms_output.put_line(v_number);
    dbms_output.put_line(v_number2);
    dbms_output.put_line(v_number3);
    dbms_output.put_line(v_number4);
    dbms_output.put_line(v_number5);
    dbms_output.put_line(v_date);
    dbms_output.put_line(v_date2);
    dbms_output.put_line(v_date3);
    dbms_output.put_line(v_date4);
    dbms_output.put_line(v_date5);
END;


/* boolean variable*/
DECLARE
    v_bool BOOLEAN := true;
BEGIN
    NULL;
    --dbms_output.put_line(v_bool);
END;