---
name: profile
description: Linux-only performance profiling workflow using perf. Use when investigating slow code, benchmark regressions, CPU hotspots, call stacks, or when the user asks to profile a command, test, or benchmark on Linux.
compatibility: Linux with perf installed. Requires sufficient perf_event permissions for sampling.
---

# Profile

Use this skill to profile CPU performance with Linux `perf`.

## When to use

Use for questions like:

- "why is this benchmark slow?"
- "profile this command"
- "find the hotspot"
- "compare before/after performance"
- "where does this 10x slowdown come from?"

Do **not** use on non-Linux systems.

## Quick workflow

1. Confirm Linux and `perf` availability:

```bash
uname -s
command -v perf
```

2. Build optimized code first when profiling Rust/C/C++:

```bash
cargo build --release
# or for benches:
cargo bench --no-run
```

3. Run the helper script from the skill directory, passing the command after `--`:

```bash
~/.agents/skills/profile/scripts/perf-profile.sh -- cargo bench all_unique
```

The script writes artifacts under `.pi/profiles/<timestamp>/` in the current working directory.

## Manual perf commands

### Timing and high-level counters

```bash
perf stat -r 5 -d -- <command> <args>
```

Look at:

- elapsed time
- cycles
- instructions
- IPC: `instructions / cycles`
- branches and branch misses
- cache misses
- context switches

### CPU hotspot sampling

```bash
perf record -F 999 -g --call-graph dwarf -o perf.data -- <command> <args>
perf report --stdio -i perf.data --no-children --sort=dso,symbol | head -120
perf report --stdio -i perf.data --children --sort=symbol | head -160
```

Use `--no-children` for direct self-time and `--children` for inclusive stack cost.

### Annotate one hot symbol

```bash
perf annotate -i perf.data --stdio --symbol <symbol>
```

## Permission issues

If `perf record` fails with permission errors, inspect:

```bash
cat /proc/sys/kernel/perf_event_paranoid
```

Temporary local fix, if allowed:

```bash
sudo sysctl kernel.perf_event_paranoid=1
sudo sysctl kernel.kptr_restrict=0
```

Do not change system settings without user approval.

## Profiling guidance

- Prefer profiling the exact benchmark command the user is discussing.
- Use `perf stat` first to determine whether the problem is extra work, stalls, branches, or memory.
- Use `perf record/report` second to identify functions responsible for CPU time.
- For candidate-selection slowdowns, profile separate variants if possible:
  - baseline/reference command
  - current command
  - feature disabled via temporary edit or flag
- Report concrete percentages from `perf report`, not guesses.
- Keep generated profiling artifacts out of commits unless the user asks to keep them.

## Output format for findings

When reporting results, include:

1. Command profiled
2. Artifact directory
3. Top hotspots with percentages
4. Interpretation tied to source locations
5. Recommended next change or experiment
