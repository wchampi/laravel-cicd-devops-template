FROM php:7.3.13-apache

RUN apt-get update \
    && pecl install redis \
    && apt-get install -y vim \
    && apt-get install -y telnet \
    && apt-get install -y curl \
    && a2enmod headers \
    && a2enmod rewrite \
    && sed -i 's!/var/www/html!/var/www/public!g' /etc/apache2/sites-enabled/000-default.conf \
    && mv /var/www/html /var/www/public \
    && apt-get install -y unzip \
    && pecl install mongodb \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www

COPY composer.lock /var/www
COPY composer.json /var/www
RUN rm -Rf composer.lock && COMPOSER_PROCESS_TIMEOUT=900 composer install --no-scripts --no-autoloader
RUN ls

COPY . /var/www

RUN ls && composer dump-autoload --optimize \
    && echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/php-custom.ini \
    && echo "extension=redis.so" >> /usr/local/etc/php/conf.d/php-custom.ini
