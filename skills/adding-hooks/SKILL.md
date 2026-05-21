---
name: adding-hooks
description: Use this skill when the user wants to enforce a rule that the
  agent must not bypass, or when the SPEC.md lists a "hard rule" in the
  rules section. Triggers include "add a hook", "enforce X", "block the
  agent from doing Y", "prevent Z from happening", "make sure tests run
  before commit". Hooks are heavier than skills — only add them for rules
  the agent could plausibly forget or rationalise away under pressure.
---

# Adding Hooks

Hooks are shell or JS scripts that fire on Claude Code lifecycle events.
They can **block** actions, audit them, or inject context.

## When to add a hook (vs a skill)

Add a hook when:

- The rule must hold even if the agent gets distracted or rationalises.
- Skipping the rule would cause real damage (bad commit, deleted file,
  prod incident).
- The rule is mechanically checkable (run a command, parse output).

Don't add a hook when:

- The rule is a suggestion or best-practice.
- The rule is judgement-based ("write good tests").
- A skill description already handles it reliably.

## Available events

| Event | Fires | Use it for |
| --- | --- | --- |
| `UserPromptSubmit` | Before agent processes user input | Inject context, log prompts |
| `PreToolUse` | Before any tool call | Block dangerous tool calls |
| `PostToolUse` | After a tool call returns | Audit, log, react to results |
| `Notification` | When the agent surfaces a notification | Pipe to external alerting |
| `Stop` | When the agent finishes a turn | Cleanup, run tests |

## File layout

Hooks live in `hooks/` at the plugin root. Register them in a
`hooks/hooks.json` file:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "command": "$CLAUDE_PROJECT_DIR/hooks/check-tests-exist.sh"
      }
    ]
  }
}
```

The `matcher` is a regex against the tool name. Use it to scope the hook
to relevant tools only — a hook that runs on every tool call is a
performance disaster.

## Hook script contract

A hook script:

- Reads JSON from stdin (the event payload).
- Writes JSON to stdout (the response).
- Exits 0 (allow), or non-zero with `{ "decision": "block", "reason": "..." }`
  on stdout to block the action.

Minimal example (`hooks/check-tests-exist.sh`):

```bash
#!/usr/bin/env bash
set -euo pipefail

# Read the event
event=$(cat)

# Extract the file path being written
file=$(echo "$event" | jq -r '.tool_input.file_path // empty')

# Skip if not a source file
case "$file" in
  *.test.*|*.spec.*|*test_*) exit 0 ;;
  *.js|*.ts|*.py)
    # Check that at least one test file exists in the same dir
    dir=$(dirname "$file")
    if ! ls "$dir"/*.test.* "$dir"/test_*.* 2>/dev/null | head -1 > /dev/null; then
      echo '{"decision":"block","reason":"No test file in this directory. Write a failing test first (TDD)."}'
      exit 2
    fi
    ;;
esac

exit 0
```

Make it executable: `chmod +x hooks/check-tests-exist.sh`.

## Anti-patterns

- Using a hook to nag the agent with reminders. Use skill descriptions
  instead.
- Blocking on heuristics that have false positives — the user will lose
  trust in the plugin within five minutes.
- Hooks that take more than a second to run. They block the agent.
- Hooks that depend on host-specific tools (`brew`, `apt`) — they break
  cross-platform.

## Next step

Run `testing-skill-triggers` (also covers hook behaviour) to validate the
hook fires only when intended.
