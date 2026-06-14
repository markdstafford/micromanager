# Wrap up

When the human calls the session done, capture the decisions before tearing down the lab.

## 1. Summarize the lock-ins

State, for each experiment that produced a winner:

- The axis the experiment explored.
- The variant that won.
- A one-line reason it won.

This summary is the value of the session. It must survive even if everything else is
deleted. Use this format:

```markdown
# <design question> — decisions

_From a prototyping session on YYYY-MM-DD._

## <axis 1>
**Chose:** <variant name>. <one-line reason>.
Considered: <other variant names>, set aside because <one line>.

## <axis 2>
**Chose:** <variant name>. <one-line reason>.

## Open / deferred
- <anything the session surfaced but did not settle>
```

Record the also-rans, briefly. The reason a variant lost is often the most useful thing
a future reader learns.

## 2. Decide where the decisions land

**If invoked by `mm:roadmapping`:** skip this step. Return the lock-in summary to the
parent skill. Roadmapping folds the decisions into its durable `concepts/` docs. Do not
write your own output doc and do not ask the human where decisions go — the parent owns
that.

**If standalone:** first check whether the lock-ins describe one feature or a feature set
with multiple implementation slices. Use this tripwire when the session settled several
related decisions whose implementation has dependencies, parallel tracks, or foundations
that other slices build on. Say the classification plainly: *"This prototype settled a
feature set, not just one feature, because the source contract must land before the
normalization and sync slices can proceed."*

If the output is feature-set-sized and the framing is not complete enough to hand off —
contracts are not drafted, slice boundaries are unnamed, or dependencies are unclear —
route to `mm:roadmapping` and hand it the lock-in summary, open/deferred items, and any
constraints discovered in the lab. If the framing is already complete — contracts
drafted, slices named, dependencies identified — propose a dependency-ordered issue set
using the sequencing logic in
`plugins/mm/skills/roadmapping/references/issue-sequencing.md`: foundations first,
dependents after, cross-links for dependencies, parallelizable work called out. Adapt the
sequencing logic to the standalone context; do not assume the roadmapping session-prep
file tree exists. Ask whether to file those issues using the configured issue tracker: *"I
can file these as implementation issues in order. Want me to do that, leave them as a
draft, or adjust the sequencing first?"* If the tracker is Jira or another unsupported
provider, do not promise GitHub issue creation; provide the ordered issue bodies for the
human or tracker-specific workflow instead. In Autocatalyst-managed runs, do not create
worktrees, switch branches, push, merge, or open PRs; branch and PR management belongs to
Autocatalyst.

If the standalone output is one feature, or the human declines issue sequencing, ask where
the decisions should land. For a substantial session, recommend detailed concept docs in
`{docs_root}/concepts/` unless the human chooses another durable destination. Use
`notes/` for throwaway seed material, not for durable decisions.

Offer these destinations:

- **a. Fold into an existing durable doc** — the human names the path; you edit it.
- **b. Detailed concept docs** — write durable docs under
  `{docs_root}/concepts/<experiment-or-topic>/` or the repository's established concepts
  path. Choose this for substantial standalone sessions where future implementers need
  the decisions as a contract.
- **c. Seed doc** — write the decision summary to
  `{docs_root}/notes/<experiment-name>/decisions.md` only for lightweight or working
  material. This can feed a later `mm:planning` or `mm:roadmapping` session, but it is
  not the durable home for substantial decisions. Before writing here, check that
  `{docs_root}/notes/` is listed in `.gitignore`. If it is not, add it and tell the
  human: *"Added `{docs_root}/notes/` to `.gitignore` — seed notes stay local; use
  `concepts/` for committed decisions."* If the human prefers not to modify `.gitignore`,
  use `concepts/` or an issue instead.
- **d. Issue body** — create a new issue, or update an existing one, with the decisions.
- **e. Just exit** — leave the summary in chat only when the human explicitly wants no
  artifact.

Phrase it as a recommendation plus a choice: *"Decisions are captured. This was a
substantial standalone session, so I recommend durable concept docs under
`{docs_root}/concepts/<experiment-or-topic>/`. Should I write those, fold the decisions
into an existing doc, create a lightweight `notes/` seed, put them on an issue, or leave
them here?"* Apply `mm:writing-guidelines` to whatever you write.

### Durable concept-doc plan

Before writing durable concept docs for a standalone session, propose a short doc plan
and get the human's approval. The plan should:

- List each durable doc under `{docs_root}/concepts/<experiment-or-topic>/` or another
  repository-appropriate concepts path.
- Split by concern when the session spans unrelated domains, such as read/preview
  behavior versus write behavior.
- Include three to five bullets of intended content for each doc.
- State whether a separate follow-up artifact is needed.
- Ask the human to approve or revise the split before you write.

Read an existing concept doc or repository exemplar first, then match its depth and
voice. Detailed concept docs are the deliverable for substantial standalone sessions, not
a thin decision summary. Durable docs should describe the contract: boundaries,
invariants, structure, relationships, constraints, and non-obvious decisions with their
reasons. Do not copy the full roadmapping workflow into prototyping. Only use roadmapping's
issue-sequencing reference when the standalone feature-set tripwire above fires and the
settled framing is complete enough to propose implementation issues safely.

Use this doc-plan shape:

```markdown
I recommend these durable docs:

1. `{docs_root}/concepts/<experiment-or-topic>/<concern-a>.md`
   - Contract this concern owns.
   - Decisions from experiments that constrain it.
   - Relationships to adjacent concepts.
   - Open edges future work may extend.
2. `{docs_root}/concepts/<experiment-or-topic>/<concern-b>.md`
   - Contract this concern owns.
   - Decisions from experiments that constrain it.
   - Relationships to adjacent concepts.
   - Open edges future work may extend.
3. `{docs_root}/concepts/<experiment-or-topic>/follow-ups.md`
   - Human tasks.
   - Future roadmap inputs.
   - Future issue candidates.
   - Items explicitly discarded.

Approve this split, or adjust it before I write the docs?
```

### Follow-ups

Human-owned follow-ups must go to a durable, human-visible artifact, never agent memory.
A throwaway lab increases the need to write follow-ups into the real repository or a
human-owned issue; it is not a reason to keep them in memory.

For substantial standalone sessions, create or update a follow-up artifact such as
`{docs_root}/concepts/<experiment-or-topic>/follow-ups.md` or another
repository-appropriate path, unless the human chooses issue tracking instead. Record each
follow-up under one of these outcomes:

- **Human task** — something the human agreed to do.
- **Future roadmap input** — a topic to consider in a later `mm:roadmapping` session.
- **Future issue** — a candidate issue to file when the human is ready.
- **Discarded** — a tangent the human explicitly chose not to pursue.

### Durable artifact branch and PR handling

Durable docs must not be written directly onto a repository's main branch or normal
working branch when the repository convention requires branch and PR review. In normal
interactive sessions, create or use an appropriate feature branch and open a PR for
durable artifacts.

In Autocatalyst-managed runs, the workspace already owns branch and PR management. Do
not create worktrees, create or switch branches, push, merge, or open PRs when the
environment provides those steps. Use the same artifact destinations, but leave branch
and PR operations to Autocatalyst.

## 3. Clean up the lab

Proceed to `cleanup.md`.
