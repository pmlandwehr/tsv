#!/bin/bash
  set -o errexit -o nounset -o pipefail
function -h {
cat <<USAGE
 USAGE: tsv.bash

USAGE
}; function --help { -h ;}                 # A nice way to handle -h and --help
export LC_ALL=en_US.UTF-8                    # A locale that works consistently

function main {
  read_brazilian_cities
}

function read_brazilian_cities {
  while read_tsv state city population area
  do
    write_tsv \
      "state: $state" "city: $city" "population: ${population-?}" "area: $area"
  done
}

function read_tsv {
  IFS=$'\t' read -r "$@" && reassign_tsv_variables "$@"
}

# Interprets escape sequences in variable values and re-assigns them. Unsets
# variables that consist of `\N`.
function reassign_tsv_variables {
  for var in "$@"
  do
    local rest="${!var}" head="${!var%%\\*}" result=""
    unset "$var"
    [[ $rest != '\N' ]] || continue                      # Let nulls stay unset
    while [[ $rest != $head ]]
    do
      result+="$head"
      rest="${rest#*\\}"
      case "$rest" in
        n*)  result+=$'\n' ; rest="${rest:1}" ;;
        r*)  result+=$'\r' ; rest="${rest:1}" ;;
        t*)  result+=$'\t' ; rest="${rest:1}" ;;
        \\*) result+=$'\\' ; rest="${rest:1}" ;;
        '')  err "Trailing backslash in $var=${!var}"
      esac
      head="${rest%%\\*}"
    done
    result+="$rest"
    eval "$var"'="$result"'
  done
}

function write_tsv {
  [[ $# -gt 0 ]] || return 0
  # TODO: Escaping
  printf '%s' "$1"
  shift
  for arg in "$@"
  do printf '\t%s' "$arg"
  done
  echo
}

function msg { out "$*" >&2 ;}
function err { local x=$? ; msg "$*" ; return $(( $x == 0 ? 1 : $x )) ;}
function out { printf '%s\n' "$*" ;}

if [[ ${1:-} ]] && declare -F | cut -d' ' -f3 | fgrep -qx -- "${1:-}"
then "$@"
else main "$@"
fi
