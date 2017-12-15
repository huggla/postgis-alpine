FROM mdillon/postgis:10-alpine

VOLUME /avolume
WORKDIR /avolume/subdir
RUN echo hello > /avolume/subdir/hello
