# Codex Tool Mapping

Skills use Claude Code tool names. When you encounter these in a skill, use your platform equivalent:

| Skill references | Codex equivalent |
|-----------------|------------------|
| `Read` (file reading) | Use your native file read tool |
| `Write` (file creation) | Use your native file write tool |
| `Edit` (file editing) | Use your native file edit tool |
| `Bash` (run commands) | Use your native shell tool |
| `Skill` tool (invoke a skill) | Skills load natively — just follow the instructions |
| `Task` tool (dispatch subagent) | `spawn_agent` (see [Subagent support](#subagent-support)) |
| Multiple `Task` calls (parallel) | Multiple `spawn_agent` calls |
| Task returns result | `wait_agent` |

## Subagent support

Enable multi-agent support in your Codex config (`~/.codex/config.toml`):

```toml
[features]
multi_agent = true
```

This enables `spawn_agent`, `wait_agent`, and `close_agent` — required for
the `designing-skill-architecture` skill when dispatching parallel analysis.

## Hook enforcement

The `check-skill-description` hook (blocks `SKILL.md` writes with invalid
descriptions) is Claude Code–specific. It is **not enforced on Codex**.

The rule still applies: every `SKILL.md` description must start with
`"Use this skill when..."` or `"Use this skill whenever..."`. On Codex,
it is enforced by the skills themselves, not mechanically by a hook.

## Commands

Slash commands (`/new-plugin`) are Claude Code–specific. On Codex, use the
equivalent phrase directly:

| Claude Code command | Codex equivalent |
|--------------------|-----------------|
| `/new-plugin <idea>` | `"I want to build a new plugin that does <idea>"` |

## Installation

Codex does not use the `/plugin` command system. Install superforge by
cloning the repo and pointing your Codex config at the `skills/` directory,
or by following the instructions in your Codex plugin registry.
