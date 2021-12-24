/* 
 find all sessions that are blocked and which session is blocking them
 x
 find what the blocking session is doing
*/
SELECT sid,
  blocking_session,
  username,
  sql_id,
  event,
  machine,
  osuser,
  program
FROM v$session
WHERE blocking_session > 0;

SELECT sid,
  blocking_session,
  username,
  sql_id,
  event,
  machine,
  osuser,
  program
FROM v$session
WHERE sid=491;


/* blocked sessions and who is blocking them */
SELECT sid,
  blocking_session,
  username,
  sql_id,
  event,
  machine,
  osuser,
  program,
  last_call_et
FROM v$session
WHERE blocking_session > 0;


/* what the blocking session is doing */
SELECT sid,
  blocking_session,
  username,
  sql_id,
  event,
  state,
  machine,
  osuser,
  program,
  last_call_et
FROM v$session
WHERE sid=746 ;