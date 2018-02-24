# Drush Make will be depreciated in Drupal 9. All efforts MUST go into using Composer to bootstrap a site.
# Roadmap: https://github.com/drush-ops/drush/issues/2528  See:  https://www.drupal.org/requirements/php#drupalversions
FROM php:7.1-apache-jessie

ENV COMPOSER_PROCESS_TIMEOUT 900
ENV TIMEZONE Australia/Sydney

RUN set -ex; \
	\
	if command -v a2enmod; then \
		a2enmod rewrite; \
	fi; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libjpeg-dev \
		libpng-dev \
		libpq-dev \
	; \
	\
	docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
	docker-php-ext-install -j "$(nproc)" \
		gd \
		opcache \
		pdo_mysql \
		pdo_pgsql \
		zip \
	; \
	\
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

WORKDIR /var/www

RUN bash -c "curl -sS 'https://getcomposer.org/installer' | php -- --install-dir=/usr/local/bin --filename=composer" \
  && chmod a+x /usr/local/bin/composer \
  && mkdir \
    .composer \
    private \
  && chown --recursive --verbose www-data:www-data \
    .composer \
    private

USER www-data
WORKDIR /var/www/html

RUN composer create-project \
  --stability dev \
  --prefer-dist \
  --no-progress \
  --no-dev \
  govcms/govcms8-project:1.0.0-alpha4 \
  /var/www/html \
  # TODO minimise permissions
  && chmod -R a+w /var/www/html/docroot/sites/default

RUN composer require \
    --prefer-stable \
    --prefer-dist \
    --no-progress \
    --update-no-dev \
    drupal/address:~1.0 \
    drupal/api_key_manager:~1.0 \
    drupal/backup_migrate \
    drupal/bibcite:1.0.0-alpha5 \
    drupal/block_styles \
    drupal/charts:3.0.0-alpha7 \
    drupal/clamav \
    drupal/diff \
    # Groups RC1 06-2017 - Kristiaan released a big patch early 2018 but group content edit and delete routes don't work
    drupal/group:1.0.0-rc2 \
    drupal/geocoder:2.0.0-beta2 \
    drupal/geofield:1.0.0-beta2 \
    drupal/geofield_map:~1.0 \
    drupal/linkit:^5.0 \
    # Realname RC 05-2017 - There's a core issue holding a further release. It works but doesn't display real names in
    # all places yet. See https://www.drupal.org/project/drupal/issues/2629286.
    drupal/realname:1.0.0-rc1\
    drupal/restui:~1.0 \
    drupal/social_api:2.0.0-beta4 \
    drupal/telephone_validation:~2.0

ADD settings.php docroot/sites/default/
ADD config config/

USER root
RUN mkdir config/sync
RUN chown --recursive --verbose www-data:www-data config
RUN chmod og-w docroot/sites/default/settings.php



