#!/usr/bin/env bash

# shellcheck disable=SC1090,SC1091
source "${0%/*}"/helpers.sh

os_install() {
  prog=$1
  prog_exists "$prog" && return
  echo "-------------------"
  echo "installing $prog..."
  (is_os ubuntu && sudo apt-get install -y "$prog") ||
    (is_os debian && sudo apt-get install -y "$prog") ||
    (is_os amzn && sudo yum install -y "$prog") ||
    (is_os manjaro && sudo pacman -Sy "$prog" --noconfirm) ||
    (is_os Darwin && brew install "$prog")
}

install_ssl() {
  prog_exists "openssl" && return
  echo "-------------------"
  echo "installing openssl..."
  (is_os ubuntu && sudo apt-get install -y libssl-dev) ||
    (is_os debian && sudo apt-get install -y libssl-dev) ||
    (is_os manjaro && sudo pacman -Sy openssl --noconfirm)
}

install_nerdfont() {
  mkdir -p "${XDG_DATA_HOME}"/fonts/
  font="$1"
  echo "-------------------"
  echo "installing font $font..."
  (
    cd "${XDG_DATA_HOME}"/fonts/ || exit 1
    latest=$(
      curl -sSL1 "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" |
        grep -oP "https://.*${font}.zip" |
        head -n1
    )
    wget -qN "${latest}"
    unzip -quo "${font}.zip" -x "*Windows*" "*.ttf"
    fc-cache -f "${XDG_DATA_HOME}"/fonts/
  )
}

install_zplug() {
  echo "-------------------"
  script_exists "$ZPLUG_HOME"/init.zsh && return
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
}

install_conda() {
  prog_exists conda && return
  echo "-------------------"
  echo "installing conda prereqs..."

  is_os ubuntu && sudo apt-get install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6 ||
    is_os amzn && sudo yum install libXcomposite libXcursor libXi libXtst libXrandr alsa-lib mesa-libEGL libXdamage mesa-libGL libXScrnSaver ||
    is_os manjaro && sudo pacman -Sy libxau libxi libxss libxtst libxcursor libxcomposite libxdamage libxfixes libxrandr libxrender mesa-libgl alsa-lib libglvnd

  echo "installing anaconda..."
  wget -q "https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh"
  bash Anaconda3-2020.11-Linux-x86_64.sh

  echo "updating conda config..."
  conda config --add channels anaconda
  conda config --add channels conda-forge
  conda config --set channel_priority false
  conda config --set pip_interop_enabled True
  conda install argcomplete
}

install_python3() {
  prog_exists python3 && return
  os_install python3
}

install_pip() {
  prog_exists pip3 && return
  os_install python3-pip ||
    curl https://bootstrap.pypa.io/get-pip.py -o \
      "$HOME"/get-pip.py && python3 "$HOME"/get-pip.py
}

install_pipx() {
  prog_exists pipx && return
  python3 -m pip install --user pipx

  eval "$(register-python-argcomplete pipx)"
}

# shellcheck disable=SC2016
install_brew() {
  setup_homebrew_prefix
  prog_exists brew && return
  echo "-------------------"
  echo "installing Homebrew..." &&
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  setup_homebrew_prefix
  fpath+="$HOMEBREW_PREFIX/etc/bash_completion.d"
  # if [ -n "$HOMEBREW_PREFIX" ]; then
  #   # echo "eval \$($HOMEBREW_PREFIX/bin/brew shellenv)" >>"$HOME"/.zprofile
  #   eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
  # fi
}

install_brew_patchelf() {
  echo "-------------------"
  prog_exists brew && brew install patchelf
}

install_git() {
  prog_exists git && return
  os_install git ||
    prog_exists brew && brew install git
}

install_gcc() {
  prog_exists gcc && return
  os_install gcc ||
    prog_exists brew && brew install gcc
}

install_neovim() {
  prog_exists nvim && return
  echo "-------------------"
  echo "installing neovim..."
  is_os ubuntu && sudo add-apt-repository ppa:neovim-ppa/unstable
  os_install neovim

  # install the addons
  prog_exists python3 && python3 -m pip install pynvim
  prog_exists ruby && gem install neovim
  # TODO: fix install, failing with - no write permissions
  # prog_exists pipx && pipx install cmake-language-server
  prog_exists yarn && yarn global add neovim
}

