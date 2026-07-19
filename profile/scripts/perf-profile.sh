#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  perf-profile.sh [--freq Hz] [--repeat N] [--out DIR] -- <command> [args...]

Runs Linux perf stat and perf record for the given command.
Artifacts are written to .pi/profiles/<timestamp>/ by default.

Examples:
  perf-profile.sh -- cargo bench all_unique
  perf-profile.sh --freq 1999 --repeat 3 -- ./target/release/my-bench
USAGE
}

freq=999
repeat=5
out=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --freq)
      freq="${2:?missing value for --freq}"
      shift 2
      ;;
    --repeat)
      repeat="${2:?missing value for --repeat}"
      shift 2
      ;;
    --out)
      out="${2:?missing value for --out}"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ $# -eq 0 ]]; then
  usage >&2
  exit 2
fi

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "error: this skill requires Linux" >&2
  exit 1
fi

if ! command -v perf >/dev/null 2>&1; then
  echo "error: perf not found. Install linux perf tools for this kernel." >&2
  exit 1
fi

timestamp="$(date +%Y%m%d-%H%M%S)"
if [[ -z "$out" ]]; then
  out=".pi/profiles/$timestamp"
fi
mkdir -p "$out"

printf '%q ' "$@" > "$out/command.txt"
printf '\n' >> "$out/command.txt"
uname -a > "$out/uname.txt"
if [[ -r /proc/sys/kernel/perf_event_paranoid ]]; then
  cat /proc/sys/kernel/perf_event_paranoid > "$out/perf_event_paranoid.txt"
fi

{
  echo "# perf stat"
  echo "command: $(cat "$out/command.txt")"
  echo
  perf stat -r "$repeat" -d -- "$@"
} > "$out/perf-stat.txt" 2>&1 || {
  echo "perf stat failed; see $out/perf-stat.txt" >&2
  exit 1
}

{
  echo "# perf record"
  echo "command: $(cat "$out/command.txt")"
  echo
  perf record -F "$freq" -g --call-graph dwarf -o "$out/perf.data" -- "$@"
} > "$out/perf-record.txt" 2>&1 || {
  echo "perf record failed; see $out/perf-record.txt" >&2
  echo "If this is a permission issue, inspect: cat /proc/sys/kernel/perf_event_paranoid" >&2
  exit 1
}

perf report --stdio -i "$out/perf.data" --no-children --sort=dso,symbol \
  > "$out/perf-report-self.txt" 2> "$out/perf-report-self.err" || true
perf report --stdio -i "$out/perf.data" --children --sort=symbol \
  > "$out/perf-report-children.txt" 2> "$out/perf-report-children.err" || true

{
  echo "Profile artifacts: $out"
  echo
  echo "Top self-time symbols:"
  grep -E '^[[:space:]]*[0-9]+\.[0-9]+%' "$out/perf-report-self.txt" | head -30 || true
  echo
  echo "Top inclusive symbols:"
  grep -E '^[[:space:]]*[0-9]+\.[0-9]+%' "$out/perf-report-children.txt" | head -30 || true
} | tee "$out/summary.txt"
