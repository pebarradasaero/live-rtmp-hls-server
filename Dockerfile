FROM ubuntu:latest
MAINTAINER pebarradas

ENV NGINX_VERSION 1.17.8


RUN	apt-get update && apt-get upgrade
RUN	DEBIAN_FRONTEND=noninteractive apt-get install git build-essential libpcre3 libpcre3-dev libssl-dev apt-utils zlib1g-dev wget stunnel4 apt-utils -y

# Clean up APT when done.
RUN 	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN	cd /tmp/									&&	\
	wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz			&&	\
	git clone https://github.com/arut/nginx-rtmp-module.git

RUN	cd /tmp										&&	\
	tar xzf nginx-${NGINX_VERSION}.tar.gz						&&	\
	cd nginx-${NGINX_VERSION}							&&	\
	./configure																	--with-http_ssl_module								\
		--add-module=../nginx-rtmp-module					&&	\
	make										&&	\
	make install

RUN	mkdir /usr/local/nginx/html/hls


ADD nginx.conf /usr/local/nginx/conf/
ADD stat.xsl /usr/local/nginx/html/
ADD crossdomain.xml /usr/local/nginx/html/
ADD index.html /usr/local/nginx/html/
ADD stunnel4 /etc/default/stunnel4
ADD stunnel.conf /etc/stunnel/


EXPOSE 1935
EXPOSE 80

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
