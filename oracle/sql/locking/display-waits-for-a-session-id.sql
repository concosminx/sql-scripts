/* waits for a session id */
select
	s.username username,
	e.event event,
	s.sid,
	e.p1text,
	e.wait_time,
	e.seconds_in_wait,
	e.state
from v$session s, v$session_wait e
where s.username is not null
	and s.sid = e.sid
	and s.sid = &usid
order by s.username, upper(e.event);