/* recent blockers */
WITH blockers AS
  ( SELECT DISTINCT blocking_session session_id,
    blocking_session_serial# session_serial#,
    sample_id
  FROM v$active_session_history
    --from dba_hist_active_sess_history
  WHERE blocking_session IS NOT NULL
  ),
  blocked AS
  ( SELECT DISTINCT ash.sample_id ,
    ash.session_id ,
    ash.session_serial# ,
    ash.blocking_session ,
    ash.blocking_session_serial# ,
    ash.time_waited ,
    MAX(ash.time_waited) over ( partition BY ash.session_id, ash.session_serial#) max_time_waited
  FROM v$active_session_history ash
    --from dba_hist_active_sess_history ash
  JOIN blockers blkr
  ON ash.blocking_session          = blkr.session_id
  AND ash.blocking_session_serial# = blkr.session_serial#
  AND ash.sample_id                = blkr.sample_id
  WHERE ash.session_state          = 'WAITING'
  AND ash.event                    = 'enq: TX - row lock contention'
    --group by ash.session_id, ash.session_serial#, ash.blocking_session, ash.blocking_session_serial#
  )
SELECT blkd.sample_id ,
  blkr.sample_time ,
  blkd.session_id ,
  blkd.session_serial# ,
  blkd.blocking_session ,
  blkd.blocking_session_serial# ,
  blkd.time_waited / 100 time_waited ,
  blkr.sql_id ,
  blkr.session_state ,
  blkr.event
FROM blocked blkd
JOIN v$active_session_history blkr
ON blkr.session_id       = blkd.blocking_session
AND blkr.session_serial# = blkd.blocking_session_serial#
AND blkr.session_id      = blkd.blocking_session
AND blkr.session_serial# = blkd.blocking_session_serial#
AND blkr.sample_id       = blkd.sample_id
  -- a kludge to get the sample id from blocked() query
WHERE blkd.time_waited = blkd.max_time_waited
ORDER BY blkd.sample_id,
  blkd.session_id;