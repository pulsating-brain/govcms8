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

USER www-data
WORKDIR /var/www/html

RUN composer create-project \
    --stability dev \
    --prefer-dist \
    --no-progress \
    --no-dev \
    govcms/govcms8-project \
    /var/www/html

# Allow the settings.php file and files directory to be created.
RUN cp /var/www/html/docroot/sites/default/default.settings.php /var/www/html/docroot/sites/default/settings.php
RUN chmod -R a+w /var/www/html/docroot/sites/default

RUN composer require \
    --prefer-stable \
    --prefer-dist \
    --no-progress \
    --update-no-dev \
    # geocoder alpha6 released 18/12/17, alpha7 released on 20/12/17, commit made to dev on 22/12/17 which fixed an
    # issue which stopped addresses geocoding into geofields. See https://www.drupal.org/project/geocoder/issues/2932171
    drupal/geocoder:2.x-dev \
    drupal/address:~1.0 \
    # groups got this RC Jun 2017. Still need to fix some routing issues.
    drupal/group:1.0.0-rc1 \
    # is geofield ready for a beta or RC? Seems fully functional to me.
    drupal/geofield:1.0.0-alpha4 \
    drupal/geofield_map:~1.0 \
    # realname did this RC May 2017. Seems perfectly fine. Should they release?
    drupal/realname:1.0.0-rc1\
    # see https://www.drupal.org/docs/8/core/modules/rest/oauth-patch-example
    drupal/restui:~1.0 \
    drupal/api_key_manager \
    drupal/telephone_validation

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
