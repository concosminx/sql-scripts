# Connecting to the database

- access the PostgreSQL container's shell: `docker exec -it sample_db bash`
- connect to PostgreSQL using psql: `docker exec -it sample_db`
- list all databases in PostgreSQL: `\l` or use SQL: `SELECT datname FROM pg_database;`
- connects to a database: `\c sample`

# Creating a database

- create a new database: `CREATE DATABASE my_new_db;`

# Delete (drop) a database

- drop a database: `DROP DATABASE my_new_db;`
