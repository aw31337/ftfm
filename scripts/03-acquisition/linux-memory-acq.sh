#!/usr/bin/env bash
# Script: linux-memory-acq.sh
# Phase: 03 — Acquisition
# Purpose: Linux memory acquisition using AVML or LiME with integrity hashing
# Usage: sudo ./linux-memory-acq.sh -o /mnt/evidence/case001
# Requirements: avml (preferred) or insmod + lime.ko; external write target
# FTFM Reference: Section 3 — Memory Acquisition

set -euo pipefail

OUTDIR=""
CASEID="case-$(date +%Y%m%d-%H%M%S)"

usage() {
  echo "Usage: sudo $0 -o <output-directory> [-c <case-id>]"
  echo "  Output must be on external media, NOT the target system."
  exit 1
}

while getopts "o:c:h" opt; do
  case $opt in
    o) OUTDIR="$OPTARG" ;;
    c) CASEID="$OPTARG" ;;
    *) usage ;;
  esac
done

[[ -z "$OUTDIR" ]] && usage
[[ $EUID -ne 0 ]] && { echo "[!] Must run as root"; exit 1; }

mkdir -p "$OUTDIR"
OUTFILE="$OUTDIR/${CASEID}-memory.lime"
HASHFILE="$OUTDIR/${CASEID}-memory.sha256"
LOGFILE="$OUTDIR/${CASEID}-acquisition.log"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOGFILE"; }

log "=== FTFM Memory Acquisition ==="
log "Case ID:    $CASEID"
log "Host:       $(hostname)"
log "Kernel:     $(uname -r)"
log "RAM size:   $(free -h | awk '/Mem:/{print $2}')"
log "Output:     $OUTFILE"
log "Operator:   $(logname 2>/dev/null || echo unknown)"

# Prefer AVML (userspace, no kernel module needed)
if command -v avml &>/dev/null; then
  log "Tool: avml (userspace)"
  avml "$OUTFILE"
elif [[ -f "./lime.ko" ]]; then
  log "Tool: LiME kernel module"
  insmod ./lime.ko "path=$OUTFILE format=lime"
  sleep 3
  rmmod lime 2>/dev/null || true
else
  log "[!] Neither avml nor lime.ko found."
  log "    Install avml: https://github.com/microsoft/avml/releases"
  log "    Or compile LiME: https://github.com/504ensicsLabs/LiME"
  exit 1
fi

log "Acquisition complete — generating hash..."
sha256sum "$OUTFILE" | tee "$HASHFILE" | tee -a "$LOGFILE"
log "Hash saved to: $HASHFILE"

log "=== Acquisition complete ==="
echo ""
echo "Next steps (FTFM Section 3):"
echo "  1. Verify hash on receiving system matches: $(cat $HASHFILE | awk '{print $1}')"
echo "  2. Document in chain of custody: $OUTDIR/"
echo "  3. Proceed to Section 4 — Analysis with Volatility or Rekall"
