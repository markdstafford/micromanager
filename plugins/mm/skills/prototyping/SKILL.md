---
name: prototyping
description: >
  Use when a design decision has several plausible options worth comparing live instead
  of in the abstract. Runs ordered experiments; each experiment builds a few variants
  that differ on one axis, the human picks a winner, and the winner folds into the
  baseline before the next experiment. Works for visual and UX questions and equally for
  CLI, API, architecture, and data-model decisions. Use when the user says "prototype",
  "experiment", "explore options", "compare a few approaches", or "try some variants".
  Not "build a throwaway version of the whole thing" — that is just exploratory coding.
  Composes with mm:roadmapping, and runs standalone.
---

# Prototyping

A structured way to answer a design question by comparison. You set up experiments in a
rough order. Each experiment builds a few variants that differ on exactly one axis. The
human picks a winner. **The winner folds into the baseline**, and the next experiment
builds on top of it. Repeat until the design is settled.

The lab is throwaway. The decisions are what you keep.

## When to use

- **DO use** — when a decision has several plausible options and comparing them live
  beats arguing them in the abstract.
- **DO use** — for any kind of decision: visual, UX, CLI, API, architecture, data model.
- **DO use** — even for a single axis with two variants. The structure scales down.
- **DON'T use** — when you already know the right answer. Just build it.
- **DON'T use** — when there is no running system to host a lab. Sketch on paper first
  and come back when something runs.

## Anti-pattern: bypassing prototyping to ship faster

Skipping comparison to ship a design quickly trades a small saving now for a likely
rework later, once the unexamined option turns out wrong under real use. Do not bypass
the process to ship a feature quickly. If the human wants to skip, say what the
comparison would have caught, then defer to their call:

> "We can commit to the first layout that works, but two of these options behave very
> differently once the list gets long, and we won't know which until we see them side by
> side. One experiment — three variants, ten minutes — and we'll know. Skip it, or run
> it?"

## Process

### 1. Set context

Before planning experiments, establish what you are exploring:

- Are we exploring inside a feature set (composed with `mm:roadmapping`), or a single
  feature (standalone)?
- Read the relevant repository docs first — the design system, related features, any
  existing contracts the design must fit.
- State the decision outcome in one or two sentences: what settling this decision
  unlocks for the project or the feature set.
- State the target altitude, such as field list, layout, mechanism, architecture, data
  model, workflow, or feature-set shape.
- Ask the human to confirm or correct the outcome and altitude before listing axes. If
  they correct it, adjust your context before moving to step 2.

Only once the context, outcome, and altitude are clear should you plan experiments. A
prototype that ignores the existing design system, an adjacent feature's contract, or the
actual level of the decision wastes a round. Say what constraints you found and what
altitude you think the decision targets: *"The design system fixes the accent color and
the sidebar width, so those are constant across all variants. Settling this unlocks the
source-selection workflow, and I think the target altitude is workflow shape rather than
row styling. Is that right?"*

### 2. Plan the experiments

List the axes the design question turns on, and a rough order to explore them. The plan
is provisional — expect it to change as you learn. Three to seven experiments is typical.
See `references/experiment-design.md` for choosing and ordering axes.

Order matters: earlier experiments should settle decisions that later ones build on.
Present the plan and get a loose nod before building — not a formal approval, just
alignment on where you are headed.

### 3. Set up the lab

Before writing any lab files, isolate the workspace. If the session is running in an
Autocatalyst-managed workspace, the workspace is already isolated: do not create a
worktree, switch branches, push, merge, or open a PR. If the session is not already
isolated, use an available worktree skill or native worktree flow before creating lab
files; if the repository has a different documented isolation convention, follow that
convention and say what you are using. A branch in the same working directory is not
sufficient isolation for throwaway lab files; untracked and temporary files dirty the
user's active checkout regardless of which branch is checked out.

