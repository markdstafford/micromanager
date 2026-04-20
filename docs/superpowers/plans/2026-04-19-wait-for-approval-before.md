# waitForApprovalBefore Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an optional `waitForApprovalBefore` array field to `mm.toml` that configures pause gates in the planning workflow, batching sections between gates instead of stopping after every individual section.

**Architecture:** The feature threads through three layers — the session-start hook parses and injects `waitForApprovalBefore` as a config value; the planning SKILL.md documents batch-mode behavior; and each stage document gains inline pause gate checks so the AI knows when to stop and present a consolidated batch. No new files are created; all changes are additive edits to existing files.

**Tech Stack:** Bash (session-start hook), Markdown (SKILL.md and stage documents), TOML (mm.toml config)

---

## File Map

| File | Change |
|------|--------|
| `mm.toml` | Add documented `waitForApprovalBefore` example (commented out) |
| `plugins/mm/hooks/session-start.sh` | Add `parse_toml_array` helper; parse and inject `waitForApprovalBefore` |
| `plugins/mm/skills/planning/SKILL.md` | Add `### Pause gates` section after `### Section-by-section checkpoints` |
| `plugins/mm/skills/planning/references/stages/product-requirements.md` | Add inline pause gate block in each of the 6 feature sections |
| `plugins/mm/skills/planning/references/stages/enhancements.md` | Add inline pause gate block in What, Why, User stories sections |
| `plugins/mm/skills/planning/references/stages/design-specs.md` | Add `## Pause gate` block at top of Process section |
| `plugins/mm/skills/planning/references/stages/tech-specs.md` | Add `## Pause gate` block at top of Process section |
| `plugins/mm/skills/planning/references/stages/task-decomposition.md` | Add `## Pause gate` block at top of Process section |

---

## Story 1: Config and session-start hook

### Task 1: Document waitForApprovalBefore in mm.toml

**Files:**
- Modify: `mm.toml`

- [ ] **Step 1: Add commented field documentation to mm.toml**

  Open `mm.toml` (currently just 2 lines). Add the documented example as comments so users know the option exists:

  ```toml
  docs_root = ".eng-docs"
  issue_tracker = "github"

  # Optional: pause for explicit approval before these sections/stages.
  # Valid keys: what, why, personas, narratives, userStories, goals,
  #             design, tech, taskList
  # waitForApprovalBefore = ["tech", "taskList"]
  ```

- [ ] **Step 2: Verify mm.toml is valid**

  ```bash
  cat mm.toml
  ```
  Expected: shows the 2 active lines plus the 4 comment lines.

- [ ] **Step 3: Check off in spec file**

  In `context-human/specs/enhancement-pause-before.md`, the task list is at the bottom.
  Add and immediately check off Task 1 there (see Task 11 which adds the full task list).
  Skip this step — the spec task list is added in Story 5.

- [ ] **Step 4: Commit**

  ```bash
  git add mm.toml
  git commit -m "docs(config): document waitForApprovalBefore option in mm.toml"
  ```

---

### Task 2: Add array parsing helper to session-start.sh

**Files:**
- Modify: `plugins/mm/hooks/session-start.sh`

- [ ] **Step 1: Add `parse_toml_array` function**

  Insert after the existing `parse_toml_value` function (after line ~25, before the `if [ -z "$CONFIG_FILE" ]` block). Add:

  ```bash
  # Parse array value from TOML key=value line
  # Returns the bracketed array literal, e.g. ["tech","taskList"], or [] if absent
  parse_toml_array() {
    local key="$1"
    local file="$2"
    local line
    line=$({ grep -E "^${key}\s*=" "$file" 2>/dev/null || true; } | head -1)
    if [ -z "$line" ]; then
      echo "[]"
      return
    fi
    # Extract everything after '=', strip whitespace (keeps bracket notation)
    echo "$line" \
      | sed -E 's/^[^=]+=\s*//' \
      | sed -E 's/#[^"]*$//' \
      | tr -d ' \t'
  }
  ```

