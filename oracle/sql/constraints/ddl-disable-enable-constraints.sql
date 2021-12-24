/* generate enable/disable all constraints script*/
SELECT 
 'ALTER TABLE "'
  || a.table_name
  || '" DISABLE CONSTRAINT "'
  || a.constraint_name
  || '";' dsb_constraint_script,
  'ALTER TABLE "'
  || a.table_name
  || '" ENABLE CONSTRAINT "'
  || a.constraint_name
  || '";' enbl_constraint_script
FROM all_constraints a
WHERE a.constraint_type IN ('C', 'R', 'P')
AND a.owner              = UPPER(:OWNER)
AND a.table_name         = DECODE(UPPER(:TABLE_NAME),'ALL',a.table_name,UPPER(:TABLE_NAME));