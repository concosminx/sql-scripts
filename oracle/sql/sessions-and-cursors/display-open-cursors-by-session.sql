/* display open cursors*/
SELECT *
FROM
  (SELECT S.SID,
    S.USERNAME,
    S.OSUSER,
    S.PROGRAM,
    V.VALUE "OPENCURSORS"
  FROM SYS.V_$SESSTAT V,
    SYS.V_$SESSION S
  WHERE V.SID      = S.SID
  AND V.STATISTIC# =
    (SELECT STATISTIC#
    FROM SYS.V_$STATNAME
    WHERE NAME LIKE 'opened cursors current'
    )
  ORDER BY V.VALUE DESC
  )
WHERE ROWNUM < 11;


/* open cursors by sid */
SELECT oc.sql_text,
  cursor_type
FROM v$open_cursor oc
WHERE oc.sid = :sid
ORDER BY cursor_type;

/* find SQL with too many child cursors */
select version_count,sql_text from v$sqlarea order by version_count desc;
