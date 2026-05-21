#!/usr/bin/env bash
set -euo pipefail

event=$(cat)

tool=$(echo "$event" | jq -r '.tool_name // empty')
file=$(echo "$event" | jq -r '.tool_input.file_path // empty')

# Only care about SKILL.md files inside a skills/ directory
if ! echo "$file" | grep -qE 'skills/[^/]+/SKILL\.md$'; then
  exit 0
fi

# Get the text to analyse depending on the tool
if [ "$tool" = "Write" ]; then
  content=$(echo "$event" | jq -r '.tool_input.content // empty')
elif [ "$tool" = "Edit" ]; then
  new_string=$(echo "$event" | jq -r '.tool_input.new_string // empty')
  # Only validate if the edit touches the description field
  if ! echo "$new_string" | grep -q 'description:'; then
    exit 0
  fi
  content="$new_string"
else
  exit 0
fi

# Extract the description value from YAML frontmatter.
# Handles multi-line values (indented continuation lines).
description=$(echo "$content" | awk '
  /^---$/ && !in_front { in_front=1; next }
  /^---$/ && in_front  { exit }
  in_front && /^description:/ {
    sub(/^description: */, "")
    desc = $0
    next
  }
  in_front && desc != "" && /^[[:space:]]/ {
    sub(/^[[:space:]]+/, " ")
    desc = desc $0
    next
  }
  in_front && desc != "" { exit }
  END { print desc }
' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

if [ -z "$description" ]; then
  printf '{"decision":"block","reason":"SKILL.md is missing a description field in the YAML frontmatter."}\n'
  exit 2
fi

# The doctrine: description MUST start with "Use this skill when" or "Use this skill whenever"
if ! echo "$description" | grep -qiE '^Use this skill (when|whenever)'; then
  preview=$(echo "$description" | cut -c1-80)
  printf '{"decision":"block","reason":"SKILL.md description must start with \"Use this skill when...\" or \"Use this skill whenever...\" — got: \"%s\""}\n' "$preview"
  exit 2
fi

exit 0
