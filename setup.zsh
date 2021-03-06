#!/bin/bash

echo "Setting up dotfiles..."

SCRIPT_DIR=$(dirname "$0")

replace_file() {
  FILE=$1
  DIR=$2
  LOC=${3:-$(pwd)/${SCRIPT_DIR##./}}
  echo "${LOC}/${FILE} -> ${DIR}/${FILE}"
  if [ -L "${DIR}/${FILE}" ]; then
    rm "${DIR}/${FILE}"
  elif [ -f "${DIR}/${FILE}" ]; then
    mv "${DIR}/${FILE}" "${DIR}/${FILE}".orig
  fi
  ln -s "${LOC}/${FILE}" "${DIR}/${FILE}"
}

replace_dir() {
  CURR=$1
  DIR=$2
  echo "${CURR} -> ${DIR}"
  if [ -L "${DIR}" ]; then
    rm -f "${DIR}"
  elif [ -d "${DIR}" ]; then
    mv "${DIR}" "${DIR}".orig
  fi
  ln -sf "${CURR}" "${DIR}"
}

declare -a files=(
  ".aliasrc"
  ".env"
  ".fdignore"
  "helper.installrc"
  ".installrc"
  ".p10k.zsh"
  "sheldon.zsh"
  ".tmux.conf"
  ".vimrc"
  ".zshrc"
)

for file in "${files[@]}"; do
  replace_file "$file" "${HOME}"
done

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"

declare -a config_folders=(
  "nvim"
  "alacritty"
  "tmux"
  "bat"
)

declare -a config_files=(
  "sheldon/plugins.toml"
)

for conf in "${config_folders[@]}"; do
  dir="${config_dir}/${conf}"
  frm="$(pwd)/${SCRIPT_DIR##./}/${conf}"
  if [ ! -d "$frm" ]; then
    continue
  fi
  mkdir -p "$dir"
  replace_dir "${frm}" "${dir}"
done

for conf in "${config_files[@]}"; do
  dir="${config_dir}/${conf%/*}"
  frm="$(pwd)/${SCRIPT_DIR##./}/${conf}"
  if [ ! -f "$frm" ]; then
    continue
  fi
  mkdir -p "$dir"
  replace_file "${frm##*/}" "${dir}" "${frm%/*}"
done

echo "Done! Reloading..."
