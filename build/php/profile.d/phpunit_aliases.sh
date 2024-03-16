#!/bin/bash

alias phpunit='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-notices --display-warnings --exclude-group=skip,quarantined'
alias t='phpunit'
alias tf='phpunit --filter'

alias phpunit-skip='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-notices --display-warnings --group=skip'
alias s='phpunit-skip'

alias phpunit-quarantined='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-notices --display-warnings --group=quarantined'
alias q='phpunit-quarantined'

alias infection='vendor/bin/infection --threads=max --show-mutations --test-framework-options="--exclude-group=skip"'
alias i='infection'
