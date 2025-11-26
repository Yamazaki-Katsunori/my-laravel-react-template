FROM php:8.4-fpm

# build deps for pecl/xdebug + runtime deps
RUN apt-get update && apt-get install -y \
    libpq-dev zip unzip git autoconf build-essential pkg-config \
    zlib1g-dev libssl-dev \
 && pecl install xdebug redis \
 && docker-php-ext-enable xdebug redis \
 && docker-php-ext-install pdo pdo_pgsql \
 && rm -rf /var/lib/apt/lists/* \
 # make log dirs and set ownership (ensure php-fpm can write)
 && mkdir -p /var/log/php /var/log/php-fpm \
 && chown -R www-data:www-data /var/log/php /var/log/php-fpm

# copy config files (本番向けは COPY／開発は volumes マウント可)
# COPY docker/php/conf.d/php.ini /usr/local/etc/php/conf.d/99-custom.ini
# COPY docker/php/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf
# COPY docker/php/conf.d/xdebug.ini /usr/local/etc/php/conf.d/20-xdebug.ini

WORKDIR /var/www/html
