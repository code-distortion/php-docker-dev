#!/bin/bash

alias phpunit='./vendor/bin/phpunit --stop-on-error --stop-on-failure --exclude-group=skip,quarantined'
alias phpunit-skip='./vendor/bin/phpunit --stop-on-error --stop-on-failure --group=skip'
alias phpunit-quarantined='./vendor/bin/phpunit --stop-on-error --stop-on-failure --group=quarantined'
