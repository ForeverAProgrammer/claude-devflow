#!/usr/bin/env bash
set -e

COMMANDS_DIR="$(cd "$(dirname "$0")/commands" && pwd)"
TARGET_DIR="$HOME/.claude/commands"

echo "Uninstalling Claude commands from $TARGET_DIR"
echo ""

# Remove symlinks for all current commands in this repo
for file in "$COMMANDS_DIR"/*.md; do
  name=$(basename "$file" .md)
  target="$TARGET_DIR/$(basename "$file")"

  if [ -L "$target" ]; then
    unlink "$target"
    echo "  removed /$name"
  elif [ -f "$target" ]; then
    echo "  skipped /$name (not a symlink — remove manually: $target)"
  else
    echo "  skipped /$name (not installed)"
  fi
done

# Remove any orphaned symlinks in TARGET_DIR that still point into this repo
# (covers commands that were renamed or deleted from the repo)
if [ -d "$TARGET_DIR" ]; then
  for link in "$TARGET_DIR"/*.md; do
    [ -e "$link" ] || continue
    if [ -L "$link" ]; then
      dest=$(readlink "$link")
      if [[ "$dest" == "$COMMANDS_DIR"/* ]]; then
        name=$(basename "$link" .md)
        unlink "$link"
        echo "  removed /$name (orphaned symlink)"
      fi
    fi
  done
fi

echo ""
echo "Done."
