#!/usr/bin/env bash
set -e

DOTFILES=$(cd "$(dirname "$0")" && pwd)

echo "Stowing shared configs..."
for dir in "$DOTFILES/shared"/*/; do
  stow -R -d "$DOTFILES/shared" -t ~ "$(basename "$dir")"
done

echo "Stowing macOS configs..."
for dir in "$DOTFILES/macos"/*/; do
  stow -R -d "$DOTFILES/macos" -t ~ "$(basename "$dir")"
done

echo "Done."
