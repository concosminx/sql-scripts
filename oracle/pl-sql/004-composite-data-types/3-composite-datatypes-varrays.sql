SET SERVEROUTPUT ON;


/*
    varrays
    - bounded type
    - index start from 1
    - null by default
*/
DECLARE
    TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
    employees e_list;
BEGIN
    employees := e_list('Leonardo', 'Raphael', 'Donatello', 'Michelangelo', 'Splinter');
    FOR i IN 1..5 LOOP
        dbms_output.put_line(employees(i));
    END LOOP;
END;

/* Error: Subscript outside of limit */
DECLARE
    TYPE e_list IS VARRAY(4) OF VARCHAR2(50);
    employees e_list;
BEGIN
    employees := e_list('Leonardo', 'Raphael', 'Donatello', 'Michelangelo', 'Splinter');
    FOR i IN 1..5 LOOP
        dbms_output.put_line(employees(i));
    END LOOP;
END;


/*Error: Subscript beyond count*/
DECLARE
    TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
    employees e_list;
BEGIN
    employees := e_list('Leonardo', 'Raphael', 'Donatello', 'Michelangelo');
    FOR i IN 1..5 LOOP
        dbms_output.put_line(employees(i));
    END LOOP;
END;

/* iterate using count() */
DECLARE
    TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
    employees e_list;
BEGIN
    employees := e_list('Leonardo', 'Raphael', 'Donatello', 'Michelangelo');
    FOR i IN 1..employees.count() LOOP
        dbms_output.put_line(employees(i));
    END LOOP;
END;


/*iterate using first() and last()*/
DECLARE
    TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
    employees e_list;
BEGIN
    employees := e_list('Leonardo', 'Raphael', 'Donatello', 'Michelangelo');
    FOR i IN employees.first()..employees.last() LOOP
        dbms_output.put_line(employees(i));
    END LOOP;
END;


/*check if an element exists*/
DECLARE
    TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
    employees e_list;
BEGIN
    employees := e_list('Leonardo', 'Raphael', 'Donatello', 'Michelangelo');
    FOR i IN 1..5 LOOP
        IF employees.EXISTS(i) THEN
            dbms_output.put_line(employees(i));
        END IF;
    END LOOP;
END;

/*diplay array limit*/
DECLARE
    TYPE e_list IS VARRAY(5) OF VARCHAR2(50);
    employees e_list;
BEGIN
    employees := e_list('Leonardo', 'Raphael', 'Donatello', 'Michelangelo');
    dbms_output.put_line(employees.limit());
END;


/*extend and insert in array */
DECLARE
    TYPE e_list IS VARRAY(15) OF VARCHAR2(50);
    employees  e_list := e_list();
    idx        NUMBER := 1;
BEGIN
    FOR i IN 100..110 LOOP
        employees.extend;
        SELECT first_name
        INTO employees(idx)
        FROM employees
        WHERE employee_id = i;

        idx := idx + 1;
    END LOOP;
    
    FOR x IN 1..employees.count() LOOP
        dbms_output.put_line(employees(x));
    END LOOP;
END;


/*create type at schema level*/
CREATE TYPE e_list IS VARRAY(15) OF VARCHAR2(50);

/*create|replace type at schema level*/
CREATE OR REPLACE TYPE e_list AS VARRAY(20) OF VARCHAR2(100);

DECLARE
    employees  e_list := e_list();
    idx        NUMBER := 1;
BEGIN
    FOR i IN 100..110 LOOP
        employees.extend;
        SELECT first_name
        INTO employees(idx)
        FROM employees
        WHERE employee_id = i;

        idx := idx + 1;
    END LOOP;

    FOR x IN 1..employees.count() LOOP
        dbms_output.put_line(employees(x));
    END LOOP;
END;

/*drop type from schema*/
DROP TYPE e_list;