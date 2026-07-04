#!/usr/bin/env bash
# Script: log-parser.sh
# Phase: 04 — Analysis
# Purpose: Parse and normalize Linux logs for forensic timeline analysis
# Usage: ./log-parser.sh -l /var/log -o ./parsed-logs -s "2026-07-01" -e "2026-07-04"
# Requirements: bash, awk, grep, journalctl (optional)
# FTFM Reference: Section 4 — Log Analysis

set -euo pipefail

LOG_DIR="/var/log"
OUT_DIR="./parsed-$(date +%Y%m%d-%H%M%S)"
START_DATE=""
END_DATE=""

usage() {
  echo "Usage: $0 [-l log-dir] [-o output-dir] [-s start-date] [-e end-date]"
  echo "  Dates: YYYY-MM-DD format"
  exit 1
}

while getopts "l:o:s:e:h" opt; do
  case $opt in
    l) LOG_DIR="$OPTARG" ;;
    o) OUT_DIR="$OPTARG" ;;
    s) START_DATE="$OPTARG" ;;
    e) END_DATE="$OPTARG" ;;
    *) usage ;;
  esac
done

mkdir -p "$OUT_DIR"
TIMELINE="$OUT_DIR/timeline.txt"
AUTHLOG="$OUT_DIR/auth-events.txt"
SSHDLOG="$OUT_DIR/sshd-events.txt"
SUDOLOG="$OUT_DIR/sudo-events.txt"
CRONLOG="$OUT_DIR/cron-events.txt"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

log "=== FTFM Log Parser ==="
log "Log source: $LOG_DIR"
log "Output:     $OUT_DIR"

# Collect auth events
log "Parsing auth log..."
for f in "$LOG_DIR"/auth.log* "$LOG_DIR"/secure*; do
  [[ -f "$f" ]] || continue
  grep -h "sshd\|sudo\|su\|PAM\|login\|cron" "$f" 2>/dev/null >> "$AUTHLOG" || true
done

# SSH specifically
grep "sshd" "$AUTHLOG" 2>/dev/null > "$SSHDLOG" || true
grep "Accepted\|Failed\|Invalid\|Disconnected" "$SSHDLOG" 2>/dev/null | sort >> "$OUT_DIR/ssh-summary.txt" || true

# Sudo events
grep "sudo" "$AUTHLOG" 2>/dev/null > "$SUDOLOG" || true

# Cron
grep "cron\|CRON" "$AUTHLOG" 2>/dev/null > "$CRONLOG" || true

# journalctl if available (more complete)
if command -v journalctl &>/dev/null; then
  log "Collecting systemd journal..."
  JCTL_ARGS=()
  [[ -n "$START_DATE" ]] && JCTL_ARGS+=(--since "$START_DATE")
  [[ -n "$END_DATE" ]]   && JCTL_ARGS+=(--until "$END_DATE")
  journalctl "${JCTL_ARGS[@]}" --no-pager -o short-iso > "$OUT_DIR/journal.txt" 2>/dev/null || true
fi

# Build a simple unified timeline
log "Building timeline..."
cat "$AUTHLOG" 2>/dev/null | \
  awk '{print $1, $2, $3, $5, $0}' | \
  sort > "$TIMELINE" || true

# Summary stats
echo "" && log "=== Summary ==="
echo "Auth events:   $(wc -l < "$AUTHLOG" 2>/dev/null || echo 0)"
echo "SSH events:    $(wc -l < "$SSHDLOG" 2>/dev/null || echo 0)"
echo "Failed logins: $(grep -c "Failed\|Invalid" "$SSHDLOG" 2>/dev/null || echo 0)"
echo "Sudo events:   $(wc -l < "$SUDOLOG" 2>/dev/null || echo 0)"
echo ""
echo "Output: $OUT_DIR"
echo "Next: FTFM Section 5 — build full timeline with log-to-timeline.py"
