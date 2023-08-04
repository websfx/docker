# docker
Nginx 1.25.1 jemalloc
<pre>
nginx-1.25.1
zlib-1.2.13
jemalloc-5.3.0
openssl-1.1.1u
pcre-8.45
mod_zip
echo-nginx-module
nginx-module-vts
ngx_cache_purge
hsperfdata_logstash
ngx-fancyindex
hsperfdata_root
ngx_upstream_jdomain
nginx-upstream-dynamic-servers
nginx_upstream_check_module
</pre>

<pre>
NGINX_VERSION=1.25.1
OPENSSL_VERSION=1.1.1u
PCRE_VERSION=8.45
ZLIB_VERSION=1.2.13
JEMALLOC_VERSION=5.3.0

RUN cd /tmp \
git clone https://ghproxy.com/https://github.com/FRiCKLE/ngx_cache_purge.git  /tmp/ngx_cache_purge \
git clone https://ghproxy.com/https://github.com/xiaokai-wang/nginx_upstream_check_module.git /tmp/nginx_upstream_check_module \
git clone https://ghproxy.com/https://github.com/evanmiller/mod_zip.git /tmp/mod_zip \
git clone https://ghproxy.com/https://github.com/wdaike/ngx_upstream_jdomain.git /tmp/ngx_upstream_jdomain \
git clone https://ghproxy.com/https://github.com/GUI/nginx-upstream-dynamic-servers.git /tmp/nginx-upstream-dynamic-servers \
git clone https://ghproxy.com/https://github.com/vozlt/nginx-module-vts.git /tmp/nginx-module-vts \
git clone https://ghproxy.com/https://github.com/openresty/echo-nginx-module.git /tmp/echo-nginx-module \
git clone https://ghproxy.com/https://github.com/aperezdc/ngx-fancyindex.git /tmp/ngx-fancyindex \
curl -fSL https://netix.dl.sourceforge.net/project/pcre/pcre/${PCRE_VERSION}/pcre-${PCRE_VERSION}.tar.gz \
wget http://mirrors.linuxeye.com/oneinstack/src/jemalloc-${JEMALLOC_VERSION}.tar.bz2 \
curl -fSL http://mirrors.linuxeye.com/oneinstack/src/openssl-${OPENSSL_VERSION}.tar.gz \
curl -fSL https://ghproxy.com/https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
wget http://www.zlib.net/zlib-${ZLIB_VERSION}.tar.gz \
wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
tar xzf zlib-${ZLIB_VERSION}.tar.gz \
tar xzf openssl-$OPENSSL_VERSION.tar.gz \
tar xzf nginx-${NGINX_VERSION}.tar.gz
</pre>