---
name: testing-skill-triggers
description: Use this skill after any SKILL.md is written or its
  description is edited. Triggers include "test the triggers", "does this
  skill activate on X", "validate the skill", "let's evaluate the skill",
  or any moment between finishing a SKILL.md and committing it. Builds a
  small eval set of positive and negative prompts and checks whether the
  skill description would activate correctly.
---

# Testing Skill Triggers

A skill is not done until you have evidence that its `description`
activates on intended prompts and stays quiet on neighbours.

## The eval set

For each skill, build a JSON file `skills/<name>/evals.json` with two
arrays:

```json
{
  "positive": [
    "I want to deploy to prod",
    "ship it",
    "fais le deploy de la nouvelle version",
    "cut a release of v1.4"
  ],
  "negative": [
    "let's deploy to staging",
    "the deploy failed, can you debug it",
    "what does 'deploy' mean in this context"
  ]
}
```

- **Positive** — phrases that SHOULD trigger the skill.
- **Negative** — phrases that should NOT (especially neighbouring skills
  in the same plugin).

Aim for 5-10 positives and 3-5 negatives. Mix languages if the plugin
targets a multilingual user.

## The eval process

Two options.

### Option A: ask Claude (cheap, manual)

For each prompt in the eval set, paste this into a fresh Claude session:

```
Here is the description of a skill:

[paste the description]

If the user said "<prompt>", would you load this skill? Answer YES or
NO with one sentence of rationale.
```

A pass is: all positives → YES, all negatives → NO.

### Option B: scripted eval

Write `scripts/eval-triggers.sh` that loops the eval set against the
Claude API with the skill description as context. Output: a pass/fail
table.

```bash
#!/usr/bin/env bash
set -euo pipefail
skill_dir="$1"
description=$(awk '/^description:/{flag=1} /^---$/{flag=0} flag' \
  "$skill_dir/SKILL.md" | sed 's/^description: *//' | tr -d '\n')

jq -r '.positive[] | "POS\t" + .' "$skill_dir/evals.json" > /tmp/cases
jq -r '.negative[] | "NEG\t" + .' "$skill_dir/evals.json" >> /tmp/cases

while IFS=$'\t' read -r expected prompt; do
  # ... call Claude API with description + prompt, parse YES/NO ...
  echo "$expected | $prompt | <result>"
done < /tmp/cases
```

A full implementation lives in `superpowers` if you want a reference.

## What to do when triggers fail

**Positive failed** (skill didn't activate when it should):
- Add the failing phrase to the description, in quotes.
- Lead with the action verb the user uses.
- Check that the description starts with "Use this skill when..." —
  Claude is trained on that pattern.

**Negative failed** (skill activated when it shouldn't):
- Add a "Do NOT use for X" sentence pointing to the correct skill.
- Tighten the trigger list to be less generic.
- Consider whether two skills are really doing the same thing — you may
  need to merge them.

## Iteration cap

Three rounds of trigger tuning. If you can't get >90% on positives and
0 false positives on negatives after three rounds, the skill is probably
trying to cover two phases. Go back to `designing-skill-architecture`.

## Anti-patterns

- Writing the eval set after the description is finalised (you'll
  rationalise rather than test).
- Only writing positives. Negatives catch over-triggering, which is
  what makes a plugin annoying.
- Skipping evals for "obvious" skills. The obvious ones fail too.
