/* all foreign keys -> to table pk or uk */
SELECT AC.TABLE_NAME,
  AC.CONSTRAINT_NAME,
  AC.STATUS,
  AC.OWNER,
  LISTAGG(ACC.COLUMN_NAME, ',') WITHIN GROUP (
ORDER BY ACC.POSITION) FK_COLUMNS
FROM ALL_CONSTRAINTS AC,
  ALL_CONS_COLUMNS ACC
WHERE AC.R_OWNER          = :OWNER
AND AC.CONSTRAINT_TYPE    = 'R'
AND AC.R_CONSTRAINT_NAME IN
  (SELECT CONSTRAINT_NAME
  FROM ALL_CONSTRAINTS
  WHERE CONSTRAINT_TYPE IN ('P', 'U')
  AND TABLE_NAME         = UPPER(:TABLE_NAME)
  AND OWNER              = UPPER(:OWNER)
  )
AND ACC.TABLE_NAME      = AC.TABLE_NAME
AND ACC.CONSTRAINT_NAME = AC.CONSTRAINT_NAME
GROUP BY AC.TABLE_NAME,
  AC.CONSTRAINT_NAME,
  AC.STATUS,
  AC.OWNER
ORDER BY AC.TABLE_NAME,
  AC.CONSTRAINT_NAME;