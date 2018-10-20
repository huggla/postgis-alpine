ARG ADDREPOS="http://dl-cdn.alpinelinux.org/alpine/edge/testing"
ARG RUNDEPS_UNTRUSTED="postgis"
ARG BUILDCMDS=\
"   cd /imagefs/usr/local "\
"&& rm -rf bin "\
"&& ln -s ../../usr/* ./ "\
"&& rm bin "\
"&& mkdir bin "\
"&& cd bin "\
"&& ln -s ../../bin/* ./ "\
"&& rm postgres"
ARG EXECUTABLES="/usr/bin/postgres"

FROM huggla/postgres-alpine as init
FROM huggla/build as build
FROM huggla/postgres-alpine as image

COPY --from=build /imagefs /

USER starter

ONBUILD USER root
