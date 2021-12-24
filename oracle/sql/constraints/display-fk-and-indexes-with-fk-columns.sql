/* foreign keys and indexes containing the fk columns */
/* https://docs.oracle.com/en/database/oracle/oracle-database/21/refrn/ALL_IND_COLUMNS.html#GUID-2A73036B-502E-4D93-9C98-DEDE234872AA */
SELECT
  CASE
    WHEN B.TABLE_NAME IS NULL
    THEN 'UNINDEXED'
    ELSE 'INDEXED'
  END               STATUS,
  A.TABLE_NAME      TABLE_NAME,
  A.CONSTRAINT_NAME FK_NAME,
  A.FK_COLUMNS      FK_COLUMNS,
  A.R_CONSTRAINT_NAME REFERENCED_CONSTRAINT,
  B.INDEX_NAME    INDEX_NAME,
  B.INDEX_COLUMNS INDEX_COLUMNS
FROM
  (SELECT A.TABLE_NAME,
    A.CONSTRAINT_NAME,
    B.R_CONSTRAINT_NAME,
    LISTAGG(A.COLUMN_NAME, ',') WITHIN GROUP (
  ORDER BY A.POSITION) FK_COLUMNS
  FROM DBA_CONS_COLUMNS A,
    DBA_CONSTRAINTS B
  WHERE A.CONSTRAINT_NAME = B.CONSTRAINT_NAME
  AND B.CONSTRAINT_TYPE   = 'R'
  AND A.OWNER             = :OWNER
  AND A.OWNER             = B.OWNER
  AND A.TABLE_NAME = UPPER(:TABLE_NAME)
  GROUP BY A.TABLE_NAME,
    A.CONSTRAINT_NAME,
    B.R_CONSTRAINT_NAME
  ) A 
  LEFT OUTER JOIN
  (SELECT TABLE_NAME,
    INDEX_NAME,
    LISTAGG(C.COLUMN_NAME, ',') WITHIN GROUP (
  ORDER BY C.COLUMN_POSITION) INDEX_COLUMNS
  FROM DBA_IND_COLUMNS C
  WHERE C.INDEX_OWNER = :OWNER
  AND TABLE_NAME = UPPER(:TABLE_NAME)
  GROUP BY TABLE_NAME,
    INDEX_NAME
  ) B
ON 
   A.TABLE_NAME = B.TABLE_NAME
AND B.INDEX_COLUMNS LIKE A.FK_COLUMNS || '%'
ORDER BY 1 DESC, 2,3;