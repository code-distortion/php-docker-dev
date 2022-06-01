ARG PHP_VERSION
FROM php:$PHP_VERSION-fpm

SHELL ["/bin/bash", "--login", "-c"]
RUN apt-get update

ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone



# ====== set the www-data user to match the current user's uid and gid ======
ARG SET_WWW_DATA_USER
ARG WWW_DATA_UID
ARG WWW_DATA_GID
RUN if [ ${SET_WWW_DATA_USER} = true ]; then \
    groupmod -g $WWW_DATA_GID www-data \
    && usermod -u $WWW_DATA_UID -g $WWW_DATA_GID www-data \
;fi



# ====== some general programs ======
RUN apt-get install -y \
    procps \
    supervisor \
    gettext \
    ;


# ====== PHP extensions ======
RUN apt-get install -y \
        libfreetype6-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libzip-dev \
        zlib1g-dev \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install bcmath \
#    && docker-php-ext-install calendar \
    && docker-php-ext-install intl \
#    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install zip \
    ;



# ====== wget ======
ARG PHP_INSTALL_WGET
RUN if [ "$PHP_INSTALL_WGET" = true ]; then apt-get install -y wget ;fi



# ====== Xdebug ======
ARG PHP_INSTALL_XDEBUG
RUN if [ "$PHP_INSTALL_XDEBUG" = true ]; then \
    pecl install xdebug \
    && docker-php-ext-enable xdebug \
;fi



# ====== PCOV ======
ARG PHP_INSTALL_PCOV
RUN if [ ${PHP_INSTALL_PCOV} = true ]; then \
    pecl install pcov \
    && docker-php-ext-enable pcov \
;fi



# ====== install redis ======
ARG PHP_INSTALL_REDIS
RUN if [ "$PHP_INSTALL_REDIS" = true ]; then \
    pecl install redis \
    && docker-php-ext-enable redis \
;fi



# ====== npm and node ======
ARG PHP_INSTALL_NPM
RUN if [ "$PHP_INSTALL_NPM" = true ]; then \
    set -o pipefail \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash \
;fi
RUN if [ "$PHP_INSTALL_NPM" = true ]; then nvm install lts/fermium ;fi



# ====== mysql-client ======
ARG PHP_INSTALL_MYSQL_CLIENT
RUN if [ "$PHP_INSTALL_MYSQL_CLIENT" = true ]; then \
    apt-get update --allow-releaseinfo-change-suite && \
    apt-get install -y default-mysql-client \
;fi



# ====== postgres-client ======
ARG PHP_INSTALL_POSTGRES_CLIENT
ARG PHP_POSTGRES_CLIENT_VERSION
RUN if [ "$PHP_INSTALL_POSTGRES_CLIENT" = true ]; then \
    apt-get update \
    && apt-get install -y gnupg2 lsb-release \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && RELEASE=$(lsb_release -cs) \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ ${RELEASE}"-pgdg main | tee /etc/apt/sources.list.d/pgdg.list \
    && apt-get update \
    && apt-get install -y ${PHP_POSTGRES_CLIENT_VERSION} \
    && apt-get install -y libpq-dev \
    && docker-php-ext-install pgsql \
    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-enable pdo_pgsql \
;fi



# ====== Composer ======
ARG PHP_INSTALL_COMPOSER
RUN if [ "$PHP_INSTALL_COMPOSER" = true ]; then \
    set -o pipefail \
    && curl https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && mkdir /var/www/.composer && chown www-data: /var/www/.composer \
    && mkdir /var/www/.ssh && chown www-data: /var/www/.ssh \
;fi



# ====== apache2-utils ======
ARG PHP_INSTALL_APACHE2_UTILS
RUN if [ "$PHP_INSTALL_APACHE2_UTILS" = true ]; then apt-get install -y apache2-utils ;fi



# ====== gzip ======
ARG PHP_INSTALL_GZIP
RUN if [ "$PHP_INSTALL_GZIP" = true ]; then apt-get install -y gzip ;fi



# ====== zip ======
ARG PHP_INSTALL_ZIP
RUN if [ "$PHP_INSTALL_ZIP" = true ]; then apt-get install -y zip ;fi



# ====== Git ======
ARG PHP_INSTALL_GIT
ARG GIT_USER
ARG GIT_EMAIL
RUN if [ "$PHP_INSTALL_GIT" = true ]; then \
    apt-get install -y git \
    && git config --global user.email "$GIT_EMAIL" \
    && git config --global user.name "$GIT_USER" \
;fi



# ====== Vim ======
ARG PHP_INSTALL_VIM
RUN if [ "$PHP_INSTALL_VIM" = true ]; then apt-get install -y vim ;fi



# ====== chromium ======
ARG PHP_INSTALL_CHROMIUM
RUN if [ "$PHP_INSTALL_CHROMIUM" = true ]; then \
    apt-get install -y \
    chromium \
    # for chromedriver...
    libnss3 \
    libdbus-1-3 \
;fi



# ====== remove things that aren't needed anymore ======
RUN apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    ;



# ====== (.config dir for php artisan tinker) ======
RUN mkdir /var/www/.config && chown www-data: /var/www/.config



# ====== copy configs and settings last ======
COPY configs/ssh_config /etc/ssh/ssh_config

COPY configs/supervisord.laravel-serve.conf /etc/supervisor/conf.d/supervisord.laravel-serve.template.conf
COPY configs/supervisord.php-serve.conf /etc/supervisor/conf.d/supervisord.php-serve.template.conf

COPY configs/php.ini /usr/local/etc/php/conf.d/php.ini

COPY configs/www.conf /usr/local/etc/php-fpm.d/www.conf

COPY scripts/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
