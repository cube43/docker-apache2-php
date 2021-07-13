FROM php:7.4-fpm-alpine3.12

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
RUN docker-php-ext-install pcntl

RUN apk --no-cache add pcre-dev ${PHPIZE_DEPS} unixodbc-dev

RUN wget https://github.com/FriendsOfPHP/pickle/releases/download/v0.6.0/pickle.phar && mv pickle.phar /usr/local/bin/pickle && chmod +x /usr/local/bin/pickle
RUN pickle install apcu -n
RUN pickle install pcov -n
RUN pickle install sqlsrv -n
RUN pickle install pdo_sqlsrv -n

RUN echo "extension=pcov.so" >> /usr/local/etc/php/php.ini
RUN echo "extension=apcu.so" >> /usr/local/etc/php/php.ini
RUN echo "extension=sqlsrv.so" >> /usr/local/etc/php/php.ini
RUN echo "extension=pdo_sqlsrv.so" >> /usr/local/etc/php/php.ini

RUN curl --insecure https://getcomposer.org/composer.phar -o /usr/bin/composer && chmod +x /usr/bin/composer
RUN composer selfupdate --2
RUN chmod 777 -R /tmp/
RUN deluser www-data && adduser -DH -h /home/www-data -s /sbin/nologin -u 1000 www-data

RUN curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.6.1.1-1_amd64.apk && \
    apk add --allow-untrusted msodbcsql17_17.6.1.1-1_amd64.apk;

RUN curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/mssql-tools_17.6.1.1-1_amd64.apk && \
    apk add --allow-untrusted mssql-tools_17.6.1.1-1_amd64.apk;

WORKDIR /var/www/
