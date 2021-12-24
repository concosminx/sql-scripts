/* table uk's */
SELECT 
TC.CONSTRAINT_NAME UK_NAME, 
KCU.COLUMN_NAME COLUMN_NAME 
FROM 
INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC, 
INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU 
WHERE 
TC.CONSTRAINT_CATALOG = KCU.CONSTRAINT_CATALOG 
AND TC.CONSTRAINT_SCHEMA = KCU.CONSTRAINT_SCHEMA 
AND TC.CONSTRAINT_NAME   = KCU.CONSTRAINT_NAME 
--AND TC.CONSTRAINT_SCHEMA = 'schema_name' 
--AND TC.TABLE_NAME = 'table_name' 
AND TC.CONSTRAINT_TYPE = 'UNIQUE';