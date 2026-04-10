---
created: 2026-04-10
last_updated: 2026-04-10
status: draft
issue: null
specced_by: markdstafford
implemented_by: null
superseded_by: null
---

# Enhancement: labels in config

## Parent feature

`specs/feature-mm-config.md`

## What

mm's issue label taxonomy — type labels (`bug`, `enhancement`, `feature-request`, etc.), priority labels (`P0: critical` through `P3: low`), and meta labels (`usability`, `performance`, etc.) — can be configured in `mm.toml`. Teams can rename labels to match their existing conventions, change colors, or remove labels they don't use. The issue-triage skill reads the taxonomy from config at session start and uses it throughout, falling back to the current built-in defaults when no taxonomy is defined.

## Why

The built-in label taxonomy works well for projects starting from scratch, but teams with existing GitHub repos already have label conventions they've settled on. Forcing them to adopt mm's names creates friction — either they rename their existing labels or they accept a split taxonomy where some issues use mm's labels and others use their own. Making the taxonomy configurable means mm fits into an existing project without requiring any label migration, and teams who do start fresh can still customize to match their preferences.

## User stories

- Sam can define her team's existing label names in `mm.toml` so mm uses them without requiring label migration
- Sam can configure label colors to match her team's conventions
- Sam can remove labels her team doesn't use so they don't get auto-created during triage
- Mark can omit the `[labels]` config block entirely and get the current built-in taxonomy unchanged
- Perry can document a custom taxonomy in `mm.toml` as part of a plugin distribution, so new installs get the right labels from day one

## Design changes

*(Not applicable — no UI changes)*

## Technical changes

### Introduction and overview

**Prerequisites and assumptions**
- `feature-mm-config.md` — this extends the existing config schema
- `feature-github-issue-triage.md` — the primary consumer of the label taxonomy
- No ADR or wiki dependencies — this plugin has no database or API surface

**Goals**
- Teams can define a custom label taxonomy in `mm.toml` or `mm.yaml` that issue-triage uses instead of the built-in one
- Missing config falls back to the current built-in defaults with no behavior change
- The config schema is extensible to support Jira type/priority mapping in a future enhancement

**Non-goals**
- Label deletion from GitHub (mm manages creation, not cleanup)
- Jira issue type/priority mapping (covered by the Jira support enhancement)

**Glossary**
- *Label taxonomy* — the full set of labels mm creates and assigns during triage, grouped into type, priority, and meta categories

### Affected files

- `plugins/mm/skills/issue-triage/SKILL.md` — extend Phase 1 config resolution to read `labels.type`, `labels.priority`, and `labels.meta`; use resolved taxonomy in step 3 (create missing labels) and steps 4 and 7 (assign labels); present label descriptions to the AI during classification so it can choose correctly
- `plugins/mm/skills/issue-triage/references/labels.md` — remains the built-in default source; no structural change

### Changes

**Config schema**

Labels are defined using label name as key, with `color` (hex, no `#`) and `description` as required fields. All three categories (`type`, `priority`, `meta`) are optional — omit a category to use the built-in defaults for that category. The "additional" labels from `references/labels.md` are folded into `meta`; teams include them by adding entries to `labels.meta`.

In `mm.toml`:
```toml
[labels.type.bug]
color = "d73a4a"
description = "Something isn't working correctly"

[labels.type.enhancement]
color = "84b6eb"
description = "Improvement to existing functionality"

[labels.priority."P0: critical"]
color = "b60205"
description = "Urgent — production broken, data loss, or security issue"

[labels.priority."P1: high"]
color = "e4460a"
description = "Significant user-facing breakage with no workaround"

[labels.meta.usability]
color = "f9d0c4"
description = "Relates to user experience or interface usability"

[labels.meta.breaking-change]
color = "b60205"
description = "Change that is not backward-compatible"
```

The schema is designed for forward compatibility: the Jira support enhancement will add optional `jira_type` and `jira_priority` fields to type and priority entries respectively. Teams using standard Jira issue type and priority names won't need to set these — a built-in mapping table handles the defaults.

**Resolution logic**

At session start, after resolving `docs_root` and `issue_tracker`, issue-triage reads the `labels` block. For each category, if present in config it replaces the built-in defaults for that category entirely. Categories are independent — overriding `priority` does not affect `type` or `meta`. The resolved taxonomy is used in three places: creating missing labels (Phase 1 step 3), classifying issues (Phase 3 step 4), and assigning labels on write-back (Phase 3 step 7).

**Alternatives considered**

TOML array-of-tables (`[[labels.type]]`) was considered but is more verbose for large taxonomies without added benefit. The dotted-key structure (`[labels.type.bug]`) is more readable. A flat key-value map (`bug = "d73a4a"`) was ruled out because it can't accommodate the required `description` field or future Jira mapping fields.

**Risks**

Low. The change is purely additive — no existing behavior changes unless a `labels` block is present in config.

## Task list

- [ ] **Story: Extend config resolution in issue-triage**
  - [ ] **Task: Read `labels` block in Phase 1 config resolution**
    - **Description**: In `plugins/mm/skills/issue-triage/SKILL.md`, extend the Phase 1 config resolution step to read `labels.type`, `labels.priority`, and `labels.meta` from config. For each category, use config values if present; fall back to `references/labels.md` built-in defaults if absent. Store resolved taxonomy in session context.
    - **Acceptance criteria**:
      - [ ] Config with a `labels.type` block uses those labels instead of built-in type labels
      - [ ] Config with no `labels` block produces identical behavior to current
      - [ ] Categories are independent — overriding one does not affect others
    - **Dependencies**: None
  - [ ] **Task: Use resolved taxonomy when creating labels (Phase 1 step 3)**
    - **Description**: Update the label creation step to iterate over the resolved taxonomy rather than the hardcoded list in `references/labels.md`. Use each entry's `name`, `color`, and `description` when calling `gh label create`.
    - **Acceptance criteria**:
      - [ ] Labels are created with names, colors, and descriptions from resolved taxonomy
      - [ ] Built-in behavior unchanged when no `labels` config is present
    - **Dependencies**: "Read `labels` block in Phase 1 config resolution"
  - [ ] **Task: Use resolved taxonomy during classification (Phase 3 step 4)**
    - **Description**: Update the classification step to present the resolved type and priority label names and descriptions to the AI, replacing the hardcoded tables. The AI uses descriptions to choose the correct label.
    - **Acceptance criteria**:
      - [ ] Classification tables shown to AI reflect resolved taxonomy names and descriptions
      - [ ] AI can distinguish between custom label names (e.g. "defect" vs "bug") using descriptions
    - **Dependencies**: "Read `labels` block in Phase 1 config resolution"
  - [ ] **Task: Use resolved taxonomy on write-back (Phase 3 step 7)**
    - **Description**: Update the `gh issue edit --add-label` step to use the resolved label names, not hardcoded values.
    - **Acceptance criteria**:
      - [ ] Labels applied to issues use names from resolved taxonomy
    - **Dependencies**: "Use resolved taxonomy during classification (Phase 3 step 4)"
