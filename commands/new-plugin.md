---
description: Start forging a new Claude Code plugin from scratch.
argument-hint: "<short description of what the plugin should do>"
---

I want to build a new Claude Code plugin. Here's what it should do:

$ARGUMENTS

Apply the superforge methodology. Do NOT generate any files yet. Start
by loading the `brainstorming-plugin` skill and walking me through the
five questions, one at a time, waiting for my answer before moving on.

When the spec is signed off, proceed through the pipeline:
`designing-skill-architecture` → `writing-plugin-manifest` →
`writing-skill-md` (loop) → optional hooks/commands/sub-agents →
`testing-skill-triggers` → `publishing-plugin`.

Never skip a phase. Show me intermediate artefacts (SPEC.md,
ARCHITECTURE.md) and wait for my sign-off before scaffolding.
