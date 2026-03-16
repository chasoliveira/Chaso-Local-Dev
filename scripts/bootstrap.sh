#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Linking dotfiles..."
bash "$ROOT_DIR/scripts/link-dotfiles.sh"

if [ ! -f "$ROOT_DIR/docker/.env" ]; then
  cp "$ROOT_DIR/docker/.env.example" "$ROOT_DIR/docker/.env"
  echo "Created docker/.env from template."
fi

echo
echo "Manual checks:"
echo "- Ensure Docker Desktop WSL integration is enabled for this distro."
echo "- Install oh-my-posh and FiraCode Nerd Font on new machines."
echo "- Open VS Code in this repo and accept extension recommendations."

