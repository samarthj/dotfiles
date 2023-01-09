#!/usr/bin/env zsh

setopt appendhistory autocd notify # extendedglob

# shellcheck disable=SC1090,SC1091
source $HOME/.env
source $HOME/helpers.sh

[ -f $HOME/preinit.zsh ] && source $HOME/preinit.zsh

zmodload zsh/mapfile

[ -f $HOME/personal.pathrc ] && source $HOME/personal.pathrc

# sheldon setup
source $HOME/sheldon.zsh

# ssh
export SSH_KEY_PATH="~/.ssh/id_rsa"
zstyle :omz:plugins:ssh-agent agent-forwarding on
[ -f $HOME/.ssh/id_rsa ] && zstyle :omz:plugins:ssh-agent identities id_rsa
[ -f $HOME/.ssh/aur ] && zstyle :omz:plugins:ssh-agent identities aur
[ -f $HOME/.ssh/macos ] && zstyle :omz:plugins:ssh-agent identities macos
[ -f $HOME/.ssh/id_ed25519 ] && zstyle :omz:plugins:ssh-agent identities id_ed25519

# install ncurses-compat-libs
cols=$(tput cols)

# User configuration
export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Compilation flags
export ARCHFLAGS="-arch x86_64"

source $HOME/.aliasrc

# Forcing color in terminal
# export TERM=konsole-direct
export COLORTERM=truecolor

fpath=(~/.zsh/completion ~/.zfunc $fpath $HOMEBREW_PREFIX/share/zsh/site-functions)

autoload bashcompinit && bashcompinit
complete -C 'aws_completer' aws

autoload -Uz compinit && compinit -i

autoload -U bashcompinit
bashcompinit

# pip zsh completion start
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=($(COMP_WORDS="$words[*]" \
    COMP_CWORD=$((cword - 1)) \
    PIP_AUTO_COMPLETE=1 $words[1] 2>/dev/null))
}
compctl -K _pip_completion pip3
# pip zsh completion end

# Renew environment variables in tmux
if [ -n "$TMUX" ]; then
  function renew_tmux_env_one {
    oneenv=$(tmux show-environment | grep "^$1")
    [[ ! -z $oneenv ]] && export $oneenv
  }
  function renew_tmux_env {
    renew_tmux_env_one DISPLAY
    renew_tmux_env_one SSH_CONNECTION
    renew_tmux_env_one SSH_AUTH_SOCK
  }
else
  function renew_tmux_env {}
fi

function preexec {
  renew_tmux_env
}

zle -N renew_tmux_env
# ctrl-alt-T
bindkey -M emacs '^[^T' renew_tmux_env
bindkey -M vicmd '^[^T' renew_tmux_env
bindkey -M viins '^[^T' renew_tmux_env

umask 002

[ -f $HOME/addon.zsh ] && source $HOME/addon.zsh
[ -f /usr/share/clang/bash-autocomplete.sh ] && source /usr/share/clang/bash-autocomplete.sh

# Initialize starship
eval "$(starship init zsh)"
