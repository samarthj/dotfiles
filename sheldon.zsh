#!/usr/bin/env zsh

# shellcheck disable=SC1090
# source "${HOME}"/.installrc
"${0%/*}"/installer.sh

# shellcheck disable=SC1090,SC1091
source "${0%/*}"/helpers.sh

# Oh My Zsh settings here
plugins=(
  # Autocomplete / aliases
  git github gitignore golang
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
  # programs
  1password rust
  # secrets
  ssh-agent gpg-agent
)

# os specific plugins
is_os ubuntu && plugins+=(ubuntu)
is_os debian && plugins+=(debian)
is_os manjaro && plugins+=(archlinux)
is_os amzn && plugins+=(yum)
is_os Darwin && plugins+=(macos)

# program dependent helpers
prog_plugins=(
  adb ansible ant aws bazel brew
  bundler celery docker docker-compose
  fasd fzf gcloud httpie kate
  keychain kubectl minikube mvn nmap node npm
  nvm pass pip rsync ruby
  rvm tmux ufw yarn
)
for p in "${prog_plugins[@]}"; do
  prog_exists "$p" && plugins+=("$p")
done

# init
eval "$(sheldon source)"

bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down
# shellcheck disable=SC2154
bindkey "${terminfo[kcuu1]}" history-substring-search-up
bindkey "${terminfo[kcud1]}" history-substring-search-down
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# Done
echo "${0##*/} done in $(format_time $SECONDS)..."
