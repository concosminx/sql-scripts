/* track database recovery operations */
/* https://docs.oracle.com/cd/E11882_01/server.112/e40402/dynviews_2128.htm#REFRN30199 */
select inst_id, max(timestamp) from gv$recovery_progress group by inst_id;
