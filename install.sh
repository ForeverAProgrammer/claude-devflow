#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
MARKETPLACE="devflow"
PLUGIN="devflow"

if ! command -v claude >/dev/null 2>&1; then
  echo "error: claude CLI not found." >&2
  echo "Install it from https://docs.anthropic.com/en/docs/claude-code/setup" >&2
  exit 1
fi

echo "Installing $PLUGIN from $REPO_DIR"
echo ""

claude plugin marketplace add "$REPO_DIR"
claude plugin install "$PLUGIN@$MARKETPLACE"

echo ""
echo "Done. Skills are available in Claude Code as /$MARKETPLACE:<skill-name>."
echo "To uninstall, run: ./uninstall.sh"
