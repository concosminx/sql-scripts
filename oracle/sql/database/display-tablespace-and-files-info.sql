/* tablespaces */
SELECT a.TABLESPACE_NAME,
  round(a.BYTES        /1024/1024, 2) Mbytes_used,
  round(b.BYTES        /1024/1024, 2) Mbytes_free,
  ROUND(((a.BYTES-b.BYTES)/a.BYTES)*100,2) percent_used
FROM
  (SELECT TABLESPACE_NAME,
    SUM(BYTES) BYTES
  FROM dba_data_files
  GROUP BY TABLESPACE_NAME
  ) a
LEFT OUTER JOIN
  (SELECT TABLESPACE_NAME,
    SUM(BYTES) BYTES ,
    MAX(BYTES) largest
  FROM dba_free_space
  GROUP BY TABLESPACE_NAME
  ) b
ON a.TABLESPACE_NAME=b.TABLESPACE_NAME
WHERE 1             =1
AND a.tablespace_name LIKE '%'
ORDER BY ((a.BYTES-b.BYTES)/a.BYTES) DESC;

/* list files in a tablespace*/
SELECT file_name,
  bytes/1024/1024 Mbytes,
  autoextensible,
  maxbytes/1024/1024 M_maxbytes
FROM dba_data_files
WHERE tablespace_name= coalesce(upper(:TABLESPACE_NAME), 'USERS');
