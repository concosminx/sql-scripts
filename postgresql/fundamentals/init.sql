CREATE TABLE category (
    id SERIAL PRIMARY KEY,
    parent_id INTEGER REFERENCES category(id) ON DELETE RESTRICT,
    name VARCHAR(50) NOT NULL UNIQUE,
    slug VARCHAR(55) NOT NULL UNIQUE,
    is_active BOOLEAN NOT NULL DEFAULT FALSE,
    level SMALLINT NOT NULL DEFAULT 0,
    CONSTRAINT check_category_slug_not_empty CHECK (name <> '')
);

COPY category (id, parent_id, name, slug, is_active, level)
FROM '/data/category.csv'
DELIMITER ','
CSV HEADER;
