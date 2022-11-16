FROM php:8.0.26RC1-fpm-alpine3.15
 
# Install PDO MySQL driver
# See https://github.com/docker-library/php/issues/62

COPY php.ini /usr/local/etc/php/php.ini

RUN apk update --update && apk add --update --no-cache icu-dev libpng-dev libzip-dev mysql-client

RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl
RUN docker-php-ext-install zip
RUN docker-php-ext-install gd
RUN docker-php-ext-configure bcmath
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install pcntl

RUN apk --no-cache add pcre-dev ${PHPIZE_DEPS}

RUN wget https://github.com/FriendsOfPHP/pickle/releases/download/v0.7.9/pickle.phar && mv pickle.phar /usr/local/bin/pickle && chmod +x /usr/local/bin/pickle
RUN pickle install apcu
RUN pickle install pcov
RUN pecl install swoole


RUN echo "extension=pcov.so" >> /usr/local/etc/php/php.ini
RUN echo "extension=apcu.so" >> /usr/local/etc/php/php.ini
RUN echo "extension=swoole.so" >> /usr/local/etc/php/php.ini


RUN curl --insecure https://getcomposer.org/composer.phar -o /usr/bin/composer && chmod +x /usr/bin/composer
RUN composer selfupdate --2
RUN chmod 777 -R /tmp/
RUN deluser www-data && adduser -DH -h /home/www-data -s /sbin/nologin -u 1000 www-data

RUN apk update \
    && apk upgrade \
    && apk add --no-cache \
        freetype-dev \
        libpng-dev \
        jpeg-dev \
        libjpeg-turbo-dev
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install exif

WORKDIR /var/www/
