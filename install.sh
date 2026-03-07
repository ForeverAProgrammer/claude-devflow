#!/usr/bin/env bash
set -e

COMMANDS_DIR="$(cd "$(dirname "$0")/commands" && pwd)"
TARGET_DIR="$HOME/.claude/commands"

mkdir -p "$TARGET_DIR"

echo "Installing Claude commands from $COMMANDS_DIR → $TARGET_DIR"
echo ""

for file in "$COMMANDS_DIR"/*.md; do
  name=$(basename "$file")
  target="$TARGET_DIR/$name"

  if [ -L "$target" ]; then
    echo "  updated  /$name (symlink already existed)"
  elif [ -f "$target" ]; then
    echo "  skipped  /$name (non-symlink file exists — remove it manually to install)"
    continue
  else
    echo "  installed /$name"
  fi

  ln -sf "$file" "$target"
done

echo ""
echo "Done. Commands are available globally in Claude Code."
echo "To uninstall, run: unlink ~/.claude/commands/<command>.md"
