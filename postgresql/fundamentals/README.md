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

CREATE TABLE promotion_events (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    price_reduction INTEGER NOT NULL
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    category_id INTEGER REFERENCES category(id) ON DELETE CASCADE,
    name VARCHAR(50) NOT NULL UNIQUE,
    slug VARCHAR(55) NOT NULL UNIQUE,
    description TEXT,
    is_digital BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP,
    price NUMERIC(10,2) NOT NULL,
    CONSTRAINT check_category_name_not_empty CHECK (name <> ''),
    CONSTRAINT check_category_slug_not_empty CHECK (slug <> ''),
    CONSTRAINT check_category_slug_format CHECK (slug ~ '^[a-z0-9_-]+$')
);

CREATE TABLE product_promotion_events (
    id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    promotion_event_id INTEGER NOT NULL REFERENCES promotion_events(id) ON DELETE CASCADE,
    CONSTRAINT unique_product_event UNIQUE (product_id, promotion_event_id)
);

CREATE TABLE stock_management (
    id SERIAL PRIMARY KEY,
    product_id INTEGER UNIQUE REFERENCES products(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL DEFAULT 0,
    last_checked_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(60) NOT NULL
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE order_products (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL,
    CONSTRAINT unique_product_order UNIQUE (product_id, order_id)
);
```
