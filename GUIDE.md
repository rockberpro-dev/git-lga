# Install Guide

Details that the [README](README.md) leaves out: what the setup script does, how to install by hand, and how to remove everything.

## What the setup script does

The script makes three changes:

1. It copies `git-lga.gitconfig`, `git-lga-help.sh` and `git-lga.bashrc` to `~/.config/git-lga/` (or `$XDG_CONFIG_HOME/git-lga/`).
2. It adds an `[include]` entry to `~/.gitconfig`, so your own config stays untouched.
3. It adds a `source` line to `~/.bashrc`, which installs the shell aliases (g-prefix).

Older versions put the files directly in `~/`. Run the script again to upgrade that install: it removes the old files, the old include and the old source line.

Read the source before you run it: [setup.sh](setup.sh), [setup.ps1](setup.ps1).

## Manual install

```bash
mkdir -p ~/.config/git-lga

curl -sL https://raw.githubusercontent.com/rockberpro-dev/git-lga/main/git-lga.gitconfig \
  -o ~/.config/git-lga/git-lga.gitconfig

curl -sL https://raw.githubusercontent.com/rockberpro-dev/git-lga/main/git-lga-help.sh \
  -o ~/.config/git-lga/git-lga-help.sh && chmod +x ~/.config/git-lga/git-lga-help.sh

curl -sL https://raw.githubusercontent.com/rockberpro-dev/git-lga/main/git-lga.bashrc \
  -o ~/.config/git-lga/git-lga.bashrc

git config --global --add include.path ~/.config/git-lga/git-lga.gitconfig
echo "source ~/.config/git-lga/git-lga.bashrc" >> ~/.bashrc
```

## Uninstall

```bash
git config --global --unset-all include.path '/git-lga/git-lga\.gitconfig$'
rm -r ~/.config/git-lga
# remove source line from ~/.bashrc manually
```

## Files

[setup.sh](setup.sh) · [setup.ps1](setup.ps1) · [git-lga.gitconfig](git-lga.gitconfig) · [git-lga-help.sh](git-lga-help.sh) · [git-lga.bashrc](git-lga.bashrc) · [git-lga.ps1](git-lga.ps1)
