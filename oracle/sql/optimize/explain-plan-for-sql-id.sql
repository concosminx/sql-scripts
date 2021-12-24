/* prints execution plan for a give sql_id */

--select * from table(dbms_xplan.display_cursor(:SQL_ID));
--select * from table(dbms_xplan.display_cursor(:SQL_ID,0,'ALLSTATS LAST'));
--select * from table(dbms_xplan.display_cursor(:SQL_ID,0,'TYPICAL OUTLINE'));
select * from table(dbms_xplan.display_cursor(:SQL_ID,null,'ADVANCED OUTLINE ALLSTATS LAST +PEEKED_BINDS'));

select * from table(dbms_xplan.display_cursor(:SQL_ID));