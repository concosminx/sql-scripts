/* check status for long ops executing right now */
SELECT s.sid,
  s.serial#,
  opname,
  target,
  program,
  sofar,
  totalwork,
  units,
  elapsed_seconds,
  MESSAGE,
  start_time,
  time_remaining
FROM v$session_longops l
JOIN v$session s
ON l.sid            =s.sid
AND s.serial#       =l.serial#
WHERE time_remaining>0
ORDER BY start_time DESC;


/*Get the longops status for a specific session*/
SELECT sid ,
  MESSAGE,
  start_time,
  time_remaining
FROM v$session_longops
WHERE sid = 28
ORDER BY start_time;