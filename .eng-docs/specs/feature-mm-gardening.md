---
created: 2026-04-10
last_updated: 2026-04-10
status: complete
issue: 41
specced_by: markdstafford
implemented_by: markdstafford
superseded_by: null
---

# mm gardening

## What

mm includes a set of gardening tasks that keep planning artifacts accurate over time. Two tasks ship initially: a wiki freshness review that revisits each wiki document and flags or updates stale content, and a synthesis task that generates and maintains a single top-level spec summarizing what mm is and does, with links out to the individual detail specs. Gardening tasks can be run on demand or on a schedule.

## Why

The most valuable input an AI has is accurate, current context. Specs and wiki documents naturally stagnate — they're written once and rarely updated as the system evolves. Without a way to keep them current, mm's planning artifacts become less useful over time, and the AI assistance they power degrades with them. Gardening tasks solve this by giving mm a structured way to revisit and refresh its own artifacts.

## Personas

- **Mark: Solo developer** — runs gardening tasks after a batch of features ship to keep his specs and wiki current before starting the next planning cycle

## Narratives

### Mark tends his project after a productive sprint

Mark has shipped three features over the past two weeks. The wiki's domain model hasn't been updated since the first feature, and two new entities were added since. He invokes `mm:update-wiki`. The skill reads each wiki document, compares it against the current specs and codebase, and presents a summary of what's stale: two missing entities in the domain model and an outdated API contract. Mark reviews the proposed updates, approves them, and the skill writes the changes.

He then invokes `mm:update-spec`. The skill reads `{docs_root}/spec.md` — the permanent top-level spec that lives alongside the wiki — and compares it against the current detail specs. One feature was deprecated last sprint and still appears in `spec.md`; a new feature shipped but isn't referenced yet. The skill proposes the edits: remove the deprecated feature, add a section for the new one with a link to its detail spec, and update the summary paragraph. Mark reviews, approves, and the skill writes the changes. `spec.md` now reflects exactly what mm does today.

## User stories

- Mark can invoke `mm:update-wiki` to get a summary of stale wiki content and approve proposed updates before they're written
- Mark can invoke `mm:update-spec` to bring `{docs_root}/spec.md` up to date with current active specs and ADRs
- Mark can invoke `mm:update-specs` to verify detail specs against the codebase and update any that have drifted, then bring `spec.md` in sync
- Mark can invoke any of the three skills on demand without disrupting in-progress planning work

## Goals

- `mm:update-wiki` reads all wiki documents, identifies stale content relative to current specs and codebase, and proposes specific edits for human approval before writing anything
- `mm:update-spec` reads `{docs_root}/spec.md` and all detail specs outside of `backlog/`, proposes edits to keep them in sync (add new features, remove deprecated ones, update links), and writes only after approval
- Both skills are safe to run at any time — they never write without explicit approval
- `{docs_root}/spec.md` is created by `mm:update-spec` on first run if it doesn't exist

## Non-goals

- Scheduled / automatic runs (gardening tasks run on demand only in this release)
- Updating detail specs themselves (these skills only update wiki docs and `spec.md`)
- Processing specs in `backlog/` — both skills skip unimplemented specs entirely

## Design spec

*(Not applicable — gardening is a skill-based workflow, not a UI feature)*

## Tech spec

### New skills

- `plugins/mm/skills/update-wiki/SKILL.md` — wiki freshness review via codebase scan
- `plugins/mm/skills/update-spec/SKILL.md` — grooms `spec.md` from active specs and ADRs (shallow)
- `plugins/mm/skills/update-specs/SKILL.md` — verifies detail specs against the codebase, then runs `mm:update-spec` (deep)

All three skills read `docs_root` from mm config at session start (defaulting to `.eng-docs`).

### `mm:update-wiki` behavior

1. For each wiki document, determine what the codebase actually contains:
   - `domain-model.md` → scan source files for domain entities, types, and relationships
   - `database-schema.md` → scan migration files, ORM models, or schema definitions
   - `api-contracts.md` → scan route definitions and handlers
   - `design-system.md` → scan component files and style definitions
2. Compare findings against the current wiki document content
3. Present a summary of proposed changes per document (additions, removals, corrections)
4. For each document with changes: show the diff, get approval, write

### `mm:update-spec` behavior

1. Check whether `{docs_root}/spec.md` exists; create a stub if not
2. Read all active specs in `{docs_root}/specs/` (skip `backlog/`) and all ADRs in `{docs_root}/adrs/`
3. Identify: features in `spec.md` with no corresponding active spec (candidates for removal), active specs with no entry in `spec.md` (candidates for addition), ADR decisions that should be reflected in the summary
4. Present proposed changes, get approval, write

### `mm:update-specs` behavior

1. Warn the user that this is a thorough codebase scan that may take several minutes, and confirm before proceeding
2. Scan the codebase to verify each active spec still accurately describes what's implemented — check for features that have changed, been removed, or diverged from their spec
2. For each spec with drift, present proposed updates to the detail spec and get approval before writing
3. Once all detail specs are current, invoke `mm:update-spec` to bring `spec.md` in sync

### `spec.md` structure

YAML frontmatter (`created`, `last_updated`, `status: active`), a brief top-level summary, then one section per feature with a one-paragraph description and a link to the detail spec.

## Task list

**Story 1: `mm:update-wiki` skill**
- [ ] Create `plugins/mm/skills/update-wiki/SKILL.md` with codebase-scan behavior for all four wiki documents
  - Acceptance: invoking `mm:update-wiki` on a project with stale wiki docs produces a specific, approvable diff per document; nothing is written without approval

**Story 2: `mm:update-spec` skill**
- [ ] Create `plugins/mm/skills/update-spec/SKILL.md` with the shallow behavior: read active specs and ADRs, compare against `spec.md`, propose changes
- [ ] On first run, create `{docs_root}/spec.md` stub with correct frontmatter if it doesn't exist
  - Acceptance: invoking `mm:update-spec` produces a specific, approvable diff; `spec.md` reflects only active (non-backlog) specs after approval

**Story 3: `mm:update-specs` skill**
- [ ] Create `plugins/mm/skills/update-specs/SKILL.md` with codebase-scan behavior for each active spec, followed by invocation of `mm:update-spec`; skill warns and confirms before starting
  - Acceptance: invoking `mm:update-specs` shows a confirmation prompt before doing any work; after confirmation, surfaces drift between code and specs; approved edits are written to detail specs before `spec.md` is updated

**Story 4: Register new skills in plugin manifest**
- [ ] Add `mm:update-wiki`, `mm:update-spec`, and `mm:update-specs` to `plugins/mm/.claude-plugin/plugin.json`
  - Acceptance: all three skills appear in the mm skill list after plugin reload
