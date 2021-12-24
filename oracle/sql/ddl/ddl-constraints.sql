/* ddl for table constraints (pk and uk)*/
SELECT DBMS_METADATA.get_ddl ('CONSTRAINT', constraint_name, owner)
FROM all_constraints
WHERE owner          = UPPER(:OWNER)
AND table_name       = DECODE(UPPER(:TABLE_NAME), 'ALL', table_name, UPPER(:TABLE_NAME))
AND constraint_type IN ('U', 'P');