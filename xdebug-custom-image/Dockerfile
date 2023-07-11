FROM composer:2.5.8 as build

COPY . /app/
RUN composer install --prefer-dist --no-dev --optimize-autoloader --no-interaction

FROM php:8.2-apache-bullseye as production

COPY --from=build /app /var/www/html
COPY apache/000-default.conf /etc/apache2/sites-available/000-default.conf

# Install xdebug
# Enable the extensions for xdebug, mysqli, pdo and pdo_mysql
RUN docker-php-ext-install mysqli pdo pdo_mysql && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini &&  \
    echo "xdebug.output_dir=/var/www/html/storage" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.mode=profile" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.start_with_request=trigger" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    # Change permissions to read/write for storage or else it'll fail to write out logs due to lack of permissions
    # Change ownership to www-data for Apache
    chmod 777 -R /var/www/html/storage/ && \
    chown -R www-data:www-data /var/www/ && \
    a2enmod rewrite && \
    service apache2 restart

EXPOSE 80