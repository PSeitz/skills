---
name: optimize-rust
description: >-
  Profile and optimize Rust code. Runs perf/instruments to find actual
  bottlenecks before changing anything. Use when user asks to "make this
  faster", "optimize", "profile", or "why is this slow".
argument-hint: "[file-or-function-or-benchmark]"
allowed-tools: Read Grep Glob Bash(cargo *) Bash(perf *) Bash(flamegraph *)
disable-model-invocation: true
---

# Rust Performance Optimization

**First principle: measure.** A benchmark tells you *how long* something
takes. A profiler tells you *where* the time goes. You need both — the
benchmark is the number to improve, the profiler is where to start
looking. The hot spot itself may not be the problem — it might be called
too often, fed bad data, or doing work that shouldn't exist.

## Step 1 — Get a workload

You need something to measure. Find it:
- Look for `benches/` directory, `#[bench]`, criterion, or binggan harnesses.
- If the user points to a function, find or ask for a benchmark that exercises it.
- If no benchmark exists, ask the user what to measure before doing anything else.

## Step 2 — Profile

### Linux

**Coarse — where is time going?**
```sh
perf stat -e cycles,instructions,cache-misses,cache-references,branch-misses,branches -- <command>
```
Read the counters. High cache-miss ratio → data locality problem.
High branch-miss ratio → unpredictable branches. Low IPC (instructions
per cycle) → pipeline stalls or memory latency.

**Fine — which functions?**
```sh
perf record -g --call-graph dwarf -- <command>
perf report --stdio --no-children --percent-limit=1
```
This gives a text table of functions sorted by overhead with call stacks.
Focus on the top entries.

**Line-level — which instructions?**
```sh
perf annotate --stdio -l <symbol>
```
Shows source lines and assembly with per-line sample counts. This tells
you exactly which lines are hot.

### macOS

Use `instruments` or `sample`:
```sh
xcrun xctrace record --template 'Time Profiler' --launch -- <command>
sample <pid> -f <output.txt>
```

### Build for profiling

Ensure the target has debug symbols but is optimized:
```sh
cargo build --release
# or for benchmarks (typically already configured):
cargo bench --no-run
```
Check that `Cargo.toml` has `[profile.bench] debug = true` or
`[profile.release] debug = true` for symbol resolution.

## Step 3 — Read the profile and state what you see

Before proposing any change, state:
1. **What the profiler shows** — which function/line is hot, what
   counters are abnormal.
2. **Why** — what about the code causes that (the bottleneck mechanism).
3. **What change would address that specific mechanism.**

Do not propose changes that aren't supported by the profile data.

## Step 4 — Make one change, re-measure

Apply the minimum change that addresses the bottleneck. Then re-profile
to verify it actually helped. If it didn't, revert and re-examine the
profile — your hypothesis was wrong.
