# Autocatalyst adaptation

Roadmapping runs the same way inside an autocatalyst workspace, with two adjustments.

## Detecting the environment

You are in an autocatalyst workspace if the working path is under an autocatalyst
workspaces directory (for example, a path containing `.autocatalyst/workspaces/`). When
in doubt, check whether the session was started by autocatalyst rather than directly by
the human.

## Adjustment 1 — no self-worktree

An autocatalyst workspace is already isolated. Do **not** create your own git worktree
or invoke `superpowers:using-git-worktrees`. Work in the provided workspace.

## Adjustment 2 — same artifact destinations

Artifact destinations do not change:

- Durable docs → `{docs_root}/concepts/` (committed).
- Ephemeral docs → `{docs_root}/notes/<roadmap-name>/` (gitignored).

## Hand-off

The issues you file in stage 5 are the hand-off. When autocatalyst later picks up an
issue, it generates a per-issue implementation session from the issue body — which is
the session-prep doc you wrote. Make sure each session-prep doc stands alone: it must
include the slice description, a link to the relevant `concepts/` doc, build steps,
acceptance criteria, and dependencies, so the implementing session can act without the
roadmapping conversation's context.
