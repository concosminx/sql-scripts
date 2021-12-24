/* check for exact matches*/
SELECT indrelid::regclass
     , array_agg(indexrelid::regclass)
  FROM pg_index
 GROUP BY indrelid
     , indkey
HAVING COUNT(*) > 1;

/* check for matches on only the first column of the index
   requires some human eyeballing to verify */
SELECT indrelid::regclass
     , array_agg(indexrelid::regclass)
  FROM pg_index
 GROUP BY indrelid
     , indkey[0]
HAVING COUNT(*) > 1;

/* check for containment
   i.e. index A contains index B
   and both share the same first column
   but they are NOT identical */
WITH index_cols_ord as (
    SELECT attrelid, attnum, attname
    FROM pg_attribute
        JOIN pg_index ON indexrelid = attrelid
    WHERE indkey[0] > 0
    ORDER BY attrelid, attnum
),
index_col_list AS (
    SELECT attrelid,
        array_agg(attname) as cols
    FROM index_cols_ord
    GROUP BY attrelid
),
dup_natts AS (
SELECT indrelid, indexrelid
FROM pg_index as ind
WHERE EXISTS ( SELECT 1
    FROM pg_index as ind2
    WHERE ind.indrelid = ind2.indrelid
    AND ( ind.indkey @> ind2.indkey
     OR ind.indkey <@ ind2.indkey )
    AND ind.indkey[0] = ind2.indkey[0]
    AND ind.indkey <> ind2.indkey
    AND ind.indexrelid <> ind2.indexrelid
) )
SELECT userdex.schemaname as schema_name,
    userdex.relname as table_name,
    userdex.indexrelname as index_name,
    array_to_string(cols, ', ') as index_cols,
    indexdef,
    idx_scan as index_scans
FROM pg_stat_user_indexes as userdex
    JOIN index_col_list ON index_col_list.attrelid = userdex.indexrelid
    JOIN dup_natts ON userdex.indexrelid = dup_natts.indexrelid
    JOIN pg_indexes ON userdex.schemaname = pg_indexes.schemaname
        AND userdex.indexrelname = pg_indexes.indexname
ORDER BY userdex.schemaname, userdex.relname, cols, userdex.indexrelname;

/*check for FKs where there is no matching index
  on the referencing side
  or a bad index */
