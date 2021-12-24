/* display used / not used features */
SELECT NAME,
  detected_usages,
  last_usage_date,
  first_usage_date,
  feature_info
FROM dba_feature_usage_statistics;
