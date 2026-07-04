#!/usr/bin/env bash
# log-to-timeline.sh — Aggregate log sources into a unified timeline
# FTFM Section 5 — Timelines | https://www.amazon.com/dp/B0F6KD9XJM
#
# Usage: sudo ./log-to-timeline.sh [output_dir]
# Outputs: timeline.csv — ISO8601 timestamped events, sorted oldest-first
# Requires: bash 4+, awk, sort, journalctl (systemd), python3

set -euo pipefail

OUTPUT_DIR="${1:-/tmp/timeline_$(date +%Y%m%d_%H%M%S)}"
mkdir -p "$OUTPUT_DIR"
TIMELINE="$OUTPUT_DIR/timeline.csv"
HASH_FILE="$OUTPUT_DIR/timeline.sha256"

echo "timestamp,source,event" > "$TIMELINE"

log() { echo "[$(date +%T)] $*" >&2; }

# ── Auth log ──────────────────────────────────────────────────────────────────
parse_auth_log() {
    local logfile="$1"
    local year
    year=$(date +%Y)
    if [[ -f "$logfile" ]]; then
        log "Parsing $logfile"
        awk -v year="$year" '
        {
            # Convert "Mon DD HH:MM:SS" to ISO8601
            months="JanFebMarAprMayJunJulAugSepOctNovDec"
            m = index(months, $1)
            mon = sprintf("%02d", (m+2)/3)
            day = sprintf("%02d", $2)
            ts = year"-"mon"-"day"T"$3
            gsub(/,/, ";", $0)
            print ts",auth,\"" substr($0,17) "\""
        }' "$logfile" >> "$TIMELINE" 2>/dev/null || true
    fi
}

for f in /var/log/auth.log /var/log/auth.log.1 /var/log/secure /var/log/secure.1; do
    parse_auth_log "$f"
done

# ── Journalctl (systemd) ──────────────────────────────────────────────────────
if command -v journalctl &>/dev/null; then
    log "Exporting journalctl events"
    journalctl --no-pager -o short-iso --since "7 days ago" 2>/dev/null \
    | awk '
        NR > 1 {
            ts=$1
            gsub(/,/, ";", $0)
            msg=substr($0, index($0,$4))
            print ts",journal,\"" msg "\""
        }' >> "$TIMELINE" 2>/dev/null || true
fi

# ── Syslog ────────────────────────────────────────────────────────────────────
parse_syslog() {
    local logfile="$1"
    local year
    year=$(date +%Y)
    if [[ -f "$logfile" ]]; then
        log "Parsing $logfile"
        awk -v year="$year" '
        /^[A-Z][a-z][a-z]/ {
            months="JanFebMarAprMayJunJulAugSepOctNovDec"
            m = index(months, $1)
            mon = sprintf("%02d", (m+2)/3)
            day = sprintf("%02d", $2)
            ts = year"-"mon"-"day"T"$3
            gsub(/,/, ";", $0)
            print ts",syslog,\"" substr($0,17) "\""
        }' "$logfile" >> "$TIMELINE" 2>/dev/null || true
    fi
}

for f in /var/log/syslog /var/log/syslog.1 /var/log/messages; do
    parse_syslog "$f"
done

# ── Cron log ──────────────────────────────────────────────────────────────────
parse_syslog "/var/log/cron"

# ── Last / wtmp logins ────────────────────────────────────────────────────────
if command -v last &>/dev/null; then
    log "Exporting last(1) login records"
    last -F 2>/dev/null \
    | grep -v "^$\|^wtmp\|still" \
    | awk '
        {
            gsub(/,/, ";", $0)
            print $0
        }' \
    | python3 -c "
import sys, re
for line in sys.stdin:
    line = line.strip()
    # Typical format: user pts/0 host.com Mon Jan 01 12:00:00 2025 - Mon Jan 01 13:00:00 2025
    m = re.search(r'(\w{3}\s+\w{3}\s+\d+\s+\d+:\d+:\d+\s+\d{4})', line)
    if m:
        import datetime
        try:
            dt = datetime.datetime.strptime(m.group(1).strip(), '%a %b %d %H:%M:%S %Y')
            ts = dt.strftime('%Y-%m-%dT%H:%M:%S')
            fields = line.split()
            user = fields[0] if fields else 'unknown'
            print(f'{ts},login,\"{line}\"')
        except Exception:
            pass
" >> "$TIMELINE" 2>/dev/null || true
fi

# ── Filesystem timeline (recent changes) ─────────────────────────────────────
log "Building filesystem timeline (last 7 days — skipping /proc /sys /dev)"
find / \
    -not \( -path "/proc/*" -o -path "/sys/*" -o -path "/dev/*" -o \
            -path "/run/*" -o -path "$OUTPUT_DIR/*" \) \
    -mtime -7 -type f -printf "%TY-%Tm-%TdT%TT,%p\n" 2>/dev/null \
| awk '{
    gsub(/,/, ";", $2)
    print $1",filesystem,\"modified: " $2 "\""
}' >> "$TIMELINE" 2>/dev/null || true

# ── Sort and deduplicate ──────────────────────────────────────────────────────
log "Sorting timeline"
HEADER=$(head -1 "$TIMELINE")
BODY=$(tail -n +2 "$TIMELINE" | sort -t',' -k1 | uniq)
echo "$HEADER" > "$TIMELINE"
echo "$BODY" >> "$TIMELINE"

EVENT_COUNT=$(wc -l < "$TIMELINE")
log "Timeline complete: $((EVENT_COUNT - 1)) events written"

# ── Hash output ───────────────────────────────────────────────────────────────
sha256sum "$TIMELINE" > "$HASH_FILE"

echo ""
echo "Output:  $TIMELINE"
echo "Hash:    $HASH_FILE"
echo "Events:  $((EVENT_COUNT - 1))"
echo ""
echo "Quick view — top 20 events:"
head -21 "$TIMELINE" | column -t -s','
