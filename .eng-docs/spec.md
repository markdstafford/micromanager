---
created: 2026-04-10
last_updated: 2026-04-10
status: active
---

# micromanager

micromanager is a Claude Code plugin that gives developers a structured, collaborative
workflow for planning software development work. It guides users through writing product
requirements, architectural decision records, design specs, technical specs, and task
decomposition — with human-AI checkpoints at each step. The plugin also includes utilities
for issue triage, live feedback capture, and keeping planning artifacts current over time.
All artifacts are written to a versioned directory inside the project. The directory and
issue tracker integration are configurable via an `mm.toml` file at the repo root.

---

## Planning

The planning feature guides developers through a structured sequence: product requirements,
design spec, tech spec, task decomposition, and implementation handoff. Each stage produces
a durable artifact written to disk and reviewed section by section before moving forward.
Specs are always written to a feature branch — main is never touched. After the task list
is approved, the skill asks whether to continue to implementation, open a PR for the spec
only, or stay on the branch. Implementation handoff creates an isolated git worktree and
delegates to superpowers for execution.

**Spec:** `specs/feature-planning.md`

---

## Issue triage

The issue triage skill handles two entry points: processing existing unlabeled GitHub issues
and converting free-form feedback into tracked issues. In repo triage mode it fetches
unlabeled issues, explores the codebase to build context, rewrites each issue with a precise
title and enriched body, classifies by type and priority, and writes back to GitHub after
human approval. In feedback intake mode it accepts bullet lists, verbal notes, or friction
log files, teases apart distinct items, classifies them, checks for duplicates, and creates
individual GitHub issues — writing a spec file and committing it before creating the issue
for features and enhancements. After triage, the skill offers to route directly into the
appropriate planning workflow.

**Spec:** `specs/feature-github-issue-triage.md`

---

## Configuration

mm reads an optional config file at the repo root — `mm.toml`, `mm.yaml`, or `mm.json` in
that precedence order. Two settings are supported: `docs_root` sets the base directory for
all planning artifacts (default: `.eng-docs`), and `issue_tracker` sets the issue tracking
integration (default: `github`; `jira` is recognized but not yet implemented). All mm skills
read config at session start and use the resolved values throughout. Missing config or
unrecognized fields fall back to defaults silently, so existing projects continue to work
without any migration.

**Spec:** `specs/feature-mm-config.md`

---

## Gardening

The gardening skills keep planning artifacts accurate over time. `mm:update-wiki` scans the
codebase and proposes specific edits to wiki documents that have drifted from what is
actually implemented. `mm:update-spec` grooms the top-level `spec.md` by comparing it
against active feature specs and ADRs, proposing additions, removals, and link fixes.
`mm:update-specs` is the deep variant: it verifies each active detail spec against the
codebase, confirms before starting (the scan can take several minutes), proposes updates for
any specs with behavioral drift, then invokes `mm:update-spec` to bring `spec.md` in sync.
Nothing is written by any gardening skill without explicit human approval.

**Spec:** `specs/feature-mm-gardening.md`

---
