/* display session */
/* http://www.dba-oracle.com/t_v$session_user_connections.htm */
SELECT A.SPID PID,
  B.SID SID,
  B.SERIAL#,
  B.MACHINE,
  B.USERNAME,
  B.SERVER,
  B.OSUSER,
  B.PROGRAM
FROM V$SESSION B,
  V$PROCESS A
WHERE B.PADDR = A.ADDR
AND TYPE      ='USER'
ORDER BY SPID;


/* all database sessions info */
SELECT NVL(s.username, '(oracle)') AS username,
  s.osuser,
  s.sid,
  s.serial#,
  p.spid,
  s.lockwait,
  s.status,
  s.service_name,
  s.module,
  s.machine,
  s.program,
  TO_CHAR(s.logon_Time,'DD-MON-YYYY HH24:MI:SS') AS logon_time,
  s.last_call_et                                 AS last_call_et_secs
FROM v$session s,
  v$process p
WHERE s.paddr = p.addr
ORDER BY s.username,
  s.osuser;
  
/* show only active sessions */
SELECT NVL(s.username,s.program) username ,
  s.sid sid ,
  s.serial# serial ,
  s.sql_hash_value sql_hash_value ,
  SUBSTR(DECODE(w.wait_time , 0, w.event , 'ON CPU'),1,15) event ,
  w.p1 p1 ,
  w.p2 p2 ,
  w.p3 p3
FROM v$session s ,
  v$session_wait w
WHERE w.sid =s.sid
AND s.status='ACTIVE'
AND s.type  ='USER';

/* details of active sessions */
SELECT 
  inst_id instance_id,
  sid sid,
  serial# serial,
  username,
  program,
  sql_id sql_id,
  ROUND((sysdate-sql_exec_start)*24*3600,1) sql_dT,
  last_call_et call_dT,
  CASE state
    WHEN 'WAITING'
    THEN ROUND(wait_time_micro           /1000000,2)
    ELSE ROUND(time_since_last_wait_micro/1000000,2)
  END W_dT,
  DECODE(state,'WAITING',event,'CPU') event,
  service_name,
  module,
  ACTION action,
  NULLIF(row_wait_obj#,-1) obj#,
  DECODE(taddr,NULL,NULL,'NN') tr
FROM gv$session
WHERE ((state  ='WAITING' AND wait_class <> 'Idle')
OR (state <>'WAITING' AND status ='ACTIVE'))
  --and audsid != to_number(sys_context('USERENV','SESSIONID')) -- this is clean but does not work on ADG so replaced by following line
AND (machine,port) <>
  (SELECT machine,port FROM v$session WHERE sid=sys_context('USERENV','SID')
  )
ORDER BY inst_id,
  sql_id;
  
  
/* how many sessions openned by each app server */
select machine,count(*) from gv$session s group by machine;
