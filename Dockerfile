FROM mdillon/postgis:10-alpine

VOLUME /avolume
WORKDIR /avolume/subdir
RUN chown nobody /avolume/subdir && touch /avolume/subdir/file
