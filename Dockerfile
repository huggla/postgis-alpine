FROM huggla/postgres-alpine as stage1

ARG POSTGIS_VERSION="2.4.4"

COPY ./rootfs /rootfs

RUN downloadDir="$(mktemp -d)" \
 && wget -O "$downloadDir/postgis.tar.gz" "https://github.com/postgis/postgis/archive/$POSTGIS_VERSION.tar.gz" \
 && buildDir="$(mktemp -d)" \
 && tar --extract --file "$downloadDir/postgis.tar.gz" --directory "$buildDir" --strip-components 1 \
 && rm -rf "$downloadDir" \
 && apk add --no-cache --virtual .build-deps autoconf automake g++ json-c-dev libtool libxml2-dev make perl \
 && apk add --no-cache --virtual .build-deps-testing --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing --allow-untrusted gdal-dev geos-dev proj4-dev protobuf-c-dev \
 && cd "$buildDir" \
 && ./autogen.sh \
 && ./configure \
 && make \
 && make install \
 && apk add --no-cache --virtual .postgis-rundeps json-c \
 && apk add --no-cache --virtual .postgis-rundeps-testing --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing --allow-untrusted geos gdal proj4 protobuf-c \
 && cd / \
 && rm -rf "$buildDir" \
 && apk del .build-deps .build-deps-testing \
 && tar -cvp -f /installed_files.tar -C / $(apk manifest json-c geos gdal proj4 protobuf-c | awk -F "  " '{print $2;}') \
 && tar -xvp -f /installed_files.tar -C /rootfs/

FROM huggla/postgres-alpine

COPY --from=stage1 /rootfs / 

USER starter

STOPSIGNAL SIGINT

ONBUILD USER root
