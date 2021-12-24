SET SERVEROUTPUT ON;


/*
  table functions
  - return collections of rows: varray or nested tables
  - regular table functions: returns after completing the whole date (in memory)
  - pipelined functions return each row one by one
*/


/*create type*/
CREATE TYPE t_day AS OBJECT(v_date DATE, v_day_number INT);
/*nested table type*/
CREATE type t_days_tab IS   TABLE OF t_day;

/*create the actual function*/
CREATE OR REPLACE FUNCTION f_get_days(p_start_date DATE, p_day_number INT) RETURN t_days_tab IS
  v_days t_days_tab := t_days_tab();
BEGIN
  FOR i IN 1 .. p_day_number
  LOOP
    v_days.extend();
    v_days(i) := t_day(p_start_date + i, to_number(TO_CHAR((p_start_date + i),'DDD')));
    --v_days(i).v_date       := p_start_date + i;
    --v_days(i).v_day_number := to_number(TO_CHAR(v_days(i).v_date,'DDD'));
  END LOOP;
  RETURN v_days;
END;

/*querying from the regular table function*/
SELECT * FROM TABLE(f_get_days(sysdate,45));

/*12.2 + querying from the regular table function without the table operator*/
SELECT * FROM f_get_days(sysdate,45);

/*creating a pipelined table function*/
CREATE OR REPLACE FUNCTION f_get_days_piped(p_start_date DATE ,p_day_number INT) RETURN t_days_tab PIPELINED IS
BEGIN
  FOR i IN 1 .. p_day_number
  LOOP
    PIPE ROW (t_day(p_start_date + i, to_number(TO_CHAR(p_start_date + i,'DDD'))));
  END LOOP;
  RETURN;
END;

/*12.2 + querying from the pipelined table function*/
SELECT * FROM f_get_days_piped(sysdate,1000000);