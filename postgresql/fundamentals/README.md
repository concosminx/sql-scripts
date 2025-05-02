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
- delete user:
  - revoke all privileges from dbuser: `REVOKE ALL PRIVILEGES ON DATABASE sample FROM dbuser;`
  - drop the user: `DROP USER dbuser;`

# Creating tables
- to list all tables: `\dt`
- check the columns of a specific table: `\dt table_name`
- wrap it in double quotes to escape the reserved keyword: `CREATE TABLE "user" ();`
- full example:

```sql
CREATE TABLE category (
    id SERIAL PRIMARY KEY,
    parent_id INTEGER REFERENCES category(id) ON DELETE RESTRICT,
    name VARCHAR(50) NOT NULL UNIQUE,
    slug VARCHAR(55) NOT NULL UNIQUE,
    is_active BOOLEAN NOT NULL DEFAULT FALSE,
    level SMALLINT NOT NULL DEFAULT 0,
    CONSTRAINT check_category_slug_not_empty CHECK (name <> '')
);

...
```

# Load data from JSON
- test if data is correctly located:

```sql
WITH json_data AS (
    SELECT *
    FROM jsonb_array_elements(
    pg_read_file('/data/category.json')::jsonb
    ) AS data
)
SELECT * FROM json_data;
```

- read the JSON data from the file and insert into the 'category' table

```sql
WITH json_data AS (
    SELECT jsonb_array_elements(
        (SELECT pg_read_file('/data/category.json')::jsonb)
    ) AS data
)
INSERT INTO category (id, parent_id, name, slug, is_active, level)
SELECT
    (data->>'id')::INT,
    (data->>'parent_id')::INT,
    data->>'name',
    data->>'slug',
    (data->>'is_active')::BOOLEAN,
    (data->>'level')::SMALLINT
FROM json_data;
```

# Load data from CSV
- use the COPY command:

```sql
COPY category (id, parent_id, name, slug, is_active, level)
FROM '/data/Category.csv'
DELIMITER ','
CSV HEADER;
```

# Backup
- binary: `pg_dump -U postgres -h localhost -p 5432 -F c -b -v -f /data/backup_file.dump sample`
- sql: `pg_dump -U postgres -h localhost -p 5432 -F p -d sample -f /data/sample_backup.sql`

# Restore
- binary: `pg_restore -U postgres -h localhost -p 5432 -d sample -v /data/backup_file.dump`
- sql: `pg_restore -U postgres -h localhost -p 5432 -d sample -v /data/sample_backup.sql`


Original author: [https://github.com/veryacademy/CW0001-SQL-Fundamentals-with-PostgreSQL-FreeView](https://github.com/veryacademy/CW0001-SQL-Fundamentals-with-PostgreSQL-FreeView)
