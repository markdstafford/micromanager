# Issue sequencing and session prep

Stage 5 turns the framed feature set into a sequenced backlog. Each issue gets one
session-prep doc that becomes its body. The sequence encodes the dependency order from
framing.

## Session-prep docs

One doc per issue, in `{docs_root}/notes/<roadmap-name>/session-prep/<NN>-<slug>.md`,
where `NN` is the implementation order. These are ephemeral and gitignored.

A session-prep doc is **prescriptive** — it describes how to build one slice of the
feature set, for the agent that will implement it. Unlike the durable contract in
`concepts/`, which states what the design is, the session-prep states what to do.

### Session-prep template

```markdown
# <Issue title>

## Slice
What this issue covers, and how it fits the feature set. One paragraph.

## Contract
Link the relevant `concepts/` doc(s). State which parts of the contract this slice
implements. Do not restate the contract — link it.

## Build steps
1. <ordered, concrete step>
2. ...
Keep these prescriptive. This is the part that distinguishes session-prep from the
durable doc.

## Acceptance criteria
- [ ] <observable, testable condition>
- [ ] ...

## Dependencies
- Depends on: #<n> (<why>)
- Blocks: #<n>

## Out of scope
What this issue deliberately does not do, so the implementer doesn't expand it.
```

Keep contract detail in `concepts/` and build detail in session-prep. Do not duplicate
the contract into every prep doc — link to it.

## Filing order

File issues in implementation order so that issue numbers reflect the sequence:

1. Topologically sort the issues by the dependency graph from framing. Foundations
   first; dependents after. Where two issues have no dependency between them, either
   order is fine — flag them as parallelizable.
2. File each issue, using its session-prep doc as the body.
3. Cross-link dependencies: each issue names the issues it depends on and the issues
   that depend on it. Use the tracker's native linking where available; otherwise put
   `Depends on #N` / `Blocks #N` in the body.
4. Identify which issues can run in parallel — work with no dependency between them — and
   say so in each issue and in the hand-off summary.

## Superseding stale issues

A roadmap often touches work that already has open issues. For each:

- **Now covered by the roadmap** — supersede it: link the new issue, close or annotate
  the old one (*"Superseded by #N as part of the <roadmap> roadmap"*), and note the
  replacement.
- **Now wrong** (the roadmap changed the design) — update or close it and explain why in
  one line.
- **Still independent** — leave it alone; not everything is part of the roadmap.

Do not leave stale issues that contradict the roadmap — they will mislead whoever picks
them up.

## Hand-off summary

Close stage 5 with a summary the human (or the next agent) can act on cold:

```
Roadmap: <slug>
Durable docs: concepts/<a>.md, concepts/<b>.md

Issues, in order:
  #12 define the source interface           (no deps)
  #13 normalization record shape            (depends #12)
  #14 sync coordinator                      (depends #12)        ┐ parallel with #13
  #15 first source: implement + flag        (depends #13, #14)

Parallelizable: #13 and #14 after #12 lands.
Superseded: #9 (old single-source issue) → #15.
```
