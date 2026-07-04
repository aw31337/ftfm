#!/usr/bin/env bash
# case-scoping.sh — Initial case scoping and environment snapshot
# FTFM Section 1 — Identification | https://www.amazon.com/dp/B0F6KD9XJM
#
# Run on the EXAMINER's machine (or remotely via SSH) to capture the environment
# of the system under investigation. Output goes to a timestamped case directory.
#
# Usage: sudo ./case-scoping.sh [case_id] [output_dir]

set -euo pipefail

CASE_ID="${1:-CASE-$(date +%Y%m%d-%H%M%S)}"
OUTPUT_DIR="${2:-/tmp/${CASE_ID}}"
mkdir -p "$OUTPUT_DIR"

TS="$(date +%Y-%m-%dT%H:%M:%S)"

log() { echo "[$TS] $*" | tee -a "$OUTPUT_DIR/scoping.log"; }

log "Starting case scoping — Case ID: $CASE_ID"
log "Output: $OUTPUT_DIR"
echo ""

# ── System Identity ────────────────────────────────────────────────────────────
log "Capturing system identity"
{
    echo "=== SYSTEM IDENTITY ==="
    echo "Capture Time: $(date)"
    echo "Hostname: $(hostname -f 2>/dev/null || hostname)"
    echo "OS: $(uname -a)"
    cat /etc/os-release 2>/dev/null || true
    echo ""
    echo "=== CPU/MEMORY ==="
    lscpu 2>/dev/null || sysctl -n machdep.cpu.brand_string 2>/dev/null || true
    free -h 2>/dev/null || vm_stat 2>/dev/null || true
    echo ""
    echo "=== DISK ==="
    lsblk 2>/dev/null || diskutil list 2>/dev/null || true
    df -h
} > "$OUTPUT_DIR/system_identity.txt" 2>&1

# ── Network Configuration ──────────────────────────────────────────────────────
log "Capturing network configuration"
{
    echo "=== INTERFACES ==="
    ip addr 2>/dev/null || ifconfig 2>/dev/null || true
    echo ""
    echo "=== ROUTING TABLE ==="
    ip route 2>/dev/null || route -n 2>/dev/null || netstat -rn 2>/dev/null || true
    echo ""
    echo "=== ARP CACHE ==="
    arp -an 2>/dev/null || ip neigh 2>/dev/null || true
    echo ""
    echo "=== DNS ==="
    cat /etc/resolv.conf 2>/dev/null || true
    echo ""
    echo "=== ACTIVE CONNECTIONS ==="
    ss -antp 2>/dev/null || netstat -antp 2>/dev/null || true
    echo ""
    echo "=== LISTENING PORTS ==="
    ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null || true
} > "$OUTPUT_DIR/network_state.txt" 2>&1

# ── User Activity ──────────────────────────────────────────────────────────────
log "Capturing user activity"
{
    echo "=== LOGGED IN USERS ==="
    who
    echo ""
    echo "=== LAST LOGINS ==="
    last -F 2>/dev/null | head -30 || true
    echo ""
    echo "=== FAILED LOGINS ==="
    lastb -F 2>/dev/null | head -20 || echo "(lastb requires root or shadow group access)"
    echo ""
    echo "=== LOCAL ACCOUNTS ==="
    cat /etc/passwd
    echo ""
    echo "=== PASSWORD-LESS ACCOUNTS ==="
    awk -F: '($2 == "" || $2 == "!") {print $1}' /etc/shadow 2>/dev/null || true
    echo ""
    echo "=== SUDO RIGHTS ==="
    cat /etc/sudoers 2>/dev/null || true
    ls /etc/sudoers.d/ 2>/dev/null || true
} > "$OUTPUT_DIR/user_activity.txt" 2>&1

# ── Process State ──────────────────────────────────────────────────────────────
log "Capturing process state"
{
    echo "=== RUNNING PROCESSES ==="
    ps auxf 2>/dev/null || ps aux 2>/dev/null || true
    echo ""
    echo "=== OPEN FILES (by process) ==="
    lsof -n 2>/dev/null | head -200 || true
    echo ""
    echo "=== LOADED KERNEL MODULES ==="
    lsmod 2>/dev/null || kextstat 2>/dev/null || true
} > "$OUTPUT_DIR/process_state.txt" 2>&1

# ── Scheduled Tasks ────────────────────────────────────────────────────────────
log "Checking scheduled tasks"
{
    echo "=== SYSTEM CRONTABS ==="
    ls -la /etc/cron* 2>/dev/null || true
    for f in /etc/crontab /etc/cron.d/*; do
        [[ -f "$f" ]] && { echo "--- $f ---"; cat "$f"; }
    done
    echo ""
    echo "=== USER CRONTABS ==="
    for user in $(cut -d: -f1 /etc/passwd); do
        crontab -u "$user" -l 2>/dev/null && echo "  (user: $user)" || true
    done
} > "$OUTPUT_DIR/scheduled_tasks.txt" 2>&1

# ── Startup / Persistence ──────────────────────────────────────────────────────
log "Checking persistence mechanisms"
{
    echo "=== SYSTEMD SERVICES (non-standard) ==="
    systemctl list-units --type=service --all 2>/dev/null || true
    echo ""
    echo "=== /ETC/LD.SO.PRELOAD (rootkit indicator) ==="
    cat /etc/ld.so.preload 2>/dev/null && echo "[!] ld.so.preload exists — investigate!" || echo "(empty — normal)"
    echo ""
    echo "=== SUID BINARIES ==="
    find / -perm -4000 -type f 2>/dev/null | sort
    echo ""
    echo "=== WORLD-WRITABLE DIRECTORIES ==="
    find / -perm -0002 -type d -not -path "/proc/*" 2>/dev/null | sort
} > "$OUTPUT_DIR/persistence.txt" 2>&1

# ── Hash All Output ────────────────────────────────────────────────────────────
log "Hashing output files"
find "$OUTPUT_DIR" -type f -not -name "*.sha256" \
    -exec sha256sum {} \; > "$OUTPUT_DIR/output_hashes.sha256"

log "Case scoping complete"
echo ""
echo "Case ID:  $CASE_ID"
echo "Output:   $OUTPUT_DIR"
echo "Files:"
ls -lh "$OUTPUT_DIR/"
