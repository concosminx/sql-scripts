/* number of sessions for each client machine */
SELECT machine,
  NVL(active_count, 0)   AS active,
  NVL(inactive_count, 0) AS inactive,
  NVL(killed_count, 0)   AS killed
FROM
  (SELECT machine,
    status,
    COUNT(*) AS quantity
  FROM v$session
  GROUP BY machine,
    status
  ) PIVOT (SUM(quantity) AS COUNT FOR (status) IN ('ACTIVE' AS active, 'INACTIVE' AS inactive, 'KILLED' AS killed))
ORDER BY machine;
