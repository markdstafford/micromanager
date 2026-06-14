# Meta-lessons

Some feedback in an experiment is not "I pick 2." It is a signal that the
experiment is framed wrong. These are the recurring patterns worth watching for. Each
has a trigger, the reframe, and an example.

## Variants-as-values: the axis is one level deeper

**Trigger.** You find yourself proposing a set of variants where each variant is one
possible *value* on some dimension. 1 — sort by date, 2 — sort by priority, 3 — sort by status.

**The reframe.** When the variants are just different values, the real design question is
usually one level up: *how does the user choose the value, and where is that choice
stored?* The decision is not "which value is right" but "this is a setting the user
controls" — and then: is it stored per user, per view, per session, or globally?

**Examples.**

- *Sort.* Variants each pick a different sort field. The real axis: sort is a setting the
  user chooses, not a default the designer hardcodes. The decision becomes where the sort
  preference lives (per saved view, say), not which field wins.
- *Filter.* Variants each apply a different filter rule. Same reframe: filtering is a
  user-controlled setting, and the real question is how filters are defined and persisted,
  not which single rule is correct.

When you hit this, stop generating value-variants. Surface the reframe to the human, and
re-aim the experiment at the real axis: the mechanism and its storage scope.

## Variants-that-differ-only-by-content: it is a renderer, not a design choice

**Trigger.** Your variants differ only by *which* entity or content shows up, not by *how*
anything is presented or behaves.

**The reframe.** Varying only the content means there is no design decision here — there
is a renderer or component that should be extracted to handle any of that content. The
work is abstraction, not comparison.

## Detection checklist

Before building a set of variants, sanity-check the axis against these. A "yes" to any
of them means stop and reframe before building:

- [ ] Is each variant just a different *value* of one property? → The axis is the
      mechanism for choosing and storing that value, not the value. (Variants-as-values.)
- [ ] Do the variants differ only by *which* content appears, not *how*? → This is a
      renderer to extract, not a design choice. (Variants-by-content.)
- [ ] Could the human reasonably want more than one of these at the same time? → It may
      be a configurable option, not an either/or decision.
- [ ] Would the "winner" change depending on the user, the data, or the context? → The
      real decision is who controls it and where the choice lives.

## Accept the reframe and rebuild

Across all of these, the action is the same: when the human reframes the axis, accept it
and rebuild the variants against the new axis. A rebuilt set after a reframe is the skill
working as intended. Do not treat the discarded variants as wasted — they are what
surfaced the real question.
