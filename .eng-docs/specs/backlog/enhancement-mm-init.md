---
created: 2026-04-11
last_updated: 2026-04-11
status: approved
issue: 51
specced_by: markdstafford
implemented_by: null
superseded_by: null
---

# Enhancement: mm init

## Parent feature

`specs/feature-mm-config.md`

## What

mm gains an `mm:init` skill that guides teams through their mm configuration. When run directly, it presents each setting with its current value (or the default if not yet configured), lets users review and update any of them, and writes the result to `mm.toml` on confirmation. At session start it runs automatically: if no config exists it walks through full setup; if the config exists but is missing settings added since it was created, it walks through only those; otherwise it exits silently.

## Why

mm's config defaults work well for teams starting from scratch, but there's no guided path for teams adopting mm mid-project. Without `mm:init`, new users either discover `mm.toml` through the docs or silently get defaults that may not match their setup. Teams using a non-default `docs_root` would have to figure out the config schema manually, and any misconfiguration is silent — mm just writes to the wrong directory. A guided init removes that friction and gives teams a correct config before they've run a single skill. The `SessionStart` hook takes this further: teams who add it get a one-time prompt the first time Claude Code opens the project, so setup happens before it can be forgotten.

## User stories

- Sam can run `mm:init` directly to review and update any mm setting, including those not yet configured
- Sam gets walked through creating `mm.toml` automatically the first time she opens a project that doesn't have one
- Sam gets prompted only for new settings automatically when they're added in a future mm release, without having to remember to run `mm:init`
- Sam can skip any prompt during direct invocation to accept the current value or the default

## Design changes

*(Not applicable — no UI changes)*

## Technical changes

### Introduction and overview

**Prerequisites and assumptions**
- `feature-mm-config.md` — defines the config schema (`docs_root`, `issue_tracker`); this enhancement adds the guided setup experience for that schema
- No ADR, wiki, or database dependencies

**Goals**
- A new `mm:init` skill defines the canonical list of mm settings with their defaults and handles both direct and session-start invocation
- A companion hook script checks `mm.toml` at session start and injects context when action is needed — missing file or missing settings
- Direct invocation presents all settings for review and update; session-start mode presents only what's missing

**Non-goals**
- Validating setting values (e.g. confirming `docs_root` exists on disk) — consuming skills handle this
- Migrating config between file formats
- Removing settings from an existing config

**Glossary**
- *Known settings* — the complete list of settings mm supports, defined in the skill and mirrored in the hook script
- *Session-start mode* — mm:init behavior when triggered by the hook rather than direct user invocation

### Affected files

- `plugins/mm/skills/init/SKILL.md` — new; defines known settings, direct and session-start invocation flows
- `plugins/mm/hooks/session-start.sh` — new; resolves config, injects values, detects missing settings
- `plugins/mm/skills/planning/SKILL.md` — remove config resolution block
- `plugins/mm/skills/issue-triage/SKILL.md` — remove config resolution block

### Changes

**Hook script behavior**

The script runs at session start. It reads `mm.toml` (falling back to `mm.yaml` then `mm.json`) and does two things:

First, resolve config and inject values into session context via `additionalContext`:
```
mm config: docs_root=".eng-docs", issue_tracker="github"
```
Skills reference these session-context values directly; they no longer need their own config resolution blocks.

Second, check for missing required settings. The known required settings are `docs_root` and `issue_tracker`. Because mm:init always writes all required settings to the config file, any missing key unambiguously means a new setting was added since the last init run. If any are missing → inject additional context: `"mm.toml is missing settings: [list]. Starting mm:init…"` and invoke the init flow for those settings. If all present → exit silently.

**Direct invocation**

When a user runs `mm:init` directly, it presents all known required settings as a numbered list. For each setting it shows the current value and the default:

```
1. docs_root
   Current: "docs/eng"  |  Default: ".eng-docs"
2. issue_tracker
   Current: "github"  |  Default: "github"
```

For each, the user can enter a new value, press enter to keep the current value, or type `default` to reset to the default. After confirming, the skill writes `mm.toml` with all settings explicitly. Settings that equal their default are still written, so the file reflects the full config state and the hook can detect future new settings.

**Session-start invocation**

When Claude receives the hook's context injection indicating missing settings:
- If no config file exists: walk through all required settings in order, confirm each, write `mm.toml`
- If settings are missing: walk through only the missing ones, then append them to the existing file

In both cases write the file before continuing with the rest of the session.

**Config resolution refactor**

Because the hook now injects resolved config values at session start, the manual config resolution blocks in individual skills become redundant. The `for f in mm.toml mm.yaml mm.json` block and the `docs_root`/`issue_tracker` extraction logic is removed from `planning/SKILL.md` and `issue-triage/SKILL.md`, replaced with: *"Config is resolved at session start by the mm hook and available in session context."*

**Known limitation**

mm:init handles required top-level settings (`docs_root`, `issue_tracker`). Optional structured settings (label taxonomy) and future conditional required settings (e.g. Jira-specific settings required when `issue_tracker = "jira"`) are out of scope. A follow-on issue will address mm:init support for conditional and structured config.

