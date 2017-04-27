FROM postgres:alpine

RUN apk --no-cache add openssh

ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=password

RUN echo "$POSTGRES_USER:$POSTGRES_PASSWORD" | chpasswd

USER $POSTGRES_PASSWORD

ENV LANG sv_SE.utf8
