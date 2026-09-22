#!/usr/bin/env bash
set -euo pipefail

# Install Asuna for Claude Code (default). Add --cursor if you also use Cursor.
#   curl -fsSL https://raw.githubusercontent.com/memospeam/asuna/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/memospeam/asuna/main/install.sh | bash -s -- --global

ASUNA_REPO="${ASUNA_REPO:-memospeam/asuna}"
ASUNA_REF="${ASUNA_REF:-main}"

usage() {
  cat <<EOF
Install Asuna (SDET agent + skills) for Claude Code.

Usage:
  $(basename "$0") [options] [TARGET_DIR]

Options:
  --global      install for this user (all projects)
  --cursor      also install Cursor copies (.cursor/)
  --force       overwrite existing files
  --templates   copy Playwright POM scaffold (project install only)
  -h, --help    show this help

Examples:
  # this project (Claude Code)
  curl -fsSL https://raw.githubusercontent.com/${ASUNA_REPO}/${ASUNA_REF}/install.sh | bash

  # every project on this machine
  curl -fsSL https://raw.githubusercontent.com/${ASUNA_REPO}/${ASUNA_REF}/install.sh | bash -s -- --global

  # Claude Code + Cursor
  curl -fsSL https://raw.githubusercontent.com/${ASUNA_REPO}/${ASUNA_REF}/install.sh | bash -s -- --cursor
EOF
}

FORCE=0
TEMPLATES=0
GLOBAL=0
WITH_CURSOR=0
TARGET=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force) FORCE=1; shift ;;
    --templates) TEMPLATES=1; shift ;;
    --global|-g) GLOBAL=1; shift ;;
    --cursor) WITH_CURSOR=1; shift ;;
    -h|--help) usage; exit 0 ;;
    --) shift; break ;;
    -*)
      echo "error: unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      if [[ -n "$TARGET" ]]; then
        echo "error: extra argument: $1" >&2
        exit 1
      fi
      TARGET="$1"
      shift
      ;;
  esac
done

looks_like_project() {
  local dir="$1"
  [[ -f "$dir/package.json" || -d "$dir/.git" || -d "$dir/.cursor" || -d "$dir/.claude" ]]
}

if [[ "$GLOBAL" -eq 1 && -n "$TARGET" ]]; then
  echo "error: --global does not take TARGET_DIR" >&2
  exit 1
fi
if [[ "$GLOBAL" -eq 1 && "$TEMPLATES" -eq 1 ]]; then
  echo "error: --templates is for a project install, not --global" >&2
  exit 1
fi

if [[ "$GLOBAL" -eq 0 && -z "$TARGET" ]]; then
  if looks_like_project "$PWD"; then
    TARGET="$PWD"
  else
    echo "Not inside a project. Pass a folder, or install for this user:" >&2
    echo "  curl -fsSL https://raw.githubusercontent.com/${ASUNA_REPO}/${ASUNA_REF}/install.sh | bash -s -- --global" >&2
    echo "  curl -fsSL https://raw.githubusercontent.com/${ASUNA_REPO}/${ASUNA_REF}/install.sh | bash -s -- /path/to/your-project" >&2
    exit 1
  fi
fi

FETCHED=""
cleanup() {
  if [[ -n "$FETCHED" && -d "$FETCHED" ]]; then
    rm -rf "$FETCHED"
  fi
}
trap cleanup EXIT

resolve_source() {
  local src="${BASH_SOURCE[0]:-$0}"
  if [[ -n "$src" && "$src" != "bash" && "$src" != "-bash" && -f "$src" ]]; then
    local dir
    dir="$(cd "$(dirname "$src")" && pwd)"
    if [[ -f "$dir/agents/asuna.md" && -d "$dir/skills" ]]; then
      ROOT="$dir"
      return
    fi
  fi

  FETCHED="$(mktemp -d "${TMPDIR:-/tmp}/asuna.XXXXXX")"
  local url="https://codeload.github.com/${ASUNA_REPO}/tar.gz/refs/heads/${ASUNA_REF}"
  echo "Downloading ${ASUNA_REPO}@${ASUNA_REF}..." >&2
  if ! curl -fsSL "$url" | tar -xz -C "$FETCHED"; then
    echo "error: download failed. If the repo is private, clone it and run ./install.sh instead." >&2
    exit 1
  fi
  local inner
  inner="$(find "$FETCHED" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
  if [[ -z "$inner" || ! -f "$inner/agents/asuna.md" ]]; then
    echo "error: unexpected archive layout from $url" >&2
    exit 1
  fi
  ROOT="$inner"
}

ROOT=""
resolve_source
if [[ -z "$ROOT" || ! -f "$ROOT/agents/asuna.md" ]]; then
  echo "error: could not find Asuna source files" >&2
  exit 1
fi

copy_file() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" && "$FORCE" -eq 0 ]]; then
    echo "skip (exists): $dest"
    return
  fi
  cp "$src" "$dest"
  echo "wrote: $dest"
}

install_into() {
  local agent_dir="$1"
  local skills_dir="$2"
  mkdir -p "$agent_dir" "$skills_dir"
  copy_file "$ROOT/agents/asuna.md" "$agent_dir/asuna.md"
  local f rel
  while IFS= read -r -d '' f; do
    rel="${f#"$ROOT/skills/"}"
    copy_file "$f" "$skills_dir/$rel"
  done < <(find "$ROOT/skills" -type f -print0)
}

print_done() {
  local commit_hint="$1"
  echo
  if [[ -n "$commit_hint" ]]; then
    echo "เสร็จแล้ว — commit โฟลเดอร์ ${commit_hint} เพื่อให้ทีมใช้ด้วย"
  else
    echo "เสร็จแล้ว"
  fi
  echo "เปิดแชทใหม่ใน Claude Code แล้วพิมพ์:"
  echo "  @asuna เพิ่ม test หน้า login"
}

if [[ "$GLOBAL" -eq 1 ]]; then
  echo "Installing Asuna for this user (Claude Code)"
  install_into "${HOME}/.claude/agents" "${HOME}/.claude/skills"
  if [[ "$WITH_CURSOR" -eq 1 ]]; then
    echo "Also installing Cursor copies"
    install_into "${HOME}/.cursor/agents" "${HOME}/.cursor/skills"
  fi
  print_done ""
  exit 0
fi

if [[ ! -d "$TARGET" ]]; then
  echo "error: target is not a directory: $TARGET" >&2
  exit 1
fi
TARGET="$(cd "$TARGET" && pwd)"

echo "Installing Asuna into $TARGET (Claude Code)"
install_into "$TARGET/.claude/agents" "$TARGET/.claude/skills"
COMMIT=".claude/"
if [[ "$WITH_CURSOR" -eq 1 ]]; then
  echo "Also installing Cursor copies"
  install_into "$TARGET/.cursor/agents" "$TARGET/.cursor/skills"
  COMMIT=".claude/ และ .cursor/"
fi

if [[ "$TEMPLATES" -eq 1 ]]; then
  if [[ -e "$TARGET/e2e" && "$FORCE" -eq 0 ]]; then
    echo "skip templates: $TARGET/e2e already exists"
  else
    cp -R "$ROOT/templates/playwright/." "$TARGET/"
    echo "wrote: Playwright POM templates under $TARGET/e2e and playwright.config.ts"
  fi
fi

print_done "$COMMIT"
