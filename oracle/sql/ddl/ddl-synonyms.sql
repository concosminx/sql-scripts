/* ddl for synonym(s) */
SELECT DBMS_METADATA.get_ddl ('SYNONYM', synonym_name, owner)
FROM all_synonyms
WHERE table_owner = UPPER(:OWNER)
AND synonym_name  = DECODE(UPPER(:SYNONYM_NAME), 'ALL', synonym_name, UPPER(:SYNONYM_NAME));
