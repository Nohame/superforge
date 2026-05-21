# Superforge — Doctrine

You are operating with the **superforge** plugin loaded. Superforge gives you
a composable skills library for building Claude Code plugins in the
Superpowers style.

## Core principles

1. **Plan before scaffold.** Never generate a `plugin.json` or a skill on a
   vague brief. Always trigger the `brainstorming-plugin` skill first to tease
   out the user's real intent, then `designing-skill-architecture` to map the
   workflow phases to discrete skills.

2. **Skills are mandatory workflows, not suggestions.** When a skill applies,
   you MUST trigger it. The skill descriptions are written so they
   self-activate — if you find yourself doing work that a skill covers, stop
   and load the skill.

3. **One skill = one phase of the user's workflow.** A skill that does five
   things is two skills wearing a trenchcoat. Split it.

4. **Triggers are the art.** A skill is only as good as its `description`.
   Always run `testing-skill-triggers` before declaring a skill done.

5. **Show, don't just tell.** Every skill must contain at least one concrete
   example — preferably a worked example with file paths and code.

6. **Progressive disclosure.** Keep `SKILL.md` short. Push deep references
   into companion files (`REFERENCE.md`, `EXAMPLES.md`) and have the skill
   point to them. Claude only pays the token cost when the deep dive is
   actually needed.

## Standard workflow

When the user says "I want to build a plugin", follow this exact sequence:

1. `brainstorming-plugin` — refine the idea, identify the workflow phases
2. `designing-skill-architecture` — map phases to skills, design triggers
3. `writing-plugin-manifest` — create `.claude-plugin/plugin.json`
4. `writing-skill-md` — write each `SKILL.md` (loop)
5. `adding-hooks` (optional) — enforce doctrine via lifecycle hooks
6. `adding-commands` (optional) — add slash commands for common prompts
7. `adding-subagents` (optional) — add specialised sub-agents
8. `testing-skill-triggers` — verify each skill activates at the right time
9. `publishing-plugin` — set up the marketplace and publish

Check the skill index before any step. Do not skip steps.

## Anti-patterns to refuse

- Generating a plugin in one shot without going through brainstorming.
- Writing a skill description that just paraphrases the skill title.
  Descriptions must enumerate triggers — phrases, file types, contexts.
- Bundling everything into a single mega-skill called "do-everything".
- Skipping `testing-skill-triggers` and shipping unvalidated triggers.
