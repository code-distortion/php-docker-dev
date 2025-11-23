ARG PHP_IMAGE
FROM ${PHP_IMAGE}

SHELL ["/bin/bash", "--login", "-c"]
# ENV SHELL="/bin/zsh"


# ====== Set the timezone ======
ENV TZ="UTC"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone



# ====== Set the www-data user to match the current user's uid and gid ======
ARG SET_WWW_DATA_USER
ARG WWW_DATA_UID
ARG WWW_DATA_GID
RUN if [ ${SET_WWW_DATA_USER} = true ]; then \
    groupmod -g $WWW_DATA_GID www-data \
    && usermod -u $WWW_DATA_UID -g $WWW_DATA_GID www-data \
;fi

# ====== Set the www-data user's home directory ======
ENV HOMEDIR="/home/www-data"

RUN mkdir -p $HOMEDIR
RUN usermod -d $HOMEDIR www-data
RUN chown -R www-data:www-data $HOMEDIR && \
    chmod 755 $HOMEDIR



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

# ARG PHP_INSTALL_NPM
# RUN if [ ${PHP_INSTALL_NPM} = true ]; then \
#     apt-get update \
#     && apt-get install -y \
#         nodejs \
#         npm \
#     && apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
# ;fi



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



# ====== add the php.log file for php to write to ======
RUN touch /var/log/php.log
RUN chown www-data: /var/log/php.log



# ====== chown these directories so programs can create necessary cache directories etc as needed ======
RUN chown www-data: /var/www
RUN mkdir /tmp/phpstan/ && chown www-data: /tmp/phpstan/
# chown the volume on the host instead: sudo chown -R 1000:1000 ./docker/volumes/php/.composer
#RUN mkdir /var/www/.composer && chown www-data: /var/www/.composer



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













# ====== install nodejs 24 and npm (for Claude Code) ======
RUN apt-get update \
    && apt-get install -y ca-certificates curl gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_24.x nodistro main" > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y nodejs \
    && node -v && npm -v \
    && apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    ;

# Add npm global bin to PATH in multiple profile files to ensure it's available in all shell types
RUN echo 'export PATH="$PATH:/usr/local/share/npm-global/bin"' >> $HOMEDIR/.bashrc && \
    echo 'export PATH="$PATH:/usr/local/share/npm-global/bin"' >> $HOMEDIR/.profile && \
    echo 'export PATH="$PATH:/usr/local/share/npm-global/bin"' >> $HOMEDIR/.bash_profile && \
    chmod 0644 $HOMEDIR/.bashrc && \
    chmod 0644 $HOMEDIR/.profile && \
    chmod 0644 $HOMEDIR/.bash_profile







# ====== Install Claude Code ======
#
# The https://github.com/anthropics/claude-code/tree/main/.devcontainer script was copied, with the changes listed below
#
# Changes:
# - removed fzf, zsh and nano from step "# Install basic development tools and iptables/ipset"
# - changed user node to www-data in step "# Ensure default node user has access to /usr/local/share"
# - changed user node to www-data in step "ARG USERNAME=node"
# - changed user node to www-data in step "# Create workspace and config directories and set permissions"
# - changed to use $HOMEDIR in step "# Create workspace and config directories and set permissions"
# - removed "/workspace" directory from step "# Create workspace and config directories and set permissions"
# - disabled step "WORKDIR /workspace"
# - changed user node to www-data in step "# Set up non-root user"
# - disabled step "# Set the default shell to zsh rather than sh"
# - disabled step "# Set the default editor and visual"
# - disabled step "# Default powerline10k theme"
# - changed user node to www-data in step "# Copy and set up firewall script"



ARG CLAUDE_CODE_VERSION=latest

# Install basic development tools and iptables/ipset
RUN apt-get update && apt-get install -y --no-install-recommends \
  less \
  git \
  procps \
  sudo \
#   fzf \
#   zsh \
  man-db \
  unzip \
  gnupg2 \
  gh \
  iptables \
  ipset \
  iproute2 \
  dnsutils \
  aggregate \
  jq \
#  nano \
  vim \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Ensure default node user has access to /usr/local/share
