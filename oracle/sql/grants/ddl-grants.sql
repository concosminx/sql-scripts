/* grant delete generator*/
SELECT 'GRANT DELETE ON "' || u.table_name || '" TO "' || UPPER(:GRANTEE) || '";'
FROM   user_tables u
WHERE  NOT EXISTS (SELECT '1'
                   FROM   all_tab_privs a
                   WHERE  a.grantee    = UPPER(:GRANTEE)
                   AND    a.privilege  = 'DELETE'
                   AND    a.table_name = u.table_name);
				   
/* grant execute generator */
SELECT 'GRANT EXECUTE ON "' || u.object_name || '" TO "' || UPPER(:GRANTEE) || '";'
FROM   user_objects u
WHERE  u.object_type IN ('PACKAGE','PROCEDURE','FUNCTION')
AND    NOT EXISTS (SELECT '1'
                   FROM   all_tab_privs a
                   WHERE  a.grantee    = UPPER(:GRANTEE)
                   AND    a.privilege  = 'EXECUTE'
                   AND    a.table_name = u.object_name);
				   
/* grant insert generator*/
SELECT 'GRANT INSERT ON "' || u.table_name || '" TO "' || UPPER(:GRANTEE) || '";'
FROM   user_tables u
WHERE  NOT EXISTS (SELECT '1'
                   FROM   all_tab_privs a
                   WHERE  a.grantee    = UPPER(:GRANTEE)
                   AND    a.privilege  = 'INSERT'
                   AND    a.table_name = u.table_name);

/* grant select */
SELECT 'GRANT SELECT ON "' || u.object_name || '" TO "' || UPPER(:GRANTEE) || '";'
FROM   user_objects u
WHERE  u.object_type IN ('TABLE','VIEW','SEQUENCE')
AND    NOT EXISTS (SELECT '1'
                   FROM   all_tab_privs a
                   WHERE  a.grantee    = UPPER(:GRANTEE)
                   AND    a.privilege  = 'SELECT'
                   AND    a.table_name = u.object_name);

/* grant update */
SELECT 'GRANT UPDATE ON "' || u.table_name || '" TO "' || UPPER(:GRANTEE) || '";'
FROM   user_tables u
WHERE  NOT EXISTS (SELECT '1'
                   FROM   all_tab_privs a
                   WHERE  a.grantee    = UPPER(:GRANTEE)
                   AND    a.privilege  = 'UPDATE'
                   AND    a.table_name = u.table_name);