#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $(basename "$0") [--force] [--templates] [TARGET_DIR]

Install Asuna agent + skills into a project (Cursor + Claude Code).

  TARGET_DIR    project root (default: current directory)
  --force       overwrite existing agent/skill files
  --templates   also copy Playwright POM scaffold if e2e/ is missing
EOF
}

ROOT="$(cd "$(dirname "$0")" && pwd)"
TARGET="."
FORCE=0
TEMPLATES=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force) FORCE=1; shift ;;
    --templates) TEMPLATES=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) TARGET="$1"; shift ;;
  esac
done

if [[ ! -d "$TARGET" ]]; then
  echo "error: target is not a directory: $TARGET" >&2
  exit 1
fi
TARGET="$(cd "$TARGET" && pwd)"

copy_file() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" && "$FORCE" -eq 0 ]]; then
    echo "skip (exists): ${dest#"$TARGET"/}"
    return
  fi
  cp "$src" "$dest"
  echo "wrote: ${dest#"$TARGET"/}"
}

echo "Installing Asuna into $TARGET"

copy_file "$ROOT/agents/asuna.md" "$TARGET/.cursor/agents/asuna.md"
copy_file "$ROOT/agents/asuna.md" "$TARGET/.claude/agents/asuna.md"

while IFS= read -r -d '' f; do
  rel="${f#"$ROOT/skills/"}"
  copy_file "$f" "$TARGET/.cursor/skills/$rel"
  copy_file "$f" "$TARGET/.claude/skills/$rel"
done < <(find "$ROOT/skills" -type f -print0)

if [[ "$TEMPLATES" -eq 1 ]]; then
  if [[ -e "$TARGET/e2e" && "$FORCE" -eq 0 ]]; then
    echo "skip templates: e2e/ already exists"
  else
    mkdir -p "$TARGET/e2e"
    cp -R "$ROOT/templates/playwright/." "$TARGET/"
    echo "wrote: Playwright POM templates under e2e/ and playwright.config.ts"
  fi
fi

echo "Done. In Cursor, mention asuna (or @asuna) to write tests."
