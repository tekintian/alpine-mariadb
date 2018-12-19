docker run -it -d --name amtest -v /diy:/diy -v /Bitbucket:/Bitbucket -p 3313:3306 tekintian/alpine



cd /tmp
wget https://github.com/jemalloc/jemalloc/archive/5.1.0.tar.gz -O jemalloc-5.1.0.tar.gz
tar zxvf jemalloc-5.1.0.tar.gz
cd jemalloc-5.1.0
./configure
make && make install


安装完成后还需执行：

echo '/usr/local/lib' > /etc/ld.so.conf.d/local.conf
/sbin/ldconfig #更新ld
/sbin/ldconfig -v #查询更新后的ld

安装其他依赖：
apk add gcc make cmake autoconf libtool libltdl gd-dev freetype-dev libjpeg-turbo-dev libpng-dev curl-dev bison patch unzip libmcrypt-dev libmhash-dev flex libaio-dev libcurl libarchive-dev boost boost-dev ncurses-dev libxml2-dev openssl-dev libaio-dev libcurl libarchive-dev jemalloc jemalloc-dev



apk add gcc make cmake autoconf ncurses-dev libxml2-dev openssl-dev curl-dev bison libaio-dev libcurl libarchive-dev boost boost-dev jemalloc jemalloc-dev libjpeg-turbo-dev libpng-dev libtool libltdl gd-dev freetype-dev 


 apk add autoconf \
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
       jemalloc jemalloc-dev \
        pkgconf \
        re2c


 cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
    -DMYSQL_DATADIR=/usr/local/mysql/data \
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
    -DCMAKE_EXE_LINKER_FLAGS='-ljemalloc'
    make -j ${THREAD}








如果你需要更改默认的配置，可以在cmake后添加编译参数，如：

-DCMAKE_INSTALL_PREFIX=/usr/local/mysql # 安装根目录 
-DMYSQL_DATADIR=/usr/local/mysql/data # 数据存储目录 
-DTMPDIR=/usr/local/mysql/tmp # 临时文件存放目录
-DMYSQL_UNIX_ADDR=/usr/local/mysql/run/mysqld.sock # UNIX socket文件 
-DSYSCONFDIR=/etc #配置文件存放目录
-DWITH_MYISAM_STORAGE_ENGINE=1 # Myisam 引擎支持 
-DWITH_INNOBASE_STORAGE_ENGINE=1  # innoDB 引擎支持 
-DWITH_ARCHIVE_STORAGE_ENGINE=1 # ARCHIVE 引擎支持 
-DWITH_BLACKHOLE_STORAGE_ENGINE=1  # BLACKHOLE 引擎支持 
-DWITH_PERFSCHEMA_STORAGE_ENGINE=1 # PERFSCHEMA 引擎支持 
-DWITH_FEDERATED_STORAGE_ENGINE=1  # FEDERATEDX 引擎支持 
-DWITH_TOKUDB_STORAGE_ENGINE=1 # TOKUDB 引擎支持
-DWITH_XTRADB_STORAGE_ENGINE=1  # XTRADB 引擎支持
-DWITH_ARIA_STORAGE_ENGINE=1 # ARIA 引擎支持 
-DWITH_PARTITION_STORAGE_ENGINE=1 # PARTITION 引擎支持 
-DWITH_SPHINX_STORAGE_ENGINE=1 # SPHINX 引擎支持 
-DWITH_READLINE=1 # readline库 
-DMYSQL_TCP_PORT=3306 # TCP/IP端口 
-DENABLED_LOCAL_INFILE=1  #启用加载本地数据 
-DWITH_EXTRA_CHARSETS=all # 扩展支持编码 ( all | utf8,gbk,gb2312 | none ) 
-DEXTRA_CHARSETS=all all # 扩展字符支持 
-DDEFAULT_CHARSET=utf8 # 默认字符集 
-DDEFAULT_COLLATION=utf8_general_ci # 默认字符校对 
-DCMAKE_EXE_LINKER_FLAGS='-ljemalloc' #Jemalloc内存管理库
-DWITH_SAFEMALLOC=OFF #关闭默认内存管理
-DWITH_DEBUG=0
-DENABLE_PROFILING=1
-DWITH_SSL=system
-DWITH_ZLIB=system
-DWITH_LIBWRAP=0


然后执行make&&make install进行安装，至此安装过程就已经完毕了，默认的安装位置在：/usr/local/man> 即可。安装完成后自动注册了服务。可以使用

systemctl start mariadb #启动mariadb
systemctl enable mariadb #设置开机自动启动mariadb
3、配置及使用

添加mysql用户：

groupadd mysql
useradd -g mysql mysql -s /sbin/nologin
chown mysql:mysql /usr/local/mysql/ -R


mkdir /var/log/mariadb


2
cd /usr/local/mysql/
scripts/mysql_install_db --user=mysql


ln -s /var/lib/mysql/mysql.sock /tmp/mysql.sock

重启mysql以后即可正常使用。再执行./bin/mysql_secure_installation 操作。如嫌每次转到/usr/local/mysql执行比较麻烦，可以在环境变量中新增如下信息：

export PATH=/usr/local/mysql/bin/:$PATH

