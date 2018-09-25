FROM huggla/postgres-alpine:20180921-edge as stage1
FROM huggla/alpine-slim:20180921-edge as stage2

ARG POSTGIS_VERSION="2.4.4"

COPY --from=stage1 / /
COPY ./rootfs /rootfs

RUN rm -rf /usr/local/bin/sudo /usr/lib/sudo \
 && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk add --no-cache --allow-untrusted json-c geos gdal proj4 protobuf-c \
 && apk --no-cache --quiet info > /apks.list \
 && apk --no-cache --quiet manifest $(cat /apks.list) | awk -F "  " '{print $2;}' > /apks_files.list \
 && tar -cvp -f /apks_files.tar -T /apks_files.list -C / \
 && tar -xvp -f /apks_files.tar -C /rootfs/ \
 && apk add --no-cache --virtual .build-deps autoconf automake g++ json-c-dev libtool libxml2-dev make perl ssl_client \
 && apk add --no-cache --virtual .build-deps-testing --allow-untrusted gdal-dev geos-dev proj4-dev protobuf-c-dev \
 && downloadDir="$(mktemp -d)" \
 && wget -O "$downloadDir/postgis.tar.gz" "https://github.com/postgis/postgis/archive/$POSTGIS_VERSION.tar.gz" \
 && buildDir="$(mktemp -d)" \
 && tar --extract --file "$downloadDir/postgis.tar.gz" --directory "$buildDir" --strip-components 1 \
 && rm -rf "$downloadDir" \
 && cd "$buildDir" \
 && ./autogen.sh \
 && ./configure --prefix=/usr/local --with-includes=/usr/local/include --with-libraries=/usr/local/lib \
 && make \
 && make install \
 && cd / \
 && find -name postgis.control \
 && rm -rf "$buildDir" \
 && mkdir -p /rootfs/usr \
 && cp -a /usr/local /usr/lib /rootfs/usr/ \
 && apk del .build-deps .build-deps-testing

FROM huggla/postgres-alpine:20180921-edge

COPY --from=stage2 /rootfs / 

USER starter

ONBUILD USER root
