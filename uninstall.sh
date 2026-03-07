#!/usr/bin/env bash
set -e

MARKETPLACE="devflow"
PLUGIN="devflow"

if ! command -v claude >/dev/null 2>&1; then
  echo "error: claude CLI not found." >&2
  echo "Install it from https://docs.anthropic.com/en/docs/claude-code/setup" >&2
  exit 1
fi

echo "Uninstalling $PLUGIN"
echo ""

claude plugin uninstall "$PLUGIN@$MARKETPLACE" || true
claude plugin marketplace remove "$MARKETPLACE" || true

echo ""
echo "Done."
