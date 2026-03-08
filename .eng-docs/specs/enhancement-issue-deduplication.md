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

*(Added by task decomposition stage)*
