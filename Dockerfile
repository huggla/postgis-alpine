ARG ADDREPOS="http://dl-cdn.alpinelinux.org/alpine/edge/testing"
ARG RUNDEPS_UNTRUSTED="postgis"

FROM huggla/busybox as init
FROM huggla/build as build
FROM huggla/base as image

