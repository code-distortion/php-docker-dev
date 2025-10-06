#!/bin/bash



# aliases for the current version of PHPUnit
alias phpunit='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-phpunit-deprecations --display-notices --display-warnings --exclude-group=skip --exclude-group=quarantined --exclude-group=3rdParty'
alias phpunit-skip='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-phpunit-deprecations --display-notices --display-warnings --group=skip'
alias phpunit-quarantined='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-phpunit-deprecations --display-notices --display-warnings --group=quarantined'

alias t='phpunit'
alias ta='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-phpunit-deprecations --display-notices --display-warnings --exclude-group=skip --exclude-group=quarantined'
alias t3='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-phpunit-deprecations --display-notices --display-warnings --group=3rdParty'
alias tf='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-phpunit-deprecations --display-notices --display-warnings --filter'

alias i='vendor/bin/infection --threads=max --show-mutations --test-framework-options="--exclude-group=skip"'



# aliases for older versions of PHPUnit
alias old-phpunit='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-phpunit-deprecations --display-notices --display-warnings --exclude-group=skip,quarantined,3rdParty'
alias old-phpunit-skip='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-phpunit-deprecations --display-notices --display-warnings --group=skip'
alias old-phpunit-quarantined='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-phpunit-deprecations --display-notices --display-warnings --group=quarantined'

alias ot='old-phpunit'
alias ota='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-phpunit-deprecations --display-notices --display-warnings --exclude-group=skip,quarantined'
alias ot3='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-phpunit-deprecations --display-notices --display-warnings --group=3rdParty'
alias otf='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-phpunit-deprecations --display-notices --display-warnings --filter'
