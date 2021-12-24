SET SERVEROUTPUT ON;

/*
    control strucure - if
    * structure:
    
    IF condition THEN statements;
    [ELSEIF condition THEN statements;]
    [ELSEIF condition THEN statements;]
    [ELSE statements;]
    END IF;
*/
DECLARE
    v_age NUMBER := 15;
BEGIN
    IF v_age < 14 THEN
        dbms_output.put_line('I am a kid');
    ELSIF v_age < 20 THEN
        dbms_output.put_line('I am a teeneger');
    ELSIF v_age < 31 THEN
        dbms_output.put_line('I am young');
    ELSE
        dbms_output.put_line('I am wise');
    END IF;
END;


/* nested if's*/
DECLARE
    v_age  NUMBER := 5;
    v_name    VARCHAR2(30) := 'Kitty';
BEGIN
    IF v_age < 14 OR v_name = 'Bitty' THEN
        dbms_output.put_line('Hi!');
        dbms_output.put_line('I am a kid');
    ELSIF v_age < 20 THEN
        dbms_output.put_line('I am a teenager');
    ELSIF v_age < 31 THEN
        dbms_output.put_line('I am young');
    ELSE
        IF v_age IS NULL THEN
            dbms_output.put_line('Your age is unknown..');
        ELSE
            dbms_output.put_line('I am wise');
        END IF;
    END IF;
END;


