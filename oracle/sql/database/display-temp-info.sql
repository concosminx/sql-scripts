/* free temp space */
SELECT tablespace_name,
  total_blocks,
  used_blocks,
  free_blocks,
  total_blocks*16/1024 AS total_MB,
  used_blocks *16/1024 AS used_MB,
  free_blocks *16/1024 AS free_MB
FROM v$sort_segment;

/* segment usage */
SELECT b.TABLESPACE,
  b.segfile#,
  b.segblk#,
  b.blocks,
  b.blocks*16/1024 AS MB,
  a.SID,
  a.serial#,
  a.status
FROM v$session a,
  v$sort_usage b
WHERE a.saddr = b.session_addr
ORDER BY b.TABLESPACE,
  b.segfile#,
  b.segblk#,
  b.blocks;