- [ ] **Step 2: Parse waitForApprovalBefore after existing parses**

  After the two `parse_toml_value` calls (lines that set `DOCS_ROOT` and `ISSUE_TRACKER`), add:

  ```bash
  WAIT_FOR_APPROVAL_BEFORE=$(parse_toml_array "waitForApprovalBefore" "$CONFIG_FILE")
  ```

- [ ] **Step 3: Inject waitForApprovalBefore into the final output**

  The final `printf` line (the "all settings present" path) currently is:
  ```bash
  printf '{"additionalContext": "mm config: docs_root=\"%s\", issue_tracker=\"%s\""}\n' \
    "$DOCS_ROOT" "$ISSUE_TRACKER"
  ```

  Replace with:
  ```bash
  printf '{"additionalContext": "mm config: docs_root=\"%s\", issue_tracker=\"%s\", waitForApprovalBefore=%s"}\n' \
    "$DOCS_ROOT" "$ISSUE_TRACKER" "$WAIT_FOR_APPROVAL_BEFORE"
  ```

  Also update the "missing settings" printf to include waitForApprovalBefore (the one that prints missing settings):
  ```bash
  printf '{"additionalContext": "mm config: docs_root=\"%s\", issue_tracker=\"%s\", waitForApprovalBefore=%s\\n\\nmm.toml is missing settings: %s. Starting mm:init to fill them in."}\n' \
    "$DOCS_ROOT" "$ISSUE_TRACKER" "$WAIT_FOR_APPROVAL_BEFORE" "$MISSING_LIST"
  ```

- [ ] **Step 4: Verify the full hook script looks correct**

  Read the file and confirm: `parse_toml_array` is defined, `WAIT_FOR_APPROVAL_BEFORE` is parsed, and both printf statements include the new field.

  ```bash
  cat plugins/mm/hooks/session-start.sh
  ```

- [ ] **Step 5: Test — field absent (default [])**

  Run the hook with the current mm.toml (no `waitForApprovalBefore` field):

  ```bash
  cd /Users/mark.stafford/.autocatalyst/workspaces/micromanager/de732d71-c83b-4c7a-827a-f834ba7d9327
  bash plugins/mm/hooks/session-start.sh
  ```

  Expected output (JSON, single line):
  ```
  {"additionalContext": "mm config: docs_root=\".eng-docs\", issue_tracker=\"github\", waitForApprovalBefore=[]"}
  ```

- [ ] **Step 6: Test — field present**

  Temporarily add the field to mm.toml, run the hook, then remove it:

  ```bash
  echo 'waitForApprovalBefore = ["tech", "taskList"]' >> mm.toml
  bash plugins/mm/hooks/session-start.sh
  # Restore mm.toml
  head -n 7 mm.toml > /tmp/mm_tmp.toml && mv /tmp/mm_tmp.toml mm.toml
  ```

  Expected output during test (before restore):
  ```
  {"additionalContext": "mm config: docs_root=\".eng-docs\", issue_tracker=\"github\", waitForApprovalBefore=[\"tech\",\"taskList\"]"}
  ```

- [ ] **Step 7: Commit**

  ```bash
  git add plugins/mm/hooks/session-start.sh
  git commit -m "feat(hook): parse and inject waitForApprovalBefore from mm.toml"
  ```

---

## Story 2: SKILL.md — Pause gates concept

### Task 3: Add Pause gates section to planning SKILL.md

**Files:**
- Modify: `plugins/mm/skills/planning/SKILL.md`

