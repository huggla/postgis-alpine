FROM mdillon/postgis:10-alpine

WORKDIR /var/lib/postgresql/data/pgdata

RUN chown postgres:postgres /var/lib/postgresql/data/pgdata \
 && chmod 700 /var/lib/postgresql/data/pgdata

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]