WITH fk_actions ( code, action ) AS (
    VALUES ( 'a', 'error' ),
        ( 'r', 'restrict' ),
        ( 'c', 'cascade' ),
        ( 'n', 'set null' ),
        ( 'd', 'set default' )
),
fk_list AS (
    SELECT pg_constraint.oid as fkoid, conrelid, confrelid as parentid,
        conname, relname, nspname,
        fk_actions_update.action as update_action,
        fk_actions_delete.action as delete_action,
        conkey as key_cols
    FROM pg_constraint
        JOIN pg_class ON conrelid = pg_class.oid
        JOIN pg_namespace ON pg_class.relnamespace = pg_namespace.oid
        JOIN fk_actions AS fk_actions_update ON confupdtype = fk_actions_update.code
        JOIN fk_actions AS fk_actions_delete ON confdeltype = fk_actions_delete.code
    WHERE contype = 'f'
),
fk_attributes AS (
    SELECT fkoid, conrelid, attname, attnum
    FROM fk_list
        JOIN pg_attribute
            ON conrelid = attrelid
            AND attnum = ANY( key_cols )
    ORDER BY fkoid, attnum
),
fk_cols_list AS (
    SELECT fkoid, array_agg(attname) as cols_list
    FROM fk_attributes
    GROUP BY fkoid
),
index_list AS (
    SELECT indexrelid as indexid,
        pg_class.relname as indexname,
        indrelid,
        indkey,
        indpred is not null as has_predicate,
        pg_get_indexdef(indexrelid) as indexdef
    FROM pg_index
        JOIN pg_class ON indexrelid = pg_class.oid
    WHERE indisvalid
),
fk_index_match AS (
    SELECT fk_list.*,
        indexid,
        indexname,
        indkey::int[] as indexatts,
        has_predicate,
        indexdef,
        array_length(key_cols, 1) as fk_colcount,
        array_length(indkey,1) as index_colcount,
        round(pg_relation_size(conrelid)/(1024^2)::numeric) as table_mb,
        cols_list
    FROM fk_list
        JOIN fk_cols_list USING (fkoid)
        LEFT OUTER JOIN index_list
            ON conrelid = indrelid
            AND (indkey::int2[])[0:(array_length(key_cols,1) -1)] @> key_cols

),
fk_perfect_match AS (
    SELECT fkoid
    FROM fk_index_match
    WHERE (index_colcount - 1) <= fk_colcount
        AND NOT has_predicate
        AND indexdef LIKE '%USING btree%'
),
fk_index_check AS (
    SELECT 'no index' as issue, *, 1 as issue_sort
    FROM fk_index_match
    WHERE indexid IS NULL
    UNION ALL
    SELECT 'questionable index' as issue, *, 2
    FROM fk_index_match
    WHERE indexid IS NOT NULL
        AND fkoid NOT IN (
            SELECT fkoid
            FROM fk_perfect_match)
),
parent_table_stats AS (
    SELECT fkoid, tabstats.relname as parent_name,
        (n_tup_ins + n_tup_upd + n_tup_del + n_tup_hot_upd) as parent_writes,
        round(pg_relation_size(parentid)/(1024^2)::numeric) as parent_mb
    FROM pg_stat_user_tables AS tabstats
        JOIN fk_list
            ON relid = parentid
),
fk_table_stats AS (
    SELECT fkoid,
        (n_tup_ins + n_tup_upd + n_tup_del + n_tup_hot_upd) as writes,
        seq_scan as table_scans
    FROM pg_stat_user_tables AS tabstats
        JOIN fk_list
            ON relid = conrelid
)
SELECT nspname as schema_name,
    relname as table_name,
    conname as fk_name,
    issue,
    table_mb,
    writes,
    table_scans,
    parent_name,
    parent_mb,
    parent_writes,
    cols_list,
    indexdef
FROM fk_index_check
    JOIN parent_table_stats USING (fkoid)
    JOIN fk_table_stats USING (fkoid)
WHERE table_mb > 9
    AND ( writes > 1000
        OR parent_writes > 1000
        OR parent_mb > 10 )
ORDER BY issue_sort, table_mb DESC, table_name, fk_name;


