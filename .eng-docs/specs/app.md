---
created: 2026-03-16
last_updated: 2026-03-16
---

# micromanager

## What

micromanager is a Claude Code plugin that gives developers a structured, collaborative workflow for planning software development work. It guides users through writing product requirements, architectural decision records, design specs, technical specs, and task decomposition — with human-AI checkpoints at each step to keep the work grounded and reviewed before moving forward. The plugin also includes utilities for issue triage and live usability feedback capture.

The plugin is distributed as a git repository and installed into Claude Code, where its skills become available as first-class commands in any development session. All planning artifacts are written to disk in a structured `.eng-docs/` directory inside the project, creating a durable, version-controlled record of every decision made during development.

## Why

Software development planning is often ad hoc — requirements live in chat threads, architecture decisions are made verbally, and the reasoning behind technical choices disappears as soon as the conversation ends. Without a consistent structure for capturing this work, teams and individual developers lose context, revisit settled decisions, and ship features that don't match original intent.

micromanager gives developers a repeatable process for turning a vague idea into a well-specified, ready-to-implement plan — with the reasoning preserved at every step. Because the workflow runs inside Claude Code, planning happens in the same environment as development, reducing the friction of context-switching and making it natural to keep specs up to date as the work evolves.

## Personas

- **Mark: Solo developer** — a developer who works primarily alone, using Claude Code as an AI pair programmer, and wants a structured process to plan features without losing the reasoning behind decisions
- **Perry: Plugin author** — a developer who builds and maintains Claude Code plugins, needing to specify, version, and evolve plugin capabilities over time
- **Sam: Software engineer on a small team** — an engineer who collaborates with a few teammates, using micromanager to produce specs that are clear enough for others to review and implement

## Narratives

### Planning a new feature

Sam's team decides to add export functionality to their app — users should be able to download their data as a CSV. She opens her project in Claude Code and invokes `mm:planning`. The skill asks her a few questions about the feature: what it does, why it matters, and who it's for. Sam describes the use case in a couple of sentences; the skill drafts the What and Why sections and presents them for her review. She tightens a phrase or two, approves, and they move through personas and user stories together.

With requirements locked, the skill routes Sam to the design spec stage. She and Claude work through the user flow — where the export button lives, what happens when the export is large, how errors surface — and the decisions land in a design spec file in her `.eng-docs/` directory. The tech spec stage follows: the skill proposes the implementation approach, surfaces a data-format decision worth recording as an ADR, and produces a list of affected files with a rationale for each change. Sam reviews and approves.

Finally, the skill decomposes the approved tech spec into a task list — stories grouping leaf tasks, each with acceptance criteria and dependencies. Sam hands the tasks off to a separate implementation session, confident that the plan is complete, version-controlled, and ready to execute without needing to reconstruct context from memory.

### From friction to fixed bugs

Mark is doing a live walkthrough of his app when he notices two rough edges: the confirmation dialog has confusing copy, and a filter control resets unexpectedly on navigation. Rather than filing issues from memory later, he invokes `mm:friction-log` mid-session and starts narrating what he's seeing. The skill captures each observation as a structured log entry — what happened, what he expected, and how jarring it felt — without interrupting his flow.

When the session ends, Mark invokes `mm:issue-triage` and points it at the friction log. The skill reads each entry, enriches it with code context by tracing the relevant files, and drafts a GitHub issue for each bug: a clear title, a detailed description with reproduction steps, and a severity classification. Mark reviews the two proposed issues, adjusts the priority on one, and approves. The issues are written to GitHub.

With the issues open, Mark asks the skill to route one of them into the planning workflow. It uses the abbreviated bug triage process — root cause analysis, affected files, and a focused task list — rather than the full feature planning flow. Within minutes he has a scoped implementation plan for each bug, and he hands them off to separate implementation sessions to fix in parallel.

## Related features

### Planning

- **Requirements** — collaborative product requirements for apps and features, with personas, narratives, and user stories
- **Enhancement specs** — delta-framed requirements for improvements to existing features
- **ADRs** — architectural decision records for significant technology and design choices
- **Design specs** — user flows and UI component design for features with UI elements
- **Tech specs** — architecture, API design, data models, and implementation plans
- **Task decomposition** — hierarchical task breakdown with acceptance criteria and dependencies
- **Implementation handoff** — routes approved task lists to implementation systems

### Issue management

- **Issue triage** — enriches, classifies, and writes GitHub issues from raw feedback or friction logs
- **Friction log** — captures live usability observations during a testing session for later triage
