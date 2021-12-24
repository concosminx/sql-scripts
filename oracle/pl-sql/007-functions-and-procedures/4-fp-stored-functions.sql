SET SERVEROUTPUT ON;

/*
  functions
  - must return a value
  - similar to procedures on cretion, except its usage
  - can be used within a select statement
  - you can assign a function to a variable
  
  structure:
  CREATE [OR REPLACE] FUNCTION function_name
  [(parameter_name [IN | OUT | IN OUT] type DEFAULT value | expression
  [, ...])] RETURN return_data_type {IS | AS}
  
  
*/

CREATE OR REPLACE FUNCTION get_avg_sal(p_dept_id departments.department_id%type)
  RETURN NUMBER AS
  v_avg_sal NUMBER;
BEGIN
  SELECT AVG(salary)
  INTO v_avg_sal
  FROM employees
  WHERE department_id = p_dept_id;
  RETURN v_avg_sal;
END get_avg_sal;


/*using a function*/
DECLARE
  v_avg_salary NUMBER;
BEGIN
  v_avg_salary := get_avg_sal(50);
  dbms_output.put_line(v_avg_salary);
END;

/*functions in a select clause*/
SELECT employee_id,
  first_name,
  salary,
  department_id,
  get_avg_sal(department_id) avg_sal
FROM employees;

/*functions in group by, order by, where clauses*/
SELECT get_avg_sal(department_id)
FROM employees
WHERE salary > get_avg_sal(department_id)
GROUP BY get_avg_sal(department_id)
ORDER BY get_avg_sal(department_id);

/*dropping a function*/
DROP FUNCTION get_avg_sal;