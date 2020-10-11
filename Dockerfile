FROM wordpress:php7.2-fpm

ARG DEBUG_IP=host.docker.internal

RUN apt update && apt install openssh-server libxml2-dev libmemcached-tools memcached zlib1g-dev libpq-dev libmemcached-dev vim nginx -y \
    && echo '' | pecl install memcached && docker-php-ext-enable memcached \
    && pecl install xdebug && docker-php-ext-enable xdebug && docker-php-ext-install soap

RUN echo 'Port 			2222\n\
ListenAddress 		0.0.0.0\n\
LoginGraceTime 		180\n\
X11Forwarding 		yes\n\
Ciphers aes128-cbc,3des-cbc,aes256-cbc,aes128-ctr,aes192-ctr,aes256-ctr\n\
MACs hmac-sha1,hmac-sha1-96\n\
StrictModes 		yes\n\
SyslogFacility 		DAEMON\n\
PasswordAuthentication 	yes\n\
PermitEmptyPasswords 	no\n\
PermitRootLogin 	yes\n\
Subsystem sftp internal-sftp\n\
AllowUsers www-data root' > /etc/ssh/sshd_config

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN chsh -s /bin/bash www-data

EXPOSE 2222
EXPOSE 443

COPY memcached/memcached.conf /etc/memcached.conf
COPY php/ /usr/local/etc/

COPY nginx/default /etc/nginx/sites-available/

COPY wp-debug-init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wp-debug-init.sh

ENTRYPOINT /usr/local/bin/wp-debug-init.sh php-fpm