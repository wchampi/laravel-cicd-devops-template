FROM php:7.3.13-apache

RUN apt-get update \
    && pecl install redis \
    && apt-get install -y vim \
    && apt-get install -y telnet \
    && apt-get install -y curl \
    && apt-get install -y libssl-dev \
    && a2enmod headers \
    && a2enmod rewrite \
    && sed -i 's!/var/www/html!/var/www/public!g' /etc/apache2/sites-enabled/000-default.conf \
    && mv /var/www/html /var/www/public \
    && apt-get install -y unzip \
    && pecl install mongodb \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/php-custom.ini \
    && echo "extension=redis.so" >> /usr/local/etc/php/conf.d/php-custom.ini

WORKDIR /var/www

COPY composer.lock composer.json /var/www
RUN COMPOSER_PROCESS_TIMEOUT=900 composer install --no-scripts --no-autoloader

COPY . /var/www

RUN composer dump-autoload --optimize
