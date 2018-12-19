#
# This is the alpine linux work with mariadb docker images dockerfile
# @author tekintian
# @url http://github.com/tekintian/alpine-mariadb
# @MariadbRelease  https://downloads.mariadb.org/mariadb/+releases/
#

FROM tekintian/alpine:3.8

# https://mirrors.shu.edu.cn/mariadb/mariadb-10.3.11/source/mariadb-10.3.11.tar.gz

ENV MARIADB_VERSION 10.3.11
ENV MARIADB_URL="https://mirrors.shu.edu.cn/mariadb/mariadb-$MARIADB_VERSION/source/mariadb-$MARIADB_VERSION.tar.gz"

# add the mysql boost compile
ADD src/boost_1_59_0.xz /tmp/boost_1_59_0.xz

# dependencies required for building
ENV MYSQL_DEPS \
		autoconf \
		dpkg-dev dpkg \
		file \
		g++ \
		gcc \
		libc-dev \
		cmake \
		make \
		ncurses-dev \
		gnutls-dev \
		bison \
		git \
		libxml2-dev \
		libxml2 \
		\
		openssl-dev \
        libaio-dev \
        libcurl libarchive-dev \
        boost boost-dev \
        libaio-dev \
        libarchive-dev \
        jemalloc-dev \
		pkgconf \
		re2c

# persistent / runtime deps
RUN apk add --no-cache --virtual .persistent-deps \
		tar \
		xz \
		jemalloc \
		libcurl

# ensure www-data user exists
RUN set -x \
	&& addgroup -g 503 -S mysql \
	&& adduser -u 503 -D -S -G mysql mysql


RUN set -xe; \
	\
	apk add --no-cache --virtual .fetch-deps \
		gnupg \
		wget \
	; \
	\
	cd /tmp/ ; \
	tar -Jxf boost_1_59_0.xz; \
	wget -O mariadb-$MARIADB_VERSION.tar.gz "$PHP_URL"; \
	tar -zxf mariadb-$MARIADB_VERSION.tar.gz; \
	\
	apk del .fetch-deps


RUN set -xe \
	&& apk add --no-cache --virtual .build-deps \
		$MYSQL_DEPS \
		argon2-dev \
		coreutils \
		curl-dev \
		libedit-dev \
		jemalloc-dev \
	\
# .build-deps end
	\
	&& cd /tmp/mariadb-$MARIADB_VERSION \
	&& cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mariadb \
    -DMYSQL_DATADIR=/usr/local/mariadb/data \
    -DDOWNLOAD_BOOST=1 \
    -DWITH_BOOST=../boost_1_59_0 \
    -DSYSCONFDIR=/etc \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    -DWITH_PARTITION_STORAGE_ENGINE=1 \
    -DWITH_FEDERATED_STORAGE_ENGINE=1 \
    -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
    -DWITH_MYISAM_STORAGE_ENGINE=1 \
    -DWITH_EMBEDDED_SERVER=1 \
    -DENABLE_DTRACE=0 \
    -DENABLED_LOCAL_INFILE=1 \
    -DDEFAULT_CHARSET=utf8mb4 \
    -DDEFAULT_COLLATION=utf8mb4_general_ci \
    -DEXTRA_CHARSETS=all \
    -DCMAKE_EXE_LINKER_FLAGS='-ljemalloc' \
    && make -j 2 \
	&& make -j "$(nproc)" \
	&& make install \
	&& make clean \
	\
	&& apk add --no-cache --virtual .mysql-rundeps $runDeps \
	\
	&& apk del .build-deps \
	\
	&& rm -rf /tmp/* \
	&& chown mysql.mysql -R /usr/local/mariadb

# configuration
COPY conf/my.cnf /etc/my.cnf
COPY bin/startup.sh /usr/local/mariadb/startup.sh

#ENTRYPOINT ["/usr/local/mariadb/startup.sh"]

EXPOSE 9000
VOLUME /usr/local/mariadb/data
WORKDIR /usr/local/mariadb

CMD ["/usr/local/mariadb/startup.sh"]