# Cleanup

The lab is throwaway. Once the decisions and follow-ups are captured in the destination chosen during wrap-up (see `wrap-up.md`), remove it.

## What to delete

- All variant files and the throwaway directory they live in.
- The toggle that activated the lab — the route flag, hidden subcommand, env-var branch,
  or keybinding.
- Any fixture data created only for the lab.
- Lab-only config changes.

## What to preserve

- The decision summary or durable concept docs, in whatever destination the wrap-up step
  chose.
- Human-owned follow-ups, in the durable artifact or issue the wrap-up step chose.
- Anything the human explicitly asks to promote toward production. Promote it
  deliberately — rewrite or cherry-pick it into the real code on a proper branch, rather
  than leaving lab-shaped code behind. Lab code carries throwaway assumptions that should
  not graduate by accident.

## How to clean up

1. List exactly what you are about to delete, so the human can see it.
2. Confirm before deleting. Default to yes, but ask — the human may want to keep a
   variant around for reference.
3. Delete, and confirm the lab no longer activates (the toggle is gone, the system runs
   as it did before the lab).

A clean exit leaves the system exactly as it was before the lab, plus the captured decisions and any human-owned follow-ups.
