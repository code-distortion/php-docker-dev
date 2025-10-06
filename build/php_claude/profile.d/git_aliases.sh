#!/bin/bash

alias gf="git fetch --prune --all"
alias gpull="git pull"
alias gpush="git push"
alias gdiff="git diff"
alias glog="git log"
alias ga="git add . --all"
alias gs="git status"
alias gb="git branch"
alias gc="git checkout"
alias gcm="git checkout master"
alias gcmm="git checkout main"
alias gmm="git merge master"
alias gpf="git push --force"

function gamend {
  if (( "$#" != 0 )); then
    git add $@
  fi
  git commit --amend --no-edit
}
