---
created: 2026-04-19
last_updated: 2026-04-20
status: approved
issue: 54
specced_by: markdstafford
implemented_by: null
superseded_by: null
---
# Enhancement: waitForApprovalBefore

## Parent feature

`feature-planning.md` — the planning workflow that guides users through requirements, design, tech spec, and task decomposition. This enhancement also builds on the config infrastructure established in `feature-mm-config.md`.
## What

mm gains an optional `waitForApprovalBefore` array in `mm.toml` that lists section and stage keys where the planning workflow should stop and request explicit human approval before continuing. When configured, mm works through all sections preceding each pause gate as a single batch — presenting them together at the end of the batch rather than stopping after every individual section. For example, `waitForApprovalBefore = ["tech", "taskList"]` causes mm to work through requirements (what, why, user stories, etc.) autonomously, pause before beginning the tech spec, and pause again before beginning task decomposition. Users who omit `waitForApprovalBefore` entirely get the existing per-section checkpoint behavior unchanged.
## Why

The current per-section checkpoint model is the right default: it keeps humans in the loop at every step. But teams that run planning sessions repeatedly, or that have strong mental models for requirements writing, find the constant stop-and-approve cadence slows them down on early sections they could review in bulk. Without a way to configure pause gates, there is no way to tell mm "move quickly through requirements, but stop before you write any technical decisions." The `waitForApprovalBefore` setting addresses this directly: it makes the checkpoint density configurable so the planning workflow matches how teams actually want to review — fast where decisions are low-stakes, deliberate where they matter most.
## User stories

- Mark can add `waitForApprovalBefore = ["tech", "taskList"]` to `mm.toml` so mm works through requirements autonomously and only pauses before the tech spec and task list stages
- Mark can omit `waitForApprovalBefore` entirely and get the existing per-section checkpoint behavior unchanged
- Mark can see a consolidated summary of all completed sections when mm pauses at a gate, so he can review the batch output before approving
## Design changes

*(Not applicable — this enhancement does not affect UI)*
## Technical changes

### Canonical section keys

The following keys are valid values for `waitForApprovalBefore`. They map to specific pause points in the planning workflow:

Key
Pauses before
Applies to

`what`
What section
Feature requirements, enhancements

`why`
Why section
Feature requirements, enhancements

`personas`
Personas section
Feature requirements only

`narratives`
Narratives section
Feature requirements only

`userStories`
User stories section
Feature requirements, enhancements

`goals`
Goals/Non-goals section
Feature requirements only

`design`
Design spec stage
All workflows

`tech`
Tech spec stage
All workflows

`taskList`
Task decomposition stage
All workflows

Unknown keys are silently ignored. Keys that don't apply to the current workflow (e.g., `personas` in an enhancement spec) pause at the next applicable section in the workflow sequence rather than being skipped entirely. For example, `["why", "personas"]` in an enhancement spec pauses before `why` and before `userStories` (the next applicable key after `personas` in the requirements sequence).
### Pause gate behavior

When `waitForApprovalBefore` contains one or more keys, the workflow operates in **batch mode** between gates:
1. **Batch processing** — Between pause gates, mm works through each section in prescribed order without stopping for individual human approval. Each section is drafted sequentially so that later sections can build on earlier ones — the prescribed order is always preserved; only the human approval checkpoints are consolidated at the gate.
2. **Gate presentation** — When the workflow reaches a section or stage whose key is in `waitForApprovalBefore`, it:
	- Presents all work completed in the current batch (all sections drafted since the last gate, or since the start if this is the first gate)
	- Displays the message: "I've completed \[section list\]. Review above and reply **continue** to proceed to \[next stage\]."
	- Stops. Does not proceed until the human explicitly replies with "continue" or equivalent affirmative.
3. **No-config default** — When `waitForApprovalBefore` is absent or empty (`[]`), the existing per-section checkpoint behavior is unchanged. No existing sessions are affected.
4. **Rework within batches** — If the human provides feedback on a batch (requests changes to a section), mm revises the relevant sections and re-presents the full batch before proceeding to the next gate.
5. **Unknown or inapplicable keys** — Keys not in the canonical list are silently ignored. Keys not applicable to the current workflow type trigger a pause at the next applicable section in the sequence instead.
### Affected files

- `mm.toml` (project config) — add `waitForApprovalBefore` optional array field
- `plugins/mm/hooks/session-start.sh` — parse `waitForApprovalBefore` array and inject into session context as `{waitForApprovalBefore}`
- `plugins/mm/skills/planning/SKILL.md` — add **Pause gates** section documenting the model, canonical key table, and batch processing behavior; instruct the AI to check `{waitForApprovalBefore}` at every stage transition
- `plugins/mm/skills/planning/references/stages/product-requirements.md` — add autonomous-batch behavior when `{waitForApprovalBefore}` is set; add inline pause gate check at each section: `what`, `why`, `personas`, `narratives`, `userStories`, `goals`
- `plugins/mm/skills/planning/references/stages/enhancements.md` — same treatment for `what`, `why`, `userStories`
- `plugins/mm/skills/planning/references/stages/design-specs.md` — add pause gate check for key `design` at stage entry
- `plugins/mm/skills/planning/references/stages/tech-specs.md` — add pause gate check for key `tech` at stage entry
- `plugins/mm/skills/planning/references/stages/task-decomposition.md` — add pause gate check for key `taskList` at stage entry
### Changes

#### Config schema — `mm.toml`

Add one new optional field:
```toml
# Optional: pause for explicit approval before these sections/stages.

# Valid keys: what, why, personas, narratives, userStories, goals,

#             design, tech, taskList

waitForApprovalBefore = ["tech", "taskList"]
```
Default when absent: `[]` (no pause gates; existing per-section checkpoint behavior applies).
#### `session-start.sh`

