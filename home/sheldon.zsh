#!/usr/bin/env zsh

# shellcheck disable=SC1090
# source "${HOME}"/.installrc
"${0%/*}"/installer.sh

# shellcheck disable=SC1090,SC1091
source "${0%/*}"/helpers.sh

# Oh My Zsh settings here
plugins=(
  # Autocomplete / aliases
  github
  gitignore
  golang
  #Admin
  sudo
  systemadmin
  systemd
  # File / Directory management
  copybuffer
  copyfile
  # Terminal Tweaks
  colored-man-pages
  colorize
  # Commandline Helpers
  alias-finder
  compleat #common-aliases
  command-not-found
  cp
  encode64
  extract
  jsontools
  safe-paste
  # programs
  # 1password # not found
  # secrets
  ssh-agent
  gpg-agent
)

# os specific plugins
is_os ubuntu && plugins+=(ubuntu)
is_os debian && plugins+=(debian)
is_os manjaro && plugins+=(archlinux)
is_os amzn && plugins+=(yum)
is_os Darwin && plugins+=(macos)

# program dependent helpers
prog_plugins=(
  adb
  ansible
  ant
  aws
  bazel
  brew
  bundler
  celery
  docker
  docker-compose
  gcloud
  git
  httpie
  kate
  keychain
  kubectl
  minikube
  mvn
  nmap
  node
  npm
  nvm
  pass
  pip
  rsync
  ruby
  rust
  rvm
  tmux
  ufw
  yarn
)
for p in "${prog_plugins[@]}"; do
  prog_exists "$p" && plugins+=("$p")
done

# init
eval "$(sheldon source)"

# Done
[[ -n $VERBOSE_DOTFILES ]] && echo "${0##*/} done in $(format_time $SECONDS)..."