/*needed indexes*/
WITH 
index_usage AS (
    SELECT  sut.relid,
            current_database() AS database,
            sut.schemaname::text as schema_name, 
            sut.relname::text AS table_name,
            sut.seq_scan as table_scans,
            sut.idx_scan as index_scans,
            pg_total_relation_size(relid) as table_bytes,
            round((sut.n_tup_ins + sut.n_tup_del + sut.n_tup_upd + sut.n_tup_hot_upd) / 
                (seq_tup_read::NUMERIC + 2), 2) as writes_per_scan
    FROM pg_stat_user_tables sut
),
index_counts AS (
    SELECT sut.relid,
        count(*) as index_count
    FROM pg_stat_user_tables sut LEFT OUTER JOIN pg_indexes
    ON sut.schemaname = pg_indexes.schemaname AND
        sut.relname = pg_indexes.tablename
    GROUP BY relid
),
too_many_tablescans AS (
    SELECT 'many table scans'::TEXT as reason, 
        database, schema_name, table_name,
        table_scans, pg_size_pretty(table_bytes) as table_size,
        writes_per_scan, index_count, table_bytes
    FROM index_usage JOIN index_counts USING ( relid )
    WHERE table_scans > 1000
        AND table_scans > ( index_scans * 2 )
        AND table_bytes > 32000000
        AND writes_per_scan < ( 1.0 )
    ORDER BY table_scans DESC
),
scans_no_index AS (
    SELECT 'scans, few indexes'::TEXT as reason,
        database, schema_name, table_name,
        table_scans, pg_size_pretty(table_bytes) as table_size,
        writes_per_scan, index_count, table_bytes
    FROM index_usage JOIN index_counts USING ( relid )
    WHERE table_scans > 100
        AND table_scans > ( index_scans )
        AND index_count < 2
        AND table_bytes > 32000000   
        AND writes_per_scan < ( 1.0 )
    ORDER BY table_scans DESC
),
big_tables_with_scans AS (
    SELECT 'big table scans'::TEXT as reason,
        database, schema_name, table_name,
        table_scans, pg_size_pretty(table_bytes) as table_size,
        writes_per_scan, index_count, table_bytes
    FROM index_usage JOIN index_counts USING ( relid )
    WHERE table_scans > 100
        AND table_scans > ( index_scans / 10 )
        AND table_bytes > 1000000000  
        AND writes_per_scan < ( 1.0 )
    ORDER BY table_bytes DESC
),
scans_no_writes AS (
    SELECT 'scans, no writes'::TEXT as reason,
        database, schema_name, table_name,
        table_scans, pg_size_pretty(table_bytes) as table_size,
        writes_per_scan, index_count, table_bytes
    FROM index_usage JOIN index_counts USING ( relid )
    WHERE table_scans > 100
        AND table_scans > ( index_scans / 4 )
        AND table_bytes > 32000000   
        AND writes_per_scan < ( 0.1 )
    ORDER BY writes_per_scan ASC
)
SELECT reason, database, schema_name, table_name, table_scans, 
    table_size, writes_per_scan, index_count
FROM too_many_tablescans
UNION ALL
SELECT reason, database, schema_name, table_name, table_scans, 
    table_size, writes_per_scan, index_count
FROM scans_no_index
UNION ALL
SELECT reason, database, schema_name, table_name, table_scans, 
    table_size, writes_per_scan, index_count
FROM big_tables_with_scans
UNION ALL
SELECT reason, database, schema_name, table_name, table_scans, 
    table_size, writes_per_scan, index_count
FROM scans_no_writes;




/*unused indexes*/
WITH table_scans as (
    SELECT relid,
        tables.idx_scan + tables.seq_scan as all_scans,
        ( tables.n_tup_ins + tables.n_tup_upd + tables.n_tup_del ) as writes,
                pg_relation_size(relid) as table_size
        FROM pg_stat_user_tables as tables
),
all_writes as (
    SELECT sum(writes) as total_writes
    FROM table_scans
),
indexes as (
    SELECT idx_stat.relid, idx_stat.indexrelid,
        idx_stat.schemaname, idx_stat.relname as tablename,
        idx_stat.indexrelname as indexname,
        idx_stat.idx_scan,
        pg_relation_size(idx_stat.indexrelid) as index_bytes,
        indexdef ~* 'USING btree' AS idx_is_btree
    FROM pg_stat_user_indexes as idx_stat
        JOIN pg_index
            USING (indexrelid)
        JOIN pg_indexes as indexes
            ON idx_stat.schemaname = indexes.schemaname
                AND idx_stat.relname = indexes.tablename
                AND idx_stat.indexrelname = indexes.indexname
    WHERE pg_index.indisunique = FALSE
),
index_ratios AS (
SELECT schemaname, tablename, indexname,
    idx_scan, all_scans,
    round(( CASE WHEN all_scans = 0 THEN 0.0::NUMERIC
        ELSE idx_scan::NUMERIC/all_scans * 100 END),2) as index_scan_pct,
    writes,
    round((CASE WHEN writes = 0 THEN idx_scan::NUMERIC ELSE idx_scan::NUMERIC/writes END),2)
        as scans_per_write,
    pg_size_pretty(index_bytes) as index_size,
    pg_size_pretty(table_size) as table_size,
    idx_is_btree, index_bytes
    FROM indexes
    JOIN table_scans
    USING (relid)
),
index_groups AS (
SELECT 'Never Used Indexes' as reason, *, 1 as grp
FROM index_ratios
WHERE
    idx_scan = 0
    and idx_is_btree
UNION ALL
SELECT 'Low Scans, High Writes' as reason, *, 2 as grp
FROM index_ratios
WHERE
    scans_per_write <= 1
    and index_scan_pct < 10
    and idx_scan > 0
    and writes > 100
    and idx_is_btree
UNION ALL
SELECT 'Seldom Used Large Indexes' as reason, *, 3 as grp
FROM index_ratios
WHERE
    index_scan_pct < 5
    and scans_per_write > 1
    and idx_scan > 0
    and idx_is_btree
    and index_bytes > 100000000
UNION ALL
SELECT 'High-Write Large Non-Btree' as reason, index_ratios.*, 4 as grp 
FROM index_ratios, all_writes
WHERE
    ( writes::NUMERIC / ( total_writes + 1 ) ) > 0.02
    AND NOT idx_is_btree
    AND index_bytes > 100000000
ORDER BY grp, index_bytes DESC )
SELECT reason, schemaname, tablename, indexname,
    index_scan_pct, scans_per_write, index_size, table_size
