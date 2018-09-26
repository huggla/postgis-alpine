FROM huggla/alpine-slim:20180921-edge as stage1
FROM huggla/postgres-alpine:20180921-edge

ARG POSTGIS_VERSION="2.4.4"

COPY ./initdb /initdb
COPY --from=stage1 /sbin/apk /sbin/apk
COPY --from=stage1 /lib/apk /lib/apk
COPY --from=stage1 /etc/apk /etc/apk

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && downloadDir="$(mktemp -d)" \
 && /usr/bin/wget -O "$downloadDir/postgis.tar.gz" "https://github.com/postgis/postgis/archive/$POSTGIS_VERSION.tar.gz" \
 && buildDir="$(mktemp -d)" \
 && /bin/tar --extract --file "$downloadDir/postgis.tar.gz" --directory "$buildDir" --strip-components 1 \
 && /bin/rm -rf "$downloadDir" \
 && /sbin/apk add --no-cache --virtual .build-deps autoconf automake g++ json-c-dev libtool libxml2-dev make perl pcre-dev \
 && /sbin/apk add --no-cache --virtual .build-deps-testing --allow-untrusted gdal-dev geos-dev proj4-dev protobuf-c-dev \
 && cd "$buildDir" \
 && ./autogen.sh \
 && ./configure \
 && /usr/bin/make \
 && /usr/bin/make install \
 && /sbin/apk add --no-cache --virtual .postgis-rundeps json-c pcre \
 && /sbin/apk add --no-cache --virtual .postgis-rundeps-testing --allow-untrusted geos gdal proj4 protobuf-c \
 && cd / \
 && /bin/rm -rf "$buildDir"

USER starter
