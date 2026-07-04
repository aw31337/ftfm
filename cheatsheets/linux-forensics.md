# Linux Forensics Quick Reference

> FTFM Cheatsheet | Sections 3 & 4 — Acquisition and Analysis  
> Source: Forensic Team Field Manual (FTFM) — https://www.amazon.com/dp/B0F6KD9XJM

---

## Key Artifact Locations

### User Activity
```
~/.bash_history              # Command history (may be cleared by attacker)
~/.zsh_history               # Zsh history
~/.profile, ~/.bashrc        # Startup scripts — check for persistence
~/.ssh/authorized_keys       # SSH backdoor keys
~/.ssh/known_hosts           # Systems the user connected to
~/.wget-hsts                 # HTTPS sites fetched by wget
/var/log/auth.log            # Auth events (Debian/Ubuntu)
/var/log/secure              # Auth events (RHEL/CentOS)
```

### System Logs
```
/var/log/syslog              # General system log
/var/log/messages            # General messages (RHEL/CentOS)
/var/log/kern.log            # Kernel messages
/var/log/cron                # Cron job execution
/var/log/dpkg.log            # Package installs (Debian)
/var/log/yum.log             # Package installs (RHEL)
/var/log/wtmp                # Login records (read with: last)
/var/log/btmp                # Failed logins (read with: lastb)
/var/log/lastlog             # Last login per user
/run/utmp                    # Currently logged-in users
```

### Persistence Mechanisms
```
/etc/cron.d/                 # System cron jobs
/etc/cron.daily/             # Daily cron scripts
/etc/cron.hourly/            # Hourly cron scripts
/var/spool/cron/crontabs/    # Per-user crontabs
/etc/rc.local                # Legacy startup script
/etc/init.d/                 # SysV init scripts
/etc/systemd/system/         # Systemd unit files
/etc/ld.so.preload           # Library preload — common rootkit location
/etc/profile.d/              # Shell profile scripts (check for injections)
```

### Network Configuration
```
/etc/hosts                   # Static hostname resolution
/etc/resolv.conf             # DNS configuration
/etc/network/interfaces      # Network interfaces (Debian)
/etc/sysconfig/network-scripts/  # Network interfaces (RHEL)
/proc/net/tcp                # Active TCP connections (raw)
/proc/net/tcp6               # IPv6 TCP connections
```

### Filesystem & Temp Areas
```
/tmp/                        # Temp files — common attacker staging area
/var/tmp/                    # Persistent temp (survives reboots)
/dev/shm/                    # Shared memory — check for hidden processes
/proc/<PID>/exe              # Symlink to binary for running process
/proc/<PID>/maps             # Memory map of process
/proc/<PID>/fd/              # File descriptors open by process
```

---

## Live Response Commands

### System State
```bash
date && uname -a && uptime
hostname && cat /etc/hostname && cat /etc/os-release
who && w && last | head -20
```

### Process Analysis
```bash
ps auxf                              # Full process tree
ps auxf | grep -v "\[" | sort -k3 -rn  # By CPU, ignore kernel threads
ls -la /proc/*/exe 2>/dev/null       # Running process binaries
lsof -n -p <PID>                     # Files opened by process
/proc/<PID>/exe -h                   # What binary is PID running?
cat /proc/<PID>/cmdline | tr '\0' ' '  # Command line for PID
```

### Network Connections
```bash
ss -antp                             # All TCP connections with PID
ss -anlp                             # All listening sockets
netstat -antp 2>/dev/null           # Alternative (legacy)
lsof -i -n                          # All network files by process
```

### User and Auth Activity
```bash
last -F                              # Login history with full timestamps
lastb -F                             # Failed login history
grep "Accepted\|Failed\|Invalid" /var/log/auth.log | tail -50
grep "sudo" /var/log/auth.log | tail -20
cat /etc/passwd | awk -F: '$3==0{print "UID=0 user:", $1}'  # Root-equivalent users
awk -F: '($2 == "") {print $1, "has NO password"}' /etc/shadow 2>/dev/null
```

### Cron and Scheduled Jobs
```bash
crontab -l                           # Current user's cron
for user in $(cut -d: -f1 /etc/passwd); do
  crontab -u $user -l 2>/dev/null && echo "  ^^ $user"
done
ls -la /etc/cron.* /var/spool/cron/crontabs/ 2>/dev/null
```

### Persistence Check
```bash
# Check ld.so.preload (rootkit indicator)
cat /etc/ld.so.preload

# Systemd services (non-standard)
systemctl list-units --type=service --state=running
systemctl list-units --type=service --all | grep -v "systemd\|dbus\|network\|ssh"

# Check SUID binaries (escalation paths)
find / -perm -4000 -type f 2>/dev/null | sort

# Recently modified files
find /etc /bin /sbin /usr/bin /usr/sbin -newer /tmp -type f 2>/dev/null
find / -mtime -2 -not -path "/proc/*" -not -path "/sys/*" -type f 2>/dev/null | head -50
```

### File Integrity
```bash
# Hash all binaries in PATH locations
find /bin /sbin /usr/bin /usr/sbin -type f -exec sha256sum {} \; 2>/dev/null > /mnt/evidence/system_binary_hashes.txt

# Check for files with no owner (orphaned — attacker artifacts)
find / -nouser -not -path "/proc/*" 2>/dev/null
find / -nogroup -not -path "/proc/*" 2>/dev/null

# Find hidden directories
find / -name ".*" -type d 2>/dev/null | grep -v ".git\|.config"
```

---

## Disk Acquisition (Linux Source)

```bash
# Identify target
lsblk
fdisk -l

# dd acquisition to network share
dd if=/dev/sdX conv=sync,noerror status=progress | \
  ssh user@evidence-server "cat > /cases/$(hostname)_$(date +%F).img"

# Local acquisition with hash
dcfldd if=/dev/sdX of=/mnt/evidence/disk.img bs=4M \
  hashwindow=1G md5log=/mnt/evidence/disk.md5 \
  sha256log=/mnt/evidence/disk.sha256 \
  conv=sync,noerror

# Verify after
sha256sum /mnt/evidence/disk.img | tee /mnt/evidence/disk.img.sha256
```

---

## Timeline Building

```bash
# Sleuth Kit mactime timeline (requires TSK)
fls -r -m "/" /mnt/evidence/disk.img > bodyfile.txt
mactime -b bodyfile.txt -d > timeline.csv

# Find-based timeline (live)
find / -not -path "/proc/*" -not -path "/sys/*" \
  -printf "%T+ %M %n %u %g %s %f %p\n" 2>/dev/null \
  | sort > /mnt/evidence/filesystem_timeline.txt
```

---

## Checklist

- [ ] Volatile state captured (memory, network, processes)
- [ ] `/var/log/` contents copied
- [ ] Auth logs extracted and analyzed
- [ ] Crontabs for all users reviewed
- [ ] `/etc/ld.so.preload` checked
- [ ] SUID binaries inventoried
- [ ] Recently modified files listed
- [ ] SSH authorized_keys for all users reviewed
- [ ] Disk imaged and hashed
- [ ] Timeline built from disk image

---

*From the Forensic Team Field Manual (FTFM) — https://www.amazon.com/dp/B0F6KD9XJM*
