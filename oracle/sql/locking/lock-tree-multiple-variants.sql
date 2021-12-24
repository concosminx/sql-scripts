/* view lock tree */
WITH sessions AS
  (SELECT
    /*+materialize*/
    sid,
    blocking_session,
    row_wait_obj#,
    sql_id
  FROM v$session
  )
SELECT LPAD(' ', LEVEL )
  || sid sid,
  object_name,
  SUBSTR(sql_text,1,40) sql_text
FROM sessions s
LEFT OUTER JOIN dba_objects
ON (object_id = row_wait_obj#)
LEFT OUTER JOIN v$sql USING (sql_id)
WHERE sid IN
  (SELECT blocking_session FROM sessions
  )
OR blocking_session           IS NOT NULL
  CONNECT BY PRIOR sid         = blocking_session
  START WITH blocking_session IS NULL;

/* view lock tree (v2) */
SELECT RPAD('+', LEVEL ,'-')
  || sid
  ||' '
  ||sess.module session_detail,
  blocker_sid,
  wait_event_text,
  object_name,
  RPAD(' ', LEVEL )
  ||sql_text sql_text
FROM v$wait_chains c
LEFT OUTER JOIN dba_objects o
ON (row_wait_obj# = object_id)
JOIN v$session sess USING (sid)
LEFT OUTER JOIN v$sql SQL
ON (sql.sql_id                = sess.sql_id
AND sql.child_number          = sess.sql_child_number)
  CONNECT BY PRIOR sid        = blocker_sid
AND PRIOR sess_serial#        = blocker_sess_serial#
AND PRIOR INSTANCE            = blocker_instance
  START WITH blocker_is_valid = 'FALSE';
  
  
/* who is blocking who */
SELECT s1.inst_id,
  s2.inst_id,
  s1.username
  || '@'
  || s1.machine
  || ' ( SID='
  || s1.sid
  || ' )  is blocking '
  || s2.username
  || '@'
  || s2.machine
  || ' ( SID='
  || s2.sid
  || ' ) ' AS blocking_status
FROM gv$lock l1,
  gv$session s1,
  gv$lock l2,
  gv$session s2
WHERE s1.sid   =l1.sid
AND s2.sid     =l2.sid
AND s1.inst_id =l1.inst_id
AND s2.inst_id =l2.inst_id
AND l1.BLOCK   =1
AND l2.request > 0
AND l1.id1     = l2.id1
AND l2.id2     = l2.id2
ORDER BY s1.inst_id;


/* blocking for more than 5 minutes */
SELECT s.SID,
  p.SPID,
  s.machine,
  s.username,
  CTIME/60       AS minutes_locking,
  do.object_name AS locked_object,
  q.sql_text
FROM v$lock l
JOIN v$session s
ON l.sid=s.sid
JOIN v$process p
ON p.addr = s.paddr
JOIN v$locked_object lo
ON l.SID = lo.SESSION_ID
JOIN dba_objects DO
ON lo.OBJECT_ID = do.OBJECT_ID
JOIN v$sqlarea q
ON s.sql_hash_value = q.hash_value
AND s.sql_address   = q.address
WHERE block         =1
AND ctime/60        >5;

/* who is blocking who, with decoding */
SELECT sn.USERNAME,
  m.SID,
  sn.SERIAL#,
  m.TYPE,
  DECODE(LMODE, 0, 'None', 1, 'Null', 2, 'Row-S (SS)', 3, 'Row-X (SX)', 4, 'Share', 5, 'S/Row-X (SSX)', 6, 'Exclusive') lock_type,
  DECODE(REQUEST, 0, 'None', 1, 'Null', 2, 'Row-S (SS)', 3, 'Row-X (SX)', 4, 'Share', 5, 'S/Row-X (SSX)', 6, 'Exclusive') lock_requested,
  m.ID1,
  m.ID2,
  t.SQL_TEXT
FROM v$session sn,
  v$lock m ,
  v$sqltext t
WHERE t.ADDRESS  = sn.SQL_ADDRESS
AND t.HASH_VALUE = sn.SQL_HASH_VALUE
AND ((sn.SID     = m.SID
AND m.REQUEST   != 0)
OR (sn.SID       = m.SID
AND m.REQUEST    = 0
AND LMODE       != 4
AND (ID1, ID2)  IN
  (SELECT s.ID1,
    s.ID2
  FROM v$lock S
  WHERE REQUEST != 0
  AND s.ID1      = m.ID1
  AND s.ID2      = m.ID2
  )))
ORDER BY sn.USERNAME,
  sn.SID,
  t.PIECE;