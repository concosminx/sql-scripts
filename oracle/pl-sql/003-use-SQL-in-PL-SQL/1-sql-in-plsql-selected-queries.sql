SET SERVEROUTPUT ON;

/*
    use sql in pl/sql 
    structure:
    SELECT columns|expressions
    INTO variables|records
    FROM table|tables
    [WHERE condition];
*/
DECLARE
    v_name    VARCHAR2(50);
    v_salary  employees.salary%TYPE;
BEGIN
    SELECT first_name || ' ' || last_name, salary
    INTO v_name, v_salary
    FROM employees
    WHERE         employee_id = 130;
    dbms_output.put_line('The salary of ' || v_name || ' is : ' || v_salary);
END;