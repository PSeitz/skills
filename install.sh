#!/usr/bin/env bash
set -euo pipefail

if ! command -v pi >/dev/null 2>&1; then
  echo "error: pi is not installed or not on PATH" >&2
  exit 1
fi

pi install git:github.com/PSeitz/skills
