/* view ddl */
SELECT DBMS_METADATA.get_ddl ('VIEW', view_name, owner)
FROM all_views
WHERE owner   = UPPER(:OWNER)
AND view_name = DECODE(UPPER(:VIEW_NAME), 'ALL', view_name, UPPER(:VIEW_NAME));