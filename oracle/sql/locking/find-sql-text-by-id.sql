/* sql text for sql_id */
SELECT inst_id,
  sql_fulltext
FROM gv$sqlstats
WHERE sql_id=:sql_id
ORDER BY inst_id;