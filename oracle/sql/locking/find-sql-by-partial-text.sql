/* find sql*/
SELECT sql_id,
  child_number,
  plan_hash_value plan_hash,
  executions execs,
  (elapsed_time/1000000)/DECODE(NVL(executions,0),0,1,executions) avg_etime,
  buffer_gets  /DECODE(NVL(executions,0),0,1,executions) avg_lio,
  sql_text
FROM v$sql s
WHERE upper(sql_text) LIKE upper(NVL('&sql_text',sql_text))
AND sql_text NOT LIKE '%from v$sql where sql_text like nvl(%'
AND sql_id LIKE NVL('&sql_id',sql_id)
ORDER BY 1,
  2,
  3;
  
  
/*Find sql_id for a specific sql snippet*/
SELECT sql_id,
  sql_text
FROM v$sql
WHERE dbms_lob.instr(sql_text, 'create INDEX',1,1) > 0;