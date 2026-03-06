# ADR 008: Claude skills pattern for document types

## Status

Accepted

## Context

The document authoring feature needs a way to represent document types (product descriptions, tech designs, SOPs, ADRs) so the AI can guide users through creating each one. Each document type requires two things:

- A **process** — how to guide the user through creating the document: what questions to ask, what order to follow, when to draft, when to checkpoint
- A **template** — what sections the document contains, with examples and structural guidance

These are inseparable. A template without a process is just a blank form. A process without a template has no structure to fill in. The representation needs to capture both.

## Decision

Each document type will be represented as a Claude Code skill, following the standard [Agent Skills](https://agentskills.io) convention used by Claude Code. Skills are stored in the repository at `.claude/skills/` so they're versioned alongside the documents and shared with the team when the repo is cloned.

**Directory structure:**

```
.claude/skills/
  product-description/
    SKILL.md                    # Process: how to guide authoring this document type
    references/
      template.md               # Template: section structure and examples
  tech-design/
    SKILL.md
    references/
      template.md
  sop-runbook/
    SKILL.md
    references/
      template.md
  adr/
    SKILL.md
    references/
      template.md
```

Each `SKILL.md` includes YAML frontmatter (name, description) and markdown content defining the authoring process. The `references/` folder contains templates, examples, and supporting material that `SKILL.md` references.

The AI receives the skill content as part of its system prompt when a user starts authoring that document type. The skill tells the AI both what to produce and how to guide the user through producing it.

**Dual-use benefit:** Because these follow the standard Claude Code skills convention, they work both inside Episteme (loaded by the app during document authoring) and directly in Claude Code CLI sessions. The same skill files serve both use cases without modification.

We adopt the Claude skills convention as-is rather than inventing a custom format. This is a two-way door — if we find cases where the skills pattern doesn't fit, we can introduce a custom process+template format without significant migration cost, since the content itself (process guidance, template structure) would transfer directly.

## Consequences

**Positive:**
- Proven pattern — the skills format is already battle-tested in the Claude ecosystem
- Captures both process and template in a single cohesive unit
- Skills are plain markdown, easy to read, write, and version in git
- New document types can be added by creating a new skill folder — no code changes required
- The team can iterate on document type definitions without touching application code
- Skills live in the repo — cloning gets you the docs and the authoring skills together
- Dual-use: same skills work in Episteme and Claude Code CLI

**Negative:**
- Tied to Claude's skills conventions, which may evolve independently
- Skills are designed for LLM consumption, not human authoring tools — we may find edge cases where the format is awkward
- No schema validation — a malformed skill would produce bad authoring guidance rather than a clear error

## Alternatives considered

**Option 2: Custom process+template format**
- Separate `process.md` and `template.md` files with our own conventions
- Pros: Full control over structure, can optimize for our specific needs
- Cons: Reinvents a pattern that already works, no ecosystem compatibility, more design work upfront
- This remains a viable fallback if the skills pattern proves limiting
