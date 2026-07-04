#!/usr/bin/env bash
# Script: hash-verify.sh
# Phase: 03 — Acquisition / 02 — Preservation
# Purpose: Hash evidence files and verify integrity at each transfer
# Usage: ./hash-verify.sh <file-or-directory> [expected-hash]
# Requirements: sha256sum, md5sum
# FTFM Reference: Section 2 — Preservation, Section 3 — Hashing

set -euo pipefail

TARGET="${1:-}"
EXPECTED="${2:-}"
OUTDIR="./hashes-$(date +%Y%m%d-%H%M%S)"

[[ -z "$TARGET" ]] && { echo "Usage: $0 <file-or-dir> [expected-sha256]"; exit 1; }
[[ ! -e "$TARGET" ]] && { echo "Target not found: $TARGET"; exit 1; }

mkdir -p "$OUTDIR"
HASHLOG="$OUTDIR/hash-log.txt"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$HASHLOG"; }

log "=== FTFM Hash Verification ==="
log "Target:   $TARGET"
log "Operator: $(whoami)@$(hostname)"

hash_file() {
  local f="$1"
  local sha256 md5 size
  sha256=$(sha256sum "$f" | awk '{print $1}')
  md5=$(md5sum "$f" | awk '{print $1}')
  size=$(du -sh "$f" | awk '{print $1}')
  echo "FILE:   $f" | tee -a "$HASHLOG"
  echo "SIZE:   $size" | tee -a "$HASHLOG"
  echo "SHA256: $sha256" | tee -a "$HASHLOG"
  echo "MD5:    $md5" | tee -a "$HASHLOG"
  echo "" | tee -a "$HASHLOG"
  echo "$sha256"
}

if [[ -f "$TARGET" ]]; then
  COMPUTED=$(hash_file "$TARGET")
elif [[ -d "$TARGET" ]]; then
  log "Directory mode — hashing all files recursively"
  find "$TARGET" -type f | sort | while read -r f; do
    hash_file "$f" > /dev/null
  done
  log "Directory hash log saved to $HASHLOG"
  exit 0
fi

# Verify against expected hash if provided
if [[ -n "$EXPECTED" ]]; then
  log "--- Verification ---"
  if [[ "$COMPUTED" == "$EXPECTED" ]]; then
    log "[PASS] Hash verified — evidence integrity confirmed"
    echo "[PASS] SHA256 match: $COMPUTED"
  else
    log "[FAIL] Hash mismatch — evidence may be corrupted or tampered"
    log "  Expected: $EXPECTED"
    log "  Computed: $COMPUTED"
    echo "[FAIL] Hash mismatch — see $HASHLOG"
    exit 1
  fi
fi

log "=== Complete. Log: $HASHLOG ==="
