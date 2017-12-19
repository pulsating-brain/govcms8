# Drush Make will be depreciated in Drupal 9. All efforts MUST go into using Composer to bootstrap a site.
# Roadmap: https://github.com/drush-ops/drush/issues/2528
# They state they will support a tool to convert Makefiles into Composer files
# Make will keep getting bugfixes in Drush 8
# https://github.com/docker-library/php/blob/6844e717a56a5dd8ad87a236a96bea069cc635fd/5.6/alpine/Dockerfile
#####


# from https://www.drupal.org/requirements/php#drupalversions
# accepts connections on port 9000
FROM php:7.1-apache

ENV APACHE_DOCUMENT_ROOT /var/www/html/docroot
ENV COMPOSER_PROCESS_TIMEOUT 900
ENV TIMEZONE Australia/Sydney

RUN a2enmod rewrite

RUN apt-get update && apt-get install -y \
  libpng12-dev \
  libjpeg-dev \
  libpq-dev \
  libbz2-dev \
  unzip \
  git-core \
  telnet \
  mysql-client \
  && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
  && docker-php-ext-install bz2 gd mbstring opcache pcntl pdo_mysql zip

RUN bash -c "curl -sS 'https://getcomposer.org/installer' | php -- --install-dir=/usr/local/bin --filename=composer"
RUN chmod a+x /usr/local/bin/composer

WORKDIR /var/www/html

RUN composer create-project \
    --stability dev \
    --prefer-dist \
    --no-progress \
    govcms/govcms8-project \
    /var/www/html

# Allow the settings.php file and files directory to be created.
RUN cp /var/www/html/docroot/sites/default/default.settings.php /var/www/html/docroot/sites/default/settings.php
RUN chmod -R a+w /var/www/html/docroot/sites/default

RUN composer require \
    --prefer-stable \
    --prefer-dist \
    --no-progress \
    # geocoder alpha6 released today 18/12/17
    drupal/geocoder:2.0.0-alpha6 \
    drupal/geophp \
    drupal/geolocation \
    drupal/address \
    drupal/group \
    drupal/geofield \
    drupal/geofield_map:^1.24 \
    drupal/realname
    
EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
