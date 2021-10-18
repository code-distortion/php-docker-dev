#!/usr/bin/env bash
set -e

# serve with PHP
if [ "$PHP_SERVE_USING_PHP" = true ]; then
    envsubst < /etc/supervisor/conf.d/supervisord.php-serve.template.conf > /etc/supervisor/conf.d/supervisord.php-serve.conf
    /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.php-serve.conf

# serve with PHP using Laravel
elif [ "$PHP_SERVE_USING_LARAVEL" = true ]; then
    envsubst < /etc/supervisor/conf.d/supervisord.laravel-serve.template.conf > /etc/supervisor/conf.d/supervisord.laravel-serve.conf
    /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.laravel-serve.conf

# serve with PHP-FPM
else
    # @see https://github.com/devilbox/docker-php-fpm-8.0/blob/master/data/docker-php-entrypoint

    # first arg is `-f` or `--some-option`
    if [ "${1#-}" != "$1" ]; then
        set -- php-fpm "$@"
    fi

    exec "$@"
fi
