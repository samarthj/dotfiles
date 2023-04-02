#!/usr/bin/env bash

SCRIPT_DIR="${0%/*}"
if [[ $SCRIPT_DIR == "." ]]; then
  SCRIPT_DIR=$PWD
fi
source "$SCRIPT_DIR/.link_helper.sh"

declare -a deep_links=(
  ".config"
  ".local"
  "home"
)

for d in "${deep_links[@]}"; do
  deep_link_home "${d}"
done

# Done
[[ -n $VERBOSE_DOTFILES ]] && source $HOME/helpers.sh && echo "${0##*/} done in $(format_time $SECONDS)..."