RUN mkdir -p /usr/local/share/npm-global && \
  chown -R www-data:www-data /usr/local/share

ARG USERNAME=www-data

# Persist bash history.
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
  && mkdir /commandhistory \
  && touch /commandhistory/.bash_history \
  && chown -R $USERNAME /commandhistory

# Set `DEVCONTAINER` environment variable to help with orientation
ENV DEVCONTAINER=true

# Create workspace and config directories and set permissions
RUN mkdir -p $HOMEDIR/.claude && \
  chown -R www-data:www-data $HOMEDIR/.claude

#WORKDIR /workspace

ARG GIT_DELTA_VERSION=0.18.2
RUN ARCH=$(dpkg --print-architecture) && \
  wget "https://github.com/dandavison/delta/releases/download/${GIT_DELTA_VERSION}/git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
  sudo dpkg -i "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
  rm "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb"

# Set up non-root user
USER www-data

# Install global packages
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV PATH=$PATH:/usr/local/share/npm-global/bin

# Set the default shell to zsh rather than sh
#ENV SHELL=/bin/zsh

# # Set the default editor and visual
# ENV EDITOR=nano
# ENV VISUAL=nano

# # Default powerline10k theme
# ARG ZSH_IN_DOCKER_VERSION=1.2.0
# RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v${ZSH_IN_DOCKER_VERSION}/zsh-in-docker.sh)" -- \
#   -p git \
#   -p fzf \
#   -a "source /usr/share/doc/fzf/examples/key-bindings.zsh" \
#   -a "source /usr/share/doc/fzf/examples/completion.zsh" \
#   -a "export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
#   -x

# Install Claude
RUN npm install -g @anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}


# Copy and set up firewall script
COPY init-firewall.sh /usr/local/bin/
USER root
RUN chmod +x /usr/local/bin/init-firewall.sh && \
  echo "node ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh" > /etc/sudoers.d/node-firewall && \
  chmod 0440 /etc/sudoers.d/node-firewall
USER www-data


















RUN touch $HOMEDIR/.claude/settings.json

# ====== Install ccstatusline ======
# ccstatusline gets Claude Code to show the status of the Claude Code session
# e.g. Model: Sonnet 4 | cwd: /var/www/html/sites/fbu2 | ⎇ Tim/main (+305,-55) | In: 0 + Out: 0 + Cached: 0 = Total: 0 [Current: Ctx: 0, Ctx: 0.0%] | Cost: $0.00
# @see https://github.com/sirmalloc/ccstatusline

COPY --chown=www-data:www-data ccstatusline/ccstatusline.settings.json /tmp/ccstatusline.settings.json
COPY --chown=www-data:www-data ccstatusline/claude.settings.json /tmp/claude.settings.json

ARG PHP_CLAUDE_INSTALL_CCSTATUSLINE
RUN if [ "${PHP_CLAUDE_INSTALL_CCSTATUSLINE}" = "true" ]; then \
    # install ccstatusline
    npm install -g ccstatusline@latest \
    # add configuration for ccstatusline
    && mkdir -p $HOMEDIR/.config/ccstatusline \
    && cp /tmp/ccstatusline.settings.json $HOMEDIR/.config/ccstatusline/settings.json \
    # copy the ccstatusline settings to claude.settings.json.template (which is added into Claude Code's configuration inside docker-entrypoint.sh)
    && cp /tmp/claude.settings.json $HOMEDIR/claude.settings.json.template \
;fi

# add the ccstatusline settings to .claude/settings.json

RUN rm /tmp/ccstatusline.settings.json
RUN rm /tmp/claude.settings.json





# ====== Install ccusage ======
# ccusage looks at Claude Code's usage JSONL files in ~/.claude/projects/ to analyse session usage
# @see https://github.com/ryoppippi/ccusage
# usage: `ccusage blocks -r`

ARG PHP_CLAUDE_INSTALL_CCUSAGE
RUN if [ "${PHP_CLAUDE_INSTALL_CCUSAGE}" = "true" ]; then \
    npm install -g ccusage \
;fi





USER root

# ====== entry-point ======
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh", "-c", "sleep infinity"]

USER www-data
