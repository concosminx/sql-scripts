/* convert blob to varchar2 */
/* https://www.codexpedia.com/database/how-to-convert-blob-data-to-text-in-oracle-sql/ */
SELECT utl_raw.cast_to_varchar2(dbms_lob.substr(valoare))
FROM schema_name.table_name;
