---
name: brainstorming-plugin
description: Use this skill whenever the user expresses intent to build,
  create, or scaffold a new Claude Code plugin and the plugin's purpose,
  scope, or workflow is not yet crisp. Triggers include "I want to make a
  plugin", "let's build a plugin for X", "je veux créer un plugin", "help me
  scaffold a plugin", "new plugin idea". MUST run before any file creation.
  Refines the idea through Socratic questioning, identifies the user's
  current workflow, and produces a written spec the user signs off on.
---

# Brainstorming a Plugin

Your job: refuse to write any code until you and the user agree, in writing,
on what the plugin does.

## The five questions

Ask these in order. Wait for the answer before moving on. Never ask more
than one at a time.

1. **What workflow do you do today that this plugin should encode?**
   You're not building features in the abstract. You're encoding a process
   the user already runs (or wishes they ran). If they can't describe the
   process, the plugin will be vague.

2. **What are the phases of that workflow?**
   Push for a list of 3-7 named phases. Examples for "PR review plugin":
   *read diff → check tests → check for security regressions → write
   summary*. Each phase is a future skill.

3. **What's the trigger for the plugin to engage?**
   What phrase or context tells Claude "now's the time"? "When I paste a PR
   URL", "when I say 'review this'", "every time I commit". This becomes the
   `description` of the entry-point skill.

4. **What rules must NEVER be broken?**
   Hard constraints that justify hooks. "Never approve a PR without running
   tests." "Never write code before a failing test exists." If the user has
   no such rule, hooks are probably not needed.

5. **Who else might use this plugin?**
   Solo plugin → permissive triggers, opinionated defaults. Team plugin →
   tighter triggers, more configuration, better README.

## Deliverable

Write a `SPEC.md` at the repo root capturing:

- Plugin name + one-line description
- The workflow, phase by phase
- Trigger phrases for each phase
- Hard rules (for hooks)
- Audience

Show it to the user. Get explicit sign-off ("looks good" or specific
edits). Only then call `designing-skill-architecture`.

## Anti-patterns

- Asking all five questions in one message — overwhelming.
- Skipping straight to "what should we name the plugin?" — naming is a
  trap that distracts from spec work.
- Accepting "make it do everything" — push back, scope it to one workflow.
