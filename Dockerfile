FROM php:5.6-fpm
 
# Install PDO MySQL driver
# See https://github.com/docker-library/php/issues/62


RUN apt-get update && apt-get install -y libicu-dev zlib1g-dev libpng-dev git unixodbc-dev
        

RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl
RUN docker-php-ext-install zip
RUN docker-php-ext-install gd

RUN pecl install sqlsrv pdo_sqlsrv
RUN docker-php-ext-enable sqlsrv pdo_sqlsrv

RUN curl --insecure https://getcomposer.org/composer.phar -o /usr/bin/composer && chmod +x /usr/bin/composer
 
# Workaround for write permission on write to MacOS X volumes
# See https://github.com/boot2docker/boot2docker/pull/534
RUN usermod -u 1000 www-data

COPY php.ini /etc/php5/apache2/conf.d/php.ini
COPY php.ini /usr/local/etc/php/php.ini

WORKDIR /var/www
