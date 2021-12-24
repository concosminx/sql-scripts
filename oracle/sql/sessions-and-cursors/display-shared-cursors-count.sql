/* display shared cursors count */
/* https://docs.oracle.com/database/121/TGSQL/tgsql_cursor.htm#TGSQL-GUID-7A37EEAC-1B50-4744-B4BC-A3052313A7E4 */
SELECT DISTINCT sql_id ,
  COUNT(child_number) over (partition BY sql_id order by sql_id) child_count
FROM v$sql_shared_cursor
ORDER BY 2 desc;
