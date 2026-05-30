# Wrap up

When the human calls the session done, capture the decisions before tearing down the lab.

## 1. Summarize the lock-ins

State, for each experiment that produced a winner:

- The axis the experiment explored.
- The variant that won.
- A one-line reason it won.

This summary is the value of the session. It must survive even if everything else is
deleted. Use this format:

```markdown
# <design question> — decisions

_From a prototyping session on YYYY-MM-DD._

## <axis 1>
**Chose:** <variant name>. <one-line reason>.
Considered: <other variant names>, set aside because <one line>.

## <axis 2>
**Chose:** <variant name>. <one-line reason>.

## Open / deferred
- <anything the session surfaced but did not settle>
```

Record the also-rans, briefly. The reason a variant lost is often the most useful thing
a future reader learns.

## 2. Decide where the decisions land

**If invoked by `mm:roadmapping`:** skip this step. Return the lock-in summary to the
parent skill. Roadmapping folds the decisions into its durable `concepts/` docs. Do not
write your own output doc and do not ask the human where decisions go — the parent owns
that.

**If standalone:** ask the human where the decisions should land. Offer:

- **a. Fold into an existing durable doc** — the human names the path; you edit it.
- **b. Seed doc** — write the decision summary to
  `{docs_root}/notes/<experiment-name>/decisions.md`. This is a working artifact that
  feeds a later `mm:planning` or `mm:roadmapping` session. It lives under `notes/`, which
  is gitignored; the human decides whether to keep it under version control.
- **c. Issue body** — create a new issue, or update an existing one, with the decisions.
- **d. Just exit** — the human takes the summary from the conversation themselves.

Phrase it as a question: *"Decisions are captured. Where should they live — fold into an
existing doc, drop a seed doc in `notes/`, put them on an issue, or just leave them
here?"* Apply `mm:writing-guidelines` to whatever you write.

## 3. Clean up the lab

Proceed to `cleanup.md`.
