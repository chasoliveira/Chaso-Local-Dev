#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.local/state/chaso-local-dev-backups/$(date +%Y%m%d-%H%M%S)"

mkdir -p "$BACKUP_DIR"

backup_if_exists() {
  local target="$1"
  if [ -e "$target" ] || [ -L "$target" ]; then
    mv "$target" "$BACKUP_DIR/"
  fi
}

link_file() {
  local source="$1"
  local target="$2"
  backup_if_exists "$target"
  ln -s "$source" "$target"
}

append_once() {
  local line="$1"
  local target="$2"
  touch "$target"
  if ! grep -Fqx "$line" "$target"; then
    printf '\n%s\n' "$line" >> "$target"
  fi
}

append_once '[ -f "$HOME/.config/chaso-local-dev/bashrc.shared" ] && . "$HOME/.config/chaso-local-dev/bashrc.shared"' "$HOME/.bashrc"

mkdir -p "$HOME/.config/chaso-local-dev"
link_file "$ROOT_DIR/dotfiles/bash/bashrc.shared" "$HOME/.config/chaso-local-dev/bashrc.shared"
link_file "$ROOT_DIR/dotfiles/bash/bash_aliases" "$HOME/.bash_aliases"
link_file "$ROOT_DIR/dotfiles/git/gitconfig" "$HOME/.gitconfig"

echo "Linked versioned dotfiles."
echo "Backups stored in: $BACKUP_DIR"

