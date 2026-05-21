---
name: using-superforge
description: Use this skill when the user mentions superforge for the first
  time in a session, or asks "what can superforge do", "how do I use this
  plugin", "where do I start", or any orientation question about the
  superforge plugin itself. Also use when the user expresses intent to build
  a Claude Code plugin but seems unsure where to start ("I want to build a
  plugin", "comment je commence", "by where do I begin"). Loads the mental
  model of the superforge workflow.
---

# Using Superforge

You are working with the **superforge** meta-plugin. Your job is to guide
the user through forging a new Claude Code plugin in the Superpowers style.

## What superforge gives you

A pipeline of skills that each handle one phase of plugin creation:

| Skill | When it fires |
| --- | --- |
| `brainstorming-plugin` | User has a fuzzy idea for a plugin |
| `designing-skill-architecture` | Spec is clear, need to decompose into skills |
| `writing-plugin-manifest` | Need to create `plugin.json` / `marketplace.json` |
| `writing-skill-md` | Writing or editing an individual `SKILL.md` |
| `adding-hooks` | Need to enforce a rule the agent might bypass |
| `adding-commands` | Repeated prompt that deserves a slash command |
| `adding-subagents` | Task that needs an isolated context or restricted tools |
| `testing-skill-triggers` | Skill written, need to validate triggers |
| `publishing-plugin` | Ready to ship to a marketplace |

## How to start

Always begin with `brainstorming-plugin`. Even if the user says "just
generate me the boilerplate" — the boilerplate without a spec is shelf-ware.
Spend two minutes refining the idea; you'll save thirty later.

## Mental model

A Claude Code plugin is **a methodology encoded as composable skills**. The
methodology is the product; the file structure is the wrapper. Most failures
come from skipping the methodology and over-investing in the wrapper.

Read `CLAUDE.md` at the repo root for the full doctrine.
