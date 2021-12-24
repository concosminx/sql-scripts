/* sessions with lockwait */
SELECT inst_id
  ||' '
  ||sid
  ||','
  ||serial# inst_sid_s#,
  username,
  row_wait_obj#
  ||','
  ||row_wait_block#
  ||','
  ||row_wait_row# obj_lck,
  blocking_session_Status
  ||' '
  ||blocking_instance
  ||','
  ||blocking_session blk_info,
  final_blocking_session_Status
  ||' '
  ||final_blocking_instance
  ||','
  ||final_blocking_session f_blk_info,
  event,
  seconds_in_wait s_wt
FROM gv$session
WHERE lockwait IS NOT NULL
ORDER BY inst_id;