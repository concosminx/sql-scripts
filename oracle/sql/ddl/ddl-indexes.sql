/*ddl for indexes*/
SELECT DBMS_METADATA.get_ddl ('INDEX', index_name, owner)
FROM all_indexes
WHERE owner    = UPPER(:OWNER)
AND table_name = DECODE(UPPER(:TABLE_NAME), 'ALL', table_name, UPPER(:TABLE_NAME));