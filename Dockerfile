FROM huggla/postgres-alpine

USER root

COPY ./initdb "$CONFIG_DIR/initdb"

ENV POSTGIS_VERSION="2.4.3" \
    POSTGIS_SHA256="b9754c7b9cbc30190177ec34b570717b2b9b88ed271d18e3af68eca3632d1d95"

RUN /sbin/apk add --no-cache --virtual .fetch-deps ca-certificates openssl tar \
 && /usr/bin/wget -O postgis.tar.gz "https://github.com/postgis/postgis/archive/$POSTGIS_VERSION.tar.gz" \
 && echo "$POSTGIS_SHA256 *postgis.tar.gz" | /usr/bin/sha256sum -c - \
 && /bin/mkdir -p /usr/src/postgis \
 && /bin/tar --use-compress-program=/bin/gzip --extract --file postgis.tar.gz --directory /usr/src/postgis --strip-components 1 \
 && /bin/rm postgis.tar.gz \
 && /sbin/apk add --no-cache --virtual .build-deps autoconf automake g++ json-c-dev libtool libxml2-dev make perl \
 && /sbin/apk add --no-cache --virtual .build-deps-testing --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing gdal-dev geos-dev proj4-dev protobuf-c-dev \
 && cd /usr/src/postgis \
 && ./autogen.sh \
# configure options taken from:
# https://anonscm.debian.org/cgit/pkg-grass/postgis.git/tree/debian/rules?h=jessie
 && ./configure \
#       --with-gui \
 && /usr/bin/make \
 && /usr/bin/make install \
 && /sbin/apk add --no-cache --virtual .postgis-rundeps json-c \
 && /sbin/apk add --no-cache --virtual .postgis-rundeps-testing --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing geos gdal proj4 protobuf-c \
 && cd / \
 && /bin/rm -rf /usr/src/postgis \
 && /sbin/apk del .fetch-deps .build-deps .build-deps-testing \
 && /bin/chown -R root:$BEV_NAME "$CONFIG_DIR/initdb" \
 && /bin/chmod -R u=rwX,g=rX,o= "$CONFIG_DIR/initdb"

USER sudoer
