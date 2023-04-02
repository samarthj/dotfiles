#!/usr/bin/env bash

function replace_file() {
  local FILE=$1
  local DIR=$2
  LOC=${3:-$(pwd)/${SCRIPT_DIR##./}}
  if [[ ! -L "${DIR}/${FILE}" && -f "${LOC}/${FILE}" ]]; then
    echo mv -v "${DIR}/${FILE}" "${DIR}/${FILE}".orig
  fi
  echo ln -sFv "${LOC}/${FILE}" "${DIR}/${FILE}"
}

function replace_dir() {
  local CURR=$1
  local DIR=$2
  if [[ ! -L "${DIR}" && -d "${CURR}" ]]; then
    echo mv -v "${DIR}" "${DIR}".orig
  fi
  echo ln -sFv "${CURR}" "${DIR}"
}

function deep_link_home() {
  local conf="$1"
  while IFS= read -r -d '' -u 9
  do
    S_DIR=""
    REPLY="${REPLY#*$SCRIPT_DIR/}"
    if [[ "home" == $conf ]]; then
      REPLY=${REPLY#home/}
      S_DIR="home/"
    fi
    DIR="${REPLY%/*}"
    if [[ "$DIR" != "." && ! -L "$HOME/$DIR" ]]; then
      mkdir -p "$HOME/$DIR"
      ln -sf "$SCRIPT_DIR/$S_DIR$REPLY" "$HOME/$REPLY" 2>/dev/null
    elif [[ "$DIR" != "." && -L "$HOME/$DIR" ]]; then
      rm -f "$HOME/$DIR"
      ln -sTf "$SCRIPT_DIR/$S_DIR$DIR" "$HOME/$DIR"
    elif [[ "$DIR" == "." || -d "$HOME/$DIR" ]]; then
      ln -sf "$SCRIPT_DIR/$S_DIR$REPLY" "$HOME/$REPLY" 2>/dev/null
    fi
  done 9< <( find $SCRIPT_DIR -path "$SCRIPT_DIR/$conf/**" -type f -exec printf '%s\0' {} + )
}