/* all indexes and index columns */
SELECT C.INDEX_NAME,
  I.UNIQUENESS,
  C.COLUMN_NAME
FROM USER_INDEXES I,
  USER_IND_COLUMNS C
WHERE I.INDEX_NAME = C.INDEX_NAME
AND I.TABLE_NAME   = UPPER(:TABLE_NAME)
ORDER BY C.INDEX_NAME,
  C.COLUMN_POSITION;

/* show indexes */
SELECT table_owner,
  table_name,
  owner AS index_owner,
  index_name,
  tablespace_name,
  num_rows,
  status,
  index_type
FROM dba_indexes
WHERE table_owner = UPPER(:OWNER)
AND table_name    = DECODE(UPPER(:TABLE_NAME), 'ALL', table_name, UPPER(:TABLE_NAME))
ORDER BY table_owner,
  table_name,
  index_owner,
  index_name;