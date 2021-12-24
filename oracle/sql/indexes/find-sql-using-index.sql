/*find sql using index*/
WITH live_plans AS
  ( SELECT DISTINCT sql_id,
    plan_hash_value
  FROM gv$sql_plan
  WHERE object_type = 'INDEX'
  AND object_owner  = :INDEX_OWNER
  AND object_name   = :INDEX_NAME
  ),
  hist_plans AS
  ( SELECT DISTINCT sql_id,
    plan_hash_value
  FROM dba_hist_sql_plan
  WHERE object_type = 'INDEX'
  AND object_owner  = :INDEX_OWNER
  AND object_name   = :INDEX_NAME
  ),
  all_plans AS
  ( SELECT DISTINCT sql_id,
    plan_hash_value
  FROM
    ( SELECT sql_id, plan_hash_value FROM live_plans
    UNION
    SELECT sql_id, plan_hash_value FROM hist_plans
    )
  )
SELECT sql_id, plan_hash_value FROM all_plans;