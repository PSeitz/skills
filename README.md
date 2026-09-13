# Pi Prompts and Skills

A collection of prompt templates, skills, and extensions for [pi](https://github.com/earendil-works/pi-coding-agent).

## Quick Install

```bash
pi install git:github.com/PSeitz/skills
```

Run `pi update --extensions` to update.

## Skills

| Skill | Description |
|-------|-------------|
| `/skill:commit` | Create git commits with user approval and no AI attribution |
| `/skill:describe-pr` | Generate a comprehensive PR description and open a pull request |

## Prompts

| Prompt | Description |
|--------|-------------|
| `/explain-visually` | Explain a topic with Markdown and validated Mermaid diagrams |
| `/find-skills` | Discover and install agent skills from the ecosystem |
| `/handoff` | Compact the current conversation into a handoff document for another agent |
| `/improve-one-thing` | Find and apply one high-leverage improvement |
| `/mypi` | Make changes to this Pi configuration repository |
| `/optimize-rust` | Profile and optimize Rust code based on measurements |
| `/profile` | Profile a command on Linux with `perf` |
| `/simplify-one-thing` | Simplify one unnecessarily complex part of a codebase |

## Extensions

| Extension | Description |
|-----------|-------------|
| `/tools` | Interactively enable or disable tools for the current Pi session; selections persist in session history |

## What's a Prompt Template?

Prompt templates are explicit, reusable workflows that are loaded only when invoked. Type `/` followed by a prompt name; unlike skills, they do not add descriptions to the model context by default.
