FROM mdillon/postgis:10-alpine

VOLUME /avolume
WORKDIR /avolume/subdir
COPY ./Dockerfile /avolume/subdir/Dockerfile
RUN echo hello > /avolume/subdir/Dockerfile
