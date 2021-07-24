#!/bin/bash

# shellcheck disable=SC1090
source "${HOME}"/.installrc

conditionally_add() {
  plugs=$1
  for p in ${plugs[@]}; do
    prog_exists $p && plugins+=$1
  done
}

# Oh My Zsh settings here
plugins=(
  # Autocomplete / aliases
  github gitignore golang
  #Admin
  sudo systemadmin systemd
  # File / Directory management
  copybuffer copyfile zsh-interactive-cd
  # Terminal Tweaks
  colored-man-pages colorize
  # Commandline Helpers
  alias-finder compleat common-aliases
  command-not-found cp encode64 extract
  jsontools safe-paste
  # secrets
  ssh-agent gpg-agent
)

# os specific plugins
is_os ubuntu && plugins+=ubuntu
is_os debian && plugins+=debian
is_os manjaro && plugins+=archlinux
is_os amzn && plugins+=yum

# program dependent helpers
prog_plugins=(
  adb ansible ant aws bazel brew
  bundler cargo docker docker-compose
  fasd fzf gcloud git httpie kate
  keychain minikube nmap node npm
  npx nvm pass pip pipenv rsync ruby
  rust rustup rvm tmux ufw yarn
)
conditionally_add prog_plugins

# init
eval "$(sheldon source)"
