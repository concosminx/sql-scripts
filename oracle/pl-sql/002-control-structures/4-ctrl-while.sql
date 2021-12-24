SET SERVEROUTPUT ON;

/* 
    while loops 
    structure:
    WHILE condition LOOP
        my_code
    END LOOP;
*/

DECLARE
    v_counter NUMBER(2) := 1;
BEGIN
    WHILE v_counter <= 10 LOOP
        dbms_output.put_line('Current value: ' || v_counter);
        v_counter := v_counter + 1;
    --you cand force exit from loop here
    --EXIT WHEN v_counter > 3;
    END LOOP;
END;
