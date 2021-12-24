/* index usage */
/* https://docs.oracle.com/en/database/oracle/oracle-database/21/refrn/V-OBJECT_USAGE.html#GUID-715CEE5C-E655-4454-BE9A-8FCC54BB8155 */
SELECT table_name,
  index_name,
  used,
  start_monitoring,
  end_monitoring
FROM v$object_usage
WHERE table_name = UPPER(:TABLE_NAME)
AND index_name   = DECODE(UPPER(:INDEX_NAME), 'ALL', index_name, UPPER(:INDEX_NAME));