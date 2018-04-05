#!/bin/sh
set -e

echo "CREATE EXTENSION IF NOT EXISTS postgis;" >> "$sql_file"
echo "CREATE EXTENSION IF NOT EXISTS postgis_topology;" >> "$sql_file"
echo "CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;" >> "$sql_file"
echo "CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;" >> "$sql_file"
echo "CREATE DATABASE template_postgis;" >> "$sql_file"
echo "UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_postgis';" >> "$sql_file"
echo "\\connect template_postgis" >> "$sql_file"
echo "CREATE EXTENSION IF NOT EXISTS postgis;" >> "$sql_file"
echo "CREATE EXTENSION IF NOT EXISTS postgis_topology;" >> "$sql_file"
echo "CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;" >> "$sql_file"
echo "CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;" >> "$sql_file"
