SET SERVEROUTPUT ON;

/*default value for parameter*/
CREATE OR REPLACE PROCEDURE PRINT(TEXT IN VARCHAR2 := 'This is the print function!.') IS
BEGIN
  DBMS_OUTPUT.PUT_LINE(TEXT);
END;

/*run with default value*/
EXEC PRINT();
/*run with null*/
EXEC PRINT(NULL);

/*default value usage*/
CREATE OR REPLACE PROCEDURE add_job(
    job_id pls_integer,
    job_title  VARCHAR2,
    min_salary NUMBER DEFAULT 1000,
    max_salary NUMBER DEFAULT NULL)
IS
BEGIN
  INSERT INTO jobs VALUES (job_id,job_title,min_salary,max_salary);
  PRINT('The job : '|| job_title || ' is inserted!..');
END;
/*standard run*/
EXEC ADD_JOB('IT_DIR','IT Director',5000,20000);
/*run with default value*/
EXEC ADD_JOB('IT_DIR2','IT Director',5000);
/*run with named notation*/
EXEC ADD_JOB('IT_DIR5','IT Director',max_salary=>10000);
/*run with named notation v2*/
EXEC ADD_JOB(job_title=>'IT Director',job_id=>'IT_DIR7',max_salary=>10000 , min_salary=>500);