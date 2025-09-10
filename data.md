## Useful PSQL Commands
### Connect via PSQL
```bash
psql postgres -h localhost -U gpadmin
```

### Run the example
```sql
CREATE DATABASE retail;
\c retail
SET search_path TO retail,user;
\i example.sql
```

### PSQL Short Commands & Keywords
| Command | Description |
|:-------:|-------------|
|\l| list databases |
|\h| help with SQL |
|\?| help with PSQL |
|\q| quit/exit|
|\dn| list schemas |
|\d| list all objects |
|\dt| list tables |
|\!| run shell cmd |
|\! clear| clear screen|
|--| comment|
|\echo "txt"| echo text|
|EXPLAIN| explain the query|
|ANALYZE| generate internal stats|
|VACUUM| cleanup/reclaims space|

* Use '+' to get additional info, i.e., `\dt+`
* View search_path `SHOW search_path;`
* set search_path (temp) `SET search_path TO xyz_schema,default;`
* set search_path (perm) `ALTER DATABASE retail SET search_path TO xyz_schema,public;`
* Create database and connect
    ```sql
    CREATE DATABASE retail;
    \c retail
    ```

## Useful GPDB Commands
* View GPDB Cluster details (e.g., Segments)
```sql
SELECT dbid, content, role, preferred_role, mode, status, hostname, address, port, datadir
FROM gp_segment_configuration
ORDER BY content, role;
```
* View distribution by segment
```sql
SELECT  gp_segment_id, count(*) as num_rows
FROM retail.fact_sales
GROUP BY gp_segment_id ORDER BY gp_segment_id;
```
* pg_relation_size
```sql
select pg_relation_size('retail_demo.dim_date');
```
* compression ratio
```sql
SELECT get_ao_compression_ratio('fact_sales');
```

## GPDB Tabel Options
### DISTRIBUTED
* `DISTRIBUTED RANDOMLY` (avoid)
* `DISTRIBUTED BY(column)`
* `DISTRIBUTED REPLICATED` (100,000 Rows)

### appendonly
* Heap Table: `WITH (appendonly=false)`
* AO Table: `WITH (appendonly=true)`

### orientation
* column `WITH(orientation=column)`
* row `WITH(orientation=row)`

### compresstype
* none `WITH(compresstype=none)`
* QuickLZ `WITH(compresstype=quicklz)`
* Zlib `WITH(compresstype=zlib)`
* Zstd `WITH(compresstype=zstd)`

### compresslevel
* (1-9) `WITH(compresslevel=5)`

### PARTITION BY