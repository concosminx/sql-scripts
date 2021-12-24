/* disabled constraints */
/* https://docs.oracle.com/en/database/oracle/oracle-database/21/refrn/ALL_CONSTRAINTS.html#GUID-9C96DA92-CFE0-4A3F-9061-C5ED17B43EFE */
SELECT owner,
  table_name ,
  constraint_name,
  DECODE(constraint_type, 'C','CHECK', 'P','PRIMARY', 'U','UNIQUE', 'R','REFERENCE', 'V','VIEW/CHK', '!ERR!' ) constype
FROM dba_constraints /*see also ALL_CONSTRAINTS and USER_CONSTRAINTS */
WHERE owner LIKE upper(:OWNER)
AND status = 'DISABLED'
ORDER BY table_name,
  constraint_name;