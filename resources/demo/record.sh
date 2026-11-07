#!/bin/bash
# Regenerates resources/img/demo.svg: builds a throwaway sandbox repo,
# records play.sh with asciinema and converts the cast with svg-term-cli.
# Requires: asciinema, bunx (bun), git.
set -euo pipefail

DEMO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$DEMO_DIR/../.." && pwd)"
PARENT_DIR="$(dirname "$REPO_DIR")"

SANDBOX="$PARENT_DIR/git-lga-demo"
REMOTE="$PARENT_DIR/git-lga-demo-remote.git"
WORK="$(mktemp -d)"
CAST="$WORK/demo.cast"
OUT="$REPO_DIR/resources/img/demo.svg"
PUBLIC_URL="git@github.com:rockberpro-dev/git-lga-demo.git"

trap 'rm -rf "$WORK"' EXIT

# Isolated git identity/config so the recording never uses the user's own
cat > "$WORK/gitconfig" <<CFG
[include]
    path = $REPO_DIR/git-lga.gitconfig
[user]
    name = Dev
    email = dev@example.com
[init]
    defaultBranch = main
[core]
    pager = cat
[commit]
    gpgsign = false
[advice]
    statusHints = false
    pushUpdateRejected = false
CFG
export GIT_CONFIG_GLOBAL="$WORK/gitconfig" GIT_CONFIG_SYSTEM=/dev/null
export DEMO_SANDBOX="$SANDBOX"
# Force English git output regardless of the user's locale
export LC_ALL=C.UTF-8 LANGUAGE=en_US:en

rm -rf "$SANDBOX" "$REMOTE"
git init -q --bare "$REMOTE"
git init -q "$SANDBOX"
(
    cd "$SANDBOX"
    git remote add origin "$REMOTE"
    echo "# demo" > README.md
    git add README.md && git commit -q -m "Initial commit"
    mkdir src
    printf 'export function login(user: string, pass: string): boolean {\n  return user !== "" && pass !== "";\n}\n' > src/login.ts
)

asciinema rec --overwrite -q -i 1 --cols 80 --rows 18 \
    -c "bash $DEMO_DIR/play.sh" "$CAST"

# Hide the local path of the throwaway remote
sed -i "s#$REMOTE#$PUBLIC_URL#g" "$CAST"

mkdir -p "$(dirname "$OUT")"
bunx svg-term-cli --in "$CAST" --out "$OUT" --window --no-cursor --padding 10

if grep -q "$HOME" "$OUT"; then
    echo "ERROR: $OUT leaks $HOME" >&2; exit 1
fi
echo "Generated $OUT"
