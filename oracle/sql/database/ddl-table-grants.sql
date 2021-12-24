/* table grants */
SELECT 'GRANT ' || 
  PRIVILEGE ||
  ' ON ' ||
  TABLE_NAME ||
  ' TO ' ||
  GRANTEE ||
  ';'
FROM DBA_TAB_PRIVS
WHERE OWNER    = :OWNER
AND TABLE_NAME = :TABLE_NAME;
