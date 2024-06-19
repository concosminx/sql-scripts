SELECT * FROM
(select 
 SEGMENT_NAME, 
 SEGMENT_TYPE, 
 BYTES/1024/1024/1024 GB, 
 TABLESPACE_NAME 
from 
 dba_segments
where
  owner = 'X' and
  SEGMENT_TYPE in ('TABLE')
  and (SEGMENT_NAME LIKE '%BK%' OR REGEXP_LIKE(SEGMENT_NAME, '[[:digit:]]'))
order by 3 desc ) WHERE
ROWNUM <= 100;
