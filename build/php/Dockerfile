ARG PHP_IMAGE
FROM ${PHP_IMAGE}

SHELL ["/bin/bash", "--login", "-c"]

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



# ====== PHP extensions ======
RUN apt-get update \
    && apt-get install -y \
        apache2-utils \
        git \
        gettext \
        gzip \
        libfreetype6-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libzip-dev \
#        procps \
        supervisor \
        vim \
        wget \
        zip \
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
    && apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    ;



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



# ====== install nodejs and npm ======
ARG PHP_INSTALL_NPM
ARG PHP_INSTALL_INTELEPHENSE
RUN if [ ${PHP_INSTALL_NPM} = true ] || [ ${PHP_INSTALL_INTELEPHENSE} = true ]; then \
    apt-get update \
    && apt-get install -y \
        nodejs \
        npm \
    && apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
;fi



# ====== mysql-client ======
ARG PHP_INSTALL_MYSQL_CLIENT
RUN if [ "$PHP_INSTALL_MYSQL_CLIENT" = true ]; then \
    apt-get update --allow-releaseinfo-change-suite \
    && apt-get install -y default-mysql-client \
    && apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
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
    && apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
;fi



# ====== Composer ======
ARG PHP_INSTALL_COMPOSER
RUN if [ "$PHP_INSTALL_COMPOSER" = true ]; then \
    set -o pipefail \
    && curl https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
;fi



# ====== Git ======
ARG GIT_USER
ARG GIT_EMAIL
RUN git config --global user.email "$GIT_EMAIL" \
    && git config --global user.name "$GIT_USER" \
    ;



# ====== chromium ======
ARG PHP_INSTALL_CHROMIUM
RUN if [ "$PHP_INSTALL_CHROMIUM" = true ]; then \
    apt-get update \
    && apt-get install -y \
        chromium \
        # for chromedriver...
        libnss3 \
        libdbus-1-3 \
    && apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
;fi



# ====== install intelliphense (for VS Code) ======
ARG INSTALL_INTELEPHENSE
RUN if [ ${INSTALL_INTELEPHENSE} = true ]; then \
    npm install -g intelephense \
;fi



# ====== add the php.log file for php to write to ======
RUN touch /var/log/php.log
RUN chown www-data: /var/log/php.log



# ====== chown these directories so programs can create necessary cache directories etc as needed ======
RUN chown www-data: /var/www
RUN mkdir /tmp/phpstan/ && chown www-data: /tmp/phpstan/



# ====== copy configs and settings last ======
COPY configs/ssh_config /etc/ssh/ssh_config

COPY configs/supervisord.laravel-serve.template.conf /etc/supervisor/conf.d/supervisord.laravel-serve.template.conf
COPY configs/supervisord.tempest-serve.template.conf /etc/supervisor/conf.d/supervisord.tempest-serve.template.conf
COPY configs/supervisord.php-serve.template.conf /etc/supervisor/conf.d/supervisord.php-serve.template.conf

COPY configs/ini/1.php.ini /usr/local/etc/php/conf.d/
COPY configs/ini/xdebug.ini /usr/local/etc/php/conf.d/

COPY configs/www.conf /usr/local/etc/php-fpm.d/www.conf

COPY scripts/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
