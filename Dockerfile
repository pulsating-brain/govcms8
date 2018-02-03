# Drush Make will be depreciated in Drupal 9. All efforts MUST go into using Composer to bootstrap a site.
# Roadmap: https://github.com/drush-ops/drush/issues/2528  See:  https://www.drupal.org/requirements/php#drupalversions
FROM php:7.1-fpm-alpine

ENV APACHE_DOCUMENT_ROOT /var/www/html/docroot
ENV COMPOSER_PROCESS_TIMEOUT 900
ENV TIMEZONE Australia/Sydney

ENV BUILD_DEPS=" \
  autoconf \
  binutils \
  g++ \
  gcc \
  libc-dev \
  make \
  musl-dev"

RUN apk update && apk add  \
  --no-cache \
  ${BUILD_DEPS} \
  # see https://github.com/smebberson/docker-alpine/blob/master/alpine-apache/Dockerfile
  apache2 \
  apache2-utils \
  bash \
  bzip2-dev \
  git \
  jpeg-dev \
  libpng-dev \
  libpq \
  openrc \
  unzip \
  mysql-client \
  && docker-php-ext-configure \
    gd \
    --with-png-dir=/usr \
    --with-jpeg-dir=/usr \
  && docker-php-ext-install \
    bz2 \
    gd \
    mbstring \
    opcache \
    pcntl \
    pdo_mysql \
    zip \
    # Clean Up
    && apk del ${BUILD_DEPS}
    # TODO cleanup build files

RUN bash -c "curl -sS 'https://getcomposer.org/installer' | php -- --install-dir=/usr/local/bin --filename=composer" \
  && chmod a+x /usr/local/bin/composer \
  && mkdir /var/www/.composer \
  && chown www-data:www-data /var/www/.composer \
  && mkdir /var/www/privately-uploaded-files \
  && mkdir /var/www/publicly-uploaded-files \
  && chown www-data:www-data /var/www/privately-uploaded-files \
  && chown www-data:www-data /var/www/publicly-uploaded-files

RUN chown www-data:www-data /var/www/html

USER www-data
WORKDIR /var/www
RUN composer create-project \
  --stability alpha \
  --prefer-dist \
  --no-progress \
  --no-dev \
  govcms/govcms8-project \
  html \
  # TODO minimise permissions
  && chmod -R a+w html/docroot/sites/default

ADD settings.php html/docroot/sites/default/
ADD config html/config/
ADD httpd.conf /etc/apache2/httpd.conf

WORKDIR /var/www/html
RUN composer require \
    --prefer-stable \
    --prefer-dist \
    --no-progress \
    --update-no-dev \
    drupal/geocoder:2.0.0-beta1 \
    drupal/address:~1.0 \
    # Groups RC1 06-2017 - Kristiaan released a big patch early 2018 but group content edit and delete routes don't work
    drupal/group:1.0.0-rc1 \
    # Geofield seems ready for a beta or RC to me
    drupal/geofield:1.0.0-alpha5 \
    drupal/geofield_map:~1.0 \
    # Realname RC 05-2017 - There's a core issue holding a further release. It works but doesn't display real names in
    # all places yet. See https://www.drupal.org/project/drupal/issues/2629286.
    drupal/realname:1.0.0-rc1\
    drupal/restui:~1.0 \
    drupal/api_key_manager:~1.0 \
    drupal/telephone_validation:~2.0 \
    drupal/social_api:2.0.0-beta3 \
    drupal/charts:3.0.0-alpha7 \
    drupal/bibcite:1.0.0-alpha4

EXPOSE 80
USER root
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