- [ ] **Step 1: Add the Pause gates subsection**

  In `SKILL.md`, the `### Section-by-section checkpoints` section ends at around line 107 (the "If the human wants to skip ahead" line). After the section-by-section checkpoints block and before `### Branch setup`, insert:

  ```markdown
  ### Pause gates

  If `{waitForApprovalBefore}` is set and non-empty, the workflow uses **batch mode** instead of per-section checkpoints. Between pause gates, draft each section in order — each section builds on the ones before it — and move to the next without stopping for human approval. At a pause gate:

  1. Present all sections completed in the current batch as a single consolidated output.
  2. Stop with the message: "I've completed [section list]. Review above and reply **continue** to proceed to [next stage/section]."
  3. Do not proceed until the human explicitly approves.

  See the canonical key table in `enhancement-pause-before.md` for valid keys and what each pauses before. Unknown keys are silently ignored. Keys not applicable to the current workflow (e.g., `personas` in an enhancement spec) pause at the next applicable section in the workflow sequence.

  If `{waitForApprovalBefore}` is absent or `[]`, use the standard per-section checkpoints (existing behavior).
  ```

- [ ] **Step 2: Verify placement**

  Read the updated file and confirm the Pause gates section appears between `### Section-by-section checkpoints` and `### Branch setup`.

  ```bash
  grep -n "Pause gates\|Section-by-section\|Branch setup" plugins/mm/skills/planning/SKILL.md
  ```

  Expected: Pause gates line number is between the other two.

- [ ] **Step 3: Commit**

  ```bash
  git add plugins/mm/skills/planning/SKILL.md
  git commit -m "feat(skill): add Pause gates concept to planning SKILL.md"
  ```

---

## Story 3: Stage documents — requirements

### Task 4: Add inline pause gates to product-requirements.md

**Files:**
- Modify: `plugins/mm/skills/planning/references/stages/product-requirements.md`

- [ ] **Step 1: Add pause gate block to "For features — What" section**

  The "### 1. What (1-3 paragraphs)" section under "For features" currently starts with "Same process as applications."

  Add the pause gate block **before** "Same process as applications.":

  ```markdown
  **Pause gate**: if `{waitForApprovalBefore}` includes `what`, treat this as a gate — present all sections completed since the last gate and wait for approval before drafting this section. If `{waitForApprovalBefore}` is absent or does not include `what`, draft this section and proceed.
  ```

- [ ] **Step 2: Add pause gate block to "For features — Why" section**

  The "### 2. Why (1-2 paragraphs)" section under "For features":

  ```markdown
  **Pause gate**: if `{waitForApprovalBefore}` includes `why`, treat this as a gate — present all sections completed since the last gate and wait for approval before drafting this section. If `{waitForApprovalBefore}` is absent or does not include `why`, draft this section and proceed.
  ```

- [ ] **Step 3: Add pause gate block to "For features — Personas" section**

  The "### 3. Personas (subset from app)" section:

  ```markdown
  **Pause gate**: if `{waitForApprovalBefore}` includes `personas`, treat this as a gate — present all sections completed since the last gate and wait for approval before drafting this section. If `{waitForApprovalBefore}` is absent or does not include `personas`, draft this section and proceed.
  ```

- [ ] **Step 4: Add pause gate block to "For features — Narratives" section**

  The "### 4. Narratives" section:

  ```markdown
  **Pause gate**: if `{waitForApprovalBefore}` includes `narratives`, treat this as a gate — present all sections completed since the last gate and wait for approval before drafting this section. If `{waitForApprovalBefore}` is absent or does not include `narratives`, draft this section and proceed.
  ```

- [ ] **Step 5: Add pause gate block to "For features — User stories" section**

  The "### 5. User stories" section:

  ```markdown
  **Pause gate**: if `{waitForApprovalBefore}` includes `userStories`, treat this as a gate — present all sections completed since the last gate and wait for approval before drafting this section. If `{waitForApprovalBefore}` is absent or does not include `userStories`, draft this section and proceed.
  ```

- [ ] **Step 6: Add pause gate block to "For features — Goals and non-goals" section**

  The "### 6. Goals and non-goals" section:

  ```markdown
  **Pause gate**: if `{waitForApprovalBefore}` includes `goals`, treat this as a gate — present all sections completed since the last gate and wait for approval before drafting this section. If `{waitForApprovalBefore}` is absent or does not include `goals`, draft this section and proceed.
  ```

