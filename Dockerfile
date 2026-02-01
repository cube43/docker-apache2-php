FROM php:8.3.29-fpm-alpine3.22

# Copier le php.ini personnalisé
COPY php.ini /usr/local/etc/php/php.ini

# Installer les dépendances système et les outils de compilation
RUN apk update && apk add --no-cache \
    icu-dev libpng-dev libzip-dev mysql-client \
    pcre-dev ${PHPIZE_DEPS} \
    freetype-dev jpeg-dev libjpeg-turbo-dev \
    imagemagick imagemagick-dev \
    brotli-dev curl wget bash \
    && rm -rf /var/cache/apk/*

# Configurer et installer les extensions PHP
RUN docker-php-ext-configure intl \
    && docker-php-ext-configure bcmath \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql intl zip gd bcmath pcntl exif

# Installer toutes les extensions PECL et activer proprement
RUN pecl install apcu \
    && docker-php-ext-enable apcu

RUN pecl install pcov \
    && docker-php-ext-enable pcov

RUN pecl install swoole \
    && docker-php-ext-enable swoole

RUN pecl install imagick \
    && docker-php-ext-enable imagick


# Installer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    && composer self-update --2

# Permissions temporaires
RUN chmod 777 -R /tmp/

# Créer l'utilisateur www-data avec UID 1000
RUN deluser www-data \
    && adduser -DH -h /home/www-data -s /sbin/nologin -u 1000 www-data

# Définir le répertoire de travail
WORKDIR /var/www/

# Commande par défaut
CMD ["php-fpm"]