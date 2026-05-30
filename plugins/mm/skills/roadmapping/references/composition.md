# Composition with prototyping

Roadmapping and `mm:prototyping` compose. Roadmapping calls prototyping in stage 3 when
the feature set has open design questions worth comparing. Prototyping also runs
standalone, outside any roadmap.

## When roadmapping invokes prototyping

Invoke `mm:prototyping` from stage 3 when one or more decisions in the feature set have
several plausible options and comparing them live would produce a better answer than
arguing them in the abstract. This applies to any kind of decision — visual, UX, CLI,
API, architecture, or data model.

Skip prototyping when the decisions are already settled enough to name and write down in
framing.

## The hand-off back

When `mm:prototyping` runs **inside** roadmapping, it does not write its own output doc
and does not ask the human where decisions should land. Instead it returns its locked-in
decisions to roadmapping. You fold those decisions into stage 4 (framing) and they
become part of the durable `concepts/` docs.

This is the one behavioral difference for prototyping when composed: standalone
prototyping asks where its decisions land; composed prototyping hands them back to the
parent. See the wrap-up section of `mm:prototyping`.

## Roadmapping does not require prototyping

Stage 3 is a decision, not a mandate. If the architecture is clear, go straight from
brainstorm (stage 2) to framing (stage 4). Prototyping is a tool for resolving open
questions, not a required step.
