---
name: writing-plugin-manifest
description: Use this skill when an ARCHITECTURE.md exists and you need to
  create the plugin manifest files. Triggers include "write the manifest",
  "create plugin.json", "set up the .claude-plugin folder", "let's scaffold
  the repo", or any moment after architecture design when no plugin.json
  exists yet. Generates .claude-plugin/plugin.json and optionally
  .claude-plugin/marketplace.json.
---

# Writing the Plugin Manifest

## Required: `.claude-plugin/plugin.json`

Every Claude Code plugin has this file. Minimal valid form:

```json
{
  "name": "kebab-case-name",
  "version": "0.1.0",
  "description": "One sentence describing what this plugin does and when to use it.",
  "author": "Author Name",
  "license": "MIT"
}
```

### Field guidance

- **`name`** — kebab-case, unique on the marketplace. The user will type
  `/plugin install <name>` so make it short and typeable.
- **`version`** — semver. Start at `0.1.0` (signals "not stable yet").
- **`description`** — appears in marketplace listings. Write it for someone
  scanning a list of 50 plugins. First six words are the most important.
- **`keywords`** — array of strings that help discovery. Include the user's
  domain, the workflow, and the tools involved.
- **`homepage`** — GitHub URL of the repo.

## Optional: `.claude-plugin/marketplace.json`

Only needed if you're publishing your own marketplace (rather than
submitting to an existing one). Schema:

```json
{
  "name": "my-marketplace",
  "description": "Plugins for X.",
  "owner": { "name": "...", "url": "https://github.com/..." },
  "plugins": [
    {
      "name": "my-plugin",
      "source": "./",
      "description": "...",
      "version": "0.1.0",
      "category": "developer-tools",
      "tags": ["..."]
    }
  ]
}
```

If you control a marketplace, users install with:

```
/plugin marketplace add <github-org>/<marketplace-repo>
/plugin install <plugin>@<marketplace>
```

## Other root files to create

Always create alongside the manifest:

- `README.md` — install instructions, what's inside, philosophy. See the
  template in `EXAMPLES.md` next to this skill if it exists, or copy the
  superforge README and adapt.
- `LICENSE` — MIT unless the user has a reason to pick something else.
- `CLAUDE.md` — root-level doctrine injected into every session that uses
  the plugin. Keep it short (one screen). State the core principles, the
  workflow order, and the anti-patterns.

## Validation

After writing, run a JSON parse on `plugin.json` and `marketplace.json` to
catch syntax errors:

```bash
jq . .claude-plugin/plugin.json > /dev/null
jq . .claude-plugin/marketplace.json > /dev/null 2>&1 || true
```

## Next step

Once the manifest exists and the user has approved the `CLAUDE.md` doctrine,
call `writing-skill-md` for the first skill from the architecture.
