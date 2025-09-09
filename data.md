CREATE DATABASE retail;
\c retail

## Useful PSQL Commands
Connect via PSQL
```bash
psql postgres -h localhost -U gpadmin
```

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

* Use '+' to get additional info, i.e., `\dt+`
* `SHOW search_path;`
* `SET search_path TO xyz_schema,default;`

## Useful GPDB Commands
View GPDB Cluster details (e.g., Segments)
```sql
SELECT dbid, content, role, preferred_role, mode, status, hostname, address, port, datadir
FROM gp_segment_configuration
ORDER BY content, role;
```