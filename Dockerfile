# Drush Make will be depreciated in Drupal 9. All efforts MUST go into using Composer to bootstrap a site.
# Roadmap: https://github.com/drush-ops/drush/issues/2528
# They state they will support a tool to convert Makefiles into Composer files
# Make will keep getting bugfixes in Drush 8
# https://github.com/docker-library/php/blob/6844e717a56a5dd8ad87a236a96bea069cc635fd/5.6/alpine/Dockerfile
#####


# from https://www.drupal.org/requirements/php#drupalversions
# accepts connections on port 9000
FROM php:7.1-apache


ENV COMPOSER_PROCESS_TIMEOUT 900

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
  && docker-php-ext-install bz2 gd mbstring pcntl pdo_mysql zip

RUN bash -c "curl -sS 'https://getcomposer.org/installer' | php -- --install-dir=/usr/local/bin --filename=composer"
RUN chmod a+x /usr/local/bin/composer

WORKDIR /var/www/govcms
RUN git clone https://github.com/govCMS/govCMS8.git /var/www/govcms

RUN mkdir -p /var/www/govcms/docroot
ADD ./build.properties build/phing/build.properties
RUN rmdir /var/www/html/ && ln -sfn /var/www/govcms/docroot /var/www/html


USER www-data
# RUN /usr/local/bin/composer install --prefer-dist --working-dir=build
# RUN build/bin/phing -f build/phing/build.xml make:local

# Allow the settings.php file and files directory to be created.
# RUN cp /var/www/govcms/docroot/sites/default/default.settings.php /var/www/govcms/docroot/sites/default/settings.php
# RUN chmod -R a+w /var/www/govcms/docroot/sites/default
