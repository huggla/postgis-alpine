FROM huggla/postgres-alpine:20180628-edge-python

USER root

# Build-only variables
ENV POSTGIS_VERSION="2.4.4"

COPY ./initdb /initdb

RUN downloadDir="$(mktemp -d)" \
 && /usr/bin/wget -O "$downloadDir/postgis.tar.gz" "https://github.com/postgis/postgis/archive/$POSTGIS_VERSION.tar.gz" \
 && buildDir="$(mktemp -d)" \
 && /bin/tar --extract --file "$downloadDir/postgis.tar.gz" --directory "$buildDir" --strip-components 1 \
 && /bin/rm -rf "$downloadDir" \
 && /sbin/apk add --no-cache --virtual .build-deps autoconf automake g++ json-c-dev libtool libxml2-dev make perl \
 && /sbin/apk add --no-cache --virtual .build-deps-testing --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing --allow-untrusted gdal-dev geos-dev proj4-dev protobuf-c-dev \
 && cd "$buildDir" \
 && ./autogen.sh \
 && ./configure \
 && /usr/bin/make \
 && /usr/bin/make install \
 && /sbin/apk add --no-cache --virtual .postgis-rundeps json-c \
 && /sbin/apk add --no-cache --virtual .postgis-rundeps-testing --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing --allow-untrusted geos gdal proj4 protobuf-c \
 && cd / \
 && /bin/rm -rf "$buildDir" \
 && /sbin/apk del .build-deps .build-deps-testing

USER starter
