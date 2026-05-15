#!/usr/bin/env bash
# lib/common.sh — shared helpers for skills-* orchestrators
# Sourced by bin scripts; not executed directly.

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCES_FILE="$SKILLS_DIR/sources"

COPILOT_TARGET="$HOME/.copilot"
CLAUDE_TARGET="$HOME/.claude"

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------
log() { printf '\033[0;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[0;33mWARN:\033[0m %s\n' "$*" >&2; }
err() { printf '\033[0;31mERROR:\033[0m %s\n' "$*" >&2; }

# ---------------------------------------------------------------------------
# Path helpers
# ---------------------------------------------------------------------------
expand_path() {
  local p="$1"
  # Replace leading ~ with $HOME
  echo "${p/#\~/$HOME}"
}

# ---------------------------------------------------------------------------
# Source list reader
# Returns each resolved, non-comment, non-blank source path on stdout.
# ---------------------------------------------------------------------------
read_sources() {
  if [[ ! -f "$SOURCES_FILE" ]]; then
    err "sources file not found: $SOURCES_FILE"
    return 1
  fi
  while IFS= read -r line; do
    # Strip inline comments and trim whitespace
    line="${line%%#*}"
    line="${line#"${line%%[![:space:]]*}"}"  # ltrim
    line="${line%"${line##*[![:space:]]}"}"  # rtrim
    [[ -z "$line" ]] && continue
    expand_path "$line"
  done < "$SOURCES_FILE"
}

# ---------------------------------------------------------------------------
# Validate a source repo has the expected structure
# Returns 0 if valid (at least one package dir exists), 1 otherwise.
# ---------------------------------------------------------------------------
validate_source() {
  local src="$1"
  if [[ ! -d "$src" ]]; then
    warn "source does not exist, skipping: $src"
    return 1
  fi
  local found=0
  for pkg in shared copilot claude; do
    [[ -d "$src/$pkg" ]] && found=1 && break
  done
  if [[ "$found" -eq 0 ]]; then
    warn "source has no shared/copilot/claude dirs, skipping: $src"
    return 1
  fi
  return 0
}

# ---------------------------------------------------------------------------
# Require GNU stow
# ---------------------------------------------------------------------------
require_stow() {
  if ! command -v stow &>/dev/null; then
    err "GNU stow is not installed."
    err "Install with: brew install stow"
    exit 1
  fi
}
