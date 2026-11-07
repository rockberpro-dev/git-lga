#!/bin/bash
# Types each line of script.txt as if a human did, then runs it.
# Meant to be run by record.sh under asciinema, inside the demo sandbox.

DEMO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$DEMO_DIR/../.." && pwd)"
SANDBOX="${DEMO_SANDBOX:?DEMO_SANDBOX not set}"

# Non-interactive bash ignores aliases unless this is set BEFORE sourcing.
shopt -s expand_aliases
source "$REPO_DIR/git-lga.bashrc" 2>/dev/null

cd "$SANDBOX" || exit 1

GREEN=$'\e[32m'; GRAY=$'\e[90m'; RESET=$'\e[0m'

type_text() {
    local text="$1" color="$2" i
    printf '%s' "$color"
    for ((i = 0; i < ${#text}; i++)); do
        printf '%s' "${text:i:1}"
        sleep 0.04
    done
    printf '%s' "$RESET"
}

sleep 0.5
while IFS= read -r line; do
    cmd="${line%%#*}"; cmd="${cmd%"${cmd##*[![:space:]]}"}"
    comment="${line#"$cmd"}"
    printf '%s$ %s' "$GREEN" "$RESET"
    sleep 0.3
    type_text "$cmd" ""
    [ -n "$comment" ] && type_text "$comment" "$GRAY"
    sleep 0.4
    printf '\n'
    eval "$cmd"
    sleep 1.2
done < "$DEMO_DIR/script.txt"

printf '%s$ %s' "$GREEN" "$RESET"
sleep 2
printf '\n'
