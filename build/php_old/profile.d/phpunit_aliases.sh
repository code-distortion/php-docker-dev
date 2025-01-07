#!/bin/bash

alias phpunit='./vendor/bin/phpunit --stop-on-error --stop-on-failure --exclude-group=skip,quarantined'
alias phpunit-skip='./vendor/bin/phpunit --stop-on-error --stop-on-failure --group=skip'
alias phpunit-quarantined='./vendor/bin/phpunit --stop-on-error --stop-on-failure --group=quarantined'
alias t='phpunit'
alias tf='./vendor/bin/phpunit --stop-on-error --stop-on-failure --filter'
alias infection='./vendor/bin/infection --threads=max --show-mutations'
