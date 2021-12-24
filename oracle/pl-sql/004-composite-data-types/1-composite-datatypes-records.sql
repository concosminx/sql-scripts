SET SERVEROUTPUT ON;

/*
    PL/SQL Records
    structure:
    - type type_name is record (varable_name variable_type, [varable_name variable_type]); 
    - where variable_type can be: all valid PL/SQL types, %TYPE, %ROWTYPE 
*/
DECLARE
    r_emp employees%rowtype;
BEGIN
    SELECT *
    INTO r_emp
    FROM employees WHERE employee_id = 113;
    --r_emp.salary := 2000;
    dbms_output.put_line(r_emp.first_name || ' ' || r_emp.last_name || ' earns ' || r_emp.salary || ' and hired at :' || r_emp.hire_date);
END;


/*custom record; the record is modified after loading from db*/
DECLARE
    --r_emp employees%rowtype;
    TYPE t_emp IS RECORD (
        first_name  VARCHAR2(50),
        last_name   employees.last_name%TYPE,
        salary      employees.salary%TYPE,
        hire_date   DATE
    );
    r_emp t_emp;
BEGIN
    SELECT first_name, last_name, salary, hire_date
    INTO r_emp
    FROM employees
    WHERE employee_id = 106;
    
    r_emp.first_name := 'June';
    r_emp.salary := 2034;
    r_emp.hire_date := '01-JAN-20'; 
    
    dbms_output.put_line(r_emp.first_name || ' ' || r_emp.last_name || ' earns ' || r_emp.salary || ' and hired at :' || r_emp.hire_date);
END;


/* use a record type in another record*/
DECLARE
    TYPE t_address IS RECORD (
        county     VARCHAR2(100),
        city        VARCHAR2(100)
    );
    TYPE t_emp IS RECORD (
        first_name  VARCHAR2(50),
        last_name   employees.last_name%TYPE,
        salary      employees.salary%TYPE NOT NULL DEFAULT 1000,
        hire_date   DATE,
        dept_id     employees.department_id%TYPE,
        department  departments%rowtype,
        address   t_address
    );
    r_emp t_emp;
BEGIN
    SELECT
        first_name,
        last_name,
        salary,
        hire_date,
        department_id
    INTO
        r_emp.first_name,
        r_emp.last_name,
        r_emp.salary,
        r_emp.hire_date,
        r_emp.dept_id
    FROM
        employees
    WHERE
        employee_id = '146';

    SELECT
        *
    INTO r_emp.department
    FROM
        departments
    WHERE
        department_id = r_emp.dept_id;

    r_emp.address.county := 'Arges';
    r_emp.address.city := 'Pitesti';
    dbms_output.put_line(r_emp.first_name
                         || ' '
                         || r_emp.last_name
                         || ' earns '
                         || r_emp.salary
                         || ' and hired at :'
                         || r_emp.hire_date);

    dbms_output.put_line('She is living in '
                         || r_emp.address.county
                         || ' / '
                         || r_emp.address.city);

    dbms_output.put_line('Her Department Name is : ' || r_emp.department.department_name);
END;