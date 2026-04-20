#!/usr/bin/env bash
# mm session-start hook
# Resolves mm config and injects values into session context.
# Detects missing settings and requests mm:init if needed.

set -euo pipefail

# Find config file (mm.toml > mm.yaml > mm.json)
CONFIG_FILE=""
for f in mm.toml mm.yaml mm.json; do
  if [ -f "$f" ]; then
    CONFIG_FILE="$f"
    break
  fi
done

# Known required settings and their defaults
DOCS_ROOT_DEFAULT=".eng-docs"
ISSUE_TRACKER_DEFAULT="github"

# Parse value from TOML key=value line (handles quoted and unquoted values)
parse_toml_value() {
  local key="$1"
  local file="$2"
  { grep -E "^${key}\s*=" "$file" 2>/dev/null || true; } \
    | head -1 \
    | sed -E 's/^[^=]+=\s*//' \
    | sed -E 's/#[^"]*$//' \
    | sed -E "s/^['\"]//; s/['\"].*$//" \
    | sed -E 's/^[[:space:]]+|[[:space:]]+$//'
}

# Parse TOML array value (e.g. key = ["a", "b"]) — returns [] if key absent
parse_toml_array() {
  local key="$1"
  local file="$2"
  local line
  line=$(grep -E "^${key}\s*=" "$file" 2>/dev/null | head -1 || true)
  if [ -z "$line" ]; then
    echo "[]"
    return
  fi
  # Extract everything after the = sign, strip leading/trailing whitespace and tabs
  local val
  val=$(printf '%s' "$line" | sed -E 's/^[^=]+=[ \t]*//' | sed -E 's/[ \t]+$//')
  echo "$val" | sed -E 's/,[ \t]+/,/g'
}

if [ -z "$CONFIG_FILE" ]; then
  # No config file found — request mm:init
  printf '{"additionalContext": "No mm.toml found. Starting mm:init to configure mm for this project."}\n'
  exit 0
fi

# Parse current values
DOCS_ROOT=$(parse_toml_value "docs_root" "$CONFIG_FILE")
ISSUE_TRACKER=$(parse_toml_value "issue_tracker" "$CONFIG_FILE")
WAIT_FOR_APPROVAL_BEFORE=$(parse_toml_array "waitForApprovalBefore" "$CONFIG_FILE")

# Apply defaults for missing values
[ -z "$DOCS_ROOT" ] && DOCS_ROOT="$DOCS_ROOT_DEFAULT"
[ -z "$ISSUE_TRACKER" ] && ISSUE_TRACKER="$ISSUE_TRACKER_DEFAULT"

# Check for missing settings
MISSING=()
grep -qE "^docs_root\s*=" "$CONFIG_FILE" || MISSING+=("docs_root")
grep -qE "^issue_tracker\s*=" "$CONFIG_FILE" || MISSING+=("issue_tracker")

if [ ${#MISSING[@]} -gt 0 ]; then
  MISSING_LIST=$(printf '%s, ' "${MISSING[@]}" | sed 's/, $//')
  printf '{"additionalContext": "mm config: docs_root=\"%s\", issue_tracker=\"%s\", waitForApprovalBefore=%s\\n\\nmm.toml is missing settings: %s. Starting mm:init to fill them in."}\n' \
    "$DOCS_ROOT" "$ISSUE_TRACKER" "$WAIT_FOR_APPROVAL_BEFORE" "$MISSING_LIST"
  exit 0
fi

# All settings present — inject resolved config values (no mm:init needed)
printf '{"additionalContext": "mm config: docs_root=\"%s\", issue_tracker=\"%s\", waitForApprovalBefore=%s"}\n' \
  "$DOCS_ROOT" "$ISSUE_TRACKER" "$WAIT_FOR_APPROVAL_BEFORE"
exit 0
