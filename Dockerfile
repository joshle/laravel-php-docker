FROM php:7.2-fpm

MAINTAINER Josh Li <joshle@qq.com>

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    cron \
    procps \
    grep \
    vim \
    supervisor \
    curl \
    libmemcached-dev \
    libz-dev \
    libpq-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libssl-dev \
    libmcrypt-dev \
    wget \
    git \
  && rm -rf /var/lib/apt/lists/*

## Composer Install
RUN EXPECTED_COMPOSER_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig) && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '${EXPECTED_COMPOSER_SIGNATURE}') { echo 'Composer.phar Installer verified'; } else { echo 'Composer.phar Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --install-dir=/usr/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

RUN docker-php-ext-install pdo_pgsql pdo_mysql bcmath opcache \
&& docker-php-ext-configure gd \
  --enable-gd-native-ttf \
  --with-jpeg-dir=/usr/lib \
  --with-freetype-dir=/usr/include/freetype2 && \
  docker-php-ext-install gd bcmath opcache zip

# install mongodb ext
RUN pecl install mongodb \
    && docker-php-ext-enable mongodb
