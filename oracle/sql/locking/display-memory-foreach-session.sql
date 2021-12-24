/* the memory each session is using*/
select sid,oracle_username,os_username,session_program,session_module,session_action, 
session_pga_memory,session_pga_memory_max,session_uga_memory,session_uga_memory_max,session_pga_memory+session_uga_memory session_total_memory from (
SELECT
    s.sid                sid
  , lpad(s.username,12)  oracle_username
  , lpad(s.osuser,9)     os_username
  , s.program            session_program
  , s.module            session_module
  , s.action            session_action
  , lpad(s.machine,8)    session_machine
  , (select ss.value from v$sesstat ss, v$statname sn
     where ss.sid = s.sid and 
           sn.statistic# = ss.statistic# and
           sn.name = 'session pga memory')        session_pga_memory
  , (select ss.value from v$sesstat ss, v$statname sn
     where ss.sid = s.sid and 
           sn.statistic# = ss.statistic# and
           sn.name = 'session pga memory max')    session_pga_memory_max
  , (select ss.value  from v$sesstat ss, v$statname sn
     where ss.sid = s.sid and 
           sn.statistic# = ss.statistic# and
           sn.name = 'session uga memory')        session_uga_memory
  , (select ss.value from v$sesstat ss, v$statname sn
     where ss.sid = s.sid and 
           sn.statistic# = ss.statistic# and
           sn.name = 'session uga memory max')   as session_uga_memory_max
FROM 
    v$session  s )
ORDER BY session_total_memory DESC;	