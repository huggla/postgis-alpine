FROM postgres:alpine

RUN apk --no-cache add ssh

ENV LANG sv_SE.utf8
