# Enhancement: Planning creates issue before handoff

## Parent feature

*(Parent spec not yet created — mm:planning)*

## What

Before routing to implementation handoff, the planning workflow checks whether a GitHub issue exists for the feature or enhancement being implemented. If one does not exist, the skill creates it — with a summary of the what and why, and a link to the spec file as the authoritative task list. The issue number is then used as the tracking artifact throughout implementation.

## Why

Features and enhancements planned through CAF can reach implementation without ever having a GitHub issue. This means there is no tracking artifact visible to the team, no way to link PRs or commits to the work, and no record of what was built and why. Creating the issue at handoff time closes this gap without requiring a separate manual step.

## User stories

- Devon can start implementation knowing a GitHub issue exists to track the work
- Devon can link his PR to a GitHub issue without having to create one manually
- Petra can see all in-progress features as open GitHub issues without checking the specs folder
- An AI agent handed an implementation task can find the tracking issue by number

## Design changes

*(Added by design specs stage — frame as delta on the parent feature's design spec)*

## Technical changes

### Affected files

*(Populated during tech specs stage — list files that will change and why)*

### Changes

*(Added by tech specs stage — frame as delta on the parent feature's tech spec)*

## Task list

*(Added by task decomposition stage)*
