#!/bin/bash

echo "Setting up dofiles..."

replace_file() {
  FILE=$1
  DIR=$2
  LOC=${3:-$(pwd)}
  echo "${LOC}/${FILE} -> ${DIR}/${FILE}"
  if [ -L "${DIR}/${FILE}" ]; then
    rm "${DIR}/${FILE}"
  elif [ -f "${DIR}/${FILE}" ]; then
    mv "${DIR}/${FILE}" "${DIR}/${FILE}".orig
  fi
  ln -s "${LOC}/${FILE}" "${DIR}/${FILE}"
}

declare -a files=(
  ".aliasrc"
  ".antigenrc"
  ".installrc"
  ".p10k.zsh"
  ".tmux.conf"
  ".vimrc"
  ".zpreztorc"
  ".zshrc"
  "personal.aliasrc"
  "personal.pathrc"
)

for file in "${files[@]}"; do
  replace_file "$file" "${HOME}"
done

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"

declare -a config_folders=(
  "nvim"
  "alacritty"
  "tmux"
  "filebot-formats"
)

for conf in "${config_folders[@]}"; do
  dir="${config_dir}/${conf}"
  frm="$(pwd)/${conf}"
  if [ ! -d "$frm" ]; then
    continue
  fi
  mkdir -p "$dir"
  for file in "$frm/"*; do
    replace_file "${file##*/}" "${dir}" "${frm}"
  done
done

echo "Done! Reloading..."
exec zsh
