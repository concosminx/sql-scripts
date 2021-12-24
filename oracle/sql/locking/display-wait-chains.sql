/* wait chains */
SELECT instance
  ||' '
  ||sid
  ||','
  ||sess_serial# inst_sid_s#,
  chain_signature,
  num_waiters wrs#,
  in_wait_secs Wsecs,
  row_wait_obj#
  ||','
  ||row_wait_block# obj_lck,
  blocker_is_valid
  ||' '
  ||blocker_instance
  ||','
  ||blocker_sid blk_info
FROM v$wait_chains
WHERE in_wait       ='TRUE'
AND blocker_is_valid='TRUE'
ORDER BY instance,
  chain_signature;