#!/usr/bin/env bash
# Paradev teardown: stop the dev server started by run.sh, if still running.
# Never fails, so it can't block workspace deletion.
WS="${SUPERSET_WORKSPACE_PATH:-$PWD}"
cd "$WS" 2>/dev/null || exit 0
pidfile="$(git rev-parse --git-path paradev-run.pid 2>/dev/null)" || exit 0
if [[ -f "$pidfile" ]]; then
  pid="$(cat "$pidfile" 2>/dev/null || true)"
  if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
    kill "$pid" 2>/dev/null || true
    echo "teardown: stopped dev server (pid $pid)"
  fi
  rm -f "$pidfile"
fi
exit 0
