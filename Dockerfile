FROM mdillon/postgis:10-alpine

COPY ./extension/* /usr/local/share/postgresql/extension/
