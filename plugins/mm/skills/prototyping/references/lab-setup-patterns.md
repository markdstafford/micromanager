# Lab setup patterns

The lab is throwaway scaffolding inside the running system that lets the human switch
between variants quickly. Build the lightest lab that lets you compare variants honestly
against the real system.

## Principles

- **Inside the real system.** Variants should run against the same tokens, styles, data
  shapes, and platform mechanics that production uses, so comparisons are honest. A
  variant that lies about the real environment produces a decision you cannot trust.
- **Quick toggle.** Switching between variants must be fast — a keypress or a flag, not a
  rebuild. Slow switching kills comparison.
- **Clearly throwaway.** Variants live in a clearly-named location that is obviously not
  production, so they are easy to find and delete later.

## Patterns by surface

- **Web / desktop UI** — a dev-only route or view, gated by a query flag or env var.
  Numeric keys switch variants. Variant components live in a dedicated throwaway
  directory and import only existing tokens and shared primitives.
- **CLI** — a hidden subcommand or a flag that selects the variant behavior. Each variant
  is a separate handler behind the selector.
- **API / service** — a variant route or a header/flag that selects the implementation.
  Each variant is isolated behind the selector so none leaks into the real routes.
- **Architecture / data model** — a small spike that exercises each variant against
  realistic data, with the variant selected by config. The goal is to feel the tradeoff,
  not to ship the spike.

## Worked example — web UI lab

A lab for comparing row layouts in a list view, gated by a query flag, variants switched
by number keys:

```
src/lab/                         # clearly-not-production; deleted at wrap-up
  README.md                      # what this is, how to enter, that it's throwaway
  Lab.tsx                        # reads ?lab=1, switches variant by number key 1..N
  registry.ts                    # [{ id, name, Component }]
  fixtures.ts                    # realistic fixture data, shaped like production
  variants/
    1-single-line.tsx
    2-two-line.tsx
    3-card.tsx
```

- `Lab.tsx` mounts only when the flag is present; the real app is untouched otherwise.
- Each variant imports the real design tokens and shared primitives — no bespoke
  styling — so what the human sees is what production will feel like.
- One variant per file keeps them independent: deleting a loser touches nothing else.

The same shape maps to other surfaces: a `--lab=2` flag selecting a CLI handler, a
`?lab=2` route selecting a service implementation, a config key selecting a data-model
spike.

## Keep it honest and disposable

- Use real fixture data shaped like production data.
- Do not wire the lab into real persistence, routing, or side effects.
- Keep each variant self-contained so it can be deleted without touching the others.
- Expect to delete all of it at wrap-up. Anything worth keeping is promoted deliberately,
  not left behind in the lab.
