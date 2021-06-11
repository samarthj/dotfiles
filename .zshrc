# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
p10k_instant_prompt="${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$(whoami).zsh"
if [[ -r ${p10k_instant_prompt} ]]; then
  source ${p10k_instant_prompt}
fi

export DOCKER_BUILDKIT=1
export XDG_RUNTIME_DIR="/run/user/1000"

# if [[ -z $WAYLAND_DISPLAY && -f "/run/user/1000/wayland-"* ]]; then
#   export WAYLAND_DISPLAY=$(echo ${${"$(ls /run/user/1000/wayland-* &2>/dev/null)"##*/}%.*})
# fi

if [[ -n $WAYLAND_DISPLAY ]]; then
  export QT_QPA_PLATFORM="wayland-egl"
else
  export QT_QPA_PLATFORM="xcb"
  unset WAYLAND_DISPLAY
fi

export GTK_USE_PORTAL=1

#export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/amd_pro_icd64.json

#export PINENTRY="/usr/bin/pinentry-tty"
export EDITOR=nvim

zmodload zsh/mapfile

source $HOME/personal.pathrc
echo "paths loaded ..."

# Antigen Setup
[[ -f $HOME/antigen.zsh ]] || curl -L git.io/antigen >$HOME/antigen.zsh
export ANTIGEN_DEFAULT_REPO_URL=https://github.com/custom/oh-my-zsh
export ANTIGEN_COMPDUMPFILE=$HOME/.zcompdump
source $HOME/antigen.zsh
antigen init $HOME/.antigenrc
echo "antigen loaded ..."

# install ncurses-compat-libs
cols=$(tput cols)

# User configuration
export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/id_rsa"
zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_rsa aur

echo "post antigen config loaded ..."

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

source $HOME/.aliasrc
echo "aliases loaded ..."

# Forcing color in terminal
# export TERM=konsole-direct
export COLORTERM=truecolor

fpath=(~/.zsh/completion ~/.zfunc $fpath /home/linuxbrew/.linuxbrew/share/zsh/site-functions)

autoload bashcompinit && bashcompinit
complete -C 'aws_completer' aws

autoload -Uz compinit && compinit -i

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
echo "p10k loaded ..."

# aws autocomplete
complete -C 'aws_completer' aws

autoload -U bashcompinit
bashcompinit
eval "$(register-python-argcomplete pipx)"

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
