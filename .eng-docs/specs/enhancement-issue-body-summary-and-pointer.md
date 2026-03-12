# Enhancement: Issue body contains summary and spec pointer, not task decompositions

## Parent feature

`feature-github-issue-triage.md`

## What

GitHub issues created for features and enhancements contain a concise summary of the what and why, plus a link to the spec file as the authoritative task list. They do not contain task decompositions. The spec file is the single source of truth for planned work; the issue is the stable tracking artifact that links commits, PRs, and discussions to that work.

## Why

When issues contain task decompositions they become a second copy of information that already lives in the spec file. The two copies diverge over time, neither is clearly authoritative, and the issue becomes too large to read as a summary. Keeping the issue as a lightweight pointer preserves its value as a tracking artifact while making the spec the unambiguous home for implementation detail.

## User stories

- Devon can read a feature or enhancement issue and understand what it is and why it matters in under a minute
- Devon can find the full task list by following the spec link in the issue
- Petra can scan open issues without wading through implementation detail
- An AI agent can locate the authoritative task list from the issue without searching the filesystem

## Design changes

*(Added by design specs stage — frame as delta on the parent feature's design spec)*

## Technical changes

### Affected files

*(Populated during tech specs stage — list files that will change and why)*

### Changes

*(Added by tech specs stage — frame as delta on the parent feature's tech spec)*

## Task list

*(Added by task decomposition stage)*
