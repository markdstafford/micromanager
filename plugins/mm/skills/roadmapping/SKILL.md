---
name: roadmapping
description: >
  Use when planning the next several features together rather than one feature at
  a time — setting course for a feature set, plotting a roadmap, doing long-term or
  look-ahead planning, or planning a group of related work that shares architecture.
  Produces durable architectural docs plus a sequenced backlog of issues. Use when
  the user says "roadmap", "plan the next few features", "plan ahead", "set course",
  "feature set", or "plan this group of work". Distinct from mm:planning, which is
  scoped to a single feature or enhancement — roadmapping plans several features at an
  inflection point and hands each one off afterward.
---

# Roadmapping

A collaborative process for planning a feature set — several related features that
share architecture — at a natural inflection point in a project. Roadmapping produces
two things: durable architectural docs that future work reads from, and a sequenced
backlog of issues, each ready to hand off to single-feature implementation.

Roadmapping is exploratory at the start and precise at the end. The human is most
involved early, while goals and concepts are still loose, and least involved late,
once the concepts are crisp enough to write down. Your job is to help them land an
excellent feature set, keep them on track, and push back when the design could be
better.

## When to use

- **DO use** — when several upcoming features share infrastructure that has not been
  named yet, and planning them as a group will produce a better architecture than
  planning each alone.
- **DO use** — at a project inflection point (see `references/inflection-points.md`),
  where a group of work forms a natural planning boundary.
- **DON'T use** — for a single feature or enhancement. Use `mm:planning` instead.
- **DON'T use** — to "boil the ocean." If the work spans dozens of features, it is too
  large for one roadmapping session; help the human find the nearest inflection point
  and scope to that.

## Routing

**In from `mm:planning`:** If a planning session reveals the work is really several
features sharing architecture, stop and route here. Plan the group first, then return
to `mm:planning` per feature.

**Out to `mm:planning`:** After issues are filed, an individual issue can be picked up
by `mm:planning` if it is non-trivial. This is usually unnecessary — the session-prep
docs this skill produces already decompose each issue.

## Anti-pattern: bypassing roadmapping to ship faster

Rushing a feature set into code without setting course feels faster, but the cost is
paid later — usually as a rewrite, because the shared architecture was guessed at one
feature at a time instead of designed once. If the human asks to skip roadmapping for a
group of related work, push back once with the concrete cost, then defer to their call.

The push-back should be specific, not a lecture. Name the architectural decision that
will be hard to reverse:

> "We can skip ahead and build the first source now, but every later source will inherit
> whatever shape we give this one. If we plan the source layer as a group first — even
> just for an hour — the abstraction comes out right the first time. Your call: skip, or
> set course first?"

## Config

mm config is resolved at session start by the mm hook and available in session context:

- `docs_root` — base directory for all artifact paths in this session
- `issue_tracker` — issue tracking integration

Use `{docs_root}` throughout wherever a path into the docs directory appears.

## Artifacts and where they live

Roadmapping produces two tiers of document. The distinction is the core of this skill;
read `references/artifact-tiers.md` for the full model and templates.

- **Durable docs** → `{docs_root}/concepts/`. Committed. These are the architectural
  contracts that future work reads to understand the shared design. Audience: anyone
  implementing one of the issues, anyone reviewing the architecture later.
- **Ephemeral docs** → `{docs_root}/notes/<roadmap-name>/`. Gitignored. Working notes,
  follow-ups, and per-issue session prep that becomes issue bodies. Audience: the agent
  running a specific implementation session.

```
{docs_root}/
  concepts/                      # durable architectural contracts (COMMITTED)
    <concept>.md
  notes/                         # ephemeral working output (GITIGNORED)
    roadmap-YYYY-MM-DD/          # one folder per roadmapping session
      brainstorm.md              # loose thinking captured during stages 1-2
      follow-ups.md              # out-of-scope tangents held for later
      session-prep/              # one prep doc per issue; becomes the issue body
        <issue-slug>.md
```

On first use, ensure `{docs_root}/notes/` is listed in `.gitignore`. If it is not, add
it and tell the human: *"Added `{docs_root}/notes/` to `.gitignore` — roadmapping's
working notes stay local; only `concepts/` is committed."* `{docs_root}/concepts/` is
committed and must not be gitignored.

## File setup and naming

Start without a name. The roadmap's real name emerges from the conversation, so do not
force one up front. This mirrors `mm:friction-log`: begin with a dated stub, rename once
the work has an identity.

### 1. Create the session notes at the start of stage 1

Create `{docs_root}/notes/roadmap-YYYY-MM-DD/` and seed it with two files before saying
anything else to the human.

`brainstorm.md` stub:

```markdown
---
created: YYYY-MM-DD
last_updated: YYYY-MM-DD
status: exploring
roadmap: null
---

# Roadmap brainstorm — YYYY-MM-DD

## Goal

_(stage 1 — what the app can do at the end that it cannot today)_

## Open questions

## Decisions

---
```

`follow-ups.md` stub:

