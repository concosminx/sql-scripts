/* find connection leaks*/
select count(*) as sessions,
         s.host_name,
         s.host_process_id,
         s.program_name,
         db_name(s.database_id) as database_name
   from sys.dm_exec_sessions s
   where is_user_process = 1
   group by host_name, host_process_id, program_name, database_id
   order by count(*) desc;