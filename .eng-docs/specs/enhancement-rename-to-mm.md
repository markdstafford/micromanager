---
created: 2026-03-16
last_updated: 2026-03-16
status: implementing
issue: 34
specced_by: markdstafford
implemented_by: markdstafford
superseded_by: null
---

# Enhancement: rename to mm

## Parent feature

`app.md`

## What

The plugin is renamed from `caf` to `mm` and the repository from `coding-agent-flow` to `micromanager`. This means the plugin's skill prefix changes from `caf:` to `mm:` (e.g. `mm:planning`, `mm:issue-triage`), the plugin directory moves from `plugins/caf/` to `plugins/mm/`, and the repository name and remote URL are updated to match. All internal references in skill files, spec documents, configuration files, and plugin metadata files (`plugin.json`, `marketplace.json`) are updated to reflect the new names.

## Why

The current names (`caf`, `coding-agent-flow`) are internal working names that don't reflect the plugin's purpose or identity. `micromanager` and its short form `mm` are more memorable, more descriptive of what the plugin does — guiding developers through a structured, step-by-step planning process — and better suited for distribution as the plugin matures. Renaming now, while the project is small and the install base is personal, minimizes the cost of the change.

## User stories

- Mark can invoke planning skills using the `mm:` prefix (e.g. `mm:planning`, `mm:issue-triage`)
- Mark can install the plugin from a repository named `micromanager`
- Perry can reference the plugin by its published name when documenting or sharing it
- Sam can find the plugin under a name that describes its purpose

## Design changes

*(Not applicable — no UI changes)*

## Technical changes

### Affected files

- `plugins/caf/.claude-plugin/plugin.json` — `name` field controls skill prefix; rename `caf` → `mm`
- `.claude-plugin/marketplace.json` — references repo name and plugin name; update both
- `plugins/caf/skills/planning/SKILL.md` — contains hardcoded `caf:` cross-references; update to `mm:`
- `plugins/caf/skills/issue-triage/SKILL.md` — contains hardcoded `caf:` cross-references; update to `mm:`
- `plugins/caf/skills/friction-log/SKILL.md` — contains hardcoded `caf:` cross-references; update to `mm:`
- 8 files in `.eng-docs/specs/` — reference `caf:` skill names; update to `mm:`
- `plugins/caf/` directory — renamed to `plugins/mm/` via `git mv`
- GitHub repository — renamed via GitHub settings UI
- Local git remote — URL updated via `git remote set-url origin`

### Changes

## Tech spec

### 1. Introduction and overview

**Prerequisites and assumptions**
- Parent spec: `app.md`
- No ADR dependencies — the rename introduces no architectural decisions
- The Claude Code plugin loading system uses the `name` field in `plugin.json` as the skill prefix; renaming requires updating that field

**Goals**
- All skills are invocable via the `mm:` prefix after the change
- No broken `caf:` references remain in any committed file
- The GitHub repository is accessible at its new name

**Non-goals**
- No behavior changes to any skill
- No changes to skill logic, prompts, or process
- No changes to `.eng-docs/` artifact structure or frontmatter schema

**Glossary**
- `mm` — the new short name for the plugin (from micromanager)
- `caf` — the former plugin name (coding agent flow), being retired

### 2. System design and architecture

No new components, services, or data flows are introduced. This is a pure renaming operation across files and infrastructure.

**Component breakdown — what changes:**

- **Plugin metadata** (`plugins/caf/.claude-plugin/plugin.json`) — `name` field controls the skill prefix in Claude Code; must change from `caf` to `mm`
- **Marketplace manifest** (`.claude-plugin/marketplace.json`) — references both the repo name and the plugin name; both must update
- **Plugin directory** (`plugins/caf/`) — renamed to `plugins/mm/`; no internal file structure changes
- **Skill files** (3 files in `plugins/caf/skills/`) — contain hardcoded `caf:` cross-references between skills; must update to `mm:`
- **Spec documents** (8 files in `.eng-docs/specs/`) — reference `caf:` skill names in implementation notes; must update
- **GitHub repository** — renamed via GitHub settings; local remote URL updated via `git remote set-url`

### 3. Detailed design

No data model or API changes. Full file change inventory:

| File | Change |
|------|--------|
| `plugins/caf/.claude-plugin/plugin.json` | `"name": "caf"` → `"name": "mm"` |
| `.claude-plugin/marketplace.json` | `"name": "coding-agent-flow"` → `"name": "micromanager"`; `"name": "caf"` → `"name": "mm"`; `"source": "./plugins/caf"` → `"source": "./plugins/mm"` |
| `plugins/caf/skills/planning/SKILL.md` | All `caf:` skill references → `mm:` |
| `plugins/caf/skills/issue-triage/SKILL.md` | All `caf:` skill references → `mm:` |
| `plugins/caf/skills/friction-log/SKILL.md` | All `caf:` skill references → `mm:` |
| 8 files in `.eng-docs/specs/` | All `caf:` skill references → `mm:` |
| `plugins/caf/` directory | Renamed to `plugins/mm/` via `git mv` |
| GitHub repository | Renamed via GitHub settings UI |
| Local git remote | URL updated via `git remote set-url origin` |

**Out of scope:** `.claude/worktrees/admiring-rosalind/` is an untracked leftover worktree — to be cleaned up separately.

### 4. Security, privacy, and compliance

Not applicable — no new endpoints, data handling, or auth changes.

### 5. Observability

Not applicable — no new logging, metrics, or alerts needed.

### 6. Testing plan

Manual verification: after the rename, confirm all skills load under the `mm:` prefix in a Claude Code session. No automated tests exist or are needed for this change.

### 7. Alternatives considered

Keeping `caf` as the skill prefix while only renaming the repo was considered, but having the prefix and repo name diverge would create more confusion than the rename itself. Full alignment across both is the right call.

### 8. Risks

The only risk is a missed `caf:` reference in a committed file. Mitigation: run `grep -r "caf"` over all `.md` and `.json` files after all changes and before committing to verify no references remain.

## Task list

- [ ] **Story: Update plugin metadata files**
  - [x] **Task: Update plugin.json**
    - **Description**: Change the `name` field in `plugins/caf/.claude-plugin/plugin.json` from `"caf"` to `"mm"`. This field controls the skill prefix Claude Code uses when loading the plugin.
    - **Acceptance criteria**:
      - [ ] `"name"` field is `"mm"` in `plugin.json`
      - [ ] No other fields in the file are changed
    - **Dependencies**: None
  - [x] **Task: Update marketplace.json**
    - **Description**: Update `.claude-plugin/marketplace.json` with three changes: set the top-level `"name"` to `"micromanager"`, set the plugin entry `"name"` to `"mm"`, and set the plugin entry `"source"` to `"./plugins/mm"`.
    - **Acceptance criteria**:
      - [ ] Top-level `"name"` is `"micromanager"`
      - [ ] Plugin entry `"name"` is `"mm"`
      - [ ] Plugin entry `"source"` is `"./plugins/mm"`
      - [ ] No other fields in the file are changed
    - **Dependencies**: None

- [x] **Story: Update skill file cross-references**
  - [x] **Task: Update caf: references in planning/SKILL.md**
    - **Description**: Replace all occurrences of `caf:` with `mm:` in `plugins/caf/skills/planning/SKILL.md`.
    - **Acceptance criteria**:
      - [ ] No occurrences of `caf:` remain in the file
      - [ ] All skill references use the `mm:` prefix
      - [ ] No other content in the file is changed
    - **Dependencies**: None
  - [x] **Task: Update caf: references in issue-triage/SKILL.md**
    - **Description**: Replace all occurrences of `caf:` with `mm:` in `plugins/caf/skills/issue-triage/SKILL.md`.
    - **Acceptance criteria**:
      - [ ] No occurrences of `caf:` remain in the file
      - [ ] All skill references use the `mm:` prefix
      - [ ] No other content in the file is changed
    - **Dependencies**: None
  - [x] **Task: Update caf: references in friction-log/SKILL.md**
    - **Description**: Replace all occurrences of `caf:` with `mm:` in `plugins/caf/skills/friction-log/SKILL.md`.
    - **Acceptance criteria**:
      - [ ] No occurrences of `caf:` remain in the file
      - [ ] All skill references use the `mm:` prefix
      - [ ] No other content in the file is changed
    - **Dependencies**: None

- [x] **Story: Update spec document references**
  - [x] **Task: Update caf: references in .eng-docs/specs/**
    - **Description**: Replace all occurrences of `caf:` with `mm:` across all 8 spec files in `.eng-docs/specs/` that contain `caf:` references. Use a bulk find-and-replace rather than editing each file manually.
    - **Acceptance criteria**:
      - [ ] No occurrences of `caf:` remain in any `.eng-docs/specs/` file
      - [ ] All skill references use the `mm:` prefix
      - [ ] No other content in any file is changed
    - **Dependencies**: None

- [x] **Story: Rename plugin directory**
  - [x] **Task: git mv plugins/caf to plugins/mm**
    - **Description**: Use `git mv plugins/caf plugins/mm` to rename the plugin directory, preserving git history.
    - **Acceptance criteria**:
      - [ ] Directory is at `plugins/mm/`
      - [ ] `plugins/caf/` no longer exists
      - [ ] `git status` shows the rename (not a delete + untracked add)
    - **Dependencies**: "Update plugin.json", "Update skill file cross-references" (edit files at their original paths before moving)

- [x] **Story: Rename GitHub repository and update remote**
  - [x] **Task: Rename GitHub repository**
    - **Description**: In GitHub repository settings (Settings → General → Repository name), rename the repo from `coding-agent-flow` to `micromanager`.
    - **Acceptance criteria**:
      - [ ] Repository is accessible at the new name on GitHub
      - [ ] Old name redirects to new name (GitHub does this automatically)
    - **Dependencies**: None (can be done at any point)
  - [x] **Task: Update local git remote URL**
    - **Description**: Run `git remote set-url origin` with the new repository URL after the GitHub rename completes.
    - **Acceptance criteria**:
      - [ ] `git remote -v` shows the new repository URL
      - [ ] `git fetch` succeeds against the new remote
    - **Dependencies**: "Rename GitHub repository"

- [ ] **Story: Verify and commit**
  - [x] **Task: Verify no remaining caf: references**
    - **Description**: Run `grep -r "caf" --include="*.md" --include="*.json"` (excluding `.git/`) across the repo and confirm no `caf:` skill references remain in committed files. The word `caf` may appear in historical prose (e.g. "formerly caf") — confirm those are intentional, not missed replacements.
    - **Acceptance criteria**:
      - [ ] No `caf:` skill prefix references remain in any `.md` or `.json` file
      - [ ] Any remaining occurrences of `caf` are reviewed and confirmed intentional
    - **Dependencies**: All prior stories
  - [ ] **Task: Commit all changes**
    - **Description**: Stage and commit all file changes (metadata updates, skill file edits, spec file edits, directory rename) in a single commit with a clear message describing the rename.
    - **Acceptance criteria**:
      - [ ] All changed files are included in the commit
      - [ ] Commit message clearly describes the rename
      - [ ] `git status` is clean after the commit
    - **Dependencies**: "Verify no remaining caf: references"
