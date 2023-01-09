#!/usr/bin/env bash

is_os() {
  [[ "$1" == "$(uname -s)" ]] && return 0
  [[ -f "/etc/os-release" ]] && [[ "$1" == "$(awk -F= '/^ID=/{print $2}' /etc/os-release)" ]] && return 0
  return 1
}

format_time() {
  ((h = ${1} / 3600))
  ((m = (${1} % 3600) / 60))
  ((s = ${1} % 60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

script_exists() {
  [[ -s $1 ]]
}

prog_exists() {
  command -v "$1" >/dev/null 2>&1
}

setup_rust_clis() {
  # echo "-------------------"
  # echo "setup rust_clis..."

  prog_exists rg && setup_completion "https://raw.githubusercontent.com/BurntSushi/ripgrep/master/complete/_rg" "_rg"
  prog_exists fg && setup_completion "https://raw.githubusercontent.com/sharkdp/fd/master/contrib/completion/_fd" "_fd"

  prog_exists bat && setup_bat
  prog_exists hck && alias cut='hck'

  prog_exists exa && setup_exa
  prog_exists delta && setup_delta

}

setup_bat() {
  alias cat='bat --paging=never -p'
  setup_completion "https://raw.githubusercontent.com/sharkdp/bat/master/assets/completions/bat.zsh.in" "_bat"
}

# shellcheck disable=SC2139
setup_exa() {
  EXA_CMD='exa --icons --git -F'
  alias ls="$EXA_CMD"
  alias ll="$EXA_CMD -lg --time-style=long-iso"
  alias la="$EXA_CMD -a"
  alias lla="$EXA_CMD -lag --sort=modified --time-style=long-iso"
  alias lt="$EXA_CMD --tree"
  alias lg="$EXA_CMD --git-ignore"

  setup_completion "https://raw.githubusercontent.com/ogham/exa/master/completions/zsh/_exa" "_exa"
  ln -sf "${HOME}/.zfunc/_exa" "${HOME}/.zfunc/_ls"
}

setup_delta() {
  if prog_exists delta && [[ $(git config --global pager.diff) != "delta" ]]; then
    git config --global pager.diff delta
    git config --global pager.log delta
    git config --global pager.reflog delta
    git config --global pager.show delta

    git config --global delta.plus-style "syntax #012800"
    git config --global delta.minus-style "syntax #340001"
    git config --global delta.syntax-theme "Monokai Extended"
    git config --global delta.navigate true

    git config --global interactive.diffFilter "delta --color-only"
  fi
}

setup_completion() {
  url="$1"
  file="$2"
  folder="${HOME}/.zfunc"

  mkdir -p "${folder}"

  if [ ! -f "${folder}/${file}" ]; then
    curl -fsSL "${url}" -o "${folder}/${file}"
    chmod +x "${folder}/${file}"
  fi
}

setup_homebrew_prefix() {
  if [ -z "$HOMEBREW_PREFIX" ]; then
    if [ -d "$HOME/.linuxbrew" ]; then
      HOMEBREW_PREFIX="$HOME/.linuxbrew"
    elif [ -d "/home/linuxbrew/.linuxbrew" ]; then
      HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
    elif [ -d "/usr/local" ] && [ -x "/usr/local/bin/brew" ]; then
      HOMEBREW_PREFIX="/usr/local"
    fi
  fi
}