Build throwaway scaffolding inside the running system only after that isolation preflight
is complete. During an active prototyping session, launch directly into the experiment by
default; use the shortcut or control as the escape hatch back to the normal app, not as
the only way into the lab. Variants live in a clearly named throwaway location inside the
isolated workspace so they are easy to find and delete later. Lab chrome must be
discoverable but unobtrusive, recessed in a consistent location by default, and separated
from the experiment's visual hierarchy. Use stable selectors such as `1..N` for variant
switching after checking host shortcut collisions, and make the visible variant label
start with the same selector the human uses. Put experiment framing and per-variant
explanations in a dismissable surface instead of persistent chrome. See
`references/lab-setup-patterns.md`.

### 4. Run one experiment

For each experiment, loop:

1. **Identify the axis and the tradeoff** — the one dimension this experiment varies, and
   what is at stake on it. State it before building.
2. **Build the variants** — hold everything else constant; vary only this axis. Three
   variants is the norm. Drop to two when the axis is nearly binary, or go up to about
   five when the option space is genuinely wider. If you need more than five, the axis is
   too broad: split it into multiple experiments or run multiple rounds.
3. **Present** the variants side by side, using the format below.
4. **Get feedback.** The human either picks a winner, or they do not.
5. **If no winner**, use their input to build a new set of variants and present again.
   This is normal — a round that produces no winner is the comparison doing its job.
6. **On a winner**, fold it into the baseline and delete the losing variant files. The
   next experiment builds on the new baseline.

#### Variant presentation format

Present every experiment the same way so the human can compare quickly:

```text
Experiment N: <axis> — <the tradeoff at stake>
Holding constant: <what is the same across all variants>

  1 — <name>: <one line on what's different and why you'd pick it>
  2 — <name>: <one line>
  3 — <name>: <one line>

How to see them: <direct launch path plus checked shortcuts/controls; labels match selectors>
```

Use as many numbered entries as the experiment has variants, normally two to five; do not introduce a second identity such as `A/B/C` when the lab controls use numeric selectors.

Then stop and let the human look. Do not recommend a winner unless asked — you propose
the options; the human picks. If asked for your lean, give it with a one-line reason.

### 5. Re-evaluate between experiments

After each experiment, decide what happens next. The plan from step 2 is a starting
point, not a script. Choose one and say which and why:

- **Continue** to the next planned experiment.
- **Re-run** the same axis with a fresh set of variants, if the winner raised new
  questions.
- **Reorder** the remaining experiments.
- **Add** an axis the last experiment surfaced.
- **Stop early** — sometimes the design is settled before the plan is exhausted.

State it plainly: *"Locked in 2. That settles the row layout but raises a density
question I didn't plan — want to run that next, or move to the empty state as planned?"*

### 6. Watch for meta-lessons

Some feedback is not "pick a variant" but "the axis itself is wrong." The most common
case: your variants are each a different *value* on a dimension, when the real question
is one level deeper. See `references/meta-lessons.md`. When this happens, accept the
reframe and rebuild — it is the skill working, not failing.

### 7. Wrap up

When the human calls it, summarize and decide where the decisions land. See
`references/wrap-up.md`, then clean up the lab per `references/cleanup.md`.

## Key principles

- **One axis at a time.** Variants hold every other dimension constant. If two things
  vary at once, you cannot attribute the preference.
- **Three variants is the norm**; two to five as the axis warrants; more than five means
  split the experiment.
- **The winner folds into the baseline.** Each experiment builds on the last, so later
  experiments are judged against real decisions, not a stale starting point.
- **Lock-in is binary.** Pick one and fold it in. Do not endlessly recombine.
- **The human picks; you propose.** Never override a pick.
- **The lab is throwaway.** It never merges to the main line; it is deleted at wrap-up.
- **Reframes are normal.** A rebuilt trio after a reframe is progress, not waste.

## Composition

When invoked by `mm:roadmapping`, prototyping returns its locked-in decisions to the
parent instead of writing its own output or asking where decisions land. The parent
folds them into its architectural docs. Standalone, prototyping handles its own output —
see `references/wrap-up.md`.

## Writing style

When writing any decision summary or seed doc, follow `mm:writing-guidelines`.
