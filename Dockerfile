#
# This is the alpine linux work with Mariadb/mysql docker images
# @author tekintian
# @url http://github.com/tekintian/alpine-mariadb
# @apk https://pkgs.alpinelinux.org/package/edge/main/s390x/mysql
# @Project	http://www.mariadb.org

FROM tekintian/alpine:3.8

LABEL maintainer="TekinTian <tekintian@gmail.com>"

#set TimeZone
ARG TZ="Asia/Shanghai"
ENV TZ ${TZ}

RUN apk update && \
	apk add mysql mysql-client && \
	addgroup mysql mysql && \
	mkdir /scripts && \
	rm -rf /var/cache/apk/*

VOLUME ["/var/lib/mariadb"]

COPY ./startup.sh /scripts/startup.sh
RUN chmod +x /scripts/startup.sh

EXPOSE 3306

ENTRYPOINT ["/scripts/startup.sh"]