The hook already parses `mm.toml` and injects `docs_root` and `issue_tracker`. Extend it to:
1. Parse `waitForApprovalBefore` as an array of strings. TOML array syntax: `waitForApprovalBefore = ["tech", "taskList"]`. Default to empty array if key absent.
2. Serialize the parsed array into the injected `additionalContext` string alongside existing config values, e.g.:
	```javascript
mm config: docs_root=".eng-docs", issue_tracker="github", waitForApprovalBefore=["tech","taskList"]
	```
3. Warn (but do not error) on unrecognized keys. No validation is required at parse time beyond extracting the string values.
TOML array parsing in bash requires careful handling. A regex-based approach extracts the bracketed value and splits on commas. The existing `parse_toml_value` helper handles scalar values only and must be extended or supplemented for array parsing.
#### `plugins/mm/skills/planning/SKILL.md` — new **Pause gates** section

Add after the existing **Section-by-section checkpoints** shared concept:
```markdown
### Pause gates

If `{waitForApprovalBefore}` is set and non-empty, the workflow uses **batch mode** instead of per-section checkpoints. Between pause gates, draft each section in order — each section builds on the ones before it — and move to the next without stopping for human approval. At a pause gate:

1. Present all sections completed in the current batch as a single consolidated output.
2. Stop with the message: "I've completed [section list]. Review above and reply **continue** to proceed to [next stage/section]."
3. Do not proceed until the human explicitly approves.

See the canonical key table in `enhancement-pause-before.md` for valid keys and what each pauses before.

If `{waitForApprovalBefore}` is absent or `[]`, use the standard per-section checkpoints (existing behavior).
```
#### Stage documents — pause gate block

Each pauseable stage document gains a **Pause gate** block at the very top of its process section:
```markdown
## Pause gate

Check `{waitForApprovalBefore}`. If it contains `[key]`:

1. Present a consolidated summary of all sections completed since the last pause gate (or since the session start if this is the first gate).
2. Stop with: "Ready to begin [stage name]. Review the above and reply **continue** to proceed."
3. Do not begin this stage until the human explicitly approves.
```
Within the requirements stage documents (`product-requirements.md`, `enhancements.md`), each individual section step gains an inline pause gate check:
```markdown
### [Section name]

**Pause gate**: if `{waitForApprovalBefore}` includes `[section-key]`, treat this as a gate — present the current batch and wait for approval before writing this section.

**Batch mode** (no gate here): draft this section and proceed to the next without stopping.
```
## Task list

- [ ] **Story: Config and session-start hook**
  - [x] **Task: Document waitForApprovalBefore in mm.toml**
    - **Description**: Add commented example of `waitForApprovalBefore` field to `mm.toml`
    - **Acceptance criteria**:
      - [x] mm.toml contains comment block with valid keys and example syntax
      - [x] Field is commented out (no active config change)
    - **Dependencies**: None
  - [x] **Task: Add array parsing to session-start.sh**
    - **Description**: Add `parse_toml_array` helper and parse `waitForApprovalBefore`; inject into additionalContext
    - **Acceptance criteria**:
      - [x] Hook outputs `waitForApprovalBefore=[]` when field absent
      - [x] Hook outputs `waitForApprovalBefore=["tech","taskList"]` when field present
      - [x] All existing hook output paths include the new field
    - **Dependencies**: None
- [ ] **Story: SKILL.md Pause gates concept**
  - [x] **Task: Add Pause gates section to SKILL.md**
    - **Description**: Add `### Pause gates` subsection after `### Section-by-section checkpoints` in planning SKILL.md
    - **Acceptance criteria**:
      - [x] Section documents batch-mode behavior
      - [x] References canonical key table
      - [x] Documents no-config default (unchanged behavior)
    - **Dependencies**: None
- [ ] **Story: Stage documents — requirements**
  - [x] **Task: Add inline pause gates to product-requirements.md**
    - **Description**: Add pause gate blocks to all 6 feature sections (what, why, personas, narratives, userStories, goals)
    - **Acceptance criteria**:
      - [x] Each of the 6 sections has a Pause gate block
      - [x] Each block specifies its canonical key
    - **Dependencies**: Story: SKILL.md Pause gates concept
  - [x] **Task: Add inline pause gates to enhancements.md**
    - **Description**: Add pause gate blocks to What, Why, User stories sections; userStories block covers inapplicable keys
    - **Acceptance criteria**:
      - [x] What, Why, User stories sections each have a Pause gate block
      - [x] userStories block documents inapplicable key (personas, narratives, goals) substitution
    - **Dependencies**: Story: SKILL.md Pause gates concept
- [ ] **Story: Stage documents — design, tech, task-decomposition**
  - [x] **Task: Add Pause gate block to design-specs.md**
    - **Description**: Add `## Pause gate` section before `## Process` with key `design`
    - **Acceptance criteria**:
      - [x] Pause gate section present with correct key
      - [x] Positioned before Process section
    - **Dependencies**: Story: SKILL.md Pause gates concept
  - [x] **Task: Add Pause gate block to tech-specs.md**
    - **Description**: Add `## Pause gate` section before `## Process` with key `tech`
    - **Acceptance criteria**:
      - [x] Pause gate section present with correct key
      - [x] Positioned before Process section
    - **Dependencies**: Story: SKILL.md Pause gates concept
  - [x] **Task: Add Pause gate block to task-decomposition.md**
    - **Description**: Add `## Pause gate` section before `## Process` with key `taskList`
    - **Acceptance criteria**:
      - [x] Pause gate section present with correct key
      - [x] Positioned before Process section
    - **Dependencies**: Story: SKILL.md Pause gates concept