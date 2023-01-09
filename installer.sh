#!/usr/bin/env bash

# shellcheck disable=SC1090,SC1091
source "${0%/*}"/helper.install.sh

export POWERLEVEL9K_INSTANT_PROMPT=off

install_ssl

# install prompt
install_starship
# install plugin manager
install_sheldon
command -v apt-get && (command -v apt-sortpkgs || sudo apt-get install -y apt-utils)

# Install the basic software
[ -z "${INSTALL_RUBY}" ] || install_ruby
[ -z "${INSTALL_BREW}" ] || install_brew
install_git
install_dnsutils
install_python3
install_pip
install_pipx

# utils
install_utils
install_tmux
install_neovim
install_nvim_plugins

# Fonts
[ -z "${INSTALL_NERDFONT}" ] || install_nerdfont "${INSTALL_NERDFONT}"

# Install configurable software
[ -z "${INSTALL_RUST}" ] || install_rustup
[ -z "${INSTALL_RUSTCLIS}" ] || install_rust_clis
[ -z "${INSTALL_GCC}" ] || install_gcc
[ -z "${INSTALL_NODE}" ] || install_nvm
[ -z "${INSTALL_DOCKER}" ] || install_docker
[ -z "${INSTALL_FZF}" ] || install_fzf
[ -z "${INSTALL_FZF}" ] || export ENHANCD_FILTER=fzf-tmux
[ -z "${INSTALL_PASS}" ] || install_pass
[ -z "${INSTALL_KEYCHAIN}" ] || install_keychain

# Done
echo "${0##*/} done in $(format_time $SECONDS)..."
