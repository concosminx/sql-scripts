/*job history */ 
SELECT job_name,
  status,
  req_start_date,
  actual_start_date,
  run_duration
FROM DBA_SCHEDULER_JOB_RUN_DETAILS
WHERE 1 = 1 
--and job_name LIKE 'SOMETHING%'
AND req_start_date> sysdate-3
ORDER BY req_start_date;

/*or*/
SELECT log_date, job_name, status FROM dba_scheduler_job_log;
 
/* job control */
exec dbms_scheduler.stop_job('santa.job');   
exec dbms_scheduler.enable('santa.job'); 

/* read more info on oracle docs: 
   https://docs.oracle.com/en/database/oracle/oracle-database/21/admin/scheduling-jobs-with-oracle-scheduler.html
*/