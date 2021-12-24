/* kill session */
ALTER system kill session '&1,&2' immediate;

/* kill session statements generator */
SELECT 'alter system kill session '''
  ||sid
  ||','
  ||serial#
  ||''' immediate;' SQL
FROM v$session;

/* generate commands to kill all sessions from a specific user on specific instance*/
SELECT 'alter system kill session '''
  || SID
  ||','
  || serial#
  ||''' immediate;'
FROM gv$session
WHERE username='BAD_USER'
AND inst_id   =1;


/* kill all sessions waiting for specific events by a specific user*/
SELECT 'alter system kill session '''
  || s.SID
  ||','
  || s.serial#
  ||''';'
FROM gv$session s
WHERE 1       =1
AND (event    ='latch: shared pool'
OR event      ='library cache lock')
AND s.USERNAME='DBSNMP';

/* kill all sessions executing a bad SQL */
SELECT 'alter system kill session '''
  || s.SID
  ||','
  || s.serial#
  ||''';'
FROM v$session s
WHERE s.sql_id='0vj44a7drw1rj';