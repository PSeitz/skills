---
name: handoff
description: Compact the current conversation into a handoff document for another agent to pick up.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

# Handoff

Write a handoff document summarising the current conversation so a fresh agent can continue the work. Save to the temporary directory of the user's OS — not the current workspace.

## Format

Use this structure:

```
# Handoff — [brief topic]

## What we're doing
[1-3 sentences on the goal and current state]

## Key decisions
- [Decision 1]
- [Decision 2]

## Where things are
- [path/to/file — what it contains]
- [URL to issue/PR/ADR]

## What's next
[Specific next step the next agent should take]

## Gotchas
- [Any surprises, constraints, or things to avoid]

## Suggested skills
- `skill-name` — why it's relevant
```

## Rules

- **Reference, don't duplicate.** Point to specs, plans, ADRs, issues, commits, or diffs by path or URL instead of re-explaining them.
- **Redact sensitive info.** Strip API keys, passwords, tokens, and PII.
- **Use the user's argument** (if provided) as the focus for "What's next" and tailor the whole document toward that next session's goal.
- **Save to `$TMPDIR`** (or `/tmp` on Linux, `$TMPDIR` on macOS). Name the file `handoff-<slug>.md`.
