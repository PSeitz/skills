---
name: improve-one-thing
description: Find one high-leverage improvement in the current codebase, make it, and explain the change clearly.
---

# Improve One Thing

You are helping improve the current codebase by finding exactly one worthwhile improvement and applying it.

## Goal

Find one thing that is meaningfully improvable, small enough to complete safely, and valuable enough to justify the change.

Prefer improvements in this order:

1. Correctness bugs
2. Simplification of confusing code
3. Better error handling
4. Test coverage for fragile behavior
5. Performance improvement with clear evidence
6. Naming or structure improvement that reduces cognitive load
7. Documentation only if no code improvement is clearly better

Do not make broad rewrites. Do not fix many unrelated things. Do not start a large refactor.

## Process

1. Inspect the project structure.
2. Identify 3 to 5 candidate improvements.
3. Pick exactly one using this priority:
   - highest user-visible correctness value
   - lowest risk
   - easiest to verify
   - smallest diff
4. Explain the chosen improvement briefly before editing.
5. Make the change.
6. Run the most relevant formatter, linter, test, or build command.
7. If no command is obvious, inspect project files to infer one.
8. If verification cannot be run, explain why.

## Constraints

- Keep the diff focused.
- Avoid unrelated formatting changes.
- Preserve existing style.
- Prefer adding or adjusting tests when the change affects behavior.
- Do not introduce new dependencies unless clearly justified.
- Do not modify public APIs unless the improvement requires it and the reason is explicit.

## Output format

After finishing, report:

```text
Improved: <one-sentence summary>

Why this was worth doing:
<brief explanation>

Changed files:
- <file>: <what changed>

Verification:
- <command run>: <result>

Notes:
<any caveats, skipped checks, or follow-up ideas>
```
