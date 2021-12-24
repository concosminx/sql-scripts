/* analyze index*/
/* http://www.dba-oracle.com/t_oracle_analyze_index.htm */
ANALYZE INDEX SCHEMA_NAME.INDEX_NAME VALIDATE STRUCTURE;

/* rebuild index */
/* https://docs.oracle.com/database/121/SQLRF/statements_1012.htm#SQLRF00805 */
ALTER INDEX SCHEMA_NAME.INDEX_NAME REBUILD;

/* rebuild index */
SELECT 'ALTER INDEX '
  || a.index_name
  || ' REBUILD;'
FROM all_indexes a
WHERE table_owner = Upper(:OWNER)
AND table_name    = DECODE(:TABLE_NAME,'ALL',a.index_name,Upper(:TABLE_NAME))
ORDER BY 1;