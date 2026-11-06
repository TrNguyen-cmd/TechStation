FROM php:8.2-apache

# Cài đặt các thư viện hệ thống cần thiết cho OpenCart 4
RUN apt-get update && apt-get install -y --no-install-recommends \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libzip-dev \
    libicu-dev \
    libonig-dev \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Cấu hình và cài đặt PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) \
    gd \
    mysqli \
    pdo_mysql \
    zip \
    intl \
    mbstring \
    opcache

# Bật Apache mod_rewrite
RUN a2enmod rewrite

# Sao chép cấu hình PHP tùy chỉnh
COPY php.ini /usr/local/etc/php/conf.d/opencart.ini

# Cấu hình Apache cho phép .htaccess
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Cài đặt entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
