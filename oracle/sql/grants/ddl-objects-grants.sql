/* object grants */
select dbms_metadata.get_dependent_ddl('OBJECT_GRANT', 
  UPPER(:TABLE_NAME), 
  UPPER(:OWNER)) AS ddl from dual;				   