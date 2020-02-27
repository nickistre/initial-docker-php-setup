#
# Use this dockerfile to run a PHP app.
#
# Start the server using docker-compose:
#
#   docker-compose build
#   docker-compose up
#
# You can install dependencies via the container:
#
#   docker-compose run web composer install
#
# OR use plain old docker
#
#   docker build -f Dockerfile -t project-web .
#   docker run -it -p "8080:80" -v $PWD:/var/www project-web
#
FROM php:7.2-apache

ENV XDEBUG_ENABLE 0
ENV XDEBUG_REMOTE_HOST host.docker.internal
ENV XDEBUG_SETTINGS_TARGET /usr/local/etc/php/conf.d/xdebug_settings.ini

# Setup PHP for development mode
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

# Configure php ini here

# Install extensions, update apache configuration, install composer here
RUN apt-get update \
&& apt-get install -y sudo \
# && apt-get install -y --no-install-recommends git zlib1g-dev libpng-dev unzip \
# && docker-php-ext-install zip \
# && docker-php-ext-install gd \
# && docker-php-ext-install mbstring \
# && docker-php-ext-install pdo pdo_mysql \
 && a2enmod rewrite \
 && sed -i 's!/var/www/html!/var/www/app/public!g' /etc/apache2/sites-available/000-default.conf \
 && mkdir -p /var/www/app \
 && mv /var/www/html /var/www/app/public \
 && curl -sS https://getcomposer.org/installer \
  | php -- --install-dir=/usr/local/bin --filename=composer \
 && echo "AllowEncodedSlashes On" >> /etc/apache2/apache2.conf

# Setup new entrypoint for enabling xdebug
COPY docker/php-xdebug-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/php-xdebug-entrypoint.sh

WORKDIR /var/www/app

ENTRYPOINT ["php-xdebug-entrypoint.sh"]
CMD ["apache2-foreground"]