SET SERVEROUTPUT ON;

/*create a sequence*/
CREATE SEQUENCE employee_id_seq START WITH 207 INCREMENT BY 1;

/*
    before 11g
    SELECT sequence_name.nextval|currval INTO variable|column
    FROM table_name|dual;
*/
BEGIN
    FOR i IN 1..10 LOOP
        INSERT INTO employees_copy (
            employee_id,
            first_name,
            last_name,
            email,
            hire_date,
            job_id,
            salary
        ) VALUES (
            employee_id_seq.NEXTVAL,
            'employee#' || employee_id_seq.NEXTVAL,
            'temp_emp',
            'abc@xmail.com',
            sysdate,
            'IT_PROG',
            1000
        );

    END LOOP;
END;


/*use sequence with select into*/
DECLARE
    v_seq_num NUMBER;
BEGIN
    SELECT
        employee_id_seq.NEXTVAL
    INTO v_seq_num
    FROM
        dual;

    dbms_output.put_line(v_seq_num);
END;


/* assign directly 11g+*/
DECLARE
    v_seq_num NUMBER;
BEGIN
    v_seq_num := employee_id_seq.nextval;
    dbms_output.put_line(v_seq_num);
END;

/*use directly in output*/
BEGIN
    dbms_output.put_line(employee_id_seq.nextval);
END;

/* or */
BEGIN
    dbms_output.put_line(employee_id_seq.currval);
END;