#!/bin/bash

alias phpunit='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-notices --display-warnings --exclude-group=skip,quarantined'
alias phpunit-skip='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-notices --display-warnings --group=skip'
alias phpunit-quarantined='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-notices --display-warnings --group=quarantined'
