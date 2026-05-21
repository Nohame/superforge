---
name: adding-subagents
description: Use this skill when the architecture identified a task that
  needs an isolated context, a restricted toolset, or to run in parallel
  with the main conversation. Triggers include "add a sub-agent", "create
  a specialised agent for X", "I want a reviewer agent", "run this in a
  separate context", "spawn an agent to handle Y". Sub-agents are heavier
  than skills — only add when the isolation actually matters.
---

# Adding Sub-Agents

A sub-agent is a Claude instance with its own system prompt, its own
toolset, and its own context window. The main agent invokes it via the
Task tool. Use sub-agents for tasks where context isolation or tool
restriction matters.

## When to add a sub-agent (vs a skill)

Add a sub-agent when:

- The task needs a fresh context (no pollution from earlier work).
- The task should run in parallel with other work.
- You want to restrict the tools available (e.g., read-only review agent).
- You want an independent opinion (code review, fact-check).

Don't add a sub-agent when:

- A skill running in the main context would do the job.
- The task needs the main conversation's context to make sense.

Superpowers uses sub-agents heavily for `subagent-driven-development`:
each engineering task gets a fresh sub-agent, isolating bugs and keeping
the main context lean.

## File layout

Sub-agents live in `agents/` at the plugin root. One Markdown file per
agent:

```
agents/
├── code-reviewer.md
└── security-auditor.md
```

## File format

```markdown
---
name: code-reviewer
description: When the user wants an independent review pass on freshly
  written code. Operates read-only; can't modify files.
tools: Read, Grep, Glob, Bash
model: sonnet
---

# Code Reviewer

You are an independent code reviewer. You have not seen the conversation
that produced this code. Your job is to review it as a fresh pair of
eyes.

## Process

1. Read the changed files.
2. Look for: bugs, missing tests, security issues, naming problems.
3. Report findings tagged by severity: critical / important / minor.

## Constraints

- You may not modify files.
- You may not run destructive commands.
- Your report must be ≤300 words.
```

### Frontmatter fields

- **`name`** — invoked as `subagent_type: "code-reviewer"` from the Task
  tool.
- **`description`** — the main agent reads this to decide when to invoke.
- **`tools`** — comma-separated list. Omit to inherit all tools (rarely
  what you want).
- **`model`** — `haiku`, `sonnet`, or `opus`. Use `haiku` for fast,
  simple checks; `opus` for deep review.

## How the main agent invokes it

```
Task({
  description: "Independent code review of /src/auth.ts",
  subagent_type: "code-reviewer",
  prompt: "Review /src/auth.ts for the JWT validation changes. Focus
on whether the signature verification handles missing kid headers."
})
```

The sub-agent runs to completion and returns a single message.

## Worked example: the two-stage review pattern

Superpowers uses sub-agents for the famous "two-stage review":

1. Main agent finishes a task.
2. Spawns `spec-compliance-reviewer` (sub-agent, read-only, checks
   against the plan).
3. If pass, spawns `code-quality-reviewer` (sub-agent, read-only, checks
   style and idioms).
4. If both pass, commits.

Each sub-agent has a tight system prompt focused on its one job, and
restricted tools so it can't drift.

## Anti-patterns

- Sub-agents with the full tool palette and a vague system prompt — they
  just behave like a fresh main agent, costing tokens without focus.
- Spawning a sub-agent for every step. The main context exists for a
  reason.
- Sub-agents that need the user's input. They run to completion in one
  shot; they can't ask follow-up questions.

## Next step

Document the sub-agent in the README, and add a worked example in the
skill that invokes it so the main agent knows when to spawn.
