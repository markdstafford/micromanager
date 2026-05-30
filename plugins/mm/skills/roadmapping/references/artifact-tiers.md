# Artifact tiers

Roadmapping produces two tiers of document. Keeping them distinct is what makes a
roadmapping session produce clean, reviewable output instead of a pile of mixed notes.

## Durable docs — `{docs_root}/concepts/`

**Committed to the repository.** These are architectural contracts. They describe the
shared design of the feature set: the concepts, their boundaries, what depends on what,
and the constraints. They outlive the session.

- **Audience:** anyone who later implements one of the issues, and anyone reviewing the
  architecture months from now.
- **Style:** descriptive and precise. State the contract, not the build steps. Apply
  `mm:writing-guidelines` before presenting.
- **Granularity:** one doc per concept or concern, whichever scales better. A feature
  set with four distinct layers usually wants four docs.
- **Lifecycle:** drafted in stage 5, reviewed per doc, committed.

A good durable doc reads like a reference a future implementer consults to understand
how their slice fits the whole — not a task list.

### Concept doc template

```markdown
---
created: YYYY-MM-DD
last_updated: YYYY-MM-DD
status: active
roadmap: <slug>
---

# <Concept name>

One-paragraph statement of what this concept is and the boundary around it — what it
owns and what it explicitly does not.

## Contract

The rules anything touching this concept must honor. State them as invariants, not
suggestions.

## Structure

The shape: the entities, interfaces, or data the concept defines. Use fenced blocks for
schemas, signatures, or types.

## Relationships

What this concept depends on, and what depends on it. Link sibling concept docs.

## Constraints and decisions

Fixed points the design must respect, and the non-obvious decisions made during
roadmapping (with the one-line reason each was chosen).

## Open edges

Known extension points or deferred questions — what later work may add without breaking
this contract.
```

Not every section is required for every concept. Keep the ones that carry weight; drop
the rest rather than padding.

## Ephemeral docs — `{docs_root}/notes/<roadmap-name>/`

**Gitignored.** These are working artifacts for the session and the implementations
that follow.

- `brainstorm.md` — loose thinking and decisions captured during stages 1–2.
- `follow-ups.md` — out-of-scope tangents, held so the human is not anxious about losing
  them. Resolved at wrap-up.
- `session-prep/<issue-slug>.md` — one prep doc per issue. Becomes the issue body. See
  the template in `issue-sequencing.md`.

- **Audience:** the agent running a specific implementation session.
- **Style:** prescriptive. Describe the build steps for one slice of the contract.
- **Lifecycle:** created in stages 1–2 (brainstorm, follow-ups) and stage 5
  (session-prep), then discarded or left for the human to clean up.

## The key distinction

The durable doc describes the **contract**. The session-prep doc describes the **build
steps** for one slice of that contract. The session-prep is therefore more prescriptive
and more detailed than the durable doc it implements. This separation is what keeps the
committed `concepts/` docs clean: implementation detail lives in `notes/`, not in the
durable contract.

A quick test when you are unsure where something belongs: *will a future implementer of
a different slice need this?* If yes, it is contract — put it in `concepts/`. If it only
matters to the one issue in front of you, it is build detail — put it in session-prep.
