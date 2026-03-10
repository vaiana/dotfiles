#!/usr/bin/env bash
set -e

DOTFILES=$(cd "$(dirname "$0")" && pwd)

echo "Stowing shared configs..."
for dir in "$DOTFILES/shared"/*/; do
  stow -d "$DOTFILES/shared" -t ~ "$(basename "$dir")"
done

echo "Stowing Linux configs..."
for dir in "$DOTFILES/linux"/*/; do
  stow -d "$DOTFILES/linux" -t ~ "$(basename "$dir")"
done

echo "Done."
