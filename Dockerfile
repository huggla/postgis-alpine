FROM mdillon/postgis:10-alpine

VOLUME /avolume
WORKDIR /avolume
RUN echo hello > /avolume/hello
