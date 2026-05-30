# Inflection points

Every roadmap has natural boundaries — points where a group of work forms a coherent
planning unit. These are inflection points. Roadmapping works best when scoped to one
inflection point at a time: large enough that planning the group beats planning each
feature alone, small enough to hold in one session.

## Why plan at an inflection point

Some work must be planned as a group or the architecture comes out wrong. The classic
case: a project will eventually support several data sources, but only the first one is
in front of you. If you plan that first source without knowing others are coming, you
will bake single-source assumptions into the architecture and pay to undo them later.
Planning the source-handling layer once, with all known sources in mind, produces the
right abstraction the first time.

The test: **does planning these features together change the architecture versus
planning them one at a time?** If yes, they belong in one roadmap. If no, they are
probably independent features — use `mm:planning` for each.

## Recognizing an inflection point

An inflection point usually shows up as:

- A foundational capability that several later features will build on (a shared layer,
  a core abstraction, a primary surface).
- A decision that is expensive to reverse once features depend on it.
- A cluster of features that all touch the same new subsystem.

Common shapes (illustrative, not exhaustive):

- Establishing the foundational design system or token set.
- Laying out the application shell — the structural frame other features mount into.
- A multi-source or multi-provider integration layer, planned with all known
  sources/providers in mind.
- A primary content surface plus its configuration and settings.

## Bounding the scope

In stage 1, sanity-check the scope against both edges:

- **Too small** — if the work is effectively one feature, there is no shared
  architecture to design. Route to `mm:planning`.
- **Too large** — if the work spans many inflection points ("everything we want to
  build"), it cannot be planned well in one session. Help the human pick the nearest
  inflection point and scope to that. The rest becomes a follow-up.

### Bounding checklist

Run these checks before committing to the scope:

- [ ] Is there shared infrastructure two or more features depend on? (If no → likely one
      feature → `mm:planning`.)
- [ ] Would planning them together change the architecture versus one at a time? (If no
      → independent features → `mm:planning` each.)
- [ ] Can the set be held in one session — a handful of features, not dozens? (If no →
      too large → scope to the nearest inflection point.)
- [ ] Are the prerequisites already in place, or at least named? (If a prerequisite is
      missing → see Sequencing below.)

## Sequencing across inflection points

Inflection points have a natural order: later ones depend on earlier ones landing. Part
of stage 1 is confirming the prerequisites are in place. The critical question is not
only "can we plan this?" but **"should we plan this now, or does an earlier inflection
point need to land first?"** Planning a feature set on top of an unbuilt foundation
produces a roadmap built on guesses.

Two cases when a prerequisite is missing:

- **Missing and unplanned** — stop. The prerequisite is itself an earlier inflection
  point. Propose roadmapping or planning that first.
- **Missing but already designed** (its contract exists in `concepts/` or an ADR) — you
  can plan on top of the contract, noting the dependency explicitly so the sequencing in
  stage 5 puts the prerequisite's implementation first.

When in doubt, ask the human directly: *"This roadmap leans on X. X isn't built yet — is
it far enough along that we can plan against it, or should we set course on X first?"*
