---
created: 2026-04-10
last_updated: 2026-04-10
status: implementing
issue: 39
specced_by: markdstafford
implemented_by: markdstafford
superseded_by: null
---

# Enhancement: planning impl intent

## Parent feature

`specs/feature-planning.md`

## What

At the start of every planning session, the planning skill creates a feature branch and writes all spec content there. Main is never touched. After the final spec section is approved, the skill asks what to do next: continue to implementation (sets up the worktree and hands off), open a PR for the spec only, or stay on the branch.

## Why

When a user plans and implements in one session, the current workflow writes the spec to main and creates the worktree separately — leaving no clean path forward. Moving the spec after the fact requires manual file moves and an awkward decision: open a PR for just the spec, or carry uncommitted work into the implementation worktree. Always writing the spec to a branch, and asking what to do at the end, eliminates the awkward handoff entirely.

## User stories

- Mark can finish a spec and immediately continue to implementation, with the worktree set up from the same branch the spec was written on
- Sam can finish a spec and open a PR for it without any manual branch setup, because the spec is already on a feature branch
- Mark can finish a spec and leave it on the branch to return to later, with no action required

## Design changes

*(Not applicable — no UI changes)*

## Technical changes

### Affected files

- `plugins/mm/skills/planning/SKILL.md` — create a branch before handing off to any stage; add post-approval prompt
- `plugins/mm/skills/planning/references/stages/implementation-handoff.md` — create worktree from the existing branch rather than creating a new branch

### Changes

In `SKILL.md`, after the stage is identified but before handing off, add:

> Create a branch named for the feature/enhancement (e.g. `feat/[short-name]`) and check it out. All spec content is written here. Main is never touched.

After the final spec section is approved, ask:

> "Spec approved. What next?
> a. Continue to implementation — I'll set up the worktree and hand off
> b. Open a PR for the spec only
> c. Stay on the branch — nothing more needed now"

Route accordingly:
- **a** → invoke `superpowers:using-git-worktrees` from the existing branch (no new branch needed), then proceed with implementation handoff as normal
- **b** → create a PR from the spec branch
- **c** → do nothing; confirm the branch name so the user can return to it later

In `implementation-handoff.md`, step 5, add a guard:

> If the spec was written on a feature branch (i.e. planning was invoked with this enhancement), create the worktree from that branch rather than creating a new one.

## Task list

*(Added by task decomposition stage)*