FROM index_groups;

/*index name*/
select c.relname FROM pg_class c, pg_namespace n WHERE c.relnamespace = n.oid AND c.relkind = 'i' AND c.relname = 'idx_name' AND n.nspname = 'schema';


/*index on fk */
select 
   FK_COL_NUMS.TABLE_NAME, 
   FK_COL_NUMS.FK_NAME, 
   fk_cols.attname COLUMN_NAME 
 from 
 ( 
   select 
	 tables.relname TABLE_NAME, 
	 fk.conrelid conrelid, 
	 fk.conname FK_NAME, 
	 unnest(fk.conkey) fk_col_num, 
	 unnest(fk.confkey) fk_col_num_order 
   from 
	 pg_catalog.pg_namespace schemas, 
	 pg_catalog.pg_class tables, 
	 pg_catalog.pg_constraint fk 
   where 
   schemas.oid = tables.relnamespace 
   and schemas.oid = fk.connamespace 
   and tables.oid = fk.conrelid 
   and schemas.nspname = 'schema_name' 
   and tables.relname = ? 'table_name'
   and fk.conname = 'fk_name'
   and fk.contype = 'f' 
 ) FK_COL_NUMS, 
 pg_catalog.pg_attribute fk_cols 
 where 
   FK_COL_NUMS.conrelid = fk_cols.attrelid 
   and FK_COL_NUMS.fk_col_num = fk_cols.attnum 
 order by FK_COL_NUMS.FK_NAME, FK_COL_NUMS.fk_col_num_order;
 
/*index columns*/
 select 
       index_names.relname INDEX_NAME, 
       tables.relname TABLE_NAME, 
       generate_subscripts(indexes.indkey, 1) + 1 COLUMN_POSITION, 
       unnest(ARRAY( 
         SELECT pg_get_indexdef(indexes.indexrelid, k + 1, true) 
         FROM generate_subscripts(indexes.indkey, 1) as k 
         ORDER BY k 
       )) as COLUMN_NAME 
     from 
       pg_catalog.pg_namespace schemas, 
       pg_catalog.pg_class tables, 
       pg_catalog.pg_class index_names, 
       pg_catalog.pg_index indexes 
     where 
       schemas.oid = tables.relnamespace 
       and tables.oid = indexes.indrelid 
       and index_names.oid = indexes.indexrelid 
       and schemas.nspname = 'schema_name'
       and tables.relname = 'table_name'
     order by 
       index_names.relname, 
       indexes.indkey;  
 
 