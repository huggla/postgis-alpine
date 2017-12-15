FROM mdillon/postgis:10-alpine

VOLUME /avolume/subdir
WORKDIR /avolume
COPY ./Dockerfile /avolume/subdir
