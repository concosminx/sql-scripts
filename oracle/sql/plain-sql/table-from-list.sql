/* create a table from a list */
/* https://www.linkedin.com/pulse/secrets-oracle-sql-functions-arash-atarzadeh */
select rownum id, column_value varchar2_data 
from (
	table(
		sys.odcivarchar2list('one','two','three','four','five','six','seven','eight','nine')
	)
);


/* see sys.odcinumberlist(100,200,300,400,500,600,700,800,900) */
/* see sys.odcidatelist(sysdate - 1, sysdate, sysdate + 1) */