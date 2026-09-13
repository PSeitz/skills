---
description: Explain a topic visually with Markdown and validated Mermaid diagrams
argument-hint: "<topic>"
---

# Explain Visually

Explain the following topic using concise Markdown and one or more Mermaid diagrams:

$@

## Requirements

- If no topic was provided, ask what should be explained.
- Lead with the diagram, then add only the text needed to clarify it.
- Choose the Mermaid diagram type that best fits the topic, such as a flowchart, sequence diagram, state diagram, class diagram, or timeline.
- Keep diagrams focused and readable. Split a complex diagram into smaller diagrams instead of overcrowding it.
- Use labels that explain the relationships, not just the components.
- Do not invent details. Clearly mark assumptions when the available context is incomplete.

## Validate the Mermaid

Before responding, validate every Mermaid block with an actual Mermaid parser or renderer. Prefer an existing project tool; otherwise render each block from a temporary `.mmd` file with Mermaid CLI, for example:

```bash
npx -y @mermaid-js/mermaid-cli -i /tmp/diagram.mmd -o /tmp/diagram.svg
```

Fix every reported error and rerun validation until it succeeds. Remove temporary validation files. Do not claim that a diagram was validated unless a parser or renderer successfully processed it.

Return the explanation as Markdown with each validated diagram in a fenced `mermaid` block.
