#!/bin/bash

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'

repeat() {

  # colours for error output
  local RED="\033[0;31m"
  local RESET="\033[0m"

  # pick the number of times to repeat the command
  local TIMES="$1"
  shift

  # check to see if the caller specified -F or --force
  local FORCE=false
  if [[ "${TIMES}" == "-F" ]] || [[ "${TIMES}" == "--force" ]]; then
    FORCE=true
    local TIMES="$1"
    shift
  fi

  # validate the input
  if [[ ! "${TIMES}" =~ ^[0-9]+$ ]]; then
    echo -e "\n${RED}ERROR: repeat requires a positive integer as the first argument.${RESET}\n" >&2
    return 1
  fi

  if [[ "${TIMES}" -le 0 ]]; then
    echo -e "\n${RED}ERROR: repeat requires a positive integer as the first argument.${RESET}\n" >&2
    return 1
  fi

  if [[ "$#" -le 0 ]]; then
    echo -e "\n${RED}ERROR: Please enter a command to repeat.${RESET}\n" >&2
    return 1
  fi

  # run the command $TIMES number of times
  local COUNT
  for COUNT in $(seq "${TIMES}"); do

    eval "$@"

    # stop if an error occurred and the user did not specify --force
    if [[ $? -ne 0 ]] && [[ "${FORCE}" == false ]]; then
      return $?
    fi
  done
}

