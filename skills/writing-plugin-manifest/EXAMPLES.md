# Examples — writing-plugin-manifest

## README template

Copy and adapt for any new plugin. Replace `<org>`, `<marketplace>`,
`<plugin>`, and the content sections.

```markdown
# <plugin-name>

> One-line description of what the plugin does.

Brief paragraph on what problem it solves and how it fits into a workflow.

## Install

### Via marketplace

\`\`\`
/plugin marketplace add <org>/<marketplace>
/plugin install <plugin>@<marketplace>
\`\`\`

### Direct from GitHub

\`\`\`
/plugin install github:<org>/<plugin>
\`\`\`

## Quickstart

\`\`\`
"<trigger phrase that starts the workflow>"
\`\`\`

## What's inside

### Skills

- **<skill-name>** — one line on when it fires and what it does.

### Commands

- `/<command>` — one line on what it does.

### Agents

- `<agent-name>` — one line on its role and restrictions.

## Philosophy

- **<principle 1>** — one sentence.
- **<principle 2>** — one sentence.

## License

MIT
```

## Minimal `plugin.json`

```json
{
  "name": "my-plugin",
  "version": "0.1.0",
  "description": "Six words that tell a marketplace browser exactly what this does.",
  "author": "Your Name",
  "homepage": "https://github.com/yourname/my-plugin",
  "license": "MIT",
  "keywords": ["domain", "workflow", "tool"]
}
```

## Minimal `marketplace.json` (self-hosted)

```json
{
  "name": "my-marketplace",
  "description": "Plugins for <domain>.",
  "owner": {
    "name": "Your Name",
    "url": "https://github.com/yourname"
  },
  "plugins": [
    {
      "name": "my-plugin",
      "source": "./",
      "description": "Same one-liner as plugin.json.",
      "version": "0.1.0",
      "category": "developer-tools",
      "tags": ["domain", "workflow"]
    }
  ]
}
```

## Minimal `CLAUDE.md`

Keep it to one screen. State principles, workflow order, anti-patterns.

```markdown
# <Plugin Name> — Doctrine

You are operating with the **<plugin-name>** plugin loaded.

## Core principles

1. **<Principle 1>.** One sentence.
2. **<Principle 2>.** One sentence.

## Standard workflow

1. `<first-skill>` — what it does
2. `<second-skill>` — what it does

## Anti-patterns to refuse

- <Anti-pattern 1>
- <Anti-pattern 2>
```