install_nvim_plugins() {
  lang_servers=()
  prog_exists bash-language-server || lang_servers+=("$_")
  prog_exists diagnostic-languageserver || lang_servers+=("$_")
  prog_exists docker-langserver || lang_servers+=(dockerfile-language-server-nodejs)
  # prog_exists graphql-lsp || lang_servers+=(graphql-language-service-cli graphql)
  prog_exists neovim-node-host || lang_servers+=(neovim)
  prog_exists pyright || lang_servers+=("$_")
  prog_exists typescript-language-server || lang_servers+=("$_" typescript)
  prog_exists vim-language-server || lang_servers+=("$_")
  prog_exists yaml-language-server || lang_servers+=("$_")
  prog_exists vscode-css-language-server || lang_servers+=(vscode-langservers-extracted)
  prog_exists vscode-html-language-server || lang_servers+=(vscode-langservers-extracted)
  prog_exists vscode-json-language-server || lang_servers+=(vscode-langservers-extracted)
  # sql-language-server
  if [ ${#lang_servers[@]} -ne 0 ]; then
    prog_exists yarn && (
      echo "-------------------"
      echo "installing neovim plugins..."
      yarn global add "${lang_servers[@]}"
    )
  fi
  prog_exists lua-language-server || prog_exists lua-lsp || (
    if is_os manjaro; then
      os_install lua-language-server
    else
      prog_exists luarocks || os_install luarocks
      # prog_exists lua-lsp || luarocks install --server=http://luarocks.org/dev lua-lsp
      # cd "${HOME}"/ws || exit 1
      # [ -d "${HOME}"/ws/lua-language-server ] ||
      #   git clone https://github.com/sumneko/lua-language-server
      # cd lua-language-server || exit 1
      # git pull
      # prog_exists ninja || os_install ninja-build
      # git submodule update --init --recursive
      # cd 3rd/luamake || exit 1
      # compile/install.sh
      # cd ../.. || exit 1
      # ./3rd/luamake/luamake rebuild
    fi
  )

  prog_exists rustup || return
  rustup component list --installed | grep -q rust-analyzer ||
    rustup +nightly component add rust-analyzer-preview
  [ -d "${XDG_DATA_HOME}"/nvim/site/pack/packer/start/packer.nvim ] ||
    git clone https://github.com/wbthomason/packer.nvim \
      "${XDG_DATA_HOME}"/nvim/site/pack/packer/start/packer.nvim
}

install_nvm() {
  export NVM_DIR="$HOME/.nvm"
  if script_exists "$NVM_DIR"/nvm.sh; then
    source "$NVM_DIR/nvm.sh"          # This loads nvm
    source "$NVM_DIR/bash_completion" # This loads nvm bash_completion
    return
  fi
  echo "-------------------"
  echo "installing nvm..."
  rm -rf "$NVM_DIR" && git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
  # Load nvm
  script_exists "$NVM_DIR"/nvm.sh && \. "$NVM_DIR/nvm.sh"
  # Load nvm bash completion
  script_exists "$NVM_DIR"/bash_completion && \. "$NVM_DIR/bash_completion"
  prog_exists node && return
  echo "-------------------"
  echo "installing node..." &&
    nvm install node
  npm install --global yarn
}

install_tmux() {
  prog_exists tmux && return
  os_install tmux
}

install_utils() {
  os_install expect
  os_install shellcheck
  os_install htop
  os_install jq
  os_install duf
}

install_ruby() {
  os_install ruby
}

install_docker() {
  prog_exists docker && return
  echo "-------------------"
  echo "installing docker..."
  (is_os ubuntu && sudo apt-get install -y docker.io) ||
    (is_os debian && sudo apt-get install -y docker) ||
    (is_os amzn && sudo yum install -y docker) ||
    (is_os manjaro && sudo pacman -Sy docker --noconfirm)
  echo "install ecr-cred-helper..."
  prog_exists brew && brew install docker-credential-helper-ecr
  echo "configuring docker..."
  sudo usermod -aG docker "$USER"
  sudo systemctl enable docker
  sudo systemctl start docker
}

install_dnsutils() {
  prog_exists dig && return
  os_install dnsutils ||
    os_install bind-utils
}

# shellcheck disable=SC2015
install_fasd() {
  if [[ ! $(prog_exists fasd) ]]; then
    echo "-------------------"
    echo "installing fasd..."
    is_os ubuntu && sh -c 'sudo add-apt-repository -y ppa:aacebedo/fasd && sudo apt-get update && sudo apt-get install -y fasd' ||
      is_os manjaro && sudo pacman -Sy fasd --noconfirm ||
      prog_exists brew && brew install fasd
  fi
}

install_fzf() {
  prog_exists fzf && return
  os_install fzf ||
    prog_exists brew && brew install fzf
  # shellcheck disable=SC1090,SC1091
  [ -f "${HOME}/.fzf.zsh" ] && source "${HOME}/.fzf.zsh"
}

install_sheldon() {
  prog_exists sheldon && ! prog_exists cargo-binstall && return
  prog_exists sheldon && prog_exists cargo-binstall && [ -x "${HOME}/.cargo/bin/sheldon" ] && return
  echo "-------------------"
  echo "installing sheldon..."
  if ! prog_exists cargo-binstall && ! prog_exists cargo; then
    curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh |
      bash -s -- --repo rossmacarthur/sheldon --to "${HOME}/.local/bin"
  elif ! prog_exists cargo-binstall; then
    cargo install -y sheldon
  else
    cargo-binstall --no-confirm sheldon
    if [ -f "${HOME}/.local/bin/sheldon" ]; then
      rm -rf "${HOME}/.local/bin/sheldon"
    fi
  fi
}

install_starship() {
  prog_exists starship && ! prog_exists cargo-binstall && return
  prog_exists starship && prog_exists cargo-binstall && [ -x "${HOME}/.cargo/bin/starship" ] && return
  echo "-------------------"
  echo "installing starship..."
  if ! prog_exists cargo-binstall && ! prog_exists cargo; then
    os_install starship
  elif ! prog_exists cargo-binstall; then
    cargo install -y starship
  else
    cargo-install --no-confirm starship
    if [ -f "${HOME}/.local/bin/starship" ]; then
      rm -rf "${HOME}/.local/bin/starship"
    fi
  fi
}

install_rustup() {
  prog_exists rustup && return
  echo "-------------------"
  echo "installing rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  rustup default nightly
}

_cargo_binstall() {
  binary=$1
  package=$2
  message=$3
  prog_exists "$binary" && return

  if ! prog_exists cargo-binstall; then
    #echo "preinit: installing cargo-binstall"
    #cargo install -y cargo-binstall
    #_cargo_binstall "$@"
    echo "---------"
    echo "cargo install: $package (bin:$binary, usage:$message)"
    cargo install -y "$package"
  else
    echo "---------"
    echo "cargo-binstall: $package (bin:$binary, usage:$message)"
    cargo-binstall --no-confirm "$package"
  fi
}

install_rust_clis() {
  if is_os ubuntu || is_os debian; then
    sudo apt-get install -y librust-libz-sys-dev >/dev/null
  elif is_os manjaro && ! pacman -Q zlib >/dev/null; then
    sudo pacman -Sy zlib >/dev/null
  fi
  # cargo plugins
  _cargo_binstall cargo-install-update cargo-update "cargo plugin: managing updates"
  _cargo_binstall cargo-info cargo-info "cargo plugin: crate info"
  # cli utils
  _cargo_binstall dust du-dust "du replacement"
  _cargo_binstall procs procs "ps replacement"
  _cargo_binstall btm bottom "top replacement"
  _cargo_binstall ytop ytop "top replacement"
  _cargo_binstall rg ripgrep "grep replacement"
  _cargo_binstall exa exa "ls replacement"
  _cargo_binstall sd sd "sed replacement"
  _cargo_binstall bat bat "cat replacement"
  _cargo_binstall fd fd-find "find replacement"
  _cargo_binstall delta git-delta "git-diff pager"
  _cargo_binstall tldr tealdeer "man alternative with short usage examples"
  prog_exists tldr && nohup tldr --update >/dev/null 2>&1 &
  _cargo_binstall grex grex "regex creation util via test samples"
  _cargo_binstall zoxide zoxide "better navigation"
  # _cargo_binstall hck hck "cut replacement"
  # _cargo_binstall runiq runiq "sort -u replacement"
  # extra cargo plugins
  # _cargo_binstall cargo-outdated cargo-outdated "cargo plugin: outdated crates"
  # _cargo_binstall cargo-edit cargo-edit "cargo plugin: Cargo commands for modifying a Cargo.toml file"
}

install_pass() {
  prog_exists pass && return
  os_install pass ||
    prog_exists brew && brew install pass
}

install_keychain() {
  prog_exists keychain && return
  os_install keychain ||
    prog_exists brew && brew install keychain
}
