---
name: designing-skill-architecture
description: Use this skill once a SPEC.md exists (produced by
  brainstorming-plugin) and the user is ready to decompose the plugin into
  concrete artefacts. Triggers include "let's design the skills", "what
  skills do we need", "how should I structure this plugin", "break this
  down". Converts the workflow phases into a skill graph, decides what
  becomes a skill vs a hook vs a sub-agent vs a slash command, and produces
  an ARCHITECTURE.md.
---

# Designing the Skill Architecture

Input: a `SPEC.md` with workflow phases. Output: an `ARCHITECTURE.md` that
maps every phase to a concrete artefact type.

## The decision tree

For each phase or rule from the spec, decide its artefact type using this
tree:

```
Is it a step the agent should follow when a specific context arises?
├── Yes → SKILL
│   ├── Does it need its own context window / restricted tools?
│   │   ├── Yes → SUB-AGENT (called from the skill)
│   │   └── No → just a skill
│
Is it a rule that must never be violated, even under pressure?
├── Yes → HOOK
│   └── Use PreToolUse / PostToolUse to block or audit
│
Is it a prompt the user types verbatim several times a week?
├── Yes → SLASH COMMAND
│
Is it static reference material the agent reads on demand?
├── Yes → REFERENCE.md inside the most relevant skill
```

## The skill graph

Draw a simple chain: which skill triggers which. Example for a PR review
plugin:

```
user pastes PR URL
   ↓
fetch-pr-context  (skill)
   ↓
analyze-diff  (skill)
   ↓ ↓
test-impact-check    security-review  (skills, can run in parallel via sub-agents)
   ↓ ↓
write-review-summary  (skill)
   ↓
[HOOK: block if no tests touched and code touched]
```

The graph tells you the trigger order, which informs the `description` of
each skill (each one should fire when its predecessor finishes).

## Naming conventions

- Skills use `kebab-case` and start with a verb: `analyzing-diff`,
  `writing-review-summary`, `checking-tests`.
- Sub-agents are nouns: `security-reviewer`, `diff-analyser`.
- Commands match user intent: `/review-pr`, `/check-tests`.

## Atomicity check

For each proposed skill, ask: "Does this do one thing?" If the description
has more than one "and" connecting verbs, split it.

Bad: `analyzing-diff-and-checking-tests-and-writing-summary`
Good: three skills, with their triggers chained.

## Deliverable

Write `ARCHITECTURE.md` with:

1. A bulleted list of every artefact (skills, hooks, commands, sub-agents)
2. The skill graph (ASCII is fine)
3. For each skill, a one-line rationale for why it's a skill and not a
   hook/command/sub-agent
4. Open questions the user must resolve before scaffolding

Get user sign-off. Then call `writing-plugin-manifest`.
