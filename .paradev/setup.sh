#!/usr/bin/env bash
# Paradev workspace setup: install dependencies (if any) and copy untracked
# local files from the main checkout into this workspace.
set -euo pipefail

ROOT="${SUPERSET_ROOT_PATH:?SUPERSET_ROOT_PATH is not set}"
WS="${SUPERSET_WORKSPACE_PATH:-$PWD}"
cd "$WS"

# --- Dependencies (only if a manifest exists) -------------------------------
installed=0
if [[ -f package.json ]]; then
  if [[ -f bun.lockb || -f bun.lock ]] && command -v bun >/dev/null; then bun install
  elif [[ -f pnpm-lock.yaml ]] && command -v pnpm >/dev/null; then pnpm install --frozen-lockfile
  elif [[ -f yarn.lock ]] && command -v yarn >/dev/null; then yarn install --frozen-lockfile
  elif [[ -f package-lock.json ]]; then npm ci
  else npm install
  fi
  installed=1
fi
if [[ -f requirements.txt ]]; then
  python3 -m venv .venv
  .venv/bin/pip install -r requirements.txt
  installed=1
fi
[[ $installed -eq 1 ]] || echo "setup: no dependency manifest found; nothing to install"

# --- Copy untracked local files from the main checkout ----------------------
# Explicit allowlist; existing files in the workspace are never overwritten.
shopt -s nullglob dotglob
for src in "$ROOT"/.env "$ROOT"/.env.* "$ROOT"/agents.md "$ROOT"/.gitignore; do
  [[ -e "$src" || -L "$src" ]] || continue
  dest="$WS/$(basename "$src")"
  if [[ -e "$dest" || -L "$dest" ]]; then
    echo "setup: $(basename "$src") already present, skipping"
  else
    cp -P "$src" "$dest"   # -P keeps symlinks (e.g. agents.md) as symlinks
    echo "setup: copied $(basename "$src")"
  fi
done
