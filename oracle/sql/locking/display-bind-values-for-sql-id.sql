/* bind values from sql id */
SELECT * FROM V$SQL_BIND_CAPTURE WHERE sql_id=:sql_id;