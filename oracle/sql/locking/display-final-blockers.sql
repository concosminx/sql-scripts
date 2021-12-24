/* final blockers */
SELECT final_blocking_instance f_blk_inst,
  final_blocking_session f_blk_sess,
  event,
  sql_id,
  row_wait_obj#
  ||','
  ||row_wait_block# obj_lck,
  COUNT(*) num_blocked,
  MAX(wait_time_micro) max_wait_musec
FROM gv$session
WHERE final_blocking_session_Status='VALID'
GROUP BY final_blocking_instance,
  final_blocking_session,
  event,
  sql_id,
  row_wait_obj#
  ||','
  ||row_wait_block#
ORDER BY 1;