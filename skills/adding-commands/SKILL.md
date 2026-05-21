---
name: adding-commands
description: Use this skill when the user wants to add a slash command to
  a plugin, or when the architecture identified a repeated prompt that
  should be exposed as a command. Triggers include "add a /command", "create
  a slash command", "I want to type /foo and have it do bar", "expose this
  as a command". Slash commands are user-typed shortcuts that inject a
  pre-written prompt — not the same as skills, which auto-trigger.
---

# Adding Slash Commands

Slash commands let the user type `/my-command` to inject a pre-written
prompt. Useful for actions the user wants to invoke explicitly rather
than relying on automatic skill triggering.

## When to add a command (vs a skill)

Add a command when:

- The user wants explicit control over when something runs.
- The prompt is long enough that retyping it is friction.
- The trigger is hard to express in a skill description.

Add a skill when:

- The action should happen automatically in a known context.
- You want the agent to decide when to fire it.

A command can also *invoke* a skill — `/review-pr` can be a thin wrapper
that says "now apply the `reviewing-pull-request` skill to this URL".

## File layout

Commands live in `commands/` at the plugin root. One Markdown file per
command:

```
commands/
├── new-plugin.md         → /new-plugin
└── review-pr.md          → /review-pr
```

The filename (without `.md`) becomes the command name.

## File format

```markdown
---
description: One-line help text shown in the command picker.
argument-hint: "<url>"
---

[The prompt that gets injected when the user runs the command.
You can reference $ARGUMENTS for whatever the user typed after the
command name.]
```

## Worked example

`commands/review-pr.md`:

```markdown
---
description: Review a pull request end-to-end.
argument-hint: "<github-pr-url>"
---

I want a full review of this PR: $ARGUMENTS

Apply the `reviewing-pull-request` skill. Specifically:

1. Fetch the diff and the PR description.
2. Run the `checking-tests` skill on changed files.
3. Run the `security-review` sub-agent.
4. Produce a structured review with severity-tagged findings.

Block on critical issues. Surface medium/low as recommendations.
```

When the user types `/review-pr https://github.com/me/repo/pull/42`, the
agent receives the prompt with `$ARGUMENTS` replaced.

## Anti-patterns

- Commands that just say "do X" without context. The agent already does X
  when asked directly — the command adds nothing.
- Commands that bypass the skill pipeline ("just do this, ignore the
  brainstorming step"). If you need to bypass the methodology, the
  methodology is wrong.
- Twenty commands. Ten is already a lot. The user has to remember them.

## Next step

After adding commands, document them in the README under a `## Commands`
section so users can discover them.