**Alternatives considered**

Keeping per-skill config resolution was considered, but having the hook centralize it removes duplication and ensures every session starts with config already resolved — even for skills that don't explicitly read config today.

**Risks**

Medium. Removing config resolution from skills is a meaningful change to multiple files — a bug in the hook would leave all skills without config values. Mitigated by the hook falling back to defaults on any parse error, matching current behavior.

The hook runs at every session start including resumptions and after `/clear`; since it injects config values every time, sessions are always initialized correctly even after compaction.

## Task list

- [ ] **Story: Create mm:init skill**
  - [ ] **Task: Write direct invocation flow in `plugins/mm/skills/init/SKILL.md`**
    - **Description**: Create the init skill file. Define the canonical list of required settings with their defaults (`docs_root`: `.eng-docs`, `issue_tracker`: `github`). The direct invocation flow presents each setting with its current value and the default, allows entering a new value, pressing enter to keep the current value, or typing `default` to reset. Shows a preview of the resulting `mm.toml` before writing. Writes all settings explicitly on confirmation, even those at their defaults.
    - **Acceptance criteria**:
      - [ ] Skill file exists at `plugins/mm/skills/init/SKILL.md` with name and description frontmatter
      - [ ] Known settings section lists `docs_root` (default: `.eng-docs`) and `issue_tracker` (default: `github`)
      - [ ] Direct invocation flow presents each setting with current value and default
      - [ ] User can enter a new value, keep current, or type `default` to reset
      - [ ] Preview of resulting `mm.toml` shown before writing
      - [ ] `mm.toml` written with all settings on confirmation, even those at default
    - **Dependencies**: None
  - [ ] **Task: Add session-start invocation section to `plugins/mm/skills/init/SKILL.md`**
    - **Description**: Add the session-start flow to the init skill. Two cases: (a) no config file — walk through all settings in order and write `mm.toml`; (b) settings missing from existing config — walk through only the missing ones and append them. In both cases the file is written before the session continues. Include a note on the known limitation: conditional and structured settings (e.g. label taxonomy, future Jira-specific settings) are out of scope.
    - **Acceptance criteria**:
      - [ ] Session-start mode section present in the skill, clearly distinct from direct invocation
      - [ ] No-config case walks through all settings and writes `mm.toml`
      - [ ] Missing-settings case walks through only missing settings and appends to existing file
      - [ ] File is written before the rest of the session proceeds
      - [ ] Known limitation about conditional/structured settings documented in the skill
    - **Dependencies**: "Write direct invocation flow in `plugins/mm/skills/init/SKILL.md`"

- [ ] **Story: Create session-start hook**
  - [ ] **Task: Write `plugins/mm/hooks/session-start.sh`**
    - **Description**: Create the hook script that runs at session start. Read `mm.toml` (falling back to `mm.yaml` then `mm.json`). Inject resolved config values as `additionalContext` (`mm config: docs_root="...", issue_tracker="..."`). Then check for missing required settings: if no config file exists, inject context saying mm:init is needed; if settings are missing, inject context listing them; if all settings present, exit silently. Fall back to defaults on any parse error.
    - **Acceptance criteria**:
      - [ ] Script exists at `plugins/mm/hooks/session-start.sh` and is executable
      - [ ] Reads `mm.toml` first, then `mm.yaml`, then `mm.json`; stops at first found
      - [ ] Injects resolved config as `additionalContext`: `mm config: docs_root="...", issue_tracker="..."`
      - [ ] No config file: injects context indicating mm:init is needed
      - [ ] Config exists but settings missing: injects context listing missing settings
      - [ ] Config complete: exits silently with no output
      - [ ] Falls back to defaults on any parse error
    - **Dependencies**: None

- [ ] **Story: Remove config resolution from existing skills**
  - [ ] **Task: Remove config resolution block from `plugins/mm/skills/planning/SKILL.md`**
    - **Description**: Remove the `for f in mm.toml mm.yaml mm.json` config resolution block and the `docs_root`/`issue_tracker` extraction logic. Replace with a note that config is resolved at session start by the mm hook and available in session context. All `{docs_root}` path references in the file stay unchanged.
    - **Acceptance criteria**:
      - [ ] Config resolution block removed
      - [ ] Note present indicating config values come from session context (provided by mm hook)
      - [ ] All `{docs_root}` path references preserved unchanged
    - **Dependencies**: "Write `plugins/mm/hooks/session-start.sh`"
  - [ ] **Task: Remove config resolution block from `plugins/mm/skills/issue-triage/SKILL.md`**
    - **Description**: Same as the planning skill — remove the config resolution block and replace with a session context reference note.
    - **Acceptance criteria**:
      - [ ] Config resolution block removed
      - [ ] Note present indicating config values come from session context (provided by mm hook)
      - [ ] All `{docs_root}` path references preserved unchanged
    - **Dependencies**: "Write `plugins/mm/hooks/session-start.sh`"
