---
name: update-specs
description: >
  Use when the user wants to verify that detail specs still accurately describe
  what's implemented. Scans the codebase against each active spec, proposes updates
  for specs that have drifted, then invokes mm:update-spec to bring spec.md in sync.
  This is a thorough, time-intensive scan — confirm before starting. Use when the
  user says "update specs", "verify specs", "specs are out of date", or similar.
---

# Update specs

Verify each active detail spec against the codebase and update any that have drifted.
After all specs are current, invoke `mm:update-spec` to bring `{docs_root}/spec.md`
in sync. Nothing is written without human approval.

## Process

### 1. Resolve config

Check for `mm.toml`, `mm.yaml`, or `mm.json` at the repo root (in that order).
Extract `docs_root` (default: `.eng-docs`).

### 2. Confirm before starting

This skill performs a thorough codebase scan that may take several minutes.

Ask: *"This will scan the codebase against every active spec and may take a few minutes. Proceed?"*

Stop if the user declines.

### 3. Locate active specs

Read all spec files in `{docs_root}/specs/` — **skip anything in `backlog/`**.

If no active specs are found, tell the user and stop.

### 4. Verify each spec against the codebase

For each active spec, scan the relevant parts of the codebase to check whether the spec still accurately describes what's implemented.

Focus on:
- **Features described but not implemented** — spec describes behavior that doesn't exist in the code
- **Features implemented but not described** — code has behavior the spec doesn't mention
- **Changed behavior** — implementation diverges from what the spec says (different API shape, different data model, different user flow)
- **Removed features** — spec describes something that was deleted

Report findings per spec before proposing any changes:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
feature-github-issue-triage.md
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ Up to date
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
feature-planning.md
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Drift found:
  - User stories reference a "Notes" section that doesn't exist in the skill
  - Tech spec describes a design spec stage that was removed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 5. Propose and apply updates

For each spec with drift:

1. Show the specific changes needed (which sections to update, what to add or remove)
2. Show the full proposed updated spec content
3. **CHECKPOINT**: Ask "Write these changes to `{docs_root}/specs/[filename]`?"
4. On approval: write the file. Update `last_updated` in frontmatter to today's date.
5. On rejection: skip and move to the next spec.

Process specs one at a time. Never write without explicit per-spec approval.

### 6. Invoke mm:update-spec

After all specs have been reviewed (whether or not changes were made), invoke `mm:update-spec`
to bring `{docs_root}/spec.md` in sync with the now-current active specs.

### 7. Report completion

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
UPDATE SPECS COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Specs reviewed:  [n]
Updated:         [n]
Up to date:      [n]
Skipped:         [n] (rejected)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
spec.md updated via mm:update-spec
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Key guidelines

- Scan the actual codebase — do not compare specs against other specs
- Focus on behavioral drift, not cosmetic wording differences
- If the codebase is unclear (e.g. no clear entry point for a feature), ask the human to point to the right files before assessing that spec
- Follow `mm:writing-guidelines` when drafting updated spec content
