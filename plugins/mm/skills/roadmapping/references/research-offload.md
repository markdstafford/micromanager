# Offloading research

Roadmapping sometimes needs research that would flood the main conversation — surveying
how comparable products solve a problem, reading a large external spec, or mapping an
unfamiliar subsystem. Offload this to a sub-agent so the main session stays focused on
the human and the design.

## When to offload

- The research is read-heavy and would produce far more context than the decision needs.
- The question is well-scoped enough to delegate ("how do comparable tools handle saved
  views — grouping, filtering, sorting, layout, property visibility?").
- The answer is an input to the design, not the design itself.

## How to offload

Dispatch a research sub-agent with a precise question and the specific output you need
back — a short structured summary, not a transcript. Keep the main session interactive
with the human while the sub-agent works.

When the sub-agent returns, capture the distilled findings in `brainstorm.md` so the
decision they inform is traceable, then continue the conversation.

## What not to offload

- The goal and scope decisions in stage 1 — these require the human.
- Framing in stage 4 — naming and boundaries are the human-facing core of the skill.

Research informs these stages; it does not replace the human's role in them.