- [ ] **Step 7: Verify all six gate blocks are present**

  ```bash
  grep -n "Pause gate" plugins/mm/skills/planning/references/stages/product-requirements.md
  ```

  Expected: 6 lines containing "Pause gate", one for each section (what, why, personas, narratives, userStories, goals).

- [ ] **Step 8: Commit**

  ```bash
  git add plugins/mm/skills/planning/references/stages/product-requirements.md
  git commit -m "feat(stage): add inline pause gates to product-requirements.md"
  ```

---

### Task 5: Add inline pause gates to enhancements.md

**Files:**
- Modify: `plugins/mm/skills/planning/references/stages/enhancements.md`

- [ ] **Step 1: Add pause gate block to "What" section**

  In `enhancements.md`, the "### 2. What (1 paragraph)" section currently starts with "**Content**:". Add before "**Content**:":

  ```markdown
  **Pause gate**: if `{waitForApprovalBefore}` includes `what`, treat this as a gate — present all sections completed since the last gate and wait for approval before drafting this section. If `{waitForApprovalBefore}` is absent or does not include `what`, draft this section and proceed.

  ```

- [ ] **Step 2: Add pause gate block to "Why" section**

  In the "### 3. Why (1 paragraph)" section, add before "**Content**:":

  ```markdown
  **Pause gate**: if `{waitForApprovalBefore}` includes `why`, treat this as a gate — present all sections completed since the last gate and wait for approval before drafting this section. If `{waitForApprovalBefore}` is absent or does not include `why`, draft this section and proceed.

  ```

- [ ] **Step 3: Add pause gate block to "User stories" section**

  In the "### 4. User stories" section, add before "**Content**:":

  ```markdown
  **Pause gate**: if `{waitForApprovalBefore}` includes `userStories`, OR includes any of `personas`, `narratives`, or `goals` (which are not applicable to enhancements and map to this section as the next applicable section in the sequence), treat this as a gate — present all sections completed since the last gate and wait for approval before drafting this section. If `{waitForApprovalBefore}` is absent or none of these keys are present, draft this section and proceed.

  ```

- [ ] **Step 4: Verify all three gate blocks are present**

  ```bash
  grep -n "Pause gate" plugins/mm/skills/planning/references/stages/enhancements.md
  ```

  Expected: 3 lines containing "Pause gate".

- [ ] **Step 5: Commit**

  ```bash
  git add plugins/mm/skills/planning/references/stages/enhancements.md
  git commit -m "feat(stage): add inline pause gates to enhancements.md"
  ```

---

## Story 4: Stage documents — design, tech, task-decomposition

### Task 6: Add Pause gate block to design-specs.md

**Files:**
- Modify: `plugins/mm/skills/planning/references/stages/design-specs.md`

- [ ] **Step 1: Add the Pause gate section**

  In `design-specs.md`, the `## Process` heading is at line ~27. Insert a `## Pause gate` section immediately **before** `## Process`:

  ```markdown
  ## Pause gate

  Check `{waitForApprovalBefore}`. If it contains `design`:

  1. Present a consolidated summary of all sections completed since the last pause gate (or since the session start if this is the first gate).
  2. Stop with: "Ready to begin the design spec. Review the above and reply **continue** to proceed."
  3. Do not begin this stage until the human explicitly approves.

  ```

- [ ] **Step 2: Verify placement**

  ```bash
  grep -n "Pause gate\|## Process\|## Prerequisite" plugins/mm/skills/planning/references/stages/design-specs.md
  ```

  Expected: Pause gate appears between "Prerequisite checklist" and "Process".

- [ ] **Step 3: Commit**

  ```bash
  git add plugins/mm/skills/planning/references/stages/design-specs.md
  git commit -m "feat(stage): add Pause gate block to design-specs.md"
  ```

---

### Task 7: Add Pause gate block to tech-specs.md

**Files:**
- Modify: `plugins/mm/skills/planning/references/stages/tech-specs.md`

