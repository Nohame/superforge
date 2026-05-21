---
name: publishing-plugin
description: Use this skill when the plugin is feature-complete and the
  user wants to publish or release it. Triggers include "let's publish",
  "ship the plugin", "release v1", "how do I distribute this", "make it
  installable", "set up the marketplace". Walks through GitHub setup,
  versioning, marketplace registration, and install instructions for the
  README.
---

# Publishing the Plugin

## Pre-flight checklist

Before publishing, verify:

- [ ] `.claude-plugin/plugin.json` parses as valid JSON and has correct
  `name`, `version`, `description`, `author`, `license`.
- [ ] `README.md` has install instructions, "What's inside", and a
  philosophy section.
- [ ] `LICENSE` file exists at the repo root.
- [ ] `CLAUDE.md` doctrine is finalised (this loads in every session).
- [ ] Every `SKILL.md` has passed `testing-skill-triggers`.
- [ ] No half-finished skills in `skills/`. Either ship or remove.
- [ ] Hooks are executable (`chmod +x hooks/*.sh`).

## Two publishing paths

### Path A: submit to an existing marketplace

If you're submitting to Anthropic's official marketplace or another
established one:

1. Push the repo to GitHub (public).
2. Open a PR against the marketplace's `marketplace.json` adding your
   plugin entry.
3. Wait for review.

### Path B: run your own marketplace

If you want full control:

1. Create a second repo, e.g. `myname/my-marketplace`.
2. Add `.claude-plugin/marketplace.json` listing your plugin:

```json
{
  "name": "my-marketplace",
  "description": "...",
  "owner": { "name": "...", "url": "https://github.com/myname" },
  "plugins": [
    {
      "name": "my-plugin",
      "source": "github:myname/my-plugin",
      "version": "0.1.0",
      "description": "..."
    }
  ]
}
```

3. Users install with:

```
/plugin marketplace add myname/my-marketplace
/plugin install my-plugin@my-marketplace
```

You can host both the plugin and the marketplace in the same repo (as
superforge does) by keeping `marketplace.json` next to `plugin.json`.

## Versioning

Use semver:

- `0.x.y` while iterating; breaking changes are fine.
- `1.0.0` when the trigger set is stable and you've shipped to >5 users.
- Bump minor (`1.1.0`) for new skills.
- Bump patch (`1.0.1`) for bug fixes / trigger tuning.
- Bump major (`2.0.0`) for breaking changes to skill names or removed
  commands.

Tag releases: `git tag v0.1.0 && git push --tags`.

## README install snippet

Add this to your README so users can copy-paste:

```markdown
## Install

### Via marketplace
\`\`\`
/plugin marketplace add myname/my-marketplace
/plugin install my-plugin@my-marketplace
\`\`\`

### Direct from GitHub
\`\`\`
/plugin install github:myname/my-plugin
\`\`\`
```

## Update cadence

Set up a `RELEASE-NOTES.md` and commit to updating it on every minor
release. Users who depend on auto-update want to know what changed.

## Anti-patterns

- Shipping with the default `"description": "TODO"` in `plugin.json`.
- Publishing before running `testing-skill-triggers` on every skill.
- Marketplace JSON that points to a private repo (`source` must be
  reachable by `/plugin install`).
- Skipping `LICENSE` — users won't install plugins without a clear
  license.
