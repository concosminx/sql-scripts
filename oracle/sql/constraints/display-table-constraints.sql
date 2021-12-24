/* all table constraints */
SELECT c.constraint_name "Constraint",
  DECODE(c.constraint_type,'P','Primary Key', 'U','Unique Key', 'C','Check', 'R','Foreign Key', c.constraint_type) "Type",
  c.r_owner "Ref Table",
  c.r_constraint_name "Ref Constraint"
FROM all_constraints c
WHERE c.table_name = Upper(:TABLE_NAME)
AND c.owner        = Upper(:OWNER);