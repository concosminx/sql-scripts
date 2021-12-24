/* view locked objects */
SELECT lo.session_id AS sid,
  s.serial#,
  NVL(lo.oracle_username, '(oracle)') AS username,
  o.owner                             AS object_owner,
  o.object_name,
  DECODE(lo.locked_mode, 0, 'None', 1, 'Null (NULL)', 2, 'Row-S (SS)', 3, 'Row-X (SX)', 4, 'Share (S)', 5, 'S/Row-X (SSX)', 6, 'Exclusive (X)', lo.locked_mode) locked_mode,
  lo.os_user_name
FROM v$locked_object lo
JOIN dba_objects o
ON o.object_id = lo.object_id
JOIN v$session s
ON lo.session_id = s.sid
ORDER BY 1,
  2,
  3,
  4;
  
  
/* locked objects */
SELECT a.type,
  SUBSTR(a.owner,1,30) owner,
  a.sid,
  SUBSTR(a.object,1,30) object
FROM v$access a
WHERE a.owner NOT IN ('SYS','PUBLIC')
ORDER BY 1,2,3,4;


/* blocked objects */
SELECT owner,
  object_name,
  object_type
FROM dba_objects
WHERE object_id IN
  (SELECT object_id
  FROM v$locked_object
  WHERE session_id=271
  AND locked_mode =3
  );