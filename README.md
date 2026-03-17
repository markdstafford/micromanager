# micromanager

An opinionated planning workflow for developers who build with AI.

> You do the thinking. The agent does the writing.

## What it is

micromanager is a plugin that walks you through planning software work — from requirements to design to technical spec to task list — with a human checkpoint at each step. Every decision gets written to disk as a versioned artifact in your repo, so future sessions (and future you) have full context without reconstructing it from memory.

It exists to make planning intentional and durable. Without structure, requirements live in chat threads, architectural decisions happen in passing, and context resets with every session. micromanager replaces that with a repeatable process and a permanent record.

## What it looks like

You're adding a new feature. You invoke `mm:planning`. The skill leads you through requirements — it drafts the What and Why, presents them for your review, and waits for your sign-off before moving forward. You shape the thinking; the agent does the writing. Nothing advances without your approval.

The skill routes you through design, then a technical spec, then a task list broken into stories with acceptance criteria. Each step builds on the last. When the session ends, the plan lives in `.eng-docs/` alongside your code — versioned, reviewable, and ready to hand off without reconstructing anything from memory.

## Skills

**`mm:planning`** — guides you from a vague idea to an approved task list. Covers requirements, ADRs, design specs, tech specs, and task decomposition, with a checkpoint at every stage.

**`mm:issue-triage`** — takes raw feedback or a friction log, enriches each item with code context, and writes GitHub issues. Classifies by type and priority; routes bugs and features into the planning workflow.

**`mm:friction-log`** — captures live usability observations during a testing session. Invoke it mid-walkthrough to log what you're seeing without breaking your flow. Feed the log to `mm:issue-triage` when you're done.

**`mm:writing-guidelines`** — style guidance for planning artifacts. Invoked automatically by other skills; also available standalone when drafting requirements or specs.

## Installation

**Claude Code**

In Claude Code, run `/plugin` and add this repository as a marketplace source:

```
https://github.com/markdstafford/micromanager
```

The `mm:` skills will be available immediately in any project.

**Codex**

Codex does not load Claude plugins directly. Install the underlying skills into `~/.codex/skills`, then restart Codex:

```bash
mkdir -p ~/.codex/skills
ln -s ~/git/coding-agent-flow/plugins/mm/skills/planning ~/.codex/skills/planning
ln -s ~/git/coding-agent-flow/plugins/mm/skills/issue-triage ~/.codex/skills/issue-triage
ln -s ~/git/coding-agent-flow/plugins/mm/skills/friction-log ~/.codex/skills/friction-log
ln -s ~/git/coding-agent-flow/plugins/mm/skills/writing-guidelines ~/.codex/skills/writing-guidelines
```

After restarting Codex, invoke `planning`, `issue-triage`, `friction-log`, or `writing-guidelines` directly.
