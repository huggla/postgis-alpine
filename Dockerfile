ARG ADDREPOS="http://dl-cdn.alpinelinux.org/alpine/edge/testing"
ARG RUNDEPS_UNTRUSTED="postgis"
ARG EXECUTABLES="/usr/bin/postgres"

FROM huggla/busybox:20181017-edge as init
FROM huggla/build:20181017-edge as build
FROM huggla/postgres-alpine:20181017-edge as image

COPY --from=build /imagefs /

USER starter

ONBUILD USER root
