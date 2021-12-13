# Docker php-fpm

## Avaible tag

- [`cube43/docker-apache2-php:5.5`](https://github.com/cube43/docker-apache2-php/tree/5.5)
- [`cube43/docker-apache2-php:5.6`](https://github.com/cube43/docker-apache2-php/tree/5.6)
- [`cube43/docker-apache2-php:7.2`](https://github.com/cube43/docker-apache2-php/tree/7.2)
- [`cube43/docker-apache2-php:7.3`](https://github.com/cube43/docker-apache2-php/tree/7.3)
- [`cube43/docker-apache2-php:7.4`](https://github.com/cube43/docker-apache2-php/tree/7.4)
- [`cube43/docker-apache2-php:8.0`](https://github.com/cube43/docker-apache2-php/tree/8.0)

`cube43/docker-apache2-php:latest` is 7.4

## Usage

```yml
version : '3'
services :
  php:
    image: cube43/docker-apache2-php


## How to build

docker build .
docker image ls
docker image tag 8d3a1ba3605f cube43/docker-apache2-php:8.0
docker image push cube43/docker-apache2-php:8.0
