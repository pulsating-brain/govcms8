# Drush Make will be depreciated in Drupal 9. All efforts MUST go into using Composer to bootstrap a site.
# Roadmap: https://github.com/drush-ops/drush/issues/2528
# They state they will support a tool to convert Makefiles into Composer files
# Make will keep getting bugfixes in Drush 8
# https://github.com/docker-library/php/blob/6844e717a56a5dd8ad87a236a96bea069cc635fd/5.6/alpine/Dockerfile
#####


# from https://www.drupal.org/requirements/php#drupalversions
# accepts connections on port 9000
FROM php:7.1-fpm-alpine

RUN set -ex \
	&& apk update \
	&& apk add --virtual .build-deps \
	# see http://blog.zot24.com/tips-tricks-with-alpine-docker
		coreutils \
		freetype-dev \
		libjpeg-turbo-dev \
		libpng-dev \
		postgresql-dev \
		# postgresql-dev is needed for https://bugs.alpinelinux.org/issues/3642
	&& docker-php-ext-configure gd \
		--with-freetype-dir=/usr/include/ \
		--with-jpeg-dir=/usr/include/ \
		--with-png-dir=/usr/include/ \
	&& docker-php-ext-install -j "$(nproc)" gd mbstring opcache pdo pdo_mysql pdo_pgsql zip \
	&& runDeps="$( \
		scanelf --needed --nobanner --recursive \
			/usr/local/lib/php/extensions \
			| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			| sort -u \
			| xargs -r apk info --installed \
			| sort -u \
	)" \
	&& apk add $runDeps git \

	# Delete build dependencies to minimise image size
	&& apk del .build-deps

# set recommended PHP.ini settings; see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin \
    --filename=composer \
    && chmod +x /usr/local/bin/composer

WORKDIR /var/www
RUN chmod -R 777 /var/www \
    && rm -r *

USER www-data

# Install Drupal
RUN composer create-project \
    --stability dev \
    --prefer-dist \
    --no-dev \
    --no-progress \
    --no-interaction \
    govcms/govcms8-project demomarkfullernetau 

COPY ./config /var/www/config/
COPY ./entrypoint.sh /usr/local/bin/
# TODO Licensing ?? MIT
CMD ["php-fpm"]
