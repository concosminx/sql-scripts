SET SERVEROUTPUT ON;

CREATE TABLE emps_high_paid AS SELECT * FROM employees WHERE 1=2;

/* using subprograms in anonymous blocks*/
DECLARE
  FUNCTION get_emp(emp_num employees.employee_id%type) RETURN employees%rowtype IS
    emp employees%rowtype;
  BEGIN
    SELECT * INTO emp FROM employees WHERE employee_id = emp_num;
    RETURN emp;
  END;
  PROCEDURE insert_high_paid_emp(emp_id employees.employee_id%type) IS
    emp employees%rowtype;
  BEGIN
    emp := get_emp(emp_id);
    INSERT INTO emps_high_paid VALUES emp;
  END;
BEGIN
  FOR r_emp IN (SELECT * FROM employees)
  LOOP
    IF r_emp.salary > 15000 THEN
      insert_high_paid_emp(r_emp.employee_id);
    END IF;
  END LOOP;
END;

/*
  scope - function inside procedure
  write local subprograms as last in declaration area
*/
DECLARE PROCEDURE insert_high_paid_emp(emp_id employees.employee_id%type) IS
  emp employees%rowtype;
  e_id NUMBER;
  FUNCTION get_emp(emp_num employees.employee_id%type) RETURN employees%rowtype IS
  BEGIN
    SELECT * INTO emp FROM employees WHERE employee_id = emp_num;
    RETURN emp;
  END;
BEGIN
  emp := get_emp(emp_id);
  INSERT INTO emps_high_paid VALUES emp;
END;
BEGIN
  FOR r_emp IN (SELECT * FROM employees)
  LOOP
    IF r_emp.salary > 15000 THEN
      insert_high_paid_emp(r_emp.employee_id);
    END IF;
  END LOOP;
END;


/*overloading .. example TO_CHAR */
PROCEDURE insert_high_paid_emp(p_emp employees%rowtype) IS
  emp employees%rowtype;
  e_id NUMBER;
  FUNCTION get_emp(emp_num employees.employee_id%type) RETURN employees%rowtype IS
  BEGIN
    SELECT * INTO emp FROM employees WHERE employee_id = emp_num;
    RETURN emp;
  END;
  FUNCTION get_emp(emp_email employees.email%type) RETURN employees%rowtype IS
  BEGIN
    SELECT * INTO emp FROM employees WHERE email = emp_email;
    RETURN emp;
  END;
  FUNCTION get_emp(f_name VARCHAR2,l_name VARCHAR2) RETURN employees%rowtype IS
  BEGIN
    SELECT * INTO emp FROM employees WHERE first_name = f_name AND last_name    = l_name;
    RETURN emp;
  END;
BEGIN
  emp := get_emp(p_emp.employee_id);
  INSERT INTO emps_high_paid VALUES emp;
  emp := get_emp(p_emp.email);
  INSERT INTO emps_high_paid VALUES emp;
  emp := get_emp(p_emp.first_name,p_emp.last_name);
  INSERT INTO emps_high_paid VALUES emp;
END;
BEGIN
  FOR r_emp IN (SELECT * FROM employees)
  LOOP
    IF r_emp.salary > 15000 THEN
      insert_high_paid_emp(r_emp);
    END IF;
  END LOOP;
END;

/* unhandled exception in function*/
CREATE OR REPLACE FUNCTION get_emp (emp_num employees.employee_id%type) RETURN employees%rowtype IS
  emp employees%rowtype;
  BEGIN
    SELECT * INTO emp FROM employees WHERE employee_id = emp_num;
    RETURN emp;
  END;

/*calling function*/
DECLARE
  v_emp employees%rowtype;
BEGIN
  dbms_output.put_line('Fetching the employee data!..');
  v_emp := get_emp(10);
  dbms_output.put_line('Some information of the employee are : ');
  dbms_output.put_line('The name of the employee is : '|| v_emp.first_name);
  dbms_output.put_line('The email of the employee is : '|| v_emp.email);
  dbms_output.put_line('The salary of the employee is : '|| v_emp.salary);
END;

/*handling the exception wihout the return clause*/
CREATE OR REPLACE FUNCTION get_emp(emp_num employees.employee_id%type) RETURN employees%rowtype IS
  emp employees%rowtype;
BEGIN
  SELECT * INTO emp FROM employees WHERE employee_id = emp_num;
  RETURN emp;
EXCEPTION
WHEN no_data_found THEN
  dbms_output.put_line('There is no employee with the id '|| emp_num);
END;

/*handling and raising the exception*/
CREATE OR REPLACE FUNCTION get_emp(emp_num employees.employee_id%type) RETURN employees%rowtype IS
  emp employees%rowtype;
BEGIN
  SELECT * INTO emp FROM employees WHERE employee_id = emp_num;
  RETURN emp;
EXCEPTION
WHEN no_data_found THEN
  dbms_output.put_line('There is no employee with the id '|| emp_num);
  raise no_data_found;
END;

/*handling all possible exception cases*/
CREATE OR REPLACE FUNCTION get_emp(emp_num employees.employee_id%type) RETURN employees%rowtype IS
  emp employees%rowtype;
BEGIN
  SELECT * INTO emp FROM employees WHERE employee_id = emp_num;
  RETURN emp;
EXCEPTION
  WHEN no_data_found THEN
    dbms_output.put_line('There is no employee with the id '|| emp_num);
    raise no_data_found;
  WHEN OTHERS THEN
    dbms_output.put_line('Something unexpected happened!.');
    RETURN NULL;
END;