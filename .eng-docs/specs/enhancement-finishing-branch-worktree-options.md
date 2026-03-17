# Enhancement: Finishing branch with worktree-appropriate options

## Parent feature

*(Parent spec not yet created — mm:planning)*

## What

When the implementation handoff stage invokes `superpowers:finishing-a-development-branch`, it passes context that overrides the default option set when running inside a worktree. The prompt instructs the skill to present three options: push and create a PR (primary path), keep the worktree as-is to return later, or discard the work. "Merge locally" is excluded. Worktree cleanup is deferred until after the PR merges — the worktree is not deleted at push time.

## Why

`superpowers:finishing-a-development-branch` presents "merge locally" as a peer of "push and create a PR." In a worktree-based workflow, merging locally defeats the purpose of isolation. Because mm owns the invocation context, it can pass instructions that constrain the option set without modifying the superpowers skill directly.

## User stories

- Devon can finish work in a worktree and see only options that make sense for that context
- Devon can push and open a PR without being offered a local merge option
- Devon can keep the worktree intact after pushing so he can return before the PR merges
- Devon is not prompted to clean up the worktree until after the PR is merged

## Design changes

*(Added by design specs stage — frame as delta on the parent feature's design spec)*

## Technical changes

### Affected files

*(Populated during tech specs stage — list files that will change and why)*

### Changes

*(Added by tech specs stage — frame as delta on the parent feature's tech spec)*

## Task list

*(Added by task decomposition stage)*
