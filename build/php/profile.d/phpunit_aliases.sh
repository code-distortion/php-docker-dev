#!/bin/bash



# aliases for the current version of PHPUnit
alias phpunit='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-phpunit-deprecations --display-notices --display-warnings --exclude-group=skip --exclude-group=quarantined'
alias tt='phpunit'
alias tf='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-phpunit-deprecations --display-notices --display-warnings --filter'

alias phpunit-skip='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-phpunit-deprecations --display-notices --display-warnings --group=skip'
alias s='phpunit-skip'

alias phpunit-quarantined='./vendor/bin/phpunit --stop-on-error --stop-on-failure --display-deprecations --display-phpunit-deprecations --display-notices --display-warnings --group=quarantined'
alias q='phpunit-quarantined'

alias infection='vendor/bin/infection --threads=max --show-mutations --test-framework-options="--exclude-group=skip"'
alias i='infection'



# aliases for older versions of PHPUnit
alias old-phpunit='./vendor/bin/phpunit --stop-on-error --stop-on-failure --exclude-group=skip,quarantined'
alias ot='old-phpunit'
alias otf='./vendor/bin/phpunit --stop-on-error --stop-on-failure --filter'

alias old-phpunit-skip='./vendor/bin/phpunit --stop-on-error --stop-on-failure --group=skip'
alias os='old-phpunit-skip'

alias old-phpunit-quarantined='./vendor/bin/phpunit --stop-on-error --stop-on-failure --group=quarantined'
alias oq='old-phpunit-quarantined'

alias old-infection='vendor/bin/infection --threads=max --show-mutations --test-framework-options="--exclude-group=skip"'
alias oi='old-infection'
