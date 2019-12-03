FROM php:7.4-fpm-alpine3.10
 
# Install PDO MySQL driver
# See https://github.com/docker-library/php/issues/62

COPY php.ini /usr/local/etc/php/php.ini

RUN echo "http://dl-3.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories

RUN apk update --update && apk add --update --no-cache icu-dev libpng-dev libzip-dev mysql-client

RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl
RUN docker-php-ext-install zip
RUN docker-php-ext-install gd
RUN docker-php-ext-configure bcmath
RUN docker-php-ext-install bcmath

RUN apk --no-cache add pcre-dev ${PHPIZE_DEPS}
# Install APCu
RUN pecl install apcu
RUN echo "extension=apcu.so" > /usr/local/etc/php/conf.d/apcu.ini

# pcov
RUN pecl install pcov
RUN docker-php-ext-enable pcov

RUN curl --insecure https://getcomposer.org/composer.phar -o /usr/bin/composer && chmod +x /usr/bin/composer
RUN composer selfupdate
RUN chmod 777 -R /tmp/
RUN deluser www-data && adduser -DH -h /home/www-data -s /sbin/nologin -u 1000 www-data

WORKDIR /var/www/
