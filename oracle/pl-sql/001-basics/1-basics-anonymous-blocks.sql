SET SERVEROUTPUT ON;

/* anonymous block */
DECLARE --optional
BEGIN
NULL;
END;

/*hello world with nested block*/
BEGIN 
dbms_output.put_line('Hello world!');
    BEGIN 
        dbms_output.put_line('Hellow from nested block');
    END;
END;
