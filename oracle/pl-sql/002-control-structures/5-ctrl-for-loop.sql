SET SERVEROUTPUT ON;

/*
    for loop
    structure:
    FOR counter IN [REVERSE]
        lower_bound ... upper_bound LOOP
        my_code;
    END LOOP;
*/
BEGIN
    FOR i IN REVERSE 1..3 LOOP
        dbms_output.put_line('Current value: ' || i);
    END LOOP;
END;

/*nested loops*/
DECLARE
    v_inner NUMBER := 1;
BEGIN
    FOR v_outer IN 1..5 LOOP
        dbms_output.put_line('Value in outer loop is: ' || v_outer);
        v_inner := 1;
        LOOP
            v_inner := v_inner + 1;
            dbms_output.put_line('  Value in inner loop is: ' || v_inner);
            EXIT WHEN v_inner * v_outer >= 15;
        END LOOP;
    END LOOP;
END;


/*nested loops with labels*/
DECLARE
    v_inner NUMBER := 1;
BEGIN
    << outer_loop >> FOR v_outer IN 1..5 LOOP
        dbms_output.put_line('outer: ' || v_outer);
        v_inner := 1;
        << inner_loop >> LOOP
            v_inner := v_inner + 1;
            dbms_output.put_line('  inner: ' || v_inner);
            EXIT outer_loop WHEN v_inner * v_outer >= 16;
            EXIT WHEN v_inner * v_outer >= 15;
        END LOOP inner_loop;

    END LOOP outer_loop;
END;