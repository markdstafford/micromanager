---
name: init
description: >
  Use to set up or update mm configuration for a project. Creates or updates
  mm.toml with guided prompts for each setting. Also use when invoked automatically
  at session start to create a missing config or fill in new settings.
---

# mm init

Guide the user through creating or updating `mm.toml` for this project.

## When to use

- **Direct invocation**: when a user runs `mm:init` to set up mm for the first time or review and update existing settings
- **Session-start invocation**: when the mm session-start hook detects a missing config file or missing settings and injects context asking for mm:init to run

## Known settings

The following settings are currently supported. Both are required — they are always written to `mm.toml`, even when set to their defaults.

| Setting | Default | Description |
|---|---|---|
| `docs_root` | `.eng-docs` | Base directory for all mm artifact output |
| `issue_tracker` | `github` | Issue tracking integration (`github` or `jira`) |

**Known limitation:** Optional structured settings (e.g. `labels.*`) and future conditional settings (e.g. Jira-specific fields required when `issue_tracker = "jira"`) are out of scope for mm:init. A follow-on enhancement will address these.

## Direct invocation

When a user runs `mm:init` directly:

### 1. Read current config

Check for `mm.toml`, `mm.yaml`, or `mm.json` at the repo root (in that order). If found, parse current values for each known setting. If not found, all settings are unset (will use defaults).

### 2. Present settings for review

Show all known settings with current values and defaults:

```
mm configuration
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. docs_root
   Current: ".eng-docs"  |  Default: ".eng-docs"

2. issue_tracker
   Current: "github"  |  Default: "github"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
For each setting: press Enter to keep current value, type a new value, or type "default" to reset.
```

For each setting in order:
- Prompt: `docs_root [.eng-docs]: `
- Accept input: empty → keep current; new value → use it; `default` → use the default
- Repeat for `issue_tracker`

### 3. Show preview and confirm

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PREVIEW: mm.toml
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
docs_root = ".eng-docs"
issue_tracker = "github"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Write mm.toml? (yes / no)
```

On `yes`: write `mm.toml` with all settings, then commit:

```bash
git add mm.toml
git commit -m "chore: add mm.toml"
```

(If `mm.toml` already existed and was updated, use `git commit -m "chore: update mm.toml"`.)

On `no`: discard and exit without writing.

### 4. Confirm

```
mm.toml written. mm is configured for this project.
```

If the project doesn't have a git repo, skip the commit step and just confirm the file was written.