```markdown
---
created: YYYY-MM-DD
last_updated: YYYY-MM-DD
---

# Follow-ups — out of scope for this roadmap

_Captured so nothing is lost. Resolved at wrap-up: each becomes its own issue, input to
a future roadmap, or is discarded._

---
```

Then tell the human: *"Starting a roadmap session — capturing notes in
`{docs_root}/notes/roadmap-YYYY-MM-DD/`."*

### 2. Write as you go

Append loose thinking, open questions, and decisions to `brainstorm.md` as the
conversation proceeds. Do not buffer — if the session ends early, the file should hold
everything decided to that point.

### 3. Rename at framing (stage 4)

Once the feature set has a clear identity, propose: *"This roadmap is about <topic>.
Rename the session folder to `roadmap-<slug>`?"* On approval:

```bash
mv {docs_root}/notes/roadmap-YYYY-MM-DD {docs_root}/notes/roadmap-<slug>
```

Set the `roadmap` frontmatter field in `brainstorm.md` to `<slug>`.

## Roles

You play different roles across the stages. Each has a goal and a tone.

- **Facilitator** (stages 1–2) — draw out the human's goal, keep them on track, capture
  tangents. Curious and generative, never passive.
- **Devil's advocate** (stages 2, 4) — name weaknesses, surface what could go wrong,
  propose alternatives. Direct but not contrarian for its own sake.
- **Architect** (stages 3–4) — name concepts, draw boundaries, resolve dependencies.
  Precise and opinionated.
- **Author** (stage 5) — turn the framed concepts into durable docs and sequenced
  issues. The human reviews; you write.

## Working with your human

- Be a partner, not a sycophant. Identify weaknesses and propose alternatives.
- Get the goal — what the app can do at the end that it could not at the start — from
  the human. This requires their input; do not invent it.
- Keep them on track. Roadmapping invites tangents; capture out-of-scope thoughts in
  `follow-ups.md` so nothing feels lost, then return to the current topic.
- The human has final say on scope, architecture, and sequencing.
- Be pleasant to work with. This matters most during open-ended roadmapping.
- Offload read-heavy research to a sub-agent so the main session stays focused on the
  human and the design. See `references/research-offload.md`.

## Checkpoints

Roadmapping uses per-section checkpoints. Complete one stage's work, write it to disk,
present it, and get explicit approval before the next. Never run several stages at once.
Each checkpoint below is phrased as the question you must be able to answer "yes" to —
ask it of the human in roughly these words and wait for an answer before proceeding. If
the human wants to skip ahead, remind them of the process; if they insist, note in
`brainstorm.md` what was skipped.

## Process

The process moves from loose to crisp across five stages. Stages 1, 2, and 4 are highly
interactive. Stage 3 may hand off to `mm:prototyping`. Stage 5 is agent-led.

### Stage 1 — Establish the goal

**Role: Facilitator.**

Read the existing system thoroughly first: specs in `{docs_root}/specs/`, ADRs in
`{docs_root}/adrs/`, wiki in `{docs_root}/wiki/`, and existing docs in
`{docs_root}/concepts/`. You cannot plan a feature set well without understanding what
is already there. Summarize back to the human what you found so they can correct your
model before you build on it.

Then work with the human to define the goal:

- What can the app do at the end of this feature set that it cannot do today?
- What changes for the user?
- Sanity-check the bounding. If this is effectively one feature, route to `mm:planning`.
  If it is dozens of features, it is too large — find the nearest inflection point.

Teach the inflection-point concept if the human is unsure where the boundary is. See
`references/inflection-points.md`. Write the agreed goal into `brainstorm.md` under
`## Goal`.

**Checkpoint:** Ask, in roughly these words:

> "Here's the scope as I understand it: <one-paragraph restatement>. Three checks before
> we go deeper: (1) Is this the right inflection point — not so small it's really one
> feature, not so big it's several roadmaps? (2) Is it internally one thing? (3) Should
> we plan this *now*, or does something else need to land first before we can plan it
> well? What do you think?"

Do not proceed until the human confirms the scope and the timing.

### Stage 2 — Brainstorm

**Roles: Facilitator + Devil's advocate.**

Help the human flesh out the feature set. This is exploratory: surface options, question
assumptions, and find the shape of the work. Be opinionated about quality while staying
pleasant.

- Capture every out-of-scope tangent in `follow-ups.md` rather than chasing it. When you
  do, say so briefly: *"That's worth doing but it's outside this roadmap — parked it in
  follow-ups so we don't lose it."*
- Surface shared infrastructure as it appears — the things several features will depend
  on are the reason to plan as a group. Call them out explicitly when you spot them.
- Play devil's advocate on at least the load-bearing decisions: what breaks this design,
  what does it cost, what is the alternative.
- Write decisions and open questions to `brainstorm.md` as you go.

**Checkpoint:** Ask, in roughly these words:

> "Before we get precise, two checks: is the feature set internally consistent — do the
> pieces fit together — and does anything in here need to land before the rest? I think
> we have enough to <prototype X / start naming the architecture>. Agree?"

Goal of this stage: enough detail to start prototyping or to discuss architecture.

### Stage 3 — Decide whether to prototype

**Role: Architect.**

