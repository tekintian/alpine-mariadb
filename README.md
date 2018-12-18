Docker + Alpine-3.8 + Mysql/MariaDB-10.3.10-r1

#### parameter

* `MYSQL_ROOT_PWD` : root Password   default "mariadb888"
* `MYSQL_USER`     : new User
* `MYSQL_USER_PWD` : new User Password
* `MYSQL_USER_DB`  : new Database for new User

Default time zone Asia/Shanghai, work with your time zone , add envirement  -e TZ=YOUR TIMEZONE

For more info about [TIME ZONE](https://timezonedb.com/time-zones)

#### build image

```
$ docker build -t tekintian/alpine-mariadb .
```

#### run a default contaier

```
$ docker run --name mariadb -v /mariadb/data/:/var/lib/mysql -d -p 3306:3306 tekintian/alpine-mariadb
```

#### run a container with new User and Password

```
$ docker run --name mariadb -v /mariadb/data/:/var/lib/mysql -d -p 3306:3306 -e MYSQL_ROOT_PWD=123 -e MYSQL_USER=dev -e MYSQL_USER_PWD=dev tekintian/alpine-mariadb
```

#### run a container with new Database for new User and Password

```
$ docker run --name mariadb -v /mariadb/data/:/var/lib/mysql -d -p 3306:3306 -e MYSQL_ROOT_PWD=123 -e MYSQL_USER=dev -e MYSQL_USER_PWD=dev -e MYSQL_USER_DB=userdb tekintian/alpine-mariadb
```

#### RUN a container with your [TIME ZONE](https://timezonedb.com/time-zones)