- [ ] **Step 1: Add the Pause gate section**

  In `tech-specs.md`, the `## Process` heading is at line ~38. Insert immediately **before** `## Process`:

  ```markdown
  ## Pause gate

  Check `{waitForApprovalBefore}`. If it contains `tech`:

  1. Present a consolidated summary of all sections completed since the last pause gate (or since the session start if this is the first gate).
  2. Stop with: "Ready to begin the tech spec. Review the above and reply **continue** to proceed."
  3. Do not begin this stage until the human explicitly approves.

  ```

- [ ] **Step 2: Verify placement**

  ```bash
  grep -n "Pause gate\|## Process\|## Prerequisite" plugins/mm/skills/planning/references/stages/tech-specs.md
  ```

  Expected: Pause gate appears between "Prerequisite checklist" and "Process".

- [ ] **Step 3: Commit**

  ```bash
  git add plugins/mm/skills/planning/references/stages/tech-specs.md
  git commit -m "feat(stage): add Pause gate block to tech-specs.md"
  ```

---

### Task 8: Add Pause gate block to task-decomposition.md

**Files:**
- Modify: `plugins/mm/skills/planning/references/stages/task-decomposition.md`

- [ ] **Step 1: Add the Pause gate section**

  In `task-decomposition.md`, the `## Process` heading is at line ~18. Insert immediately **before** `## Process`:

  ```markdown
  ## Pause gate

  Check `{waitForApprovalBefore}`. If it contains `taskList`:

  1. Present a consolidated summary of all sections completed since the last pause gate (or since the session start if this is the first gate).
  2. Stop with: "Ready to begin task decomposition. Review the above and reply **continue** to proceed."
  3. Do not begin this stage until the human explicitly approves.

  ```

- [ ] **Step 2: Verify placement**

  ```bash
  grep -n "Pause gate\|## Process\|## Output" plugins/mm/skills/planning/references/stages/task-decomposition.md
  ```

  Expected: Pause gate appears between "Output" and "Process".

- [ ] **Step 3: Commit**

  ```bash
  git add plugins/mm/skills/planning/references/stages/task-decomposition.md
  git commit -m "feat(stage): add Pause gate block to task-decomposition.md"
  ```

---

## Story 5: Spec task list and final commit

### Task 9: Add task list to spec file

**Files:**
- Modify: `context-human/specs/enhancement-pause-before.md`

