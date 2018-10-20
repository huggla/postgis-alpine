ARG ADDREPOS="http://dl-cdn.alpinelinux.org/alpine/edge/testing"
ARG RUNDEPS_UNTRUSTED="postgis"
ARG EXECUTABLES="/usr/bin/postgresql"

FROM huggla/postgres-alpine as init
FROM huggla/build as build
FROM huggla/postgres-alpine as image

COPY --from=build /imagefs /

USER starter

ONBUILD USER root
