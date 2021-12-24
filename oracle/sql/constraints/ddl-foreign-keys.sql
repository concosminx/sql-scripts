/* generate DDL for table foreign keys */
/* https://docs.oracle.com/en/database/oracle/oracle-database/21/arpls/DBMS_METADATA.html#GUID-F72B5833-C14E-4713-A588-6BDF4D4CBA2A */
SELECT DBMS_METADATA.get_ddl ('REF_CONSTRAINT', constraint_name, owner)
FROM all_constraints
WHERE owner         = UPPER(:OWNER)
AND table_name      = DECODE(UPPER(:TABLE_NAME), 'ALL', table_name, UPPER(:TABLE_NAME))
AND constraint_type = 'R';

/* generate DDL for foreign keys to table */
SELECT DBMS_METADATA.get_ddl ('REF_CONSTRAINT', ac1.constraint_name, ac1.owner)
FROM all_constraints ac1
JOIN all_constraints ac2
ON ac1.r_owner            = ac2.owner
AND ac1.r_constraint_name = ac2.constraint_name
WHERE ac2.owner           = UPPER(:OWNER)
AND ac2.table_name        = UPPER(:TABLE_NAME)
AND ac2.constraint_type  IN ('P','U')
AND ac1.constraint_type   = 'R';