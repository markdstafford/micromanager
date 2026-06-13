# Experiment design

An experiment is one axis with a few variants. The quality of a prototyping session is
mostly decided here: a well-chosen axis produces a clean decision, a muddy axis produces
variants the human cannot compare.

## Choosing axes

An axis is a single dimension of the design that has several plausible settings. Good
axes are:

- **Singular** — one dimension, not a bundle. "Row layout" is an axis. "Row layout and
  density and what shows in the row" is three axes wearing a trenchcoat. Split them.
- **Consequential** — the choice actually matters and is hard to reverse later. Do not
  spend an experiment on something a one-line change can flip after the fact.
- **Comparable** — the variants can be seen side by side and judged. If you cannot show
  the difference, it is not ready to be an experiment.

If you catch yourself making variants that each set a different *value* of some
property, the axis is probably one level too shallow — see `meta-lessons.md`.

## Ordering experiments

Order so that earlier decisions constrain later ones, not the other way around:

1. **Structure before surface.** Settle the layout or shape before the styling. A color
   choice made on the wrong layout is wasted.
2. **High-leverage before low.** Decisions many later variants depend on come first.
3. **Cheap-to-reverse last.** Things you can flip in one line can wait.

The order is provisional. Stage 5 of the main loop (re-evaluate) exists precisely so you
can reorder once a winner changes what matters.

## Designing the variants

- **Hold everything else constant.** Vary only the axis under test. If a second thing
  changes between variants, the human cannot tell which difference drove their
  preference.
- **Make them genuinely different.** Three variants clustered around the same idea waste
  the round. Spread them across the option space so the comparison is informative — even
  include one you suspect is wrong, if it sharpens the contrast.
- **Three is the norm.** Two when the axis is nearly binary. Up to five when the space is
  genuinely wider. More than five means the axis is too broad — split it or run a second
  round to narrow first.
- **Name each variant** for what makes it distinct ("attached titlebar", "footer
  toggle"), and pair that name with the lab selector. If the selector is `1`, write the
  visible identity as `1 — attached titlebar`. The name is how the decision gets
  remembered, but the selector is how the human switches; do not create a second visible
  identity such as `A` for the same variant.

## When an experiment produces no winner

Not landing a winner is a normal, useful outcome. It usually means one of:

- The variants were too similar — spread them further and re-run.
- The axis was wrong — the human's feedback points at the real axis (a reframe; see
  `meta-lessons.md`). Rebuild against it.
- The decision depends on something not yet settled — pause this experiment, run the
  prerequisite one first, come back.

Use the human's feedback to decide which, say which, and rebuild.
