/* view dml locks */
SELECT session_id sid, owner,name,mode_held,mode_requested FROM dba_dml_locks;