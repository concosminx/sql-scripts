SET SERVEROUTPUT ON;

/*
  persistent state of packages
  - add pragma also to the body ... variable will be stored in SGA instead of PGA
  - cannot be accesed from: trigger and subprograms called from SQL statements
*/
CREATE OR REPLACE PACKAGE constants_pkg IS PRAGMA SERIALLY_REUSABLE;
  v_salary_increase CONSTANT NUMBER:= 0.04;
  CURSOR cur_emps IS SELECT * FROM employees;
  t_emps_type employees%rowtype;
  v_company_name VARCHAR2(20) := 'ORACLE';
END;

/*display package variable value*/
EXECUTE dbms_output.put_line(constants_pkg.v_salary_increase);

/*grants for second user*/
GRANT EXECUTE ON constants_pkg TO my_user;
REVOKE EXECUTE ON constants_pkg FROM my_user;

/*
  try to override constant value with 5 --> error
*/
BEGIN
  constants_pkg.v_salary_increase := 5;
  dbms_output.put_line(constants_pkg.v_salary_increase);
END;

/*changed value is not visible by other sessions*/
BEGIN
  constants_pkg.v_company_name := 'ACME';
  dbms_output.put_line(constants_pkg.v_company_name);
  --dbms_lock.sleep(20); //needs privileges for hr
END;
EXEC dbms_output.put_line(constants_pkg.v_company_name);

/*
  check if we can use a cursor in 2 blocks in the same session;
  we can if we do not close the cursor
*/
DECLARE
  v_emp employees%rowtype;
BEGIN
  OPEN constants_pkg.cur_emps;
  FETCH constants_pkg.cur_emps INTO v_emp;
  dbms_output.put_line(v_emp.first_name);
  --CLOSE constants_pkg.cur_emps;
END;

DECLARE
  v_emp employees%rowtype;
BEGIN
  FETCH constants_pkg.cur_emps INTO v_emp;
  dbms_output.put_line(v_emp.first_name);
END;