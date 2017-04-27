FROM mdillon/postgis:9.6-alpine

RUN apk --no-cache add openssh

ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=password

RUN echo "$POSTGRES_USER:$POSTGRES_PASSWORD" | chpasswd

USER $POSTGRES_USER

ENV LANG sv_SE.utf8
