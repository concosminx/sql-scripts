/* uptime */
SELECT TO_CHAR(STARTUP_TIME,'DD-MON-YYYY HH24:MI:SS') STARTED_AT FROM SYS.V_$INSTANCE;
