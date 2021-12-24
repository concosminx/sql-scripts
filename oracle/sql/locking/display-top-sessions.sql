/* view top sessions */
SELECT NVL(a.username, '(oracle)') AS username,
  a.osuser,
  a.sid,
  a.serial#,
  c.value,
  a.lockwait,
  a.status,
  a.module,
  a.machine,
  a.program,
  TO_CHAR(a.logon_Time,'DD-MON-YYYY HH24:MI:SS') AS logon_time
FROM v$session a,
  v$sesstat c,
  v$statname d
WHERE a.sid      = c.sid
AND c.statistic# = d.statistic#
ORDER BY c.value DESC;