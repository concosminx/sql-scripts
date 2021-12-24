/* Dump database on remote host to file */
$ pg_dump -U username -h hostname databasename > dump.sql

/* Import dump into existing database */
$ psql -d newdb -f dump.sql