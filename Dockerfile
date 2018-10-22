ARG BASEIMAGE="huggla/postgres-alpine"
ARG ADDREPOS="http://dl-cdn.alpinelinux.org/alpine/edge/testing"
ARG RUNDEPS_UNTRUSTED="postgis"
#ARG BUILDCMDS=\
#"   cd /imagefs/usr/local "\
#"&& rm -rf bin "\
#"&& ln -sf ../../usr/* ./ "\
#"&& rm bin "\
#"&& mkdir bin "\
#"&& cd bin "\
#"&& ln -s ../../bin/* ./ "\
#"&& rm postgres"
#ARG EXECUTABLES="/usr/bin/postgres"

#---------------Don't edit----------------
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${BASEIMAGE:-huggla/base} as base
FROM huggla/build as build
FROM ${BASEIMAGE:-huggla/base} as image
COPY --from=build /imagefs /
#-----------------------------------------

#---------------Don't edit----------------
USER starter
ONBUILD USER root
ONBUILD RUN chmod u+s /usr/local/bin/sudo \
         && chmod go= /environment \
         && chmod -R o= /start /etc/sudoers* /usr/lib/sudo /tmp \
         && chmod u=rx,go= /start/stage1 /start/stage2 \
         && chmod -R g=r,o= /stop \
         && chmod g=rx /stop /stop/functions \
         && chmod u=rwx,g=rx /stop/stage1
#-----------------------------------------
