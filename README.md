# Agent Skills

A collection of [pi](https://github.com/earendil-works/pi-coding-agent) / Claude Code compatible skills.

## Quick Install

```bash
curl -L https://raw.github.com/PSeitz/skills/main/install.sh | sh
```

This clones the repo into `~/.agents/skills/`. Re-run to update.

## Skills

| Skill | Description |
|-------|-------------|
| `commit` | Create git commits with user approval and no AI attribution |
| `describe-pr` | Generate a comprehensive PR description and open a pull request |
| `find-skills` | Discover and install agent skills from the ecosystem |
| `improve-one-thing` | Find one high-leverage improvement, make it, and explain it |
| `optimize-rust` | Profile and optimize Rust code with `perf` (Linux) or `instruments` (macOS) |
| `profile` | Linux performance profiling with `perf` — hotspots, call stacks, counters |
| `simplify-one-thing` | Find one unnecessarily complex thing, simplify it, and explain the change |
| `handoff` | Compact the current conversation into a handoff document for another agent |

## What's a Skill?

Skills are specialized instructions that agentic coding tools load on demand. Each skill lives in its own directory with a `SKILL.md` file containing YAML frontmatter (name, description, allowed tools) and markdown instructions. When your task matches the description, the agent automatically uses the skill.
