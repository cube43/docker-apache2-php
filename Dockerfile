ARG PHP_EXTENSIONS="pdo_mysql intl zip gd bcmath pcntl apcu pcov"
FROM thecodingmachine/php:7.4-v4-fpm

# Install MS ODBC Driver for SQL Server
RUN curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - \
    && curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && sudo apt-get update \
    && sudo apt-get -y --no-install-recommends install msodbcsql17 unixodbc-dev \
    && pecl install sqlsrv \
    && pecl install pdo_sqlsrv

RUN docker-php-ext-enable sqlsrv pdo_sqlsrv

RUN sudo apt-get -y --no-install-recommends install mysql-client
RUN sudo apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

WORKDIR /var/www/
