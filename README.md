# superforge

> An agentic skills framework for forging Claude Code plugins in the
> Superpowers style. A meta-plugin: a plugin that helps you build plugins.

Superforge takes you from "I have an idea for a plugin" to a published,
marketplace-ready plugin — without you having to remember the boilerplate,
the manifest schema, or the trigger-writing heuristics.

It's deliberately modelled on [obra/superpowers][sp] : a composable library
of skills that auto-trigger at the right moment, plus a strict doctrine
that the agent enforces. Where Superpowers is a methodology for *writing
software*, superforge is a methodology for *writing plugins*.

[sp]: https://github.com/obra/superpowers

## Platforms

| Platform | Status | Notes |
|----------|--------|-------|
| Claude Code | ✅ Full support | Skills + hooks + slash commands |
| Codex | ✅ Skills | Hook enforcement advisory only — see `skills/using-superforge/references/codex-tools.md` |
| Cursor | ✅ Skills | Hook enforcement advisory only |
| Gemini CLI | ✅ Skills | Via `GEMINI.md` entry point |

## Install

### Claude Code — via marketplace

```
/plugin marketplace add nohame/superforge
/plugin install superforge@superforge-marketplace
```

### Claude Code — direct from GitHub

```
/plugin install github:nohame/superforge
```

### Codex

Clone the repo and point your Codex config at the `skills/` directory,
or follow the instructions in your Codex plugin registry.
See `skills/using-superforge/references/codex-tools.md` for the tool
name mapping and subagent configuration.

### Gemini CLI

Place `GEMINI.md` (or a symlink) in your project root, or add the
following line to your existing `GEMINI.md`:

```
@path/to/superforge/skills/using-superforge/SKILL.md
```

## Quickstart

Once installed, just talk to your agent:

```
"I want to build a plugin that helps me review pull requests"
```

The agent will pick up `brainstorming-plugin` automatically and guide you
through the rest.

## What's inside

### Skills

- **using-superforge** — orientation skill, loads first.
- **brainstorming-plugin** — Socratic intake of the idea; identifies the
  workflow phases the plugin will encode.
- **designing-skill-architecture** — turns the phase map into a skill
  graph; decides what's a skill, what's a sub-agent, what's a hook.
- **writing-plugin-manifest** — generates `plugin.json` and
  `marketplace.json`.
- **writing-skill-md** — writes individual `SKILL.md` files; opinionated
  about frontmatter, triggers, structure, length.
- **adding-hooks** — when and how to add lifecycle hooks to enforce
  doctrine.
- **adding-commands** — slash commands for repeated prompts.
- **adding-subagents** — specialised sub-agents with their own toolset.
- **testing-skill-triggers** — eval harness to validate that each skill
  activates on intended phrases and doesn't activate on neighbours.
- **publishing-plugin** — marketplace setup, versioning, distribution.

### Commands

- `/new-plugin` — bootstrap a new plugin in the current directory.

### Agents

- `skill-reviewer` — independent review pass over a freshly-written
  `SKILL.md`, checking trigger quality and structure.

## Philosophy

- **Plan before scaffold** — every plugin starts with a brainstorm, never
  with a `plugin.json`.
- **One skill, one phase** — atomic skills compose; mega-skills don't.
- **Triggers are the product** — a skill that doesn't auto-activate is
  dead weight.
- **Progressive disclosure** — `SKILL.md` stays short, deep refs live in
  companion files.

## License

MIT
