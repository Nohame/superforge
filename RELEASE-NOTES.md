# Release Notes

## 0.1.1 — 2026-05-21

### Added

- Multi-platform support: Codex (`.codex-plugin/`), Cursor (`.cursor-plugin/`),
  Gemini CLI (`GEMINI.md`).
- `skills/using-superforge/references/codex-tools.md` — tool name mapping,
  subagent config, and command equivalents for Codex users.
- Platform table in README with per-platform install instructions.

---

## 0.1.0 — 2026-05-21

Initial release.

### Skills

- `using-superforge` — orientation skill, loads the mental model of the pipeline
- `brainstorming-plugin` — Socratic intake; produces a signed-off `SPEC.md`
- `designing-skill-architecture` — decomposes the spec into a skill graph; produces `ARCHITECTURE.md`
- `writing-plugin-manifest` — generates `.claude-plugin/plugin.json` and optional `marketplace.json`
- `writing-skill-md` — authors individual `SKILL.md` files with validated trigger descriptions
- `adding-hooks` — adds `PreToolUse`/`PostToolUse` lifecycle hooks for hard rules
- `adding-commands` — creates slash commands for repeated prompts
- `adding-subagents` — adds specialised sub-agents with isolated context and restricted tools
- `testing-skill-triggers` — builds `evals.json` eval sets and validates skill activation
- `publishing-plugin` — marketplace setup, versioning, and distribution

### Commands

- `/new-plugin` — bootstraps a new plugin through the full pipeline

### Agents

- `skill-reviewer` — independent read-only review pass over a freshly-written `SKILL.md`

### Hooks

- `check-skill-description` — blocks `Write`/`Edit` on any `skills/*/SKILL.md` whose `description`
  does not start with `"Use this skill when..."` or `"Use this skill whenever..."`
