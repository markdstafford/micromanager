# Lab setup patterns

The lab is throwaway scaffolding inside the running system that lets the human switch
between variants quickly. Build the lightest lab that lets you compare variants honestly
against the real system.

## Principles

- **Inside the real system.** Variants should run against the same tokens, styles, data
  shapes, and platform mechanics that production uses, so comparisons are honest. A
  variant that lies about the real environment produces a decision you cannot trust.
- **Active labs open directly.** During an active prototyping session, launch into the
  experiment by default. The shortcut or affordance is the escape hatch back to the
  normal app, not the only way into the lab. If the host cannot safely open directly
  into a lab, make the entry point explicit in the launch command, URL, or first visible
  instruction so the human never has to remember an undocumented shortcut.
- **Chrome recedes.** Lab controls must be discoverable but unobtrusive. Put persistent
  controls in a consistent recessed location by default, such as the upper-right for
  visual surfaces, and keep them out of the experiment's visual hierarchy. The controls
  should read as lab furniture, not as part of the variant under test.
- **Framing is dismissable.** Put the experiment title, axis, per-variant explanations,
  why each variant was chosen, and pros/tradeoffs in a modal, popover, side panel, or
  equivalent dismissable surface with enough room. Do not use a persistent header band
  that competes visually with the experiment.
- **Shortcuts are stable and checked.** Use `1..N` as the default variant-switch
  convention. Before binding keys, inspect the host app's documented shortcuts,
  obvious browser/OS shortcuts, and existing lab or development shortcuts; ask the
  human when collisions are unclear. For CLI, API, architecture, and data-model labs,
  map this check to existing flags, routes, headers, config keys, scripts, or command
  names before choosing the lab selector.
- **Visible identity matches the gesture.** If the key, flag, route, or config value is
  `1`, the visible variant label starts with `1`. Do not label the same variant as `A`
  in one place and `1` somewhere else. Pair the stable selector with a descriptive name,
  such as `1 — attached titlebar`.
- **Clearly throwaway means isolated and disposable.** Variants live in an isolated
  workspace first, then in a clearly named location inside that workspace that is
  obviously not production. A directory such as `src/lab/` makes cleanup easy, but it is
  not sufficient by itself if creating it would dirty the human's active checkout. Regardless, before
  choosing paths, check repository conventions for existing `proto/`, `spike/`, lab, or
  branch/workspace naming patterns and follow them when they exist.

## Patterns by surface

- **Web / desktop UI** — a dev-only route, view, query flag, or env var that opens the
  active lab directly while the session is running. Use `1..N` to switch variants after
  checking host shortcuts. Keep persistent controls recessed in the upper-right by
  default, with details in a dismissable modal or equivalent surface. Variant components
  live in a dedicated throwaway directory and import only existing tokens and shared
  primitives.
- **CLI** — a dev-only subcommand or explicit flag that opens the active lab directly,
  plus `1..N` selector values when interactive switching is available. Check existing
  flags, subcommands, shell aliases documented by the project, and common terminal
  control keys before choosing selectors. Show variant labels as `1 — <name>` in help
  text and prompts.
- **API / service** — a variant route, header, query parameter, or config value that
  selects the implementation. Check existing route, header, query, and config names
  before choosing selectors. Expose labels as `1 — <name>` in logs, response metadata,
  or the run sheet so the selector and visible identity match.
- **Architecture / data model** — a small spike that exercises each variant against
  realistic data, with the variant selected by config, script argument, or fixture name.
  Check existing config keys, scripts, and fixture names before choosing selectors. The
  goal is to feel the tradeoff, not to ship the spike.

## Worked example — web UI lab

A lab for comparing row layouts in a list view. This `src/lab/` directory is inside the
already isolated prototyping workspace; it is not a substitute for workspace isolation.
The active prototyping launch command or URL opens the lab directly, variants switch with
checked `1..N` shortcuts, and lab chrome stays recessed while details live in a
dismissable modal:

```text
src/lab/                         # clearly-not-production; deleted at wrap-up
  README.md                      # what this is, how to launch, that it's throwaway
  Lab.tsx                        # active lab shell; 1..N keys switch variants
  LabChrome.tsx                  # upper-right recessed controls + details modal
  registry.ts                    # [{ shortcut, name, summary, tradeoffs, Component }]
  fixtures.ts                    # realistic fixture data, shaped like production
  variants/
    1-single-line.tsx
    2-two-line.tsx
    3-card.tsx
```

- Launch the active session directly into `Lab.tsx`. If safety requires a gate, make it
  explicit in the command or URL, such as `npm run dev -- --lab=row-layout` or
  `/orders?lab=row-layout`, instead of relying on a memorized hidden entry shortcut.
- Before binding `1`, `2`, and `3`, check the host app's shortcut map and obvious
  browser/OS collisions. If a collision exists, choose the nearest non-conflicting
  selector and make the visible label match it.
- `LabChrome.tsx` keeps persistent lab controls discoverable but unobtrusive in the
  upper-right by default: current variant, compact switcher, details button, and exit
  control. It should be visually recessed and must not look like part of any variant.
- The details button opens a dismissable modal with the experiment title, axis, what is
  held constant, each variant's explanation, why it was chosen, and pros/tradeoffs.
- `registry.ts` owns the selector-visible identity so labels match shortcuts everywhere:

```ts
export const variants = [
  {
    shortcut: "1",
    name: "single-line",
    summary: "Keeps every row compact for fast scanning.",
    tradeoffs: "Lowest height, but secondary metadata has less room.",
    Component: SingleLineVariant,
  },
  {
    shortcut: "2",
    name: "two-line",
    summary: "Gives title and metadata separate rows.",
    tradeoffs: "More readable metadata, but fewer items fit above the fold.",
    Component: TwoLineVariant,
  },
  {
    shortcut: "3",
    name: "card",
    summary: "Groups row content in a larger card-like surface.",
    tradeoffs: "Strong separation between records, but the list feels heavier.",
    Component: CardVariant,
  },
];
```

- Present labels from the registry as `1 — single-line`, `2 — two-line`, and `3 — card`
  in chrome, modal content, logs, and spoken/written instructions.
- Each variant imports the real design tokens and shared primitives — no bespoke styling
  — so what the human sees is what production will feel like.
- One variant per file keeps them independent: deleting a loser touches nothing else.

The same shape maps to other surfaces: a `--lab=row-layout --variant=2` flag selecting a
CLI handler, a `?lab=row-layout&variant=2` route selecting a service implementation, or
a config key selecting a data-model spike. In each case, the selector is checked for
collisions, shown in the label, and documented as the direct entry path for the active
session.

## Keep it honest and disposable

- Confirm the workspace is isolated before the first lab write. In Autocatalyst-managed
  runs, use the provided workspace and do not create another worktree or switch branches.
- Use real fixture data shaped like production data.
- Do not wire the lab into real persistence, routing, or side effects.
- Keep each variant self-contained so it can be deleted without touching the others.
- Keep the lab path easy to remove, such as `src/lab/`, `proto/<topic>/`, or the
  repository's existing spike location, inside the isolated workspace.
- Expect to delete all of it at wrap-up. Anything worth keeping is promoted deliberately,
  not left behind in the lab.
