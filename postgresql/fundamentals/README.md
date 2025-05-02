# Connecting to the database
- access the PostgreSQL container's shell: `docker exec -it sample_db bash`
- connect to PostgreSQL using psql: `psql -U postgres`
- list all databases in PostgreSQL: `\l` or use SQL: `SELECT datname FROM pg_database;`
- connects to a database: `\c sample`

# Creating a database
- create a new database: `CREATE DATABASE my_new_db;`

# Delete (drop) a database
- drop a database: `DROP DATABASE my_new_db;`

# Users and roles
- list all users (roles): `\du`
- return just the usernames: `SELECT usename FROM pg_user;`
- roles and permissions: `SELECT * FROM pg_roles;`
- creates a new user with a password: `CREATE USER dbuser WITH PASSWORD 'password';`
- check for users associated with the database:

```sql
SELECT rolname 
FROM pg_catalog.pg_roles 
WHERE rolcanlogin = true;
```

- grants all permissions on my_database to `dbuser`: `GRANT ALL PRIVILEGES ON DATABASE sample TO dbuser;`
- revoke access from postgres database:

```sql
REVOKE CONNECT ON DATABASE postgres FROM dbuser;
REVOKE ALL PRIVILEGES ON DATABASE dbuser FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM dbuser;
```

- login with new user: `psql -U dbuser -d sample`
