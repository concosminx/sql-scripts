/* https://docs.oracle.com/cd/E11882_01/server.112/e25494/scheduse.htm#ADMIN12384 */
/* view jobs */
SELECT owner,
  job_name,
  job_action,
  program_name,
  repeat_interval,
  state,
  failure_count,
  LAST_START_DATE,
  LAST_RUN_DURATION,
  NEXT_RUN_DATE,
  JOB_CLASS ,
  schedule_name,
  schedule_owner
FROM dba_scheduler_jobs
WHERE owner = :OWNER;

/* currently running jobs (new) */
select * from dba_scheduler_running_jobs;


/* see running jobs */
SELECT s.username,
  jr.sid,
  jr.job,
  jr.failures,
  jr.last_date,
  jr.this_date,
  dj.next_date
FROM dba_jobs_running jr,
  v$session s,
  dba_jobs dj
WHERE jr.sid = s.sid
AND jr.job   = dj.job
ORDER BY username,
  job;
  
/* schedules */
SELECT schedule_name,
  schedule_type,
  start_date,
  repeat_interval
FROM dba_scheduler_schedules;