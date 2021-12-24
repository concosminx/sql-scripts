SET SERVEROUTPUT ON;

/*
    basic loops
    structure:
    LOOP 
        my_code
        EXIT [WHEN condition]
    END LOOP;
*/
DECLARE
    v_counter NUMBER(2) := 1;
BEGIN
    LOOP
        IF v_counter MOD 2 = 0 THEN
            dbms_output.put_line('Even : ' || v_counter);
        ELSE 
            dbms_output.put_line('Odd : ' || v_counter);
        END IF;
        v_counter := v_counter + 1;
        
        --if v_counter = 10 then
        --  dbms_output.put_line('Now I reached : '|| v_counter);
        --  exit;
        --end if;
        EXIT WHEN v_counter > 10;
    END LOOP;
END;