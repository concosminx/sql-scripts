/* drop existing database */
DROP DATABASE IF EXISTS my_new_database;

/* create new database */
CREATE DATABASE my_new_database;

/* kill existing sessions connected to database - if needed*/
SELECT count(*) AS sessions_killed FROM (SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'my_new_database' AND pid != pg_backend_pid()) a;

