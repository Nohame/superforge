---
name: writing-skill-md
description: Use this skill any time you need to author or substantively
  edit a SKILL.md file inside a Claude Code plugin's skills/ directory.
  Triggers include "write the SKILL.md for X", "add a skill that does Y",
  "let's create the next skill", "edit the description of skill Z",
  "improve this skill's triggers". This is the most-used skill in
  superforge — every plugin needs at least one good SKILL.md.
---

# Writing a SKILL.md

The single most important file in a plugin. Get this right and the skill
auto-triggers at the right time. Get it wrong and it sits unused.

## The anatomy

```markdown
---
name: kebab-case-name
description: One paragraph. See "Writing the description" below.
---

# Human-Readable Title

## When this skill runs
(implicit — your description handled it. Don't repeat it here.)

## What you do
Step-by-step instructions for the agent.

## Examples
At least one worked example with concrete inputs/outputs.

## Anti-patterns
Common mistakes the agent should refuse to make.
```

## Writing the `description` — the only part that matters for activation

Claude only sees the description (not the body) when deciding whether to
load the skill. Therefore:

**RULE 1: Enumerate triggers.** List the phrases, file types, contexts,
and verbs that should activate the skill. The more specific, the better.

Bad: `"Use this skill for tasks related to git."`
Good: `"Use this skill whenever the user wants to create a new branch,
mentions 'git checkout', pastes a git error message, or asks about merge
conflicts."`

**RULE 2: Include the negative.** Optionally specify when NOT to use it,
to prevent over-triggering.

> "Do NOT use for read-only git inspection (use `inspecting-git` instead)."

**RULE 3: Quote user phrases.** Include the actual words the user is
likely to type, in the language they'll type them. Multilingual triggers
should list both: `"create a plan" / "fais un plan"`.

**RULE 4: Lead with the action verb.** Start the description with
"Use this skill when..." or "Use this skill whenever...". This is the
convention Claude is trained on; deviating makes activation less reliable.

**RULE 5: Keep it under ~80 words.** Long descriptions dilute the signal.
If you have more to say, put it in the body.

## Writing the body

The body is loaded only after the skill triggers. Use this space for:

- **Step-by-step procedure** the agent must follow.
- **Worked examples** with real file paths and code.
- **Anti-patterns** — explicit list of "do not do X".
- **References** — link to companion files (`REFERENCE.md`,
  `EXAMPLES.md`) for deep dives. Don't inline 500 lines of API reference.

Keep the body under ~300 lines. Anything longer is a sign you should
split into companion files (progressive disclosure).

## Structure conventions

- `## When this skill runs` — implicit, don't repeat the description.
- `## What you do` — numbered steps the agent follows.
- `## Examples` — at least one full worked example.
- `## Anti-patterns` — bulleted list of refusals.
- `## Next step` — if the skill is part of a pipeline, name the next skill
  that should fire.

## Worked example: writing the description for a "deploy" skill

User intent: agent should help deploy a service to production after a PR
merges.

**v1 (too vague):**
> "Use this skill for deployments."

**v2 (better, enumerated):**
> "Use this skill when the user wants to deploy a service to production
> after a PR merge. Triggers: 'ship it', 'deploy to prod', 'release', or
> after the user confirms a PR has been merged to main."

**v3 (best, with negatives and quoted phrases):**
> "Use this skill when the user is ready to deploy code to production.
> Triggers include 'ship it', 'deploy to prod', 'cut a release', 'fais le
> deploy', or any moment after a PR has been merged to main and the user
> asks 'what's next'. Do NOT use for staging or dev deploys (see
> `deploying-staging`). Do NOT use to investigate a failed deploy (see
> `debugging-deploy`)."

## After writing

Always call `testing-skill-triggers` immediately. A skill is not done
until its triggers are validated against a small eval set.

## Anti-patterns

- Writing a description that just paraphrases the title.
- Putting activation logic in the body (Claude won't see it).
- Bundling two phases into one skill so the description becomes ambiguous.
- Skipping the worked example.
