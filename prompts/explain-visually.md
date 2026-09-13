---
description: Create a visual explanation as Markdown and open it as standalone HTML
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

## Render

Save the explanation to a Markdown (`.md`) file in the temporary directory of the user's OS, with each diagram in a fenced `mermaid` block. Then run the package renderer:

```bash
node "$HOME/.pi/agent/git/github.com/PSeitz/skills/scripts/render-explanation.mjs" <markdown-file>
```

The renderer validates the Mermaid, applies the standard HTML template, embeds the rendered diagrams, and opens the standalone HTML in the default browser. If rendering fails, fix the Markdown and rerun it until it succeeds.

Do not create the HTML yourself or read the renderer/template into context. Respond with both file paths.
