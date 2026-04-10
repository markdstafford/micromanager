---
created: 2026-04-10
last_updated: 2026-04-10
status: complete
issue: 40
specced_by: markdstafford
implemented_by: markdstafford
superseded_by: null
---

# mm configuration

## What

mm supports an optional config file at the repo root. Teams can set a custom directory for planning artifacts and choose which issue tracker mm integrates with. Defaults are provided for both settings, so the config file is only needed when the defaults don't fit.

## Why

Different teams have different conventions — a monorepo might put engineering docs somewhere other than `.eng-docs`, and not every team uses GitHub for issue tracking. Without a config surface, mm works only for teams whose setup matches the defaults, and everyone else has to fork the skills or work around the hardcoded paths. With config support, mm fits into an existing project without requiring any changes to the project's structure.

## Personas

- **Sam: Software engineer on a small team** — her team uses Jira and stores docs outside `.eng-docs`; she needs config support to adopt mm without restructuring the project

## Narratives

### Sam adopts mm on her team's monorepo

Sam's team wants to try mm, but their monorepo already has a `docs/` directory where engineering artifacts live, and they track everything in Jira. She adds an `mm.toml` to the repo root with two lines: `docs_root = "docs/mm"` and `issue_tracker = "jira"`. She invokes `mm:planning` and the skill writes the first spec to `docs/mm/specs/` without prompting her to reconfigure anything. When the spec is ready to track, mm creates a Jira ticket instead of a GitHub issue. The rest of the team installs mm and gets the same behavior from day one, with no coordination required.

## User stories

- Sam can add an `mm.toml`, `mm.yaml`, or `mm.json` to the repo root to configure mm without editing any skill files
- Sam can set `docs_root` to redirect all mm artifact output to a custom directory
- Sam can set `issue_tracker` to `jira` so mm creates Jira tickets instead of GitHub issues
- Sam can omit the config file entirely and get the existing default behavior unchanged

## Goals

- All mm skills read config at session start and use `docs_root` and `issue_tracker` values throughout
- No skill file edits are required to change `docs_root` or `issue_tracker`
- Missing config file or unrecognized fields produce no errors and fall back to defaults
- Config format is valid TOML, YAML, or JSON; `mm.toml` takes precedence if multiple files exist

## Non-goals

- Jira integration implementation (the `issue_tracker` setting is defined and validated, but Jira support ships separately)
- Per-user config (config is per-repo only)
- GUI or CLI for editing config (users edit the file directly)

## Design spec

*(Not applicable — configuration is not a UI feature)*

## Tech spec

### Config resolution

At session start, look for `mm.toml`, `mm.yaml`, or `mm.json` at the repo root (in that precedence order). Parse the file and extract:

- `docs_root` (default: `.eng-docs`) — base directory for all mm artifact output
- `issue_tracker` (default: `github`; valid values: `github`, `jira`) — issue tracking integration

Missing config file or unrecognized fields produce no errors; fall back to defaults silently.

### Affected files

- `plugins/mm/skills/planning/SKILL.md` — read config at session start; resolve `docs_root` and use it for all artifact paths throughout the session
- `plugins/mm/skills/planning/references/stages/product-requirements.md` — replace `.eng-docs` with `{docs_root}` in spec and backlog paths
- `plugins/mm/skills/planning/references/stages/enhancements.md` — replace `.eng-docs` with `{docs_root}` in enhancement spec paths
- `plugins/mm/skills/planning/references/stages/implementation-handoff.md` — replace `.eng-docs` with `{docs_root}` in spec paths and superpowers plan path
- `plugins/mm/skills/planning/references/stages/adrs.md` — replace `.eng-docs` with `{docs_root}` in ADR paths (lines 22, 35, 84)
- `plugins/mm/skills/planning/references/stages/tech-specs.md` — replace `.eng-docs` with `{docs_root}` in wiki paths
- `plugins/mm/skills/friction-log/SKILL.md` — replace `.eng-docs` with `{docs_root}` in friction log output path
- `plugins/mm/skills/issue-triage/SKILL.md` — replace `.eng-docs` with `{docs_root}` in friction log and spec paths; use `issue_tracker` to route issue creation

### Changes

The mechanical change across all stage files is the same: replace every `.eng-docs` literal with the `docs_root` value resolved at session start. The only file with real logic is `SKILL.md`, which owns config resolution and passes the resolved values into the session context used by all stages.

## Task list

**Story 1: Config resolution**
- [ ] Add config resolution logic to `SKILL.md`: detect `mm.toml` / `mm.yaml` / `mm.json` at repo root (toml > yaml > json), extract `docs_root` and `issue_tracker`, fall back to defaults if absent
  - Acceptance: running mm with no config file produces the same behavior as today; running with a config file uses the specified values

**Story 2: Apply `docs_root` across planning stages**
- [ ] Update `planning/SKILL.md` artifact paths
- [ ] Update `product-requirements.md` artifact paths
- [ ] Update `enhancements.md` artifact paths
- [ ] Update `implementation-handoff.md` artifact paths
- [ ] Update `adrs.md` artifact paths
- [ ] Update `tech-specs.md` artifact paths
  - Acceptance: all spec and ADR files land in `{docs_root}/...` when a custom `docs_root` is set

**Story 3: Apply `docs_root` across utility skills**
- [ ] Update `friction-log/SKILL.md` artifact paths
- [ ] Update `issue-triage/SKILL.md` artifact and friction log paths
  - Acceptance: friction logs and triage output land in `{docs_root}/...` when a custom `docs_root` is set

**Story 4: Apply `issue_tracker` routing**
- [ ] Update `issue-triage/SKILL.md` to route issue creation based on `issue_tracker` value; `github` uses existing `gh` CLI flow; `jira` is a stub that logs "Jira integration not yet implemented"
  - Acceptance: `issue_tracker = "github"` produces current behavior; `issue_tracker = "jira"` produces a clear not-implemented message rather than silently failing
