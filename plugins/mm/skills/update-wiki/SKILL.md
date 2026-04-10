---
name: update-wiki
description: >
  Use when the user wants to keep wiki documents current. Scans the codebase
  to find what domain entities, database schemas, API endpoints, and UI components
  actually exist, compares against the wiki docs, and proposes specific edits for
  human approval. Nothing is written without explicit approval. Use when the user
  says "update the wiki", "refresh the wiki", "wiki is stale", or similar.
---

# Update wiki

Scan the codebase and refresh the wiki documents in `{docs_root}/wiki/` to reflect
what the project currently contains. Nothing is written without human approval.

## Process

### 1. Resolve config

Check for `mm.toml`, `mm.yaml`, or `mm.json` at the repo root (in that order).
Extract `docs_root` (default: `.eng-docs`).

### 2. Locate wiki documents

Check `{docs_root}/wiki/` for the four standard documents:

- `domain-model.md`
- `database-schema.md`
- `api-contracts.md`
- `design-system.md`

Skip any that don't exist. If none exist, tell the user and stop.

### 3. Scan the codebase for each wiki document

For each wiki document present, scan the codebase to determine current state:

**`domain-model.md`**
- Scan source files for type definitions, interfaces, classes, structs, and enums that represent domain entities
- Note relationships (foreign keys, references, associations)
- Focus on the core domain layer — not utilities or infrastructure

**`database-schema.md`**
- Scan migration files, ORM model definitions, and schema files
- Note table names, columns, types, constraints, and relationships
- Check for recent migrations that may have added or removed columns

**`api-contracts.md`**
- Scan route definitions, controllers, and handler files
- Note HTTP methods, paths, request/response shapes, and authentication requirements
- Check for routes that have been added, removed, or changed

**`design-system.md`**
- Scan component files and style definitions
- Note component names, props, variants, and design tokens (colors, spacing, typography)
- Focus on shared/reusable components, not one-off layouts

### 4. Compare and propose changes

For each wiki document, compare scan findings against current document content.

Identify:
- **Additions** — entities, endpoints, components, or schema elements in the codebase but absent from the wiki
- **Removals** — items documented in the wiki that no longer exist in the codebase
- **Corrections** — items documented inaccurately (wrong type, outdated schema, changed behavior)

Present a summary per document:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
domain-model.md
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Add:    Project entity (title, description, owner_id, created_at)
Add:    Membership entity (user_id, project_id, role)
Remove: Team entity (no longer exists in codebase)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

If a document is already current, report: *"`domain-model.md` is up to date — no changes needed."*

### 5. Get approval and write

For each document with proposed changes:

1. Show the full proposed updated content (not just the diff) so the human can review in context
2. **CHECKPOINT**: Ask "Write these changes to `{docs_root}/wiki/[document]`?"
3. On approval: write the file. Update `last_updated` in the frontmatter to today's date.
   If the document had `status: stub`, update to `status: active`.
4. On rejection: skip this document and move to the next.

Process documents one at a time. Never write without explicit per-document approval.

### 6. Report completion

After processing all documents:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
UPDATE WIKI COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Updated:   [n] documents
Skipped:   [n] documents (no changes / rejected)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Key guidelines

- The codebase is the source of truth — not the specs. Specs may also be stale.
- Never infer what should exist from spec files; scan the actual code.
- If the codebase is unclear (e.g. no migrations found), say so and ask the human to point to the right files before proceeding.
- Follow `mm:writing-guidelines` when drafting updated wiki content.
