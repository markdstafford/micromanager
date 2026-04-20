# Writing enhancements

> **This is a process document.** Follow these steps in order.
> Refer to the planning skill's SKILL.md for shared concepts
> (prerequisites, checkpoints, wiki management).

This stage guides the creation of enhancement artifacts — improvements to existing features.
An enhancement modifies or extends something that already works, rather than building something new.

**Use this stage when:** the work is clearly scoped to improving an existing feature
(adding a capability, changing behavior, filling a gap). If the work is large enough to
stand alone as independent functionality, use the feature requirements stage instead.

## Output artifacts

- `enhancement-*.md` — one per enhancement, stored in `{docs_root}/specs/`
  - Contains: Parent feature, What, Why, User stories
  - Design changes, Technical changes, and Task list sections are added by later stages

## Prerequisite check

First, run the standard prerequisite check from SKILL.md (ADRs, wiki documents, dependent feature specs).

Then, additionally locate and read the parent feature spec in `{docs_root}/specs/`.

**If the parent feature spec doesn't exist:** stop. The enhancement cannot be specified without it.
Propose creating the parent feature spec first using the feature requirements stage.

**If the parent feature spec exists:** note its key design decisions and tech stack. These constrain the enhancement.

## Process

### 1. Confirm the parent feature

Ask the human: "Which feature does this enhance?" Identify the corresponding spec file.
Read it. Present a one-sentence summary of what the parent feature does.

**CHECKPOINT**: Confirm with the human before proceeding.

Once the parent feature is confirmed, choose a short kebab-case name for the enhancement (e.g., `at-reference-files`) and create the file:
- Path: `{docs_root}/specs/backlog/enhancement-[name].md` (create `{docs_root}/specs/backlog/` if it doesn't exist)
- Copy from: `references/templates/enhancement.md`
- Populate frontmatter immediately: set `created` and `last_updated` to today's date, `status: draft`, `specced_by` to the current GitHub username (`gh api user -q .login`), all other person/reference fields to `null`
- Fill in the `## Parent feature` section now; leave all other sections to be filled in subsequent steps

### 2. What (1 paragraph)

**Pause gate**: if `{waitForApprovalBefore}` includes `what`, treat this as a gate — present all sections completed since the last gate and wait for approval before drafting this section. If `{waitForApprovalBefore}` is absent or does not include `what`, draft this section and proceed.

**Content**: What does this enhancement add to the existing feature? Describe the new behavior
specifically. Do not describe the implementation.

**Process**:
- Draft based on the human's description
- Present for review
- **CHECKPOINT**: Get human approval before proceeding to Why

**Anti-solutioning**: Same rules as feature requirements. What answers "what are we building?" — describe the new behavior in plain terms. The What describes new user-visible behavior, not how it's built.

### 3. Why (1 paragraph)

**Pause gate**: if `{waitForApprovalBefore}` includes `why`, treat this as a gate — present all sections completed since the last gate and wait for approval before drafting this section. If `{waitForApprovalBefore}` is absent or does not include `why`, draft this section and proceed.

**Content**: Why does this improvement matter? What gap does it fill? What does it unblock?

**Process**:
- Draft based on the human's description
- Present for review
- **CHECKPOINT**: Get human approval before proceeding

### 4. User stories

**Pause gate**: if `{waitForApprovalBefore}` includes `userStories`, OR includes any of `personas`, `narratives`, or `goals` (which are not applicable to enhancements and map to this section as the next applicable section in the sequence), treat this as a gate — present all sections completed since the last gate and wait for approval before drafting this section. If `{waitForApprovalBefore}` is absent or none of these keys are present, draft this section and proceed.

**Content**: "[Persona] can [new action]" statements for the new capability only.
Do not repeat stories from the parent feature — only what's new.

**Process**:
- Propose 3-6 user stories based on What/Why
- Present for review
- **CHECKPOINT**: Get human approval

### 5. Route to design and tech stages

After user stories are approved, route based on what the enhancement touches:

- **Has UI changes** → continue to design-specs stage, framed as delta on the parent feature's design spec
- **Backend/logic only** → skip design, go directly to tech-specs stage
- **Both** → design-specs stage first, then tech-specs stage

When entering design-specs or tech-specs for an enhancement:
- Read the parent feature's existing design/tech sections first
- Frame everything as "what changes" relative to what exists
- Only document what's new or different — do not re-describe the existing implementation

## Key guidelines

- **Delta framing throughout** — every section is about what changes, not a complete description
- **Personas are inherited** — do not repeat personas from the parent feature
- **Narratives are optional** — add a narrative only if the interaction is genuinely novel; otherwise user stories suffice
- **Non-goals are optional** — only include if there's real scope ambiguity to address
- **Architecture diagrams are optional** — only add if the enhancement introduces new components; otherwise reference the parent feature's diagrams
- **Stage placeholders are additive** — when a later stage adds content to a section, append it below the placeholder line rather than removing it. This preserves traceability of what was added at each stage.

For templates and examples, see:
- `references/templates/enhancement.md` — template for enhancement-*.md artifacts
- `references/examples/enhancement.md` — complete enhancement example (@-reference files)
