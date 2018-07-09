FROM huggla/postgres-alpine as stage1

USER root

# Build-only variables
ENV POSTGIS_VERSION="2.4.4" \
    GDAL_VERSION="2.3.0-r0"

COPY ./initdb /rootfs/initdb

RUN downloadDir="$(mktemp -d)" \
 && wget -O "$downloadDir/postgis.tar.gz" "https://github.com/postgis/postgis/archive/$POSTGIS_VERSION.tar.gz" \
 && buildDir="$(mktemp -d)" \
 && tar --extract --file "$downloadDir/postgis.tar.gz" --directory "$buildDir" --strip-components 1 \
 && rm -rf "$downloadDir" \
 && apk add --no-cache --virtual .build-deps autoconf automake g++ json-c-dev libtool libxml2-dev make perl \
 && apk add --no-cache --virtual .build-deps-testing --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing --allow-untrusted gdal-dev=$GDAL_VERSION geos-dev proj4-dev protobuf-c-dev \
 && cd "$buildDir" \
 && ./autogen.sh \
 && ./configure \
 && make \
 && make install \
 && apk add --no-cache --virtual .postgis-rundeps json-c \
 && apk add --no-cache --virtual .postgis-rundeps-testing --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing --allow-untrusted geos gdal=$GDAL_VERSION proj4 protobuf-c \
 && cd / \
 && rm -rf "$buildDir" \
 && apk del .build-deps .build-deps-testing \
 && tar -cpf /installed_files.tar $(apk manifest .postgis-rundeps .postgis-rundeps-testing | awk -F "  " '{print $2;}') \
 && tar -xpf /installed_files.tar -C /rootfs/

FROM huggla/postgres-alpine

USER root

COPY --from=stage1 /rootfs / 

USER starter
