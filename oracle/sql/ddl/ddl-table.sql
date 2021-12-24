/*ddl for table*/
SELECT DBMS_METADATA.get_ddl ('TABLE', table_name, owner)
FROM all_tables
WHERE owner    = UPPER(:OWNER)
AND table_name = DECODE(UPPER(:TABLE_NAME), 'ALL', table_name, UPPER(:TABLE_NAME));