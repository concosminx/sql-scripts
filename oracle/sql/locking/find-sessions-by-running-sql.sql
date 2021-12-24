/*running in the system*/
select 
s.inst_id,
--      'alter system kill session '''|| s.SID||',' || s.serial# ||'''' ,
--'!kill -9 ' || p.spid, 
      p.SPID UnixProcess ,s.SID,s.serial#,s.USERNAME,s.COMMAND,s.MACHINE,s.blocking_session
      ,s.program, status,state,event,s.sql_id,sql_text,COMMAND_TYPE
    ,sbc.name,to_char(sbc.last_captured,'yyyy-mm-dd hh24:mi:ss'),sbc.value_string
    from gv$session s
left outer join gv$process p on p.ADDR = s.PADDR and s.inst_id=p.inst_id 
left outer join gv$sqlarea sa on sa.ADDRESS = s.SQL_ADDRESS and s.inst_id=sa.inst_id
left outer join gV$SQL_BIND_CAPTURE sbc on sbc.ADDRESS = s.SQL_ADDRESS and s.inst_id=p.inst_id
where 1=1 and sql_text like '...';


/* sql session for specific sid*/
SELECT a.sql_text
FROM v$sqltext a,
  v$session b
WHERE a.address  = b.sql_address
AND a.hash_value = b.sql_hash_value
AND b.sid        = :sid
ORDER BY a.piece;