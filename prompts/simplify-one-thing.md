---
description: Find one unnecessarily complex thing in the current codebase, simplify it, and explain the change.
---

# Simplify One Thing

Find exactly one thing in the current codebase that can be made simpler.

## Goal

Reduce complexity without changing behavior.

Prefer simplifying:

1. Overly complicated control flow
2. Repeated logic
3. Confusing names
4. Unnecessary abstractions
5. Missing abstractions that would clarify intent or simplify usage
6. Code that is hard to reason about
7. Comments that explain confusing code that could instead be made clearer

Do not rewrite unrelated code.  
Do not change behavior unless explicitly necessary.
Do focus on reducing LOC.

## Process

1. Inspect the relevant files.
2. Find 3 to 5 simplification candidates.
3. Pick exactly one.
4. Choose the candidate with:
   - the clearest reduction in complexity
   - the lowest risk of behavior change
   - the easiest verification path
5. Explain the chosen simplification before editing.
6. Make the change.
7. Run the most relevant test, formatter, linter, or build command.
8. If no verification command is obvious, infer one from the project files.
9. If verification cannot be run, explain why.

## Rules

- Preserve behavior.
- Prefer deleting code over adding code.
- Preserve the project’s existing style.
- Do not introduce new dependencies.
- Do not rename public APIs unless the simplification clearly requires it.
- Add or update tests only if needed to preserve confidence.

## Output format

After finishing, report:

```text
Simplified: <one-sentence summary>

Why this was worth doing:
<brief explanation>

What changed:
- <file>: <what was simplified>

Verification:
- <command run>: <result>

Notes:
<any caveats or follow-up ideas>
```