- [ ] **Step 1: Replace the "Task list" section placeholder**

  The spec currently ends with:
  ```markdown
  ## Task list

  *(Added by task decomposition stage)*
  ```

  Replace the placeholder content with the task list below (mirroring this plan's stories and tasks):

  ```markdown
  ## Task list

  - [ ] **Story: Config and session-start hook**
    - [ ] **Task: Document waitForApprovalBefore in mm.toml**
      - **Description**: Add commented example of `waitForApprovalBefore` field to `mm.toml`
      - **Acceptance criteria**:
        - [ ] mm.toml contains comment block with valid keys and example syntax
        - [ ] Field is commented out (no active config change)
      - **Dependencies**: None
    - [ ] **Task: Add array parsing to session-start.sh**
      - **Description**: Add `parse_toml_array` helper and parse `waitForApprovalBefore`; inject into additionalContext
      - **Acceptance criteria**:
        - [ ] Hook outputs `waitForApprovalBefore=[]` when field absent
        - [ ] Hook outputs `waitForApprovalBefore=["tech","taskList"]` when field present
        - [ ] All existing hook output paths include the new field
      - **Dependencies**: None
  - [ ] **Story: SKILL.md Pause gates concept**
    - [ ] **Task: Add Pause gates section to SKILL.md**
      - **Description**: Add `### Pause gates` subsection after `### Section-by-section checkpoints` in planning SKILL.md
      - **Acceptance criteria**:
        - [ ] Section documents batch-mode behavior
        - [ ] References canonical key table
        - [ ] Documents no-config default (unchanged behavior)
      - **Dependencies**: None
  - [ ] **Story: Stage documents — requirements**
    - [ ] **Task: Add inline pause gates to product-requirements.md**
      - **Description**: Add pause gate blocks to all 6 feature sections (what, why, personas, narratives, userStories, goals)
      - **Acceptance criteria**:
        - [ ] Each of the 6 sections has a Pause gate block
        - [ ] Each block specifies its canonical key
      - **Dependencies**: Story: SKILL.md Pause gates concept
    - [ ] **Task: Add inline pause gates to enhancements.md**
      - **Description**: Add pause gate blocks to What, Why, User stories sections; userStories block covers inapplicable keys
      - **Acceptance criteria**:
        - [ ] What, Why, User stories sections each have a Pause gate block
        - [ ] userStories block documents inapplicable key (personas, narratives, goals) substitution
      - **Dependencies**: Story: SKILL.md Pause gates concept
  - [ ] **Story: Stage documents — design, tech, task-decomposition**
    - [ ] **Task: Add Pause gate block to design-specs.md**
      - **Description**: Add `## Pause gate` section before `## Process` with key `design`
      - **Acceptance criteria**:
        - [ ] Pause gate section present with correct key
        - [ ] Positioned before Process section
      - **Dependencies**: Story: SKILL.md Pause gates concept
    - [ ] **Task: Add Pause gate block to tech-specs.md**
      - **Description**: Add `## Pause gate` section before `## Process` with key `tech`
      - **Acceptance criteria**:
        - [ ] Pause gate section present with correct key
        - [ ] Positioned before Process section
      - **Dependencies**: Story: SKILL.md Pause gates concept
    - [ ] **Task: Add Pause gate block to task-decomposition.md**
      - **Description**: Add `## Pause gate` section before `## Process` with key `taskList`
      - **Acceptance criteria**:
        - [ ] Pause gate section present with correct key
        - [ ] Positioned before Process section
      - **Dependencies**: Story: SKILL.md Pause gates concept
  ```

- [ ] **Step 2: Verify spec file ends correctly**

  ```bash
  tail -20 context-human/specs/enhancement-pause-before.md
  ```

  Expected: shows the task list checkboxes, no placeholder text.

- [ ] **Step 3: Commit**

  ```bash
  git add context-human/specs/enhancement-pause-before.md
  git commit -m "docs(spec): add task list to enhancement-pause-before.md"
  ```

---

### Task 10: Mark spec tasks complete

**Files:**
- Modify: `context-human/specs/enhancement-pause-before.md`

- [ ] **Step 1: Check off all completed tasks in the spec**

  After all previous tasks are done, update `context-human/specs/enhancement-pause-before.md` to mark each story and task as complete (`- [ ]` → `- [x]`).

- [ ] **Step 2: Commit the final spec update**

  ```bash
  git add context-human/specs/enhancement-pause-before.md
  git commit -m "docs(spec): mark all tasks complete in enhancement-pause-before.md"
  ```

---

## Post-implementation

### Verification

No automated test suite exists in this repository (it is a documentation/configuration project). Manual verification:

1. Run the session-start hook with no `waitForApprovalBefore` field → confirm `waitForApprovalBefore=[]` in output
2. Run with field set → confirm correct bracket-notation array in output
3. Scan each modified stage document to confirm all Pause gate blocks are present and correctly keyed

### Spec coverage checklist

| Requirement | Covered by |
|-------------|-----------|
| `waitForApprovalBefore` TOML field | Task 1 (mm.toml) |
| Hook parses array, injects into context | Task 2 (session-start.sh) |
| Batch mode concept documented | Task 3 (SKILL.md) |
| Per-section gates in product-requirements | Task 4 |
| Per-section gates in enhancements | Task 5 |
| Stage gate for design | Task 6 |
| Stage gate for tech | Task 7 |
| Stage gate for taskList | Task 8 |
| No-config unchanged behavior | Task 3 (SKILL.md pause gates section) |
| Inapplicable key substitution | Task 5 (userStories gate in enhancements) + SKILL.md |
