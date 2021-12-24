SET SERVEROUTPUT ON;

/*
    case expressions 
    structure:
    CASE [expression || condition] 
        WHEN condition1 THEN result1
        WHEN condition2 THEN result2
        ...
        [WHEN conditionN then resultN]
        [ELSE                 result]
    END;
*/
DECLARE
    v_job_code         VARCHAR2(10) := 'CTO';
    v_salary_increase  NUMBER;
BEGIN
    v_salary_increase :=
        CASE v_job_code
            WHEN 'CTO' THEN
                0.2
            WHEN 'COO' THEN
                0.3
            ELSE 0
        END;

    dbms_output.put_line('Salary increase is : ' || v_salary_increase);
END;



/* searched case expression*/
DECLARE
    v_job_code         VARCHAR2(10) := 'IT_PROG';
    v_department       VARCHAR2(10) := 'IT';
    v_salary_increase  NUMBER;
BEGIN
    v_salary_increase :=
        CASE
            WHEN v_job_code = 'SA_MAN' THEN
                0.2
            WHEN
                v_department = 'IT'
                AND v_job_code = 'IT_PROG'
            THEN
                0.3
            ELSE 0
        END;

    dbms_output.put_line('Salary increase is : ' || v_salary_increase);
END;

/*case statement*/
DECLARE
    v_job_code         VARCHAR2(10) := 'IT_PROG';
    v_department       VARCHAR2(10) := 'IT';
    v_salary_increase  NUMBER;
BEGIN
    CASE
        WHEN v_job_code = 'SA_MAN' THEN
            v_salary_increase := 0.2;
            dbms_output.put_line('The salary increase for a Sales Manager is : ' || v_salary_increase);
        WHEN
            v_department = 'IT'
            AND v_job_code = 'IT_PROG'
        THEN
            v_salary_increase := 0.2;
            dbms_output.put_line('The salary increase for a Sales Manager is : ' || v_salary_increase);
        ELSE
            v_salary_increase := 0;
            dbms_output.put_line('The salary increase for this job code is : ' || v_salary_increase);
    END CASE;
END;