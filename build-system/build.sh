#!/bin/bash
# ============================================================
# Lutiek OS 2026 — Build All Phases
# ============================================================
# Usage: ./build.sh [phase]
#   ./build.sh         — build everything
#   ./build.sh phase1  — build phase 1 only
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

PHASE="${1:-all}"

run_phase() {
  local phase="$1"
  local script="$SCRIPT_DIR/phase${phase}-*.sh"
  for f in $script; do
    if [ -f "$f" ]; then
      echo "Running $f..."
      bash "$f"
    fi
  done
}

case "$PHASE" in
  phase1) run_phase 1 ;;
  phase2) run_phase 2 ;;
  phase3) run_phase 3 ;;
  phase4) run_phase 4 ;;
  all)
    run_phase 1
    run_phase 2
    run_phase 3
    run_phase 4
    ;;
  *) echo "Usage: $0 [phase1|phase2|phase3|phase4|all]" ;;
esac
