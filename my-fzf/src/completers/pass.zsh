#!/usr/bin/env zsh

_fzf_complete_pass() {
  _fzf_complete +m -- "$@" < <(
    local prefix
    prefix="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
    command fd -tf ".*.gpg" --follow "$prefix" |
      sed -e "s#${prefix}/\{0,1\}##" -e 's#\.gpg##' -e 's#\\#\\\\#' | sort
  )
}
