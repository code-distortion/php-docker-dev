#!/bin/bash

alias pa="php artisan"
pas() {
  php artisan | grep --color=auto -i "$1"
}

app() {
  # if there is no argument, just run artisan and grep the results
  if [[ "$#" -le 0 ]]; then
    php artisan | grep "app:"
    return "$?"
  fi

  ARG1="$1"
  shift 1 # remove the first argument

  php artisan "app:${ARG1}" "$@"
  return $?
}
