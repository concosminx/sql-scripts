SET SERVEROUTPUT ON;

/*
    nested tables
    - we can delete any values (oposite to varrays)
    - not stored consecutively
    - are unbounded (no max size specified)
    
    structure:
    type type_name as table of value_data_type [NOT NULL];

    create type at schema level:
    create or replace type type_name as table of value_data_type [NOT NULL];
*/
DECLARE
    TYPE e_list IS TABLE OF VARCHAR2(50);
    emps e_list;
BEGIN
    emps := e_list('Luigi', 'Mario', 'Jim');
    FOR i IN 1..emps.count() LOOP
        dbms_output.put_line(emps(i));
    END LOOP;
END;

/* adding a new value to existing nested table*/
DECLARE
    TYPE e_list IS TABLE OF VARCHAR2(50);
    emps e_list;
BEGIN
    emps := e_list('Jim', 'Jimbo', 'John');
    emps.extend;
    emps(4) := 'Bill';
    FOR i IN 1..emps.count() LOOP
        dbms_output.put_line(emps(i));
    END LOOP;
END;

/*populate nested table from database table*/
DECLARE
    TYPE e_list IS TABLE OF employees.first_name%TYPE;
    emps  e_list := e_list();
    idx   PLS_INTEGER := 1;
BEGIN
    FOR x IN 100..110 LOOP
        emps.extend;
        SELECT first_name
        INTO emps(idx)
        FROM employees
        WHERE employee_id = x;
        
        idx := idx + 1;
    END LOOP;
    FOR i IN 1..emps.count() LOOP
        dbms_output.put_line(emps(i));
    END LOOP;
END;


/*delete element*/
DECLARE
    TYPE e_list IS TABLE OF employees.first_name%TYPE;
    emps  e_list := e_list();
    idx   PLS_INTEGER := 1;
BEGIN
    FOR x IN 100..110 LOOP
        emps.extend;
        SELECT first_name
        INTO emps(idx)
        FROM employees
        WHERE employee_id = x;

        idx := idx + 1;
    END LOOP;

    emps.DELETE(3);
    FOR i IN 1..emps.count() LOOP
        IF emps.EXISTS(i) THEN --no data found (if we are not using the exists() function
            dbms_output.put_line(emps(i));
        END IF;
    END LOOP;
END;