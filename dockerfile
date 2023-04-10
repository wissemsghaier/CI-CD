# Use an official PHP runtime as a parent image
FROM php:8.1-fpm

# Set the working directory to /app
WORKDIR /var/www/html

# Install any necessary dependencies
RUN apt-get update && apt-get install -y \
    nginx \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip
RUN apt-get upgrade -y

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql zip gd mbstring exif pcntl bcmath opcache

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the application code into the container
COPY . /var/www/html

RUN composer install

RUN chmod -R 775 /var/www/html

# Copy the Nginx configuration file
COPY ./site.conf /etc/nginx/conf.d/default.conf
COPY ./site.conf /etc/nginx/conf.d/default.conf

# Set the appropriate permissions on the application directory
RUN chown -R www-data:www-data /var/www/html

USER www-data

EXPOSE 80
CMD service nginx start && php-fpm
