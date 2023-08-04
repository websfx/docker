# 使用一个阶段为构建器，用于编译和安装Nginx
FROM alpine:3.18 AS builder

LABEL maintainer="sunwei<service@fooher.com>" version="1.0" license="MIT" app.name="YunWei Nginx" description="Portlands Nginx HTTP/2"

ENV NGINX_VERSION=1.25.1 \
    OPENSSL_VERSION=1.1.1u \
    PCRE_VERSION=8.45 \
    ZLIB_VERSION=1.2.13 \
    JEMALLOC_VERSION=5.3.0 \
    WWW_LOGS=/data/wwwlogs \
    LOGS_DIR=/data/logs \
    NGINX_LOGS=/data/nginxlogs \
    wwwroot=/www/default \
    INSTALL_NGINX=/usr/local/nginx \
    LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}

# 有空添加这些模块
#  ngx_http_geoip_module.so
#  ngx_http_js_module-debug.so
#  ngx_http_xslt_filter_module.so
#  ngx_http_image_filter_module-debug.so
#  ngx_http_js_module.so
#  ngx_stream_js_module.so
#  ngx_stream_js_module-debug.so
#  ngx_stream_geoip_module.so
#  ngx_stream_geoip_module-debug.so
#  ngx_http_image_filter_module.so
#  ngx_http_xslt_filter_module-debug.so

# 下载Nginx源码并解压
#RUN cd /tmp \
#  && curl -fSL http://mirrors.linuxeye.com/oneinstack/src/openssl-${OPENSSL_VERSION}.tar.gz \
#  && curl -fSL https://ghproxy.com/https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
#  && git clone https://ghproxy.com/https://github.com/FRiCKLE/ngx_cache_purge.git  /tmp/ngx_cache_purge \
#  && git clone https://ghproxy.com/https://github.com/xiaokai-wang/nginx_upstream_check_module.git /tmp/nginx_upstream_check_module \
#  && git clone https://ghproxy.com/https://github.com/evanmiller/mod_zip.git /tmp/mod_zip \
#  && wget https://github.com/yaoweibin/ngx_http_substitutions_filter_module/archive/refs/heads/master.tar.gz -O nginx_substitutions_filter.tar.gz \
#  && git clone https://ghproxy.com/https://github.com/wdaike/ngx_upstream_jdomain.git /tmp/ngx_upstream_jdomain \
#  && git clone https://ghproxy.com/https://github.com/GUI/nginx-upstream-dynamic-servers.git /tmp/nginx-upstream-dynamic-servers \
#  && git clone https://ghproxy.com/https://github.com/vozlt/nginx-module-vts.git /tmp/nginx-module-vts \
#  && git clone https://ghproxy.com/https://github.com/openresty/echo-nginx-module.git /tmp/echo-nginx-module \
#  && git clone  https://ghproxy.com/https://github.com/nginx/njs.git \
#  && git clone https://ghproxy.com/https://github.com/aperezdc/ngx-fancyindex.git /tmp/ngx-fancyindex \
#  && git clone https://ghproxy.com/https://github.com/simon987/ngx_http_js_challenge_module.git \
#  && curl -fSL https://netix.dl.sourceforge.net/project/pcre/pcre/${PCRE_VERSION}/pcre-${PCRE_VERSION}.tar.gz \
#  && wget http://mirrors.linuxeye.com/oneinstack/src/jemalloc-${JEMALLOC_VERSION}.tar.bz2 \
#  && wget http://www.zlib.net/zlib-${ZLIB_VERSION}.tar.gz \
#  && wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
#  && tar xzf zlib-${ZLIB_VERSION}.tar.gz \
#  && tar xzf openssl-$OPENSSL_VERSION.tar.gz \
#  && tar xzf nginx-${NGINX_VERSION}.tar.gz

ADD moudle/ /tmp/

## Build nginx
RUN set -ex \
  # 对Apk镜像源使用清华大学的镜像站以加速安装过程
  && sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/' /etc/apk/repositories \
  && apk add --no-cache \
      libtool \
      gnupg \
      libc-dev \
      openssl-dev \
      pcre-dev \
      zlib-dev \
      gd-dev \
      geoip-dev \
      libedit-dev \
      alpine-sdk \
      build-base \
      linux-headers \
      certbot \
      perl-dev \
      libxslt-dev \
      curl \
      libgcc \
      musl \
      libc6-compat \
      bash \
      findutils \
      pcre2-dev \
      libxml2-dev \
  # 进入到Nginx源码目录，配置编译选项，编译并安装
  && cd /tmp/ \
  && tar zxf nginx_substitutions_filter.tar.gz  \
  && tar zxf nginx-${NGINX_VERSION}.tar.gz \
  && tar xzf openssl-$OPENSSL_VERSION.tar.gz \
  && tar xzf zlib-${ZLIB_VERSION}.tar.gz \
  && tar xzf pcre-${PCRE_VERSION}.tar.gz \
  && tar xjf jemalloc-${JEMALLOC_VERSION}.tar.bz2 \
  && cd jemalloc-${JEMALLOC_VERSION} \
  && ./configure \
  && make -j$(getconf _NPROCESSORS_ONLN) \
  && make install \
  && ln -s /usr/local/lib/libjemalloc.so.2 /usr/lib/libjemalloc.so.1 \
  && cd /tmp/nginx-${NGINX_VERSION} \
  # close debug
  && sed -i 's@CFLAGS="$CFLAGS -g"@#CFLAGS="$CFLAGS -g"@' auto/cc/gcc \
  && sed -i 's@#define NGINX_VER.*NGINX_VERSION$@#define NGINX_VER          "AlphaStage/" NGINX_VERSION@' src/core/nginx.h \
  && sed -i 's@Server: nginx@Server: AlphaStage@' src/http/ngx_http_header_filter_module.c \
  # https://www.hxstrive.com/subject/nginx/789.htm
  && ./configure \
        --prefix=${INSTALL_NGINX} \
        --sbin-path=${INSTALL_NGINX}/sbin/nginx \
        --user=www \
        --group=www \
        --with-compat \
        --with-http_ssl_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_geoip_module=dynamic \
        --with-http_image_filter_module=dynamic \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_stub_status_module \
        --with-http_auth_request_module \
        --with-http_v2_module \
        --with-http_slice_module \
        --with-threads \
        --with-mail \
        --with-mail_ssl_module \
        --with-file-aio \
        --with-ipv6 \
        --with-stream \
        --with-stream_ssl_module \
        --with-stream_realip_module \
        --with-stream_ssl_preread_module \
        --with-pcre-jit \
        --with-pcre=/tmp/pcre-${PCRE_VERSION} \
        --with-zlib=/tmp/zlib-${ZLIB_VERSION} \
        --with-openssl=/tmp/openssl-${OPENSSL_VERSION} \
        --with-ld-opt='-ljemalloc' \
        --with-openssl-opt=enable-tls1_3 \
        --add-module=/tmp/echo-nginx-module \
        --add-module=/tmp/nginx_upstream_check_module \
        --add-module=/tmp/mod_zip \
        --add-module=/tmp/ngx_cache_purge \
        --add-module=/tmp/ngx_upstream_jdomain \
        --add-module=/tmp/nginx-upstream-dynamic-servers \
        --add-module=/tmp/ngx-fancyindex \
        --add-module=/tmp/ngx_http_substitutions_filter_module-master \
        --add-module=/tmp/njs/nginx \
  && make -j 4 \
  && make install \
  && rm -rf /tmp/* \
  && sed -i '1iload_module /usr/lib/nginx/modules/ngx_http_subs_filter_module.so;\n' ${INSTALL_NGINX}/conf/nginx.conf \
  && if [ -f "${INSTALL_NGINX}/conf/nginx.conf" ]; then /bin/cp -R "${INSTALL_NGINX}/conf/nginx.conf" ${INSTALL_NGINX}/conf/nginx.conf_bk; fi:对Apk镜像源使用清华大学的镜像站以加速安装过程

# 创建新镜像
FROM alpine:3.18

ENV JEMALLOC_VERSION=5.3.0 \
    WWW_LOGS=/data/wwwlogs \
    LOGS_DIR=/data/logs \
    NGINX_LOGS=/data/nginxlogs \
    wwwroot=/www/default \
    INSTALL_NGINX=/usr/local/nginx \
    LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH} \
    # 设置环境变量，将Nginx的sbin路径加入到系统PATH变量中
    PATH=/usr/local/nginx/sbin:$PATH

#  创建www用户和www组，前提验证用户名不存在
 RUN getent passwd www >/dev/null ||\
    addgroup -g 1000 www && \
    adduser -D -u 1000 -s /sbin/nologin -G www www

ADD moudle/jemalloc-${JEMALLOC_VERSION}.tar.bz2 /tmp
# 使用单个 RUN 语句进行镜像配置
RUN set -ex \
  && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/' /etc/apk/repositories \
  && sed -i  's#root:x:0:0:root:\/root:\/bin\/ash#root:x:0:0:root:\/root:\/bin\/bash#g' /etc/passwd \
  && apk update \
  && apk upgrade \
  && apk add --no-cache \
    libressl \
    zlib \
    libltdl \
    curl \
    vim \
    certbot \
    tar \
    ca-certificates \
    bash \
    bash-completion \
    libgcc \
    libxml2-dev \
    musl \
    libc6-compat \
  && apk add --no-cache --virtual .build-deps tzdata alpine-sdk build-base  \
  && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo "Asia/Shanghai" > /etc/timezone \
  && mkdir -p ${INSTALLED_NGINX}/conf/rewrite \
  && mkdir -p ${INSTALLED_NGINX}/conf/vhost \
  && mkdir -p ${INSTALLED_NGINX}/conf/ssl \
  && mkdir -p ${WWW_LOGS} ${LOGS_DIR} ${NGINX_LOGS} ${wwwroot} \
  # 修改配置文件和数据文件的权限
  && chown www:www -R ${INSTALLED_NGINX} ${WWW_LOGS} ${NGINX_LOGS} ${wwwroot} \
  && cd /tmp/jemalloc-${JEMALLOC_VERSION} \
  && ./configure \
  && make -j$(getconf _NPROCESSORS_ONLN) \
  && make install \
  && ln -sf /usr/local/lib/libjemalloc.so.2 /usr/lib/libjemalloc.so.1 \
  && echo "ulimit -HSn 65535" >> /etc/profile \
  && echo "ulimit -HSu 65535" >> /etc/profile \
  && echo "export LD_LIBRARY_PATH=/usr/local/lib" >> /etc/profile \
  && source /etc/profile \
  && rm -rf /tmp/* \
  && mkdir -p /root/.pip \
  && echo -e "[global]\nindex-url = https://pypi.tuna.tsinghua.edu.cn/simple\n\n[install]\ntrusted-host = pypi.tuna.tsinghua.edu.cn\n\n[list]\nformat=columns" >/root/.pip/pip.conf \
  && apk del .build-deps

RUN if grep -q "hosts: files dns" /etc/nsswitch.conf; then \
    echo "已经存在'hosts: files dns'"; \
  else \
    echo "hosts: files dns" >> /etc/nsswitch.conf; \
  fi

# 复制构建好的Nginx至新Alpine容器
COPY --from=builder ${INSTALL_NGINX} ${INSTALL_NGINX}
COPY --from=builder ${INSTALL_NGINX}/conf ${INSTALL_NGINX}/conf_bk

## 移除明文存储在镜像中的敏感文件
COPY ssl/ ${INSTALL_NGINX}/conf/ssl
# 使用 Docker Secret 或 配置映射来存储 SSL 证书
RUN chmod 400 ${INSTALL_NGINX}/conf/ssl/container.pem

COPY rewrite/ ${INSTALL_NGINX}/conf/rewrite
COPY default/ /www/default
COPY ps.sh /etc/profile.d

COPY conf/default.conf ${INSTALL_NGINX}/conf/vhost/default.conf
COPY conf/fastcgi.conf ${INSTALL_NGINX}/conf/fastcgi.conf
COPY conf/fastcgi_params ${INSTALL_NGINX}/conf/fastcgi_params
COPY conf/fastcgi-php.conf ${INSTALL_NGINX}/conf/fastcgi-php.conf
COPY conf/logrotate_nginx ${INSTALL_NGINX}/conf/logrotate_nginx
COPY conf/mime.types ${INSTALL_NGINX}/conf/mime.types
COPY conf/nginx.conf ${INSTALL_NGINX}/conf/nginx.conf
COPY conf/proxy.conf ${INSTALL_NGINX}/conf/proxy.conf
COPY conf/uwsgi_params ${INSTALL_NGINX}/conf/uwsgi_params
ADD ./modules/ /usr/local/nginx/modules/

# 修改nginx的配置文件以满足需求
#RUN sed -i 's/user nginx;/user www www;/' /etc/nginx/nginx.conf
#RUN sed -i 's/server_name _;/server_name _; listen [::]:80 default_server;/' /etc/nginx/conf.d/default.conf

# 设置工作目录
WORKDIR /www

EXPOSE 80 443

SHELL ["/bin/bash", "-c", "source /etc/profile"]

# 使用 ENTRYPOINT 启动 Nginx
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]

# 构建镜像
#   docker build . -t openresty:base
#   docker build . -t openresty:syh
#   docker build -t alpine/openresty:syh .

#   检查配置文件
#   docker exec -ti openresty_base_v1_syh nginx -t -c /usr/local/openresty/nginx/conf/nginx.conf
#   docker exec -ti openresty_base_v1_syh cat /usr/local/openresty/nginx/conf/nginx.conf
#   docker exec -ti openresty_base_v1_syh nginx -v