#!/usr/bin/env bash
set -euo pipefail

if ! command -v pi >/dev/null 2>&1; then
  echo "error: pi is not installed or not on PATH" >&2
  exit 1
fi

PACKAGES=(
  # npm packages (published, no local dep needed)
  npm:pi-subagents
  npm:@codexstar/pi-listen

  # git packages
  git:github.com/PSeitz/skills
)

# Subdirectories of PSeitz/my-pi-packages — not installable via git
# because pi doesn't support subdirectory refs (e.g. git:github.com/user/repo/subdir).
# These need their own repos or npm packages:
#   ./no-expert-pi-package
#   ./pi-skills
#   ./prompt-history-pi-package

for pkg in "${PACKAGES[@]}"; do
  echo "pi install $* $pkg"
  pi install "$@" "$pkg"
done
