/* sql text, cursors by sid */
/* https://docs.oracle.com/cd/E18283_01/server.112/e17110/dynviews_2083.htm */
SELECT st.sql_text, oc.sid
FROM v$sqltext st,
  v$open_cursor oc
WHERE st.address  = oc.address
AND st.hash_value = oc.hash_value
AND oc.sid        = :sid
ORDER BY st.address,
  st.piece;