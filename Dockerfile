# Use the official PHP image as a base image
FROM php:8.0-fpm-alpine

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apk update && apk add --no-cache \
    bash \
    less \
    mariadb-client \
    nginx \
    su-exec

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql

# Copy Nginx configuration file
COPY ./nginx.conf /etc/nginx/nginx.conf

# Copy the startup script to the container
COPY ./start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Copy the entrypoint script to the container
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose port 80
EXPOSE 80

# Start the application
CMD ["/usr/local/bin/entrypoint.sh"]
