/*create an empty table with the same structure as employees*/
CREATE TABLE extra_employees
    AS SELECT * FROM employees WHERE 1 = 2;

SELECT * FROM extra_employees;

/*insert row from employees in extra_employees*/
DECLARE
    r_emp employees%rowtype;
BEGIN
    SELECT
        *
    INTO r_emp
    FROM
        employees
    WHERE
        employee_id = 107;

    r_emp.salary := 0;
    r_emp.commission_pct := 0;
    INSERT INTO extra_employees VALUES r_emp;
END;


/*load row from initial table, modify record, update row in second table*/
DECLARE
    r_emp employees%rowtype;
BEGIN
    SELECT
        *
    INTO r_emp
    FROM
        employees
    WHERE
        employee_id = 107;

    r_emp.salary := 10;
    r_emp.commission_pct := 0;
    
    UPDATE extra_employees
    SET
        row = r_emp
    WHERE
        employee_id = 107;
END;

DELETE FROM extra_employees;