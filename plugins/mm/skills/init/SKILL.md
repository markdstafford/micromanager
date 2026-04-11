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

When config exists with values:
```
mm configuration
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. docs_root
   Current: "docs/eng"  |  Default: ".eng-docs"

2. issue_tracker
   Current: "github"  |  Default: "github"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
For each setting: press Enter to keep current value, type a new value, or type "default" to reset.
```

When no config exists:
```
mm configuration
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. docs_root
   Current: (not set)  |  Default: ".eng-docs"

2. issue_tracker
   Current: (not set)  |  Default: "github"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
For each setting: press Enter to use the default, type a new value, or type "default" to use the default.
```

For each setting in order:
- Prompt: `docs_root [current value or default]: ` — show the current value in brackets, or the default if not set
- Accept input: empty → keep current value (or default if unset); new value → use it; `default` → reset to default
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

On `yes`: check whether the resulting `mm.toml` content would differ from the existing file. If no file existed before, or if the content changed, write `mm.toml` with all settings and commit:

```bash
git add mm.toml
git commit -m "chore: add mm.toml"
```

(If `mm.toml` already existed and was updated, use `git commit -m "chore: update mm.toml"`.)

If the content would be identical to the existing file, skip the write and commit and instead say:

```
No changes — mm.toml is already up to date.
```

On `no`: discard and exit without writing. Tell the user: "Cancelled. No changes written."

### 4. Done

```
mm.toml written. mm is configured for this project.
```

If the project doesn't have a git repo, skip the commit step and just confirm the file was written.

## Session-start invocation

When Claude receives context from the mm session-start hook indicating action is needed, handle the appropriate case before proceeding with any other session work.

### Case 1: No config file found

Hook context will say: `"No mm.toml found. Starting mm:init to configure mm for this project."`

Walk through all known settings in order using the same steps as direct invocation (steps 1–3) (including the git commit in step 3; replace step 4's confirmation message with the session-start message below), but frame it as first-time setup:

```
Welcome! mm isn't configured for this project yet. Let's set it up — it takes about a minute.
```

After writing `mm.toml`, say:
```
mm is configured. Continuing with your session.
```

### Case 2: Missing settings found

The hook context will contain a string beginning with `"mm.toml is missing settings:"` followed by a comma-separated list of setting names, for example:

`"mm config: docs_root=".eng-docs", issue_tracker="github"\n\nmm.toml is missing settings: issue_tracker. Starting mm:init to fill them in."`

Match on the prefix `"mm.toml is missing settings:"` and extract the setting names that follow (before the period) as the list to walk through.

Walk through only the listed settings. For each, show the setting name and default value, and prompt for a value or press Enter to accept the default. Append the new settings to the existing `mm.toml` — do not rewrite the whole file; preserve all existing content. For each missing setting, prompt the user exactly as in direct invocation Step 2 (show current value as `(not set)` and the default). After all missing settings are collected, append them as new lines at the end of the file and commit without showing a full-file preview — only the new lines are being added.

After writing, say:
```
mm.toml updated with new settings. Continuing with your session.
```

### Case 3: Config complete

The hook exits silently when config is complete — no context is injected about mm:init. Take no action; the session proceeds normally.
