# Agent Skills

A collection of [pi](https://github.com/earendil-works/pi-coding-agent) / Claude Code compatible skills.

## Quick Install

```bash
curl -L https://raw.github.com/PSeitz/skills/main/install.sh | sh
```

This clones the repo into `~/.agents/`. Re-run to update.

## Skills

| Skill | Description |
|-------|-------------|
| `optimize-rust` | Profile and optimize Rust code with `perf` (Linux) or `instruments` (macOS). Measure first, then change. |

## What's a Skill?

Skills are specialized instructions that agentic coding tools load on demand. Each skill lives in its own directory with a `SKILL.md` file containing YAML frontmatter (name, description, allowed tools) and markdown instructions. When your task matches the description, the agent automatically uses the skill.
