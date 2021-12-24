/* ddl for sequence(s) */
SELECT DBMS_METADATA.get_ddl ('SEQUENCE', sequence_name, sequence_owner)
FROM all_sequences
WHERE sequence_owner = UPPER(:OWNER)
AND sequence_name    = DECODE(UPPER(:SEQUENCE_NAME), 'ALL', sequence_name, UPPER(:SEQUENCE_NAME));