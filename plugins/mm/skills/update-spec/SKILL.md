---
name: update-spec
description: >
  Use when the user wants to keep the top-level spec.md current. Reads all active
  (non-backlog) specs and ADRs, compares against spec.md, and proposes edits for
  human approval — adding new features, removing deprecated ones, and updating links.
  Creates spec.md on first run if it doesn't exist. Use when the user says "update
  the spec", "update spec.md", "sync the top-level spec", or similar.
---

# Update spec

Groom `{docs_root}/spec.md` to reflect the current set of active specs and ADRs.
Nothing is written without human approval.

## Process

### 1. Resolve config

Check for `mm.toml`, `mm.yaml`, or `mm.json` at the repo root (in that order).
Extract `docs_root` (default: `.eng-docs`).

### 2. Check for spec.md

If `{docs_root}/spec.md` does not exist, create a stub before proceeding:

```markdown
---
created: YYYY-MM-DD
last_updated: YYYY-MM-DD
status: active
---

# [Project name]

[One paragraph describing what this project does and who it's for.]

---
```

Tell the user: *"Created `{docs_root}/spec.md` — will populate it now."*

### 3. Read active specs and ADRs

- Read all spec files in `{docs_root}/specs/` — **skip anything in `backlog/`**
- Read all ADR files in `{docs_root}/adrs/`
- Read the current `{docs_root}/spec.md`

### 4. Identify changes

Compare the active specs against `spec.md`:

- **Additions** — active spec files with no corresponding section in `spec.md`
- **Removals** — sections in `spec.md` with no corresponding active spec file (feature was deprecated or removed)
- **Link updates** — links in `spec.md` pointing to moved or renamed spec files
- **ADR surface** — key architectural decisions in ADRs that should be reflected in the top-level summary but aren't

### 5. Present proposed changes

Show a summary of what would change:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PROPOSED CHANGES TO spec.md
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Add:    ## Configuration  (feature-mm-config.md)
Add:    ## Gardening      (feature-mm-gardening.md)
Remove: ## Legacy export  (no active spec found)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

If no changes are needed, report: *"`spec.md` is already in sync — no changes needed."* and stop.

### 6. Show full proposed spec.md

Present the complete proposed `spec.md` content for review — not just the diff. The human should be able to read the whole document and assess it in context.

**CHECKPOINT**: Ask "Write this to `{docs_root}/spec.md`?"

On approval: write the file. Update `last_updated` in frontmatter to today's date.
On rejection: stop without writing.

## spec.md structure

```markdown
---
created: YYYY-MM-DD
last_updated: YYYY-MM-DD
status: active
---

# [Project name]

[1-2 paragraphs: what this project is and who it's for.]

---

## [Feature name]

[1 paragraph: what this feature does and why it matters.]

**Spec:** `specs/feature-[name].md`

---

## [Feature name]

...
```

One section per active feature spec. Each section has a one-paragraph description and a link to the detail spec. ADRs inform the top-level summary paragraph but are not listed individually.

## Key guidelines

- Only include features with active spec files outside `backlog/`
- Do not include features that are planned but not yet implemented
- Keep each feature description to one paragraph — detail belongs in the spec
- Follow `mm:writing-guidelines` when drafting feature descriptions
