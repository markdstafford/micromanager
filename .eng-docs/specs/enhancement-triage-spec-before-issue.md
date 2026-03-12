# Enhancement: Triage writes spec file before creating issue

## Parent feature

`feature-github-issue-triage.md`

## What

For features and enhancements, the triage skill writes the spec file before creating the GitHub issue. The issue is created last, using the spec filename as a reference link in the issue body. This means the issue always points to a file that already exists on the remote at the time the issue is created.

## Why

If the issue is created before the spec file is committed and pushed, the spec link in the issue body points to a file that does not yet exist on the remote. Anyone reading the issue immediately after triage finds a broken reference. Writing the spec first and pushing it before issue creation ensures the link is valid from the moment the issue is opened.

## User stories

- Devon can open a newly triaged issue and follow the spec link immediately
- Petra can see a valid spec reference in every feature or enhancement issue from the moment it is created
- An AI agent reading the issue can fetch the spec file without encountering a 404

## Design changes

*(Added by design specs stage — frame as delta on the parent feature's design spec)*

## Technical changes

### Affected files

*(Populated during tech specs stage — list files that will change and why)*

### Changes

*(Added by tech specs stage — frame as delta on the parent feature's tech spec)*

## Task list

*(Added by task decomposition stage)*
