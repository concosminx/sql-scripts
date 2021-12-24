/*find unusable indexes*/
SELECT owner,
  index_name
FROM dba_indexes
WHERE owner     = DECODE(UPPER(:OWNER), 'ALL', owner, UPPER(:OWNER))
AND status NOT IN ('VALID', 'N/A')
ORDER BY owner,
  index_name;