FROM ubuntu:14.04

RUN apt-get update; \
	apt-get install -yq \
        	apache2 \
	        libapache2-mod-php5 \
                curl \
	       	php5-gd \
	        php5-curl \
	       	php-pear \
	        php5-dev \
		libcurl4-openssl-dev \
		expect-dev \
		php5-sqlite \
		php-apc \
                wget ; \
	pecl install expect; \
	echo "extension=expect.so" >> /etc/php5/apache2/php.ini; \
	rm -rf /var/lib/apt/lists/*; \
	echo "ServerName localhost" >> /etc/apache2/apache2.conf; \
        sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini;


COPY httpd-foreground /usr/bin/
RUN chmod 755 /usr/bin/httpd-foreground
CMD ["/usr/bin/httpd-foreground"]

EXPOSE 80
