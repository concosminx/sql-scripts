/* ddl triggers */
SELECT DBMS_METADATA.get_ddl ('TRIGGER', trigger_name, owner)
FROM all_triggers
WHERE table_owner = UPPER(:OWNER)
AND table_name    = DECODE(UPPER(:TABLE_NAME), 'ALL', table_name, UPPER(:TABLE_NAME));