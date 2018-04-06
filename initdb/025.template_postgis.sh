#!/bin/sh
set -e

echo "CREATE EXTENSION IF NOT EXISTS postgis;" >> "$sql_file"
echo "CREATE EXTENSION IF NOT EXISTS postgis_topology;" >> "$sql_file"
echo "CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;" >> "$sql_file"
echo "CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;" >> "$sql_file"
