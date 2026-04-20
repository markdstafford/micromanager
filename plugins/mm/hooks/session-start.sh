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

# Parse scalar value for a given key from TOML, YAML, or JSON.
# Handles: key = value (TOML), key: value (YAML), "key": value (JSON)
parse_config_value() {
  local key="$1"
  local file="$2"
  { grep -E "^\"?${key}\"?\s*[:=]" "$file" 2>/dev/null || true; } \
    | head -1 \
    | sed -E 's/^"?[^":=]*"?\s*[:=]\s*//' \
    | sed -E 's/#[^"]*$//' \
    | sed -E "s/^['\"]//; s/['\",]*\s*$//" \
    | sed -E 's/^[[:space:]]+|[[:space:]]+$//'
}

# Parse array value for a given key from TOML, YAML (flow or block), or JSON.
# Returns [] if key absent; output format: ["a","b"]
parse_config_array() {
  local key="$1"
  local file="$2"

  # Inline/flow array: key = ["a","b"] or key: [a, b] or "key": ["a","b"]
  local line
  line=$({ grep -E "^\"?${key}\"?\s*[:=]" "$file" 2>/dev/null || true; } | head -1)
  if [ -n "$line" ] && echo "$line" | grep -q '\['; then
    echo "$line" \
      | sed -E 's/^[^[]*//' \
      | sed -E 's/#[^"]*$//' \
      | tr -d ' \t'
    return
  fi

  # YAML block style:
  #   waitForApprovalBefore:
  #     - tech
  #     - taskList
  local key_line_num
  key_line_num=$({ grep -nE "^\"?${key}\"?\s*:" "$file" 2>/dev/null || true; } | head -1 | cut -d: -f1)
  if [ -n "$key_line_num" ]; then
    local values=() total_lines i next_line val
    total_lines=$(wc -l < "$file")
    i=$((key_line_num + 1))
    while [ "$i" -le "$total_lines" ]; do
      next_line=$(sed -n "${i}p" "$file")
      if echo "$next_line" | grep -qE '^\s*-\s+\S'; then
        val=$(echo "$next_line" | sed -E 's/^\s*-\s+//' | sed -E "s/^['\"]//; s/['\"]?\s*$//")
        values+=("\"$val\"")
      else
        break
      fi
      i=$((i + 1))
    done
    if [ ${#values[@]} -gt 0 ]; then
      local joined
      joined=$(printf '%s,' "${values[@]}")
      echo "[${joined%,}]"
      return
    fi
  fi

  echo "[]"
}

if [ -z "$CONFIG_FILE" ]; then
  # No config file found — request mm:init
  printf '{"additionalContext": "No mm config file found. Starting mm:init to configure mm for this project."}\n'
  exit 0
fi

# Parse current values
DOCS_ROOT=$(parse_config_value "docs_root" "$CONFIG_FILE")
ISSUE_TRACKER=$(parse_config_value "issue_tracker" "$CONFIG_FILE")
WAIT_FOR_APPROVAL_BEFORE=$(parse_config_array "waitForApprovalBefore" "$CONFIG_FILE")

# Apply defaults for missing values
[ -z "$DOCS_ROOT" ] && DOCS_ROOT="$DOCS_ROOT_DEFAULT"
[ -z "$ISSUE_TRACKER" ] && ISSUE_TRACKER="$ISSUE_TRACKER_DEFAULT"

# Check for missing required settings
MISSING=()
{ grep -qE "^\"?docs_root\"?\s*[:=]" "$CONFIG_FILE" 2>/dev/null; } || MISSING+=("docs_root")
{ grep -qE "^\"?issue_tracker\"?\s*[:=]" "$CONFIG_FILE" 2>/dev/null; } || MISSING+=("issue_tracker")

if [ ${#MISSING[@]} -gt 0 ]; then
  MISSING_LIST=$(printf '%s, ' "${MISSING[@]}" | sed 's/, $//')
  printf '{"additionalContext": "mm config: docs_root=\"%s\", issue_tracker=\"%s\", waitForApprovalBefore=%s\\n\\n%s is missing settings: %s. Starting mm:init to fill them in."}\n' \
    "$DOCS_ROOT" "$ISSUE_TRACKER" "$WAIT_FOR_APPROVAL_BEFORE" "$CONFIG_FILE" "$MISSING_LIST"
  exit 0
fi

# All settings present — inject resolved config values (no mm:init needed)
printf '{"additionalContext": "mm config: docs_root=\"%s\", issue_tracker=\"%s\", waitForApprovalBefore=%s"}\n' \
  "$DOCS_ROOT" "$ISSUE_TRACKER" "$WAIT_FOR_APPROVAL_BEFORE"
exit 0
