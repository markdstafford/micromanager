# Enhancement: Triage commits and pushes spec files

## Parent feature

`feature-github-issue-triage.md`

## What

After writing a spec file for a feature or enhancement during triage, the skill commits and pushes the file to the remote before creating the corresponding GitHub issue. Each spec file gets its own commit with a descriptive message. The push happens immediately after the commit so the file is available on the remote when the issue references it.

## Why

A spec file that exists only locally cannot be read by anyone else — including the GitHub issue that links to it. Without committing and pushing, the triage session produces issues with broken spec links and leaves planning artifacts in an uncommitted state that could be lost if the local environment is reset. Committing and pushing as part of triage makes the work durable and the links valid.

## User stories

- Devon can close his terminal after a triage session knowing all spec files are safely on the remote
- Petra can follow a spec link from a newly created issue and read the file immediately
- Any team member can clone the repo after a triage session and find all spec files present

## Design changes

*(Added by design specs stage — frame as delta on the parent feature's design spec)*

## Technical changes

### Affected files

*(Populated during tech specs stage — list files that will change and why)*

### Changes

*(Added by tech specs stage — frame as delta on the parent feature's tech spec)*

## Task list

*(Added by task decomposition stage)*
