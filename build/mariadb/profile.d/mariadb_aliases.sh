#!/bin/bash

alias db="mariadb -h localhost -u root --password=\$MARIADB_ROOT_PASSWORD -A \$MARIADB_DATABASE"
