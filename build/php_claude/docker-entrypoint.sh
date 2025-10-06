#!/bin/sh
set -e



# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- php-fpm "$@"
fi



# add ccstatusline to Claude Code
PHP_CLAUDE_INSTALL_CCSTATUSLINE="${PHP_CLAUDE_INSTALL_CCSTATUSLINE:-}"
if [ "${PHP_CLAUDE_INSTALL_CCSTATUSLINE}" = "true" ]; then

    # only for www-data user
    if [ $(id -u) = "1000" ]; then
        mkdir -p ~/.claude
        # add the ccstatusline settings to .claude/settings.json
        jq -s add ~/.claude/settings.json ~/claude.settings.json.template > ~/.claude/settings.json
    fi
fi

exec "$@"
