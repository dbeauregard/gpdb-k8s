-- Run from psql with 'psql=# \i /path/to/file.sql'
-- or psql <database> -h <host> -U <user> -f /path/to/yourfile.sql

-- Create Schema
DROP SCHEMA IF EXISTS retail CASCADE;
CREATE SCHEMA retail;

-- Create Product table
DROP TABLE IF EXISTS retail.product;
CREATE TABLE retail.product (
    product_id    int PRIMARY KEY,
    sku           text,
    name          text,
    category      text,
    brand         text,
    unit_price    numeric(10,2)
)
WITH (appendonly=false)
DISTRIBUTED REPLICATED;

-- Create Customer table
DROP TABLE IF EXISTS retail.customer;
CREATE TABLE retail.customer (
    customer_id   int PRIMARY KEY,
    first_name    text,
    last_name     text,
    email         text,
    city          text,
    state         text
)
WITH (appendonly=true, orientation=column, compresstype=zstd, compresslevel=5)
DISTRIBUTED BY(customer_id);

-- Create Order table
DROP TABLE IF EXISTS retail.order;
CREATE TABLE retail.order (
    order_id       bigint,
    sale_date     date NOT NULL,
    customer_id   int NOT NULL,
    product_id    int NOT NULL,
    qty           int NOT NULL,
    unit_price    numeric(10,2) NOT NULL
)
WITH (appendonly=true, orientation=column, compresstype=zstd, compresslevel=5)
DISTRIBUTED BY (customer_id);

-- Generate and insert product data
INSERT INTO retail.product
SELECT p_id AS product_id,
       'SKU-' || LPAD(p_id::text, 6, '0') AS sku,
       'Product ' || p_id AS name,
       CASE (p_id % 4) 
        WHEN 0 THEN 'Electronics' 
        WHEN 1 THEN 'Home' 
        WHEN 2 THEN 'Outdoor' 
        ELSE 'Apparel' 
       END AS category,
       CASE (p_id % 5) 
        WHEN 0 THEN 'Acme' 
        WHEN 1 THEN 'Globex' 
        WHEN 2 THEN 'Initech' 
        WHEN 3 THEN 'Umbrella' 
        ELSE 'Soylent' 
       END AS brand,
       ROUND( (10 + (random()*490))::numeric, 2) AS unit_price
FROM generate_series(1, 500) AS p_id;

-- Generate and insert customer data
INSERT INTO retail.customer
SELECT c AS customer_id,
       'First_' || c AS first_name,
       'Last_'  || c AS last_name,
       'customer' || c || '@example.com' AS email,
       CASE (c % 5)
         WHEN 0 THEN 'Denver'
         WHEN 1 THEN 'Seattle'
         WHEN 2 THEN 'Austin'
         WHEN 3 THEN 'Chicago'
         ELSE 'San Jose'
       END AS city,
       CASE (c % 5)
         WHEN 0 THEN 'CO' 
         WHEN 1 THEN 'WA' 
         WHEN 2 THEN 'TX' 
         WHEN 3 THEN 'IL' 
         ELSE 'CA' 
       END AS state
FROM generate_series(1, 500) AS c;

-- Generate and insert order data
INSERT INTO retail.order
SELECT o_id AS order_id,
       (DATE '2018-01-01' + (o_id % 2190))::date AS sale_date,
       (1 + floor(random() * 500))::int AS customer_id,
       (1 + floor(random() * 500))::int AS product_id,
       1 + (random()*4)::int AS qty,
       ROUND( (10 + (random()*490))::numeric, 0) AS unit_price
FROM generate_series(1, 500000) AS o_id;

-- Run a query that joins all 3 tables
SELECT o.order_id, o.customer_id, c.email, o.product_id, p.sku 
FROM retail.order o
JOIN retail.customer c ON o.customer_id = c.customer_id
JOIN retail.product p ON o.product_id = p.product_id
LIMIT 10;