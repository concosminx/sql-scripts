SET SERVEROUTPUT ON;

/* 
    variable scope
*/
BEGIN
    << hereiam >> DECLARE /*use a lable before DECLARE*/
        v_text VARCHAR2(20) := 'Out-text';
    BEGIN
        DECLARE
            v_text   VARCHAR2(20) := 'In-text';
            v_inner  VARCHAR2(30) := 'Inner Variable';
        BEGIN
            dbms_output.put_line('inner -> ' || v_text);
            dbms_output.put_line('outer -> ' || hereiam.v_text);
        END;
        dbms_output.put_line(v_text);
    END;
END hereiam;
