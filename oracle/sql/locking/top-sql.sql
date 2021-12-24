/* top sql */
WITH sql_size AS
  (SELECT s.sql_id ,
    s.sharable_mem -- SGA
    ,
    s.persistent_mem -- PGA: bind values, other cursor specific
    ,
    s.runtime_mem -- PGA: session related
    --, s.sql_fulltext
  FROM v$sqlarea s
  ORDER BY s.sharable_mem DESC
  ),
  sql_top AS
  ( SELECT * FROM sql_size WHERE rownum <= :topcount
  )
SELECT t.sql_id ,
  s.parsing_schema_name ,
  s.version_count ,
  t.sharable_mem ,
  t.persistent_mem ,
  t.runtime_mem
FROM sql_top t
JOIN v$sqlarea s
ON s.sql_id = t.sql_id;