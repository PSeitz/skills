#!/bin/bash
set -e

SKILLS_REPO="https://github.com/PSeitz/skills.git"
TARGET_DIR="${HOME}/.agents"

echo "==> Installing PSeitz/skills into ${TARGET_DIR}..."

mkdir -p "${TARGET_DIR}"
cd "${TARGET_DIR}"

if [ -d .git ]; then
    echo "  -> Already a git repo, pulling updates..."
    git pull --ff-only
else
    echo "  -> Initializing git repo..."
    git init
    git remote add origin "${SKILLS_REPO}"
    git fetch --depth 1 origin main
    git checkout -b main FETCH_HEAD
fi

echo "==> Done!"
ls "${TARGET_DIR}/"
