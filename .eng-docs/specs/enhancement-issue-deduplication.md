# Enhancement: Issue deduplication

## Parent feature

`feature-github-issue-triage.md`

## What

Before creating a new GitHub issue, the skill searches existing open issues for a close match. If a match is found, the evidence from the current item is appended to the existing issue rather than creating a duplicate. If no match is found, the skill proceeds to create a new issue as normal.

## Why

Triage sessions often produce near-duplicate issues — the same bug filed twice, or a friction log item that describes a problem already tracked from a previous session. Without deduplication, the backlog fills with redundant issues, triagers spend time manually cross-referencing, and the same work gets planned more than once.

By detecting duplicates at creation time and consolidating evidence onto the existing issue, the skill keeps the backlog clean without requiring the human to remember what was already filed.

## User stories

- Devon can see a duplicate warning before an issue is created, with the matching issue linked
- Devon can approve the match and have evidence appended to the existing issue instead of creating a new one
- Devon can reject the match and create a new issue anyway if the match is wrong
- Tara can run the same friction log through triage twice without generating duplicate issues
- Petra can see consolidated evidence on an issue when the same problem has been observed multiple times

## Design changes

*(Not applicable — no UI)*

## Technical changes

### Affected files

- `plugins/caf/skills/github-issue-triage/SKILL.md` — add dedup check in both repo triage mode and feedback intake mode

### Changes

**Where it applies:**

- **Repo triage mode** — after Step 6 (human approves proposed triage), before Step 7 (write back to GitHub). The action when a match is found is to close the current issue as a duplicate of the match.
- **Feedback intake mode** — before creating each issue in Step 4. The action when a match is found is to append evidence to the existing issue instead of creating a new one.

**Dedup check (same in both modes):**

1. Extract 3–5 key terms from the proposed issue title
2. Search for matches:
   ```bash
   gh issue list --search "KEYWORDS" --state open --json number,title,labels \
     --jq '.[] | "#\(.number): \(.title) [\(.labels | map(.name) | join(", "))]"'
   ```
3. Always report the result — either the matches found or "No duplicates found"
4. If matches found, present them and ask: `Possible duplicate of #N: "[title]". Append evidence / close as duplicate / new issue? (append / close / new)`

**If "append" (feedback intake mode):**

Post a comment on the existing issue:
```markdown
## Additional observation

[Summary of the new item]

**Context:** [source — e.g. "friction log 2026-03-07, Item 3" or "feedback intake 2026-03-07"]
**Severity/priority signal:** [if from friction log]
```
Skip issue creation.

**If "close as duplicate" (repo triage mode):**

Add a comment referencing the duplicate, then close the issue:
```bash
gh issue comment [number] --body "Closing as duplicate of #[match-number]."
gh issue close [number] --reason "duplicate"
```

**If "new" or no match:**

Proceed to issue creation / write-back as normal.

## Task list

- [x] **Story: Add dedup check to github-issue-triage skill**
  - [x] **Task: Add dedup check to repo triage mode**
    - **Description**: In Phase 3 of `plugins/caf/skills/github-issue-triage/SKILL.md`, add a new Step 6a between Step 6 (human approval) and Step 7 (write-back). The step extracts 3–5 key terms from the proposed title, runs `gh issue list --search`, always reports the result, and offers two paths when a match is found: close as duplicate (posts a comment, runs `gh issue close --reason "duplicate"`, skips Step 7) or proceed with triage as normal.
    - **Acceptance criteria**:
      - [ ] Step 6's "yes" path updated to say "run dedup check (Step 6a), then proceed to Step 7"
      - [ ] Step 6a appears between Step 6 and Step 7 with the `gh issue list --search` command
      - [ ] "No duplicates found" is always reported when there are no matches
      - [ ] Match found → close / proceed options presented
      - [ ] "close" path posts a comment and runs `gh issue close [number] --reason "duplicate"`, then moves to next issue
      - [ ] Steps 7 and 8 are unchanged
    - **Dependencies**: None
  - [x] **Task: Add dedup check to feedback intake mode**
    - **Description**: In `## Feedback Intake Mode`, update Step 4 to run a dedup check before each `gh issue create`. Same `gh issue list --search` pattern. Always reports the result. Match found → append / new options: "append" posts a structured comment (Summary, Context source, Suggested approach) on the existing issue and skips creation; "new" proceeds to creation as normal.
    - **Acceptance criteria**:
      - [ ] Dedup check runs before each item's creation in Step 4
      - [ ] "No duplicates found" is always reported when there are no matches
      - [ ] "append" posts a comment with Summary, Context, and Suggested approach, then confirms "Evidence appended to #N" and skips creation
      - [ ] "new" proceeds to issue creation as normal
      - [ ] Original issue creation instructions are preserved, clearly separated under an "Issue creation" subheading
    - **Dependencies**: None
