#!/usr/bin/env bash
set -euo pipefail

if ! command -v pi >/dev/null 2>&1; then
  echo "error: pi is not installed or not on PATH" >&2
  exit 1
fi

PACKAGES=(
  # npm packages (published, no local dep needed)
  npm:pi-subagents

  # git packages
  git:github.com/PSeitz/pi-listen
  git:github.com/PSeitz/skills
  git:github.com/PSeitz/no-expert-pi-package
  git:github.com/PSeitz/prompt-history-pi-package
)

for pkg in "${PACKAGES[@]}"; do
  echo "pi install $* $pkg"
  pi install "$@" "$pkg"
done
