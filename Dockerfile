FROM php:5.5-apache

# Install PDO MySQL driver
# See https://github.com/docker-library/php/issues/62

# Wheezy and Jessie were recently removed from the mirror network, so if you want to continue fetching Jessie backports, you need to use archive.debian.org instead:
# See https://unix.stackexchange.com/questions/508724/failed-to-fetch-jessie-backports-repository
RUN echo "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list

RUN apt-get update && apt-get install -y libicu-dev zlib1g-dev libpng-dev mysql-client wget

RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl
RUN docker-php-ext-install zip
RUN docker-php-ext-install gd

RUN curl --insecure https://getcomposer.org/composer.phar -o /usr/bin/composer && chmod +x /usr/bin/composer

# Workaround for write permission on write to MacOS X volumes
# See https://github.com/boot2docker/boot2docker/pull/534
RUN usermod -u 1000 www-data

# Allow the rewriting engine
RUN a2enmod rewrite

COPY php.ini /etc/php5/apache2/conf.d/php.ini
COPY php.ini /usr/local/etc/php/php.ini

WORKDIR /var/www/html
