/* gather schema statistics */
/* https://docs.oracle.com/en/database/oracle/oracle-database/21/arpls/DBMS_STATS.html#GUID-3B3AE30F-1A34-4BFE-A326-15048F7E904F */
EXEC DBMS_STATS.GATHER_SCHEMA_STATS(ownname=> 'SCHEMA_NAME', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, cascade=> TRUE, degree => DBMS_STATS.AUTO_DEGREE);

/* gather table statistics */
/* https://docs.oracle.com/en/database/oracle/oracle-database/21/arpls/DBMS_STATS.html#GUID-CA6A56B9-0540-45E9-B1D7-D78769B7714C */
EXEC DBMS_STATS.GATHER_TABLE_STATS (ownname => 'SCHEMA_NAME', tabname => 'TABLE_NAME', estimate_percent => 100, cascade => true);

/* gather index statistics */
/* https://docs.oracle.com/en/database/oracle/oracle-database/21/arpls/DBMS_STATS.html#GUID-9D01B268-734F-45C0-9620-1478F5A1B261 */
EXEC DBMS_STATS.GATHER_INDEX_STATS('SCHEMA_NAME', 'INDEX_NAME');