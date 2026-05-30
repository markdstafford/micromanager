# Framing guide

Framing (stage 4) is where loose thinking becomes precise enough to write down. It is
the last highly-interactive stage. After it, the human reviews but no longer co-authors,
so the concepts must be crisp before you leave this stage.

## What framing produces

Framing does not produce a document. It produces shared, precise agreement on four
things, which the durable docs then capture:

1. **Names.** Every concept the feature set introduces has a clear, agreed name. Vague
   references ("the thing that handles syncing") become named concepts ("the sync
   coordinator"). Naming is not cosmetic — an unnamed concept cannot be referenced in a
   contract or an issue.

2. **Boundaries.** Related ideas are grouped into concepts, and the line between concepts
   is explicit. What belongs to concept A, what belongs to concept B, and what is shared.
   This is what later becomes the per-doc split in `concepts/`.

3. **Dependencies.** What depends on what. Which concept must exist before another can be
   built. This ordering drives issue sequencing in stage 5.

4. **Constraints.** The fixed points the design must respect — existing architecture,
   platform limits, decisions already made in ADRs.

## The framing worksheet

Work through this with the human, capturing the result in `brainstorm.md`. The filled
worksheet is the raw material for the doc plan in stage 5.

```
Concepts
  <name> — <one line: what it owns, and the boundary>
  <name> — ...

Boundaries (what is NOT in each concept, where it's ambiguous)
  <name> owns X but NOT Y; Y lives in <other concept>

Dependencies (A → B means B depends on A)
  <name> → <name>
  <name> → <name>

Constraints
  - <fixed point: existing architecture / platform / prior ADR>
```

A worked shape, for a multi-source sync feature set:

```
Concepts
  source-interface — what every source must implement (fetch, auth, identity)
  normalization    — the common record shape sources map into
  sync-coordinator — schedules and runs syncs; owns retry/backoff
  source-config    — per-source settings, isolated so one source can't leak into another

Dependencies
  source-interface → normalization
  source-interface → sync-coordinator
  source-config    → sync-coordinator

Constraints
  - tokens never persisted in the DB (per ADR on secret storage)
  - first source ships behind a flag
```

## How to run it

- Take the open items from `brainstorm.md` and the locked-in decisions from any
  prototyping, and turn each into a named, bounded concept.
- Draw the dependency graph out loud with the human. Disagreement here is cheap to
  resolve now and expensive later.
- Watch for two failure modes: a concept that is really two concepts (split it), and two
  "concepts" that are really one (merge them). Boundary errors here propagate into the
  docs and the issues.
- Name the constraints explicitly, even the obvious ones — they become the "Constraints
  and decisions" section of each concept doc.

## The exit bar

You are done framing when you are confident you can canonize everything discussed into
durable architectural docs without going back to the human for clarification. Concretely:

- [ ] Every concept has a name you could put in a file path.
- [ ] For every concept, you can state in one sentence what it does *not* own.
- [ ] The dependency order is acyclic and agreed.
- [ ] Every constraint is written down.

If you cannot yet write a clean contract for a concept, it is not framed — keep working
it with the human while their attention is still high.

## Rename the roadmap here

By stage 4 the feature set has a clear identity. Propose renaming the session folder
from `roadmap-YYYY-MM-DD` to `roadmap-<slug>` so the durable and ephemeral artifacts
carry a meaningful name into the future.