If open design questions remain — visual, UX, **or CLI / API / architecture / data
model** — invoke `mm:prototyping` to compare options before committing. Prototyping is
not only a UI tool; any decision with several plausible options can be prototyped.

If the decisions are already settled enough to name and write down, skip to stage 4.
State which you are doing and why: *"The data model has three plausible shapes — worth
prototyping. The sync trigger is settled. I'll prototype the model, then we frame."*

When `mm:prototyping` runs inside roadmapping, it returns its locked-in decisions to you
rather than writing its own output doc. Fold those decisions into the framing stage. See
`references/composition.md`.

### Stage 4 — Framing

**Roles: Architect + Devil's advocate.**

This is the last highly-interactive stage, and the most important. Take the loose
thinking from stages 2–3 and make it crisp. The human's attention diminishes after this
point, so getting the concepts precise now is what makes the durable docs possible.

Produce precise agreement on four things (see `references/framing-guide.md` for how):

- **Names** — every concept has a clear, agreed name. An unnamed concept cannot be
  written into a contract or an issue.
- **Boundaries** — related ideas grouped into concepts, with explicit lines between them.
  This becomes the per-doc split in `concepts/`.
- **Dependencies** — what depends on what; what must exist before what. This drives issue
  sequencing in stage 5.
- **Constraints** — the fixed points the design must respect.

This is also where the roadmap earns its name — propose the folder rename here (see File
setup and naming).

**Checkpoint:** Ask, in roughly these words:

> "Here are the concepts, their boundaries, and the dependency order: <summary>. Are
> these the right names and the right groupings? Anything mis-bounded? Once you say yes,
> I'll canonize these into the durable docs and you'll review the writing, not the
> structure."

The bar: you are confident you can canonize everything discussed into durable
architectural docs without coming back to the human for structural clarification.

### Stage 5 — Wrap up and hand off

**Role: Author.** Everything from here is agent-led. The human reviews; they do not
co-author.

#### 5a. Propose the doc plan

List which docs are durable (→ `concepts/`) and which are ephemeral (→ `notes/`). Give
3–5 bullet points of intended content per doc. Present it like this:

```
Durable (concepts/, committed):
  concepts/source-layer.md
    - the source abstraction and what every source must implement
    - the sync lifecycle: fetch, normalize, store
    - how source-specific config is isolated
  concepts/normalization.md
    - the normalized record shape all sources map into
    - ...

Ephemeral (notes/<roadmap>/session-prep/, gitignored → issues):
  session-prep/01-source-interface.md  → issue: define the source interface
  session-prep/02-first-source.md      → issue: implement the first source
  ...
```

**Get the human's buy-in on the plan before writing anything.** Adjust until they
approve.

#### 5b. Write the durable docs first

For each durable doc, in dependency order: draft it from the framing, apply
`mm:writing-guidelines`, then present it. **Checkpoint per doc:** *"Here's
`concepts/<name>.md`. Reviewable, or want changes?"* Get approval before the next doc.
Write each approved doc to disk immediately.

#### 5c. Produce session-prep docs

One per issue, in `notes/<roadmap-name>/session-prep/`, numbered in implementation
order. These are more prescriptive than the durable contracts — they describe the build
steps for one slice. Use the template in `references/issue-sequencing.md`.

#### 5d. File the issues in order

File in implementation order so issue numbers encode the sequence. Cross-link
dependencies; supersede any stale existing issues. See `references/issue-sequencing.md`.

#### 5e. Resolve follow-ups

Surface each item in `follow-ups.md` and ask whether it becomes its own issue, input to
a future roadmap, or is discarded. Record the disposition next to each item.

#### 5f. Hand off

Summarize the chain: what implements what, what blocks what, what can run in parallel.
End with the ordered issue list and any parallelizable groups called out.

## Scaling

Adapt the depth to the size of the feature set:

- **Large feature set** (5+ features, multiple shared concepts) — all five stages,
  multiple durable docs, full dependency graph.
- **Small feature set** (2–4 features, one shared concept) — run all stages but expect
  one or two durable docs and a short dependency chain. Do not skip framing; a small set
  still benefits from named concepts and explicit ordering.
- **Borderline (one feature?)** — if stage 1 reveals it is really one feature, stop and
  route to `mm:planning`. Do not stretch a single feature into a roadmap.

The stages do not change with size; the number of artifacts does.

## Composition

- `mm:prototyping` — invoked in stage 3 when design questions warrant comparison. See
  `references/composition.md` for how the two skills hand off.
- `mm:writing-guidelines` — applied to every durable doc before it is presented.
- `mm:planning` — available per-issue after the roadmap is sequenced (usually
  unnecessary).
- `superpowers:using-git-worktrees` — for an isolated workspace, so planning artifacts
  do not disturb the working branch.

## Autocatalyst environments

If running inside an autocatalyst workspace, the session is already isolated — do not
create your own worktree. Durable docs still go to `{docs_root}/concepts/`; ephemeral
docs still go to `{docs_root}/notes/`. See `references/autocatalyst-adaptation.md`.

## Writing style

When drafting any durable doc, follow `mm:writing-guidelines` for style, tone, and
anti-jargon principles